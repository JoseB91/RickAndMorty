//
//  LocalCharactersStorage+Save.swift
//  RickAndMorty
//
//  Created by José Briones on 4/7/25.
//

import Foundation

protocol CharactersCache {
    func save(_ characters: [Character]) async throws
}

extension LocalCharactersStorage: CharactersCache {
    func save(_ characters: [Character]) async throws {
        do {
            try await store.insert(characters.toLocal(), timestamp: currentDate())
        } catch {
            try await store.deleteCache()
        }
    }
}
