//
//  Composer.swift
//  RickAndMorty
//
//  Created by José Briones on 26/6/25.
//

import Foundation
import SwiftData

struct Dependencies {
    let baseURL: URL
    let httpClient: URLSessionHTTPClient
    let localCharactersStorage: LocalCharactersStorage
    let localImageStorage: LocalImageStorage
}

extension Dependencies {
    private static func makeStore() -> CharactersStore & ImageStore {
        do {
            let schema = Schema([
                LocalCharacter.self,
                LocalCache.self
            ])

            let configuration = ModelConfiguration(schema: schema)
            let modelContainer = try ModelContainer(for: schema, configurations: [configuration])
            
            return SwiftDataStore(modelContainer: modelContainer)
        } catch {
            return InMemoryStore()
        }
    }
    
    static func makeDependencies() -> Dependencies {
        let baseURL = URL(string: "https://rickandmortyapi.com/api/")!
        let httpClient = URLSessionHTTPClient(session: .init(configuration: .ephemeral))
        let store = makeStore()
        let localCharactersStorage = LocalCharactersStorage(store: store, currentDate: Date.init)
        let localImageStorage = LocalImageStorage(store: store)

        return Dependencies(
            baseURL: baseURL,
            httpClient: httpClient,
            localCharactersStorage: localCharactersStorage,
            localImageStorage: localImageStorage
        )
    }
}

class Composer {
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func composeCharactersViewModel() -> CharactersViewModel {
        let repository = CharactersRepositoryImpl(baseURL: dependencies.baseURL,
                                                  httpClient: dependencies.httpClient,
                                                  localCharactersStorage: dependencies.localCharactersStorage)
                
        return CharactersViewModel(repository: repository)
    }
    
    func composeImageView(with url: URL) -> ImageView {
        let repository = ImageRepositoryImpl(url: url,
                                             httpClient: dependencies.httpClient,
                                             localImageStorage: dependencies.localImageStorage)

        let imageViewModel = ImageViewModel(repository: repository)

        return ImageView(imageViewModel: imageViewModel)
    }
}
