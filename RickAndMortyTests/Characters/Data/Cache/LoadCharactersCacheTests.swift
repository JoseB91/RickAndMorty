//
//  LoadCharactersCacheTests.swift
//  RickAndMortyTests
//
//  Created by José Briones on 4/7/25.
//

import Testing
import RickAndMorty
import Foundation

@Suite("Load Characters Cache Tests")
struct LoadCountriesCacheTests {
    
    @Test("Load requests cache retrieval")
    func loadRequestsCacheRetrieval() async {
        // Arrange
        let (sut, store) = makeSUT()
        
        // Act
        _ = try? await sut.load()
        
        // Assert
        #expect(store.receivedMessages == [.retrieve])
    }
        
    @Test("Load delivers cached characters on non-expired cache")
    func loadDeliversCachedCountriesOnNonExpiredCache() async {
        // Arrange
        let characters = mockCharacters()
        let fixedCurrentDate = Date()
        let nonExpiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: 1)
        let (sut, store) = makeSUT()
        
        // Act & Assert
        await expect(sut, toCompleteWith: .success(characters.models), when: {
            store.completeRetrieval(with: characters.local, timestamp: nonExpiredTimestamp)
        })
    }
        
    @Test("Load fails on expired cache")
    func loadFailsOnExpiredCache() async {
        // Arrange
        let characters = mockCharacters()
        let fixedCurrentDate = Date()
        let expiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: -1)
        let retrievalError = anyNSError()
        let (sut, store) = makeSUT()

        // Act & Assert
        await expect(sut, toCompleteWith: .failure(anyNSError()), when: {
            store.completeRetrievalWithExpiredCache(with: characters.local, timestamp: expiredTimestamp, error: retrievalError)
        })
    }
        
    @Test("Load fails on retrieval error")
    func loadFailsOnRetrievalError() async {
        // Arrange
        let retrievalError = anyNSError()
        let (sut, store) = makeSUT()
        
        // Act & Assert
        await expect(sut, toCompleteWith: .failure(retrievalError), when: {
            store.completeRetrieval(with: retrievalError)
        })
    }
        
    // MARK: - Helpers
        
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, sourceLocation: SourceLocation = #_sourceLocation) -> (sut: LocalCharactersStorage, store: CharactersStoreSpy) {
        let store = CharactersStoreSpy()
        let sut = LocalCharactersStorage(store: store, currentDate: currentDate)
        return (sut, store)
    }
    
    private func expect(_ sut: LocalCharactersStorage, toCompleteWith expectedResult: Result<[Character], Error>, when action: () async -> Void, sourceLocation: SourceLocation = #_sourceLocation) async {
        await action()

        do {
            let receivedCharacters = try await sut.load()
            
            switch expectedResult {
            case let .success(expectedCharacters):
                #expect(receivedCharacters == expectedCharacters, sourceLocation: sourceLocation)
            case .failure:
                Issue.record("Expected failure but got success with \(receivedCharacters)", sourceLocation: sourceLocation)
            }
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
