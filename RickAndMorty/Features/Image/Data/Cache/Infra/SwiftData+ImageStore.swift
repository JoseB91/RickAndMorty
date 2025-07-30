//
//  SwiftData+ImageStore.swift
//  RickAndMorty
//
//  Created by José Briones on 3/7/25.
//

import Foundation
import SwiftData

extension SwiftDataStore: ImageStore {
    
    func insert(_ data: Data, for url: URL) async throws {
        if let localCharacter = try LocalCharacter.getFirst(with: url, in: modelContext) {
            localCharacter.data = data
        }
        try modelContext.save()
    }

    func retrieve(dataFor url: URL) async throws -> Data?  {
        return try LocalCharacter.getImageData(with: url, in: modelContext)
    }
}
