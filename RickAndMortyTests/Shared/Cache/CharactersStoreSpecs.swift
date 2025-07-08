//
//  CharactersStoreSpecs.swift
//  RickAndMortyTests
//
//  Created by José Briones on 8/7/25.
//

protocol CharactersStoreSpecs {
    func test_insert_deliversNoErrorOnEmptyCache() async throws
    func test_insert_deliversNoErrorOnNonEmptyCache() async throws
    func test_insert_doNotSaveOnNonEmptyCache() async throws
    
    func test_delete_deliversNoErrorOnEmptyCache() async throws
    func test_delete_hasNoSideEffectsOnEmptyCache() async throws
    func test_delete_deliversNoErrorOnNonEmptyCache() async throws
    func test_delete_emptiesPreviouslyInsertedCache() async throws
}

import Foundation
import Testing
import RickAndMorty

extension CharactersStoreSpecs {
    func assertThatInsertDeliversNoErrorOnEmptyCache(on sut: CharactersStore, sourceLocation: SourceLocation = #_sourceLocation) async {
        // Act
        let insertionError = await insert((mockCharacters().local, Date()), to: sut)
        
        // Assert
        #expect(insertionError == nil, "Expected to insert cache successfully", sourceLocation: sourceLocation)
    }
    
    func assertThatInsertDeliversNoErrorOnNonEmptyCache(on sut: CharactersStore, sourceLocation: SourceLocation = #_sourceLocation) async {
        // Act
        await insert((mockCharacters().local, Date()), to: sut)
                
        let insertionError = await insert((mockCharacters().local, Date()), to: sut)
   
        //Assert
        #expect(insertionError == nil, "Expected to insert just once without error", sourceLocation: sourceLocation)
    }
    
    func assertThatInsertDoNotSaveOnNonEmptyCache(on sut: CharactersStore, sourceLocation: SourceLocation = #_sourceLocation) async {
        // Act
        let timestamp = Date()
        await insert((mockCharacters().local, timestamp), to: sut)
                
        await insert((mockOtherCharacters().local, Date(timeIntervalSinceNow: -1)), to: sut)
   
        //Assert
        await expect(sut, toRetrieve: .success(CachedCharacters(characters: mockCharacters().local, timestamp: timestamp)))
    }
        
    func assertThatDeleteDeliversNoErrorOnEmptyCache(on sut: CharactersStore, sourceLocation: SourceLocation = #_sourceLocation) async {
        // Act
        let deletionError = await deleteCache(from: sut)
        
        // Assert
        #expect(deletionError == nil, "Expected empty cache deletion to succeed", sourceLocation: sourceLocation)
    }
    
    func assertThatDeleteHasNoSideEffectsOnEmptyCache(on sut: CharactersStore, sourceLocation: SourceLocation = #_sourceLocation) async {
        // Act
        await deleteCache(from: sut)
        
        // Assert
        await expect(sut, toRetrieve: .success(.none), sourceLocation: sourceLocation)
    }
    
    func assertThatDeleteDeliversNoErrorOnNonEmptyCache(on sut: CharactersStore, sourceLocation: SourceLocation = #_sourceLocation) async {
        // Act
        await insert((mockCharacters().local, Date()), to: sut)
        let deletionError = await deleteCache(from: sut)
        
        // Assert
        #expect(deletionError == nil, "Expected non-empty cache deletion to succeed", sourceLocation: sourceLocation)
    }
    
    func assertThatDeleteEmptiesPreviouslyInsertedCache(on sut: CharactersStore, sourceLocation: SourceLocation = #_sourceLocation) async {
        // Act
        await insert((mockCharacters().local, Date()), to: sut)
        await deleteCache(from: sut)
        
        // Assert
        await expect(sut, toRetrieve: .success(.none), sourceLocation: sourceLocation)
    }
        
    @discardableResult
    func insert(_ cache: (characters: [LocalCharacter], timestamp: Date), to sut: CharactersStore) async -> Error? {
        do {
            // Act
            try await sut.insert(cache.characters, timestamp: cache.timestamp)
            return nil
        } catch {
            return error
        }
    }
    
    @discardableResult
    func deleteCache(from sut: CharactersStore) async -> Error? {
        do {
            // Act
            try await sut.deleteCache()
            return nil
        } catch {
            return error
        }
    }
    
    func expect(_ sut: CharactersStore, toRetrieve expectedResult: Result<CachedCharacters?, Error>, sourceLocation: SourceLocation = #_sourceLocation) async {
                
        do {
            let retrievedCache: CachedCharacters? = try await sut.retrieve()
           
            switch expectedResult {
            case let .success(expectedCache):
                #expect(retrievedCache?.characters == expectedCache?.characters, sourceLocation: sourceLocation)
                #expect(retrievedCache?.timestamp == expectedCache?.timestamp, sourceLocation: sourceLocation)
            case .failure:
                Issue.record("Expected failure but got success", sourceLocation: sourceLocation)
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
