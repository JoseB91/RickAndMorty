//
//  MockCharacter.swift
//  RickAndMorty
//
//  Created by José Briones on 30/7/25.
//

import Foundation

struct MockCharactersViewModel {
    static func mockCharacter() -> Character {
        return Character(id: 1,
                         name: "Rick Sanchez",
                         origin: "Earth (C-137)",
                         location: "Citadel of Ricks",
                         image: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")!)
    }
    
    static func mockAnotherCharacter() -> Character {
        return Character(id: 2,
                         name: "Morty Smith",
                         origin: "unknown",
                         location: "Citadel of Ricks",
                         image: URL(string: "https://rickandmortyapi.com/api/character/avatar/2.jpeg")!)
    }
    
}

struct MockCharactersRepository: CharactersRepository {
    func loadCharacters() async throws -> [Character] {
        [MockCharactersViewModel.mockCharacter()]
    }
}
