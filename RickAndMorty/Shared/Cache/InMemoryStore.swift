//
//  InMemoryStore.swift
//  RickAndMorty
//
//  Created by José Briones on 3/7/25.
//

import Foundation

public class InMemoryStore {
    private var charactersCache: CachedCharacters?
    
    public init() {}
}

extension InMemoryStore: CharactersStore {
    public func retrieve() async throws -> CachedCharacters? {
        charactersCache
    }
    
    public func deleteCache() throws {
        charactersCache = nil
    }

    public func insert(_ characters: [LocalCharacter], timestamp: Date) throws {
        if charactersCache == nil {
            charactersCache = CachedCharacters(characters: characters, timestamp: timestamp)
        }
    }
}
