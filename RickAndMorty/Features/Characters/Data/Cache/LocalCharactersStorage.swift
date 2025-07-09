//
//  LocalCharactersStorage.swift
//  RickAndMorty
//
//  Created by José Briones on 30/6/25.
//

import Foundation

public typealias CachedCharacters = (characters: [LocalCharacter], timestamp: Date)

public protocol CharactersStore {
    func deleteCache() async throws
    func insert(_ characters: [LocalCharacter], timestamp: Date) async throws
    func retrieve() async throws -> CachedCharacters?
}

public final class LocalCharactersStorage {
    let store: CharactersStore
    let currentDate: () -> Date
    
    public init(store: CharactersStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
}

extension Array where Element == Character {
    func toLocal() -> [LocalCharacter] {
        return map { LocalCharacter(id: $0.id,
                                    name: $0.name,
                                    origin: $0.origin,
                                    location: $0.location,
                                    image: $0.image)
        }
    }
}

extension Array where Element == LocalCharacter {
    func toModels() -> [Character] {
        return map { Character(id: $0.id,
                               name: $0.name,
                               origin: $0.origin,
                               location: $0.location,
                               image: $0.image)
        }
    }
}
