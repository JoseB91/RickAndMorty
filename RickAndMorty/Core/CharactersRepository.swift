//
//  CharactersRepository.swift
//  RickAndMorty
//
//  Created by José Briones on 4/7/25.
//

import Foundation

protocol CharactersRepository {
    func loadCharacters() async throws -> [Character]
}

final class CharactersRepositoryImpl: CharactersRepository {
    private let baseURL: URL
    private let httpClient: HTTPClient
    private let localCharactersStorage: LocalCharactersStorage

    init(baseURL: URL, httpClient: HTTPClient, localCharactersStorage: LocalCharactersStorage) {
        self.baseURL = baseURL
        self.httpClient = httpClient
        self.localCharactersStorage = localCharactersStorage
    }

    func loadCharacters() async throws -> [Character] {
        do {
            return try await localCharactersStorage.load()
        } catch {
            let url = CharactersEndpoint.getCharacters.url(baseURL: baseURL)
            let (data, response) = try await httpClient.get(from: url)
            let characters = try CharactersMapper.map(data, from: response)

            try? await localCharactersStorage.save(characters)

            return characters
        }
    }
}
