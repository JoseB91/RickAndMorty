//
//  InMemory+ImageStore.swift
//  RickAndMorty
//
//  Created by José Briones on 4/7/25.
//

import Foundation

extension InMemoryStore: ImageStore {
    func insert(_ data: Data, for url: URL) async throws {
        imageData.setObject(data as NSData, forKey: url as NSURL)

    }
    
    func retrieve(dataFor url: URL) async throws -> Data? {
        imageData.object(forKey: url as NSURL) as Data?
    }
}
