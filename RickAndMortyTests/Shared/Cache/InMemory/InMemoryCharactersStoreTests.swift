//
//  InMemoryCharactersStoreTests.swift
//  RickAndMortyTests
//
//  Created by José Briones on 4/7/25.
//

import Foundation
import Testing
@testable import RickAndMorty

@Suite("InMemory Characters Tests")
struct InMemoryCharactersStoreTests: CharactersStoreSpecs {
    
    @Test("Insert delivers no empty cache")
    func insert_deliversNoErrorOnEmptyCache() async throws {
        let sut = makeSUT()

        await assertThatInsertDeliversNoErrorOnEmptyCache(on: sut)
    }

    @Test("Insert delivers no error on non empty cache")
    func insert_deliversNoErrorOnNonEmptyCache() async throws {
        let sut = makeSUT()

        await assertThatInsertDeliversNoErrorOnNonEmptyCache(on: sut)
    }
    
    @Test("Insert do not save on non empty cache")
    func insert_doNotSaveOnNonEmptyCache() async throws {
        //TODO: Review test
//        let sut = makeSUT()
//        
//        await assertThatInsertDoNotSaveOnNonEmptyCache(on: sut)
    }
    
    @Test("Delete delivers no error on empty cache")
    func delete_deliversNoErrorOnEmptyCache() async throws {
        let sut = makeSUT()

        await assertThatDeleteDeliversNoErrorOnEmptyCache(on: sut)
    }

    @Test("Delete has no side effects on empty cache")
    func delete_hasNoSideEffectsOnEmptyCache() async throws {
        let sut = makeSUT()

        await assertThatDeleteHasNoSideEffectsOnEmptyCache(on: sut)
    }

    @Test("Delete delivers no error on non empty cache")
    func delete_deliversNoErrorOnNonEmptyCache() async throws {
        let sut = makeSUT()

        await assertThatDeleteDeliversNoErrorOnNonEmptyCache(on: sut)
    }

    @Test("Delete empties previously inserted cache")
    func delete_emptiesPreviouslyInsertedCache() async throws {
        let sut = makeSUT()

        await assertThatDeleteEmptiesPreviouslyInsertedCache(on: sut)
    }

    // - MARK: Helpers

    private func makeSUT(sourceLocation: SourceLocation = #_sourceLocation) -> InMemoryStore {
        let sut = InMemoryStore()
        return sut
    }
}

