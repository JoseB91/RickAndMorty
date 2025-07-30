//
//  ImageStoreSpy.swift
//  RickAndMortyTests
//
//  Created by José Briones on 8/7/25.
//

import Foundation
@testable import RickAndMorty

class ImageStoreSpy: ImageStore {

    enum ReceivedMessage: Equatable {
        case insert(Data, URL)
        case retrieve
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    
    private var insertionResult: Result<Void, Error>?
    private var retrievalResult: Result<Data?, Error>?

    
    // MARK: Insert
    func insert(_ data: Data, for url: URL) async throws {
        receivedMessages.append(.insert(data, url))
        try insertionResult?.get()
    }
        
    func completeInsertion(with error: Error) {
        insertionResult = .failure(error)
    }

    func completeInsertionSuccessfully() {
        insertionResult = .success(())
    }
    
    // MARK: Retrieve
    func retrieve(dataFor url: URL) async throws -> Data? {
        receivedMessages.append(.retrieve)
        return try retrievalResult?.get()
    }

    func completeRetrieval(with error: Error) {
        retrievalResult = .failure(error)
    }
    
    func completeRetrieval(with data: Data?) {
        retrievalResult = .success(data)
    }
}
