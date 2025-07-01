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
    //private let localCountriesLoader: LocalCountriesLoader
    
    init(baseURL: URL, httpClient: URLSessionHTTPClient) {
        self.baseURL = baseURL
        self.httpClient = httpClient
        //        self.localCountriesLoader = localCountriesLoader
    }
    
    static func makeComposer() -> Composer {
        
        let baseURL = URL(string: "https://rickandmortyapi.com/api/")!
        let httpClient = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        //        let store = makeStore()
        //        let localCountriesLoader = LocalCountriesLoader(store: store, currentDate: Date.init)
        
        return Composer(baseURL: baseURL,
                        httpClient: httpClient)
    }
    
    private static func makeStore() -> CharactersStore {
        
        var sharedModelContainer: ModelContainer = {
            let schema = Schema([
                LocalCharacter.self,
            ])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

            do {
                return try ModelContainer(for: schema, configurations: [modelConfiguration])
            } catch {
                fatalError("Could not create ModelContainer: \(error)")
            }
        }()
        
//        do {
//            return try CoreDataCountriesAppStore(
//                storeURL: NSPersistentContainer
//                    .defaultDirectoryURL()
//                    .appendingPathComponent("countries-app-store.sqlite"))
//        } catch {
//            return InMemoryStore()
//        }
    }
    
    func composeCharactersViewModel() -> CharactersViewModel {
        let charactersLoader: () async throws -> [Character] = { [baseURL, httpClient] in
            
            let url = CharactersEndpoint.getCharacters.url(baseURL: baseURL)
            let (data, response) = try await httpClient.get(from: url)
            
            return try CharactersMapper.map(data, from: response)
        }
        
        return CharactersViewModel(charactersLoader: charactersLoader)
    }
}
