//
//  CharactersStoreSpy.swift
//  RickAndMortyTests
//
//  Created by José Briones on 8/7/25.
//

import Foundation
import RickAndMorty

public class CharactersStoreSpy: CharactersStore {
    
    enum ReceivedMessage: Equatable {
        case delete
        case insert([LocalCharacter], Date)
        case retrieve
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    
    private var deletionResult: Result<Void, Error>?
    private var insertionResult: Result<Void, Error>?
    private var retrievalResult: Result<CachedCharacters?, Error>?


    // MARK: Delete
    public func deleteCache() async throws {
        receivedMessages.append(.delete)
        try deletionResult?.get()
    }

    func completeDeletion(with error: Error) {
        deletionResult = .failure(error)
    }

    func completeDeletionSuccessfully() {
        deletionResult = .success(())
    }
    
    // MARK: Insert
    public func insert(_ characters: [LocalCharacter], timestamp: Date) async throws {
        receivedMessages.append(.insert(characters, timestamp))
        try insertionResult?.get()
    }
    
    func completeInsertion(with error: Error) {
        insertionResult = .failure(error)
    }

    func completeInsertionSuccessfully() {
        insertionResult = .success(())
    }
    
    // MARK: Retrieve
    public func retrieve() async throws -> CachedCharacters? {
        receivedMessages.append(.retrieve)
        return try retrievalResult?.get()
    }

    func completeRetrieval(with error: Error) {
        retrievalResult = .failure(error)
    }
    
    func completeRetrievalWithEmptyCache() {
        retrievalResult = .success(.none)
    }
    
    func completeRetrievalWithExpiredCache(with characters: [LocalCharacter], timestamp: Date, error: Error) {
        retrievalResult = .failure(error)
    }

    func completeRetrieval(with characters: [LocalCharacter], timestamp: Date) {
        retrievalResult = .success(CachedCharacters(characters: characters, timestamp: timestamp))
    }
}
