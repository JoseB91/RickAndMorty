//
//  RickAndMortyApp.swift
//  RickAndMorty
//
//  Created by José Briones on 26/6/25.
//

import SwiftUI
import SwiftData

@main
struct RickAndMortyApp: App {
    
    private let composer: Composer
    
    init() {
        self.composer = Composer.makeComposer()
    }

//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            Item.self,
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()

    var body: some Scene {
        WindowGroup {
            CharactersView(charactersViewModel: composer.composeCharactersViewModel())
        }
        //.modelContainer(sharedModelContainer)
    }
}
