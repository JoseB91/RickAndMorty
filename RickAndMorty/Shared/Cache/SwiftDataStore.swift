//
//  SwiftDataStore.swift
//  RickAndMorty
//
//  Created by José Briones on 30/6/25.
//

import SwiftData
import Foundation

@ModelActor
actor SwiftDataStore {
    init(isStoredInMemoryOnly: Bool = false) throws {
        let schema = Schema([
            LocalCharacter.self,
            LocalCache.self
        ])

        let configuration = ModelConfiguration(isStoredInMemoryOnly: isStoredInMemoryOnly)
        let modelContainer = try ModelContainer(for: schema, configurations: [configuration])
        self.init(modelContainer: modelContainer)
    }
}
