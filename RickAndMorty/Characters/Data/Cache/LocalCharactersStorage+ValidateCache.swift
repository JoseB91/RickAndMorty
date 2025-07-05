//
//  LocalCharactersStorage+ValidateCache.swift
//  RickAndMorty
//
//  Created by José Briones on 4/7/25.
//

import Foundation

extension LocalCharactersStorage {
    private struct InvalidCache: Error {}
    
    public func validateCache() async throws {
        do {
            if let cache = try await store.retrieve(), !CachePolicy.validate(cache.timestamp,
                                                                             against: currentDate()) {
                throw InvalidCache()
            }
        } catch {
            try await store.deleteCache()
        }
    }
}
