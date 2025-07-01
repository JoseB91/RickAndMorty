//
//  SwiftDataStore.swift
//  RickAndMorty
//
//  Created by José Briones on 30/6/25.
//

import SwiftData
import Foundation

public final class SwiftDataStore {
    public let container: ModelContainer
    public let context: ModelContext

    public enum StoreError: Error {
        case failedToLoadModel(Error)
    }

    public init() throws {
        let schema = Schema([
            LocalCharacter.self,
            LocalCache.self
        ])

        let configuration: ModelConfiguration
        configuration = ModelConfiguration(schema: schema)

        do {
            container = try ModelContainer(for: schema, configurations: [configuration])
            context = ModelContext(container)
        } catch {
            throw StoreError.failedToLoadModel(error)
        }
    }
}
