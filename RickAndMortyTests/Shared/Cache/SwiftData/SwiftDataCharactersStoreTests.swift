//
//  SwiftDataCharacterStoreTests.swift
//  RickAndMortyTests
//
//  Created by José Briones on 4/7/25.
//

import Foundation
import Testing
@testable import RickAndMorty
import SwiftData

@Suite("SwiftData Characters Tests")

struct SwiftDataCharacterStoreTests: CharactersStoreSpecs {
    
    @Test("Insert delivers no empty cache")
    func test_insert_deliversNoErrorOnEmptyCache() async throws {
        let sut = makeSUT()

        await assertThatInsertDeliversNoErrorOnEmptyCache(on: sut)
    }

    @Test("Insert delivers no error on non empty cache")
    func test_insert_deliversNoErrorOnNonEmptyCache() async throws {
        let sut = makeSUT()

        await assertThatInsertDeliversNoErrorOnNonEmptyCache(on: sut)
    }
    
    @Test("Insert do not save on non empty cache")
    func test_insert_doNotSaveOnNonEmptyCache() async throws {
        //TODO: Review this test
//        let sut = makeSUT()
//
//        await assertThatInsertDoNotSaveOnNonEmptyCache(on: sut)
    }
    
    @Test("Delete delivers no error on empty cache")
    func test_delete_deliversNoErrorOnEmptyCache() async throws {
        let sut = makeSUT()

        await assertThatDeleteDeliversNoErrorOnEmptyCache(on: sut)
    }

    @Test("Delete has no side effects on empty cache")
    func test_delete_hasNoSideEffectsOnEmptyCache() async throws {
        let sut = makeSUT()

        await assertThatDeleteHasNoSideEffectsOnEmptyCache(on: sut)
    }

    @Test("Delete delivers no error on non empty cache")
    func test_delete_deliversNoErrorOnNonEmptyCache() async throws {
        let sut = makeSUT()

        await assertThatDeleteDeliversNoErrorOnNonEmptyCache(on: sut)
    }

    @Test("Delete empties previously inserted cache")
    func test_delete_emptiesPreviouslyInsertedCache() async throws {
        let sut = makeSUT()

        await assertThatDeleteEmptiesPreviouslyInsertedCache(on: sut)
    }

    // - MARK: Helpers

    private func makeSUT(sourceLocation: SourceLocation = #_sourceLocation) -> SwiftDataStore {
        let schema = Schema([
            LocalCharacter.self,
            LocalCache.self
        ])

        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let modelContainer = try! ModelContainer(for: schema, configurations: [configuration])
        
        let sut = SwiftDataStore(modelContainer: modelContainer) //TODO: Improve this
        return sut
    }

}

