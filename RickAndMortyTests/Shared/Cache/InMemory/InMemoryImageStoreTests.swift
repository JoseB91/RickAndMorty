//
//  InMemoryImageStoreTests.swift
//  RickAndMortyTests
//
//  Created by José Briones on 4/7/25.
//

import Foundation
import Testing
@testable import RickAndMorty

@Suite("InMemory Image Tests")
struct InMemoryImageStoreTests: ImageStoreSpecs {
    
    @Test("Retrieve image data delivers last inserted value")
    func retrieveImageData_deliversLastInsertedValue() async throws {
        let sut = makeSUT()
        await assertThatRetrieveImageDataDeliversLastInsertedValueForURL(on: sut)
    }
    
    @Test("Retrieve image data delivers found data when there is a stored image data matching URL")
    func retrieveImageData_deliversFoundDataWhenThereIsAStoredImageDataMatchingURL() async throws {
        let sut = makeSUT()
        await assertThatRetrieveImageDataDeliversFoundDataWhenThereIsAStoredImageDataMatchingURL(on: sut)
    }
    
    @Test("Retrieve image data delivers not found when empty")
    func retrieveImageData_deliversNotFoundWhenEmpty() async throws {
        let sut = makeSUT()
        await assertThatRetrieveImageDataDeliversNotFoundOnEmptyCache(on: sut)
    }
    
    @Test("Retreive image data delivers not found when stored data URL does not match")
    func retrieveImageData_deliversNotFoundWhenStoredDataURLDoesNotMatch() async throws {
        let sut = makeSUT()
        await assertThatRetrieveImageDataDeliversNotFoundWhenStoredDataURLDoesNotMatch(on: sut)
    }
    
    // - MARK: Helpers
    
    private func makeSUT(sourceLocation: SourceLocation = #_sourceLocation) -> InMemoryStore {
        let sut = InMemoryStore()
        return sut
    }
}
