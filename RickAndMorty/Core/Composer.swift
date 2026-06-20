//
//  DependencyContainer.swift
//  RickAndMorty
//
//  Created by José Briones on 26/6/25.
//

import Foundation
import SwiftData

final class DependencyContainer {
    private let baseURL: URL
    private let httpClient: URLSessionHTTPClient
    private let localCharactersStorage: LocalCharactersStorage
    private let localImageStorage: LocalImageStorage
    
    init(baseURL: URL, httpClient: URLSessionHTTPClient, localCharactersStorage: LocalCharactersStorage, localImageStorage: LocalImageStorage) {
        self.baseURL = baseURL
        self.httpClient = httpClient
        self.localCharactersStorage = localCharactersStorage
        self.localImageStorage = localImageStorage
    }
    
    static func make() -> DependencyContainer {
        
        let baseURL = URL(string: "https://rickandmortyapi.com/api/")!
        let httpClient = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        let store = makeStore()
        let localCharactersStorage = LocalCharactersStorage(store: store, currentDate: Date.init)
        let localImageStorage = LocalImageStorage(store: store)
        return DependencyContainer(baseURL: baseURL,
                        httpClient: httpClient,
                        localCharactersStorage: localCharactersStorage,
                        localImageStorage: localImageStorage)
    }
    
    private static func makeStore() -> CharactersStore & ImageStore {
        do {
            return try SwiftDataStore(isStoredInMemoryOnly: false)
        } catch {
            return InMemoryStore()
        }
    }

    func composeCharactersViewModel() -> CharactersViewModel {
        let repository = CharactersRepositoryImpl(baseURL: baseURL,
                                                  httpClient: httpClient,
                                                  localCharactersStorage: localCharactersStorage)
                
        return CharactersViewModel(repository: repository)
    }
    
    func composeImageView(with url: URL) -> ImageView {
        let repository = ImageRepositoryImpl(url: url,
                                             httpClient: httpClient,
                                             localImageStorage: localImageStorage)

        let imageViewModel = ImageViewModel(repository: repository)

        return ImageView(imageViewModel: imageViewModel)
    }
    
    func validateCache() async throws {
        try await localCharactersStorage.validateCache()
    }
}
