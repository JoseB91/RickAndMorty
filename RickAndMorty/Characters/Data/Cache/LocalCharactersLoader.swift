//
//  LocalCharactersLoader.swift
//  RickAndMorty
//
//  Created by José Briones on 30/6/25.
//

import Foundation

public final class LocalCharactersLoader {
    private let store: CharactersStore
    private let currentDate: () -> Date
    
    public init(store: CharactersStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
}

public protocol CharacterCache {
    func save(_ characters: [Character]) async throws
}

extension LocalCharactersLoader: CharacterCache {
    public func save(_ characters: [Character]) async throws {
        do {
            try await store.insert(characters.toLocal(), timestamp: currentDate())
        } catch {
            try await store.deleteCache()
        }
    }
}

extension LocalCharactersLoader {
    private struct FailedLoad: Error {}
    
    public func load() async throws -> [Character] {
        if let cache = try await store.retrieve(), CachePolicy.validate(cache.timestamp, against: currentDate()) {
            return cache.characters.toModels()
        } else {
            throw FailedLoad()
        }
    }
}

extension LocalCharactersLoader {
    private struct InvalidCache: Error {}
    
    public func validateCache() async throws {
        do {
            if let cache = try await store.retrieve(),
               !CachePolicy.validate(cache.timestamp,
                                     against: currentDate()) {
                throw InvalidCache()
            }
        } catch {
            try await store.deleteCache()
        }
    }
}

extension Array where Element == Character {
    public func toLocal() -> [LocalCharacter] {
        return map { LocalCharacter(id: $0.id,
                                    name: $0.name,
                                    origin: $0.origin,
                                    location: $0.location,
                                    image: $0.image)
        }
    }
}

private extension Array where Element == LocalCharacter {
    func toModels() -> [Character] {
        return map { Character(id: $0.id,
                               name: $0.name,
                               origin: $0.origin,
                               location: $0.location,
                               image: $0.image)
        }
    }
}
