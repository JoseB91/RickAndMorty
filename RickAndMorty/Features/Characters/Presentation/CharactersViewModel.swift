//
//  CharactersViewModel.swift
//  RickAndMorty
//
//  Created by José Briones on 26/6/25.
//

import Foundation
import Observation

@Observable
final class CharactersViewModel {
    
    var characters = [Character]()
    var isLoading = false
    var errorMessage: ErrorModel? = nil
    
    private let repository: CharactersRepository
    
    init(repository: CharactersRepository) {
        self.repository = repository
    }
    
    @MainActor
    func loadCharacters() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            characters = try await repository.loadCharacters()
        } catch {
            errorMessage = ErrorModel(message: "Failed to load characters: \(error.localizedDescription)")
        }
    }
}

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
