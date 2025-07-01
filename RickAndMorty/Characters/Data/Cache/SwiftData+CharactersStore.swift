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
    
//    func insert(_ countries: [LocalCountry], timestamp: Date, in context: ModelContext) throws {
//        if try context.fetch(FetchDescriptor<LocalCacheEntity>()).isEmpty {
//            let entities = countries.map { local in
//                let entity = LocalCountryEntity(
//                    commonName: local.commonName,
//                    officialName: local.officialName,
//                    capital: local.capital,
//                    flagURL: local.flagURL!,
//                    isBookmarked: local.isBookmarked
//                )
//                if let data = URLImageCache.shared.getImageData(for: local.flagURL!) {
//                    entity.data = data
//                }
//                return entity
//            }
//            
//            let cache = LocalCacheEntity(timestamp: timestamp, countries: entities)
//            context.insert(cache)
//        }
//    }
    
    public func insert(_ characters: [LocalCharacter], timestamp: Date) async throws {
        if try !LocalCache.cacheExists(in: context) {
            try await deleteCache()
            let localCache = LocalCache(timestamp: timestamp, characters: characters)
            try context.save()
        }
    }
    
    public func deleteCache() async throws {
        try LocalCache.deleteCache(in: context)
    }
}
