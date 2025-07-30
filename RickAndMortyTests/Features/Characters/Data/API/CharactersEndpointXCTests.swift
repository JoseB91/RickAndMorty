//
//  CharactersEndpointXCTests.swift
//  RickAndMortyTests
//
//  Created by José Briones on 21/7/25.
//

import XCTest
@testable import RickAndMorty

class CharactersEndpointXCTests: XCTestCase {
    
    func test_charactersEndpointURL_hasCorrectComponents() {
        // Arrange
        let baseURL = URL(string: "https://rickandmortyapi.com/api/")!

        // Act
        let received = CharactersEndpoint.getCharacters.url(baseURL: baseURL)
        
        // Assert
        XCTAssertEqual(received.scheme, "https", "scheme")
        XCTAssertEqual(received.host, "rickandmortyapi.com", "host")
        XCTAssertEqual(received.path, "/api/character", "path")
    }
}

