//
//  SaveImageCacheTests.swift
//  RickAndMortyTests
//
//  Created by José Briones on 4/7/25.
//

import Testing
@testable import RickAndMorty
import Foundation

@Suite("Image Mapper Tests")
struct ImageMapperTests {

    @Test("Map delivers non empty data on 200 HTTP response")
    func map_deliversNonEmptyDataOn200HTTPResponse() throws {
        // Arrange
        let nonEmptyData = Data("non-empty data".utf8)

        // Act
        let result = try ImageMapper.map(nonEmptyData,
                                         from: HTTPURLResponse(statusCode: 200))

        // Assert
        #expect(result == nonEmptyData)
    }
    
    @Test("Map throws error on 200 HTTP response with empty data")
    func map_throwsErrorOn200HTTPResponseWithEmptyData() {
        // Arrange
        let emptyData = Data()

        // Act & Assert
        #expect(throws: MapperError.unsuccessfullyResponse.self) {
            try ImageMapper.map(emptyData, from: HTTPURLResponse(statusCode: 200))
        }
    }
    
    @Test("Map throws error on non-200 HTTP response", arguments: [199, 201, 300, 400, 500])
    func map_throwsUnsuccessfullyResponseErrorOnNon200HTTPResponse(statusCode: Int) throws {
        
        // Act & Assert
        #expect(throws: MapperError.unsuccessfullyResponse.self) {
            try ImageMapper.map(anyData(), from: HTTPURLResponse(statusCode: statusCode))
        }
    }
}
