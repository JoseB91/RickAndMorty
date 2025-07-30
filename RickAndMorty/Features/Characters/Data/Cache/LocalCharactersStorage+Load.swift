//
//  LocalCharactersStorage+Load.swift
//  RickAndMorty
//
//  Created by José Briones on 4/7/25.
//

import Foundation

extension LocalCharactersStorage {
    private struct FailedLoad: Error {}
    
    func load() async throws -> [Character] {
        if let cache = try await store.retrieve(), CachePolicy.validate(cache.timestamp, against: currentDate()) {
            return cache.characters.toModels()
        } else {
            throw FailedLoad()
        }
    }
}
