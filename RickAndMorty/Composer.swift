//
//  Composer.swift
//  RickAndMorty
//
//  Created by José Briones on 26/6/25.
//

import Foundation
import SwiftData
import UIKit

class Composer {
    private let baseURL: URL
    private let httpClient: URLSessionHTTPClient
    private let localCharactersLoader: LocalCharactersLoader
    private let localImageLoader: LocalImageLoader
    
    init(baseURL: URL, httpClient: URLSessionHTTPClient, localCharactersLoader: LocalCharactersLoader, localImageLoader: LocalImageLoader) {
        self.baseURL = baseURL
        self.httpClient = httpClient
        self.localCharactersLoader = localCharactersLoader
        self.localImageLoader = localImageLoader
    }
    
    static func makeComposer() -> Composer {
        
        let baseURL = URL(string: "https://rickandmortyapi.com/api/")!
        let httpClient = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        let store = makeStore()
        let localCharactersLoader = LocalCharactersLoader(store: store, currentDate: Date.init)
        let localImageLoader = LocalImageLoader(store: store)
        return Composer(baseURL: baseURL,
                        httpClient: httpClient,
                        localCharactersLoader: localCharactersLoader,
                        localImageLoader: localImageLoader)
    }
    
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
    
    func composeImageView(with url: URL) -> ImageView {

        let imageLoader: () async throws -> Data = { [httpClient, localImageLoader] in
            
            do {
                return try await localImageLoader.loadImageData(from: url)
            } catch {
                let (data, response) = try await httpClient.get(from: url)
                let imageData = try ImageMapper.map(data, from: response)
                
                try? await localImageLoader.save(imageData, for: url)
                
                return imageData
            }
        }
        
        let imageViewModel = ImageViewModel(imageLoader: imageLoader,
                                            imageTransformer: UIImage.init)

        return ImageView(imageViewModel: imageViewModel)
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
