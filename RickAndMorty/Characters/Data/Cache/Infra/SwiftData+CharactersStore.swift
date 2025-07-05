//
//  SwiftData+CharactersStore.swift
//  RickAndMorty
//
//  Created by José Briones on 30/6/25.
//

import SwiftData
import Foundation

extension SwiftDataStore: CharactersStore {    
    public func retrieve() async throws -> CachedCharacters? {
        try LocalCache.find(in: modelContext).map {
            CachedCharacters(characters: $0.characters, timestamp: $0.timestamp)
        }
    }
    
    public func insert(_ characters: [LocalCharacter], timestamp: Date) async throws {
        guard try modelContext.fetch(FetchDescriptor<LocalCache>()).isEmpty else {
            return
        }
        
        for character in characters {
            if let cachedData = URLImageCache.shared.getImageData(for: character.image) {
                character.data = cachedData
            }
        }
        
        let cache = LocalCache(timestamp: timestamp, characters: characters)
        modelContext.insert(cache)
        try modelContext.save()
    }
    
    public func deleteCache() async throws {
        try LocalCache.deleteCache(in: modelContext)
    }
}
