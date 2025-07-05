//
//  LocalImageStorage.swift
//  RickAndMorty
//
//  Created by José Briones on 3/7/25.
//

import Foundation

public protocol ImageStore {
    func insert(_ data: Data, for url: URL) async throws
    func retrieve(dataFor url: URL) async throws -> Data?
}

public final class LocalImageStorage {
    let store: ImageStore
    
    public init(store: ImageStore) {
        self.store = store
    }
}
