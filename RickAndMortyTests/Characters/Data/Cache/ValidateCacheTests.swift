//
//  ValidateCacheTests.swift
//  RickAndMortyTests
//
//  Created by José Briones on 4/7/25.
//

import Foundation
import Testing
@testable import RickAndMorty

@Suite("Validate Cache Tests")
struct ValidateCacheTests {
    
    @Test("Validate cache succeeds on successful deletion of expired cache")
    func validateCacheSucceedsOnSuccessfulDeletionOfExpiredCache() async {
        let leagues = mockCharacters()
        let fixedCurrentDate = Date()
        let expiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: -1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })

        await expect(sut, toCompleteWith: .success(()), when: {
            store.completeRetrieval(with: leagues.local, timestamp: expiredTimestamp)
            store.completeDeletionSuccessfully()
        })
    }
    
    @Test("Validate cache succeeds on non-expired cache")
    func validateCacheSucceedsOnNonExpiredCache() async {
        let leagues = mockCharacters()
        let fixedCurrentDate = Date()
        let nonExpiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: 1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })

        await expect(sut, toCompleteWith: .success(()), when: {
            store.completeRetrieval(with: leagues.local, timestamp: nonExpiredTimestamp)
        })
    }
    
    @Test("Validate cache succeeds on successful deletion of failed retrieval")
    func validateCacheSucceedsOnSuccessfulDeletionOfFailedRetrieval() async {
        let (sut, store) = makeSUT()

        await expect(sut, toCompleteWith: .success(()), when: {
            store.completeRetrieval(with: anyNSError())
            store.completeDeletionSuccessfully()
        })
    }
    
    @Test("Validate cache succeeds on empty cache")
    func validateCacheSucceedsOnEmptyCache() async {
        let (sut, store) = makeSUT()

        await expect(sut, toCompleteWith: .success(()), when: {
            store.completeRetrievalWithEmptyCache()
        })
    }
    
    @Test("Validate cache deletes cache on retrieval error")
    func validateCacheDeletesCacheOnRetrievalError() async {
        let (sut, store) = makeSUT()
        store.completeRetrieval(with: anyNSError())
        
        try? await sut.validateCache()

        #expect(store.receivedMessages == [.retrieve, .delete])
    }

    @Test("Validate cache does not delete cache on empty cache")
    func validateCacheDoesNotDeleteCacheOnEmptyCache() async {
        let (sut, store) = makeSUT()
        store.completeRetrievalWithEmptyCache()

        try? await sut.validateCache()
        
        #expect(store.receivedMessages == [.retrieve])
    }
        
    @Test("Validate cache deletes on cache expiration")
    func validateCacheDeletesOnCacheExpiration() async {
        let leagues = mockCharacters()
        let fixedCurrentDate = Date()
        let expirationTimestamp = fixedCurrentDate.minusFeedCacheMaxAge()
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        store.completeRetrieval(with: leagues.local, timestamp: expirationTimestamp)

        try? await sut.validateCache()

        #expect(store.receivedMessages == [.retrieve, .delete])
    }
    
    @Test("Validate cache deletes on expired cache")
    func validateCacheDeletesOnExpiredCache() async {
        let leagues = mockCharacters()
        let fixedCurrentDate = Date()
        let expiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: -1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        store.completeRetrieval(with: leagues.local, timestamp: expiredTimestamp)

        try? await sut.validateCache()
        
        #expect(store.receivedMessages == [.retrieve, .delete])
    }
    
    @Test("Validate cache does not delete on non-expired cache")
    func validateCacheDoesNotDeleteOnNonExpiredCache() async {
        let leagues = mockCharacters()
        let fixedCurrentDate = Date()
        let nonExpiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: 1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        store.completeRetrieval(with: leagues.local, timestamp: nonExpiredTimestamp)
        
        try? await sut.validateCache()
        
        #expect(store.receivedMessages == [.retrieve])
    }
    
    @Test("Validate cache fails on deletion error of failed retrieval")
    func validateCacheFailsOnDeletionErrorOfFailedRetrieval() async {
        let (sut, store) = makeSUT()

        await expect(sut, toCompleteWith: .failure(anyNSError()), when: {
            store.completeRetrieval(with: anyNSError())
            store.completeDeletion(with: anyNSError())
        })
    }
    
    @Test("Validate cache fails on deletion error of expired cache")
    func validateCacheFailsOnDeletionErrorOfExpiredCache() async {
        let leagues = mockCharacters()
        let fixedCurrentDate = Date()
        let expiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: -1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        let deletionError = anyNSError()

        await expect(sut, toCompleteWith: .failure(deletionError), when: {
            store.completeRetrieval(with: leagues.local, timestamp: expiredTimestamp)
            store.completeDeletion(with: deletionError)
        })
    }

    // MARK: - Helpers
    
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, sourceLocation: SourceLocation = #_sourceLocation) -> (sut: LocalCharactersStorage, store: CharactersStoreSpy) {
        let store = CharactersStoreSpy()
        let sut = LocalCharactersStorage(store: store, currentDate: currentDate)
        return (sut, store)
    }
    
    private func expect(_ sut: LocalCharactersStorage, toCompleteWith expectedResult: Result<Void, Error>, when action: () async -> Void, sourceLocation: SourceLocation = #_sourceLocation) async {
        await action()
        
        do {
            try await sut.validateCache()            
        } catch {
            switch expectedResult {
            case .success:
                Issue.record("Expected success but got failure with \(error)", sourceLocation: sourceLocation)
            case let .failure(expectedError as NSError):
                #expect((error as NSError) == expectedError, sourceLocation: sourceLocation)
            }
        }
    }
}
