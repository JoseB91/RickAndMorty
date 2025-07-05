//
//  ImageRepository.swift
//  RickAndMorty
//
//  Created by José Briones on 4/7/25.
//

import Foundation

protocol ImageRepository {
    func loadImage() async throws -> Data
}

final class ImageRepositoryImpl: ImageRepository {
    private let url: URL
    private let httpClient: HTTPClient
    private let localImageStorage: LocalImageStorage

    init(url: URL, httpClient: HTTPClient, localImageStorage: LocalImageStorage) {
        self.url = url
        self.httpClient = httpClient
        self.localImageStorage = localImageStorage
    }
    
    func loadImage() async throws -> Data {
        do {
            return try await localImageStorage.loadImageData(from: url)
        } catch {
            let (data, response) = try await httpClient.get(from: url)
            let imageData = try ImageMapper.map(data, from: response)
            
            try? await localImageStorage.save(imageData, for: url)
            
            return imageData
        }
    }
}
