//
//  CoordinatorView.swift
//  RickAndMorty
//
//  Created by José Briones on 20/6/26.
//

import SwiftUI

struct CoordinatorView: View {
    let appCoordinator: AppCoordinator

    var body: some View {
        // Coordinator View use CharactersFlowView to manage navigation with charactersCoordinator parameter
        CharactersFlowView(coordinator: appCoordinator.charactersCoordinator)
            .task {
                try? await appCoordinator.validateCache()
            }
    }
}

// MARK: - Characters flow

private struct CharactersFlowView: View {
    // Needs to bind CharactersCoordinator path
    @Bindable var coordinator: CharactersCoordinator

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            CharactersView(
                charactersViewModel: coordinator.charactersViewModel,
                imageViewLoader: coordinator.makeImageView,
                onSelectCharacter: coordinator.showDetail
            )
            .navigationDestination(for: CharactersRoute.self) { route in
                switch route {
                case .detail(let character):
                    CharacterDetailPlaceholder(character: character)
                }
            }
        }
    }
}

// MARK: - Detail placeholder

private struct CharacterDetailPlaceholder: View {
    let character: Character

    var body: some View {
        VStack(spacing: 12) {
            Text(character.name)
                .font(.largeTitle.bold())
            Text("Origin: \(character.origin)")
            Text("Location: \(character.location)")
        }
        .navigationTitle(character.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    CoordinatorView(appCoordinator: .make())
}
