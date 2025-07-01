//
//  CharactersStore.swift
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
