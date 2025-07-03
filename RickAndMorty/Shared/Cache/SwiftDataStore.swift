//
//  SwiftDataStore.swift
//  RickAndMorty
//
//  Created by José Briones on 30/6/25.
//

import SwiftData
import Foundation

public actor SwiftDataStore {
    public let container: ModelContainer
    public let context: ModelContext

    public enum StoreError: Error {
        case failedToLoadContainer(Error)
    }

    public init() throws {
        let schema = Schema([
            LocalCharacter.self,
            LocalCache.self
        ])

        let configuration = ModelConfiguration(schema: schema)

        do {
            container = try ModelContainer(for: schema, configurations: [configuration])
            context = ModelContext(container)
        } catch {
            throw StoreError.failedToLoadContainer(error)
        }
    }
}
