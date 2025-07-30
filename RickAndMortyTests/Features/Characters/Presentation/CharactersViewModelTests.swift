//
//  CharactersViewModelTests.swift
//  RickAndMortyTests
//
//  Created by José Briones on 30/6/25.
//

import Testing
import Foundation
@testable import RickAndMorty

@MainActor
struct CharactersViewModelTests {
    
    // MARK: - Test Data
    
    private func createMockCharacter(id: Int = 1, name: String = "Test Character") -> Character {
        Character(
            id: id,
            name: name,
            origin: "Test Origin",
            location: "Test Location",
            image: URL(string: "https://example.com/avatar/\(id).jpeg")!
        )
    }
    
    private func createMockCharacters() -> [Character] {
        [
            createMockCharacter(id: 1, name: "Rick Sanchez"),
            createMockCharacter(id: 2, name: "Morty Smith"),
            createMockCharacter(id: 3, name: "Summer Smith")
        ]
    }
    
    // MARK: - Initialization Tests
    
    @Test("ViewModel initializes with correct default values")
    func testInitialization() {
        let viewModel = CharactersViewModel { [] }
        
        #expect(viewModel.characters.isEmpty)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage == nil)
    }
    
    // MARK: - Success Scenarios
    
    @Test("loadCharacters successfully loads and stores characters")
    func testLoadCharactersSuccess() async {
        let mockCharacters = createMockCharacters()
        let viewModel = CharactersViewModel {
            return mockCharacters
        }
        
        await viewModel.loadCharacters()
        
        #expect(viewModel.characters.count == 3)
        #expect(viewModel.characters[0].name == "Rick Sanchez")
        #expect(viewModel.characters[1].name == "Morty Smith")
        #expect(viewModel.characters[2].name == "Summer Smith")
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage == nil)
    }
    
    @Test("loadCharacters handles empty response")
    func testLoadCharactersEmptyResponse() async {
        let viewModel = CharactersViewModel {
            return []
        }
        
        await viewModel.loadCharacters()
        
        #expect(viewModel.characters.isEmpty)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage == nil)
    }
    
    @Test("loadCharacters updates existing characters")
    func testLoadCharactersUpdatesExistingData() async {
        let initialCharacters = [createMockCharacter(id: 1, name: "Initial Character")]
        let newCharacters = createMockCharacters()
        
        let viewModel = CharactersViewModel {
            return initialCharacters
        }
        
        // Load initial data
        await viewModel.loadCharacters()
        #expect(viewModel.characters.count == 1)
        #expect(viewModel.characters[0].name == "Initial Character")
        
        // Update the loader and load new data
        let updatedViewModel = CharactersViewModel {
            return newCharacters
        }
        
        await updatedViewModel.loadCharacters()
        #expect(updatedViewModel.characters.count == 3)
        #expect(updatedViewModel.characters[0].name == "Rick Sanchez")
    }
    
    // MARK: - Error Handling Tests
    
    @Test("loadCharacters handles network error")
    func testLoadCharactersNetworkError() async {
        struct NetworkError: Error, LocalizedError {
            var errorDescription: String? { "Network connection failed" }
        }
        
        let viewModel = CharactersViewModel {
            throw NetworkError()
        }
        
        await viewModel.loadCharacters()
        
        #expect(viewModel.characters.isEmpty)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage != nil)
        #expect(viewModel.errorMessage?.message.contains("Failed to load characters") == true)
        #expect(viewModel.errorMessage?.message.contains("Network connection failed") == true)
    }
    
    @Test("loadCharacters handles generic error")
    func testLoadCharactersGenericError() async {
        struct GenericError: Error {
            let message = "Something went wrong"
        }
        
        let viewModel = CharactersViewModel {
            throw GenericError()
        }
        
        await viewModel.loadCharacters()
        
        #expect(viewModel.characters.isEmpty)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage != nil)
        #expect(viewModel.errorMessage?.message.contains("Failed to load characters") == true)
    }
    
    @Test("loadCharacters preserves previous data on error")
    func testLoadCharactersPreservesPreviousDataOnError() async {
        let initialCharacters = createMockCharacters()
        var shouldThrow = false
        
        let viewModel = CharactersViewModel {
            if shouldThrow {
                throw URLError(.networkConnectionLost)
            }
            return initialCharacters
        }
        
        // First successful load
        await viewModel.loadCharacters()
        #expect(viewModel.characters.count == 3)
        #expect(viewModel.errorMessage == nil)
        
        // Second load that fails
        shouldThrow = true
        await viewModel.loadCharacters()
        
        // Previous data should be preserved
        #expect(viewModel.characters.count == 3)
        #expect(viewModel.errorMessage != nil)
        #expect(viewModel.isLoading == false)
    }
    
    // MARK: - Loading State Tests
    
    @Test("isLoading state changes correctly during successful load")
    func testLoadingStateDuringSuccessfulLoad() async {
        let viewModel = CharactersViewModel {
            // Simulate some delay
            try await Task.sleep(for: .milliseconds(10))
            return self.createMockCharacters()
        }
        
        #expect(viewModel.isLoading == false)
        
        let loadTask = Task {
            await viewModel.loadCharacters()
        }
        
        // Give the task a moment to start
        try? await Task.sleep(for: .milliseconds(5))
        
        await loadTask.value
        
        #expect(viewModel.isLoading == false)
        #expect(viewModel.characters.count == 3)
    }
    
    @Test("isLoading state changes correctly during failed load")
    func testLoadingStateDuringFailedLoad() async {
        let viewModel = CharactersViewModel {
            // Simulate some delay before error
            try await Task.sleep(for: .milliseconds(10))
            throw URLError(.timedOut)
        }
        
        #expect(viewModel.isLoading == false)
        
        await viewModel.loadCharacters()
        
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage != nil)
    }
    
    // MARK: - Error Model Tests
    
    @Test("ErrorModel has unique identifiers")
    func testErrorModelUniqueIdentifiers() {
        let error1 = ErrorModel(message: "Error 1")
        let error2 = ErrorModel(message: "Error 2")
        
        #expect(error1.id != error2.id)
        #expect(error1.message == "Error 1")
        #expect(error2.message == "Error 2")
    }
    
    // MARK: - Mock Tests
    
    @Test("MockCharactersViewModel provides valid mock data")
    func testMockCharactersViewModel() async throws {
        let mockCharacter = MockCharactersViewModel.mockCharacter()
        
        #expect(mockCharacter.id == 1)
        #expect(mockCharacter.name == "Rick Sanchez")
        #expect(mockCharacter.origin == "Earth (C-137)")
        #expect(mockCharacter.location == "Citadel of Ricks")
        #expect(mockCharacter.image.absoluteString == "https://rickandmortyapi.com/api/character/avatar/1.jpeg")
        
        let mockCharacters = try await MockCharactersViewModel.mockcharactersLoader()
        #expect(mockCharacters.count == 1)
        #expect(mockCharacters[0].name == "Rick Sanchez")
    }
    
    @Test("ViewModel works with MockCharactersViewModel")
    func testViewModelWithMockLoader() async {
        let viewModel = CharactersViewModel(charactersLoader: MockCharactersViewModel.mockcharactersLoader)
        
        await viewModel.loadCharacters()
        
        #expect(viewModel.characters.count == 1)
        #expect(viewModel.characters[0].name == "Rick Sanchez")
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage == nil)
    }
}
