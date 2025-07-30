//
//  LocalImageStorage+Save.swift
//  RickAndMorty
//
//  Created by José Briones on 4/7/25.
//

import Foundation

protocol ImageCache {
    func save(_ data: Data, for url: URL) async throws
}


extension LocalImageStorage: ImageCache {
    enum SaveError: Error {
        case failed
    }
    
    func save(_ data: Data, for url: URL) async throws {
        do {
            try await store.insert(data, for: url)
        } catch {
            throw SaveError.failed
        }
    }
}
