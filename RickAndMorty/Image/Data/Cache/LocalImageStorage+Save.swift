//
//  LocalImageStorage+Save.swift
//  RickAndMorty
//
//  Created by José Briones on 4/7/25.
//

import Foundation

public protocol ImageCache {
    func save(_ data: Data, for url: URL) async throws
}


extension LocalImageStorage: ImageCache {
    public enum SaveError: Error {
        case failed
    }
    
    public func save(_ data: Data, for url: URL) async throws {
        do {
            try await store.insert(data, for: url)
        } catch {
            throw SaveError.failed
        }
    }
}
