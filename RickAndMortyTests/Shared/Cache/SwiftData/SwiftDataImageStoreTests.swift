//
//  SwiftDataImageStoreTests.swift
//  RickAndMortyTests
//
//  Created by José Briones on 4/7/25.
//

import Foundation
import Testing
@testable import RickAndMorty

@Suite("SwiftData Image Tests")
struct SwiftDataImageStoreTests: ImageStoreSpecs {
    
    @Test("Retrieve image data delivers last inserted value")
    func retrieveImageData_deliversLastInsertedValue() async throws {
        //TODO: Review
//        let sut = try await makeSUT()
//        await assertThatRetrieveImageDataDeliversLastInsertedValueForURL(on: sut)
    }
    
    @Test("Retrieve image data delivers found data when there is a stored image data matching URL")
    func retrieveImageData_deliversFoundDataWhenThereIsAStoredImageDataMatchingURL() async throws {
        //TODO: Review
//        let sut = try await makeSUT()
//        await assertThatRetrieveImageDataDeliversFoundDataWhenThereIsAStoredImageDataMatchingURL(on: sut)
    }
    
    @Test("Retrieve image data delivers not found when empty")
    func retrieveImageData_deliversNotFoundWhenEmpty() async throws {
        let sut = try await makeSUT()
        await assertThatRetrieveImageDataDeliversNotFoundOnEmptyCache(on: sut)
    }
    
    @Test("Retreive image data delivers not found when stored data URL does not match")
    func retrieveImageData_deliversNotFoundWhenStoredDataURLDoesNotMatch() async throws {
        let sut = try await makeSUT()
        await assertThatRetrieveImageDataDeliversNotFoundWhenStoredDataURLDoesNotMatch(on: sut)
    }
    
    // - MARK: Helpers
    
    private func makeSUT(sourceLocation: SourceLocation = #_sourceLocation) async throws ->  SwiftDataStore {
        let sut = try SwiftDataStore(isStoredInMemoryOnly: true)
        await insertCharacter(with: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")!, into: sut)
        return sut
    }
    
    private func insertCharacter(with url: URL, into sut: SwiftDataStore, sourceLocation: SourceLocation = #_sourceLocation) async {
        do {
            try await sut.insert(mockCharacters().local, timestamp: Date())
        } catch {
            Issue.record("Failed to insert league with URL \(url) - error: \(error)", sourceLocation: sourceLocation)
        }
    }
}
