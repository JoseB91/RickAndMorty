//
//  LoadImageCacheTests.swift
//  RickAndMortyTests
//
//  Created by José Briones on 4/7/25.
//

import Foundation
import Testing
@testable import RickAndMorty

@Suite("Load Image Cache Tests")
struct LoadImageCacheTests {
    
    @Test("Load requests image retrieval")
    func loadRequestsImageRetrieval() async {
        // Arrange
        let (sut, store) = makeSUT()
        
        // Act
        _ = try? await sut.loadImageData(from: anyURL())
        
        // Assert
        #expect(store.receivedMessages == [.retrieve])
    }
        
    @Test("Load delivers stored data on successful load")
    func loadDeliversStoredDataOnSuccessfulLoad() async {
        // Arrange
        let data = anyData()
        let (sut, store) = makeSUT()
        
        // Act & Assert
        await expect(sut, toCompleteWith: .success(data), when: {
            store.completeRetrieval(with: data)
        })
    }
            
    @Test("Load fails with NotFoundError on not found data")
    func loadFailsWithNotFoundErrorOnNotFoundData() async {
        // Arrange
        let (sut, store) = makeSUT()

        // Act & Assert
        await expect(sut, toCompleteWith: .failure(LocalImageStorage.LoadError.notFound), when: {
            store.completeRetrieval(with: .none)
        })
    }
        
    @Test("Load fails with FailedError on load error")
    func loadFailsWithFailedErrorOnLoadError() async {
        // Arrange
        let (sut, store) = makeSUT()
        
        // Act & Assert
        await expect(sut, toCompleteWith: .failure(LocalImageStorage.LoadError.failed), when: {
            store.completeRetrieval(with: anyNSError())
        })
    }
        
    // MARK: - Helpers
        
    private func makeSUT(sourceLocation: SourceLocation = #_sourceLocation) -> (sut: LocalImageStorage, store: ImageStoreSpy) {
        let store = ImageStoreSpy()
        let sut = LocalImageStorage(store: store)
        return (sut, store)
    }
    
    private func expect(_ sut: LocalImageStorage, toCompleteWith expectedResult: Result<Data, Error>, when action: () async -> Void, sourceLocation: SourceLocation = #_sourceLocation) async {
        await action()

        do {
            let receivedData = try await sut.loadImageData(from: anyURL())
            
            switch expectedResult {
            case let .success(expectedData):
                #expect(receivedData == expectedData, sourceLocation: sourceLocation)
            case .failure:
                Issue.record("Expected failure but got success with \(receivedData)", sourceLocation: sourceLocation)
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
