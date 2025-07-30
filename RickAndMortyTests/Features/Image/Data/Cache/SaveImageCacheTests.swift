//
//  SaveImageCacheTests.swift
//  RickAndMortyTests
//
//  Created by José Briones on 4/7/25.
//

import Testing
import Foundation
@testable import RickAndMorty

@Suite("Save Image Cache Tests")
struct SaveImageCacheTests {
    
    @Test("Save succeeds on successful image insertion")
    func saveSucceedsOnSuccessfulImageInsertion() async {
        // Arrange
        let (sut, store) = makeSUT()
        
        // Act & Assert
        await expect(sut, toCompleteWithError: nil, when: {
            store.completeInsertionSuccessfully()
        })
    }
    
    @Test("Save fails on insertion error with FailedError")
    func saveFailsOnInsertionErrorWithFailedError() async {
        // Arrange
        let (sut, store) = makeSUT()
        
        // Act & Assert
        await expect(sut, toCompleteWithError: LocalImageStorage.SaveError.failed, when: {
            store.completeInsertion(with: anyNSError())
        })
    }
        
    // MARK: - Helpers

    private func makeSUT(sourceLocation: SourceLocation = #_sourceLocation) -> (sut: LocalImageStorage, store: ImageStoreSpy) {
        let store = ImageStoreSpy()
        let sut = LocalImageStorage(store: store)
        return (sut, store)
    }

    private func expect(_ sut: LocalImageStorage, toCompleteWithError expectedError: LocalImageStorage.SaveError?, when action: () async -> Void, sourceLocation: SourceLocation = #_sourceLocation) async {
        
        do {
            try await sut.save(anyData(), for: anyURL())
            
            await action()
        } catch {
            if let expectedError = expectedError {
                #expect((error as? LocalImageStorage.SaveError) == expectedError, sourceLocation: sourceLocation)
            } else {
                Issue.record("Expected success but got error \(error)", sourceLocation: sourceLocation)
            }
        }
    }
}
