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
    
    private let charactersLoader: () async throws -> [Character]
    
    init(charactersLoader: @escaping () async throws -> [Character]) {
        self.charactersLoader = charactersLoader
    }
    
    @MainActor
    func loadCharacters() async {
        isLoading = true
        
        do {
            characters = try await charactersLoader()
        } catch {
            errorMessage = ErrorModel(message: "Failed to load characters: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
}

final class MockCharactersViewModel {
    static func mockCharacter() -> Character {
        return Character(id: 1,
                         name: "Rick Sanchez",
                         origin: "Earth (C-137)",
                         location: "Citadel of Ricks",
                         image: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")!)
    }
    
    static func mockcharactersLoader() async throws -> [Character] {
        return [mockCharacter()]
    }
}

struct ErrorModel: Identifiable {
    let id = UUID()
    let message: String
}
