//
//  InMemory+CharactersStore.swift
//  RickAndMorty
//
//  Created by José Briones on 4/7/25.
//

import Foundation

extension InMemoryStore: CharactersStore {
    func retrieve() async throws -> CachedCharacters? {
        charactersCache
    }
    
    func deleteCache() throws {
        charactersCache = nil
    }

    func insert(_ characters: [LocalCharacter], timestamp: Date) throws {
        if charactersCache == nil {
            charactersCache = CachedCharacters(characters: characters, timestamp: timestamp)
        }
    }
}
