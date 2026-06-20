//
//  AppCoordinator.swift
//  RickAndMorty
//
//  Created by José Briones on 20/6/26.
//

import Foundation

enum AppRoute {
    case characters
}

@MainActor
final class AppCoordinator {
    var currentRoute: AppRoute = .characters

    private let composer: DependencyContainer
    private(set) var charactersCoordinator: CharactersCoordinator

    // Just init with composer parameter
    // Inits charactersCoordinator with composer as well
    init(composer: DependencyContainer) {
        self.composer = composer
        self.charactersCoordinator = CharactersCoordinator(composer: composer)
    }

    // To be used on the init of App
    static func make() -> AppCoordinator {
        AppCoordinator(composer: DependencyContainer.make())
    }

    func validateCache() async throws {
        try await composer.validateCache()
    }
}
