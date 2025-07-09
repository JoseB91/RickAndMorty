//
//  LocalImageStorage+Load.swift
//  RickAndMorty
//
//  Created by José Briones on 4/7/25.
//

import Foundation

public protocol ImageLoader {
    func loadImageData(from url: URL) async throws -> Data
}

extension LocalImageStorage: ImageLoader {
    public enum LoadError: Error {
        case failed
        case notFound
    }
    
    public func loadImageData(from url: URL) async throws -> Data {
            do {
                if let imageData = try await store.retrieve(dataFor: url) {
                    return imageData
                }
            } catch {
                throw LoadError.failed
            }
        throw LoadError.notFound
    }
}
