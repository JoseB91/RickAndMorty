//
//  RickAndMortyApp.swift
//  RickAndMorty
//
//  Created by José Briones on 26/6/25.
//

import SwiftUI
import SwiftData

//@main
struct RickAndMortyApp: App {
    
    private let composer: DependencyContainer
    
    init() {
        self.composer = DependencyContainer.make()
    }
    
    var body: some Scene {
        WindowGroup {
            CharactersView(charactersViewModel: composer.composeCharactersViewModel(),
                           imageViewLoader: composer.composeImageView)
            .task {
                try? await composer.validateCache()
            }
        }

    }
}
