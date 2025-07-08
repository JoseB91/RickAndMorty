//
//  SaveCharactersCacheTests.swift
//  RickAndMortyTests
//
//  Created by José Briones on 4/7/25.
//

import Testing
import RickAndMorty
import Foundation

@Suite("Save Countries Cache Tests")
struct SaveCountriesCacheTests {
    
    @Test("Save succeeds on successful cache insertion")
    func saveSucceedsOnSuccessfulCacheInsertion() async {
        // Arrange
        let (sut, store) = makeSUT()
        
        // Act & Assert
        await expect(sut, toCompleteWithError: nil, when: {
            store.completeInsertionSuccessfully()
        })
    }
    
    @Test("Save deletes cache on insertion error")
    func saveDeletesCacheOnInsertionError() async {
        // Arrange
        let (sut, store) = makeSUT()
        let insertionError = anyNSError()
        
        // Act & Assert
        await expect(sut, toCompleteWithError: insertionError, when: {
            store.completeInsertion(with: insertionError)
            store.completeDeletionSuccessfully()
        })
    }
    
    @Test("Save fails on insertion error and deletion error")
    func saveFailsOnInsertionErrorAndDeletionError() async {
        // Arrange
        let (sut, store) = makeSUT()
        
        // Act & Assert
        await expect(sut, toCompleteWithError: anyNSError(), when: {
            store.completeInsertion(with: anyNSError())
            store.completeDeletion(with: anyNSError())
        })
    }
        
    // MARK: - Helpers

    private func makeSUT(currentDate: @escaping () -> Date = Date.init, sourceLocation: SourceLocation = #_sourceLocation) -> (sut: LocalCharactersStorage, store: CharactersStoreSpy) {
        let store = CharactersStoreSpy()
        let sut = LocalCharactersStorage(store: store, currentDate: currentDate)
        return (sut, store)
    }

    private func expect(_ sut: LocalCharactersStorage, toCompleteWithError expectedError: NSError?, when action: () async -> Void, sourceLocation: SourceLocation = #_sourceLocation) async {
        
        do {
            try await sut.save(mockCharacters().models)
            
            await action()
        } catch {
            if let expectedError = expectedError {
                #expect((error as NSError) == expectedError, sourceLocation: sourceLocation)
            } else {
                Issue.record("Expected success but got error \(error)", sourceLocation: sourceLocation)
            }
        }
    }
}
