//
//  CharactersViewModel.swift
//  RickAndMorty
//
//  Created by José Briones on 26/6/25.
//

import Foundation

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
