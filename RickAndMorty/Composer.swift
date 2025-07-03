//
//  Composer.swift
//  RickAndMorty
//
//  Created by José Briones on 26/6/25.
//

import Foundation
import SwiftData

class Composer {
    private let baseURL: URL
    private let httpClient: URLSessionHTTPClient
    private let localCharactersLoader: LocalCharactersLoader
    
    init(baseURL: URL, httpClient: URLSessionHTTPClient, localCharactersLoader: LocalCharactersLoader) {
        self.baseURL = baseURL
        self.httpClient = httpClient
        self.localCharactersLoader = localCharactersLoader
    }
    
    static func makeComposer() -> Composer {
        
        let baseURL = URL(string: "https://rickandmortyapi.com/api/")!
        let httpClient = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        let store = makeStore()
        let localCharactersLoader = LocalCharactersLoader(store: store, currentDate: Date.init)
        return Composer(baseURL: baseURL,
                        httpClient: httpClient,
                        localCharactersLoader: localCharactersLoader)
    }
    
    private static func makeStore() -> CharactersStore {
        do {
            return try SwiftDataStore()
        } catch {
            return InMemoryStore()
        }
    }
    
    func composeCharactersViewModel() -> CharactersViewModel {
        let charactersLoader: () async throws -> [Character] = { [baseURL, httpClient, localCharactersLoader] in
            
            do {
                return try await localCharactersLoader.load()
            } catch {
                let url = CharactersEndpoint.getCharacters.url(baseURL: baseURL)
                let (data, response) = try await httpClient.get(from: url)
                
                let characters = try CharactersMapper.map(data, from: response)
                
                try? await localCharactersLoader.save(characters)
                
                return characters
            }
        }
        
        return CharactersViewModel(charactersLoader: charactersLoader)
    }
}
