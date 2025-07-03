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
        try LocalCache.find(in: context).map {
            CachedCharacters(characters: $0.characters, timestamp: $0.timestamp)
        }
    }
    
    public func insert(_ characters: [LocalCharacter], timestamp: Date) async throws {
        guard try context.fetch(FetchDescriptor<LocalCache>()).isEmpty else {
            return
        }
        
        for character in characters {
            if let cachedData = URLImageCache.shared.getImageData(for: character.image) {
                character.data = cachedData
            }
        }
        
        let cache = LocalCache(timestamp: timestamp, characters: characters)
        context.insert(cache)
        try context.save()
    }
    
    public func deleteCache() async throws {
        try LocalCache.deleteCache(in: context)
    }
}
