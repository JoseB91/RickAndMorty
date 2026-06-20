//
//  CharactersCoordinator.swift
//  RickAndMorty
//
//  Created by José Briones on 20/6/26.
//

import Foundation

enum CharactersRoute: Hashable {
    case detail(Character)
}

@Observable
@MainActor
final class CharactersCoordinator {
    // declare and inits path
    var path: [CharactersRoute] = []
    @ObservationIgnored let charactersViewModel: CharactersViewModel

    @ObservationIgnored private let composer: Composer

    init(composer: Composer) {
        self.composer = composer
        self.charactersViewModel = composer.composeCharactersViewModel()
    }

    func makeImageView(url: URL) -> ImageView {
        composer.composeImageView(with: url)
    }

    // used if detail were implemented
    func showDetail(for character: Character) {
        path.append(.detail(character))
    }
}
