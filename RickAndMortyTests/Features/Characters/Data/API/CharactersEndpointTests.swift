//
//  CharactersEndpointTests.swift
//  RickAndMortyTests
//
//  Created by José Briones on 26/6/25.
//

import Foundation
import Testing
@testable import RickAndMorty

@Suite("CharactersEndpoint Tests")
struct CharactersEndpointTests {
    
    @Test("Characters endpoint URL has the correct components")
    func charactersEndpointURL_hasCorrectComponents() {
        // Arrange
        let baseURL = URL(string: "https://rickandmortyapi.com/api/")!
        
        // Act
        let received = CharactersEndpoint.getCharacters.url(baseURL: baseURL)
        
        // Assert
        #expect(received.scheme == "https")
        #expect(received.host == "rickandmortyapi.com")
        #expect(received.path == "/api/character")
    }
    
    @Test(arguments: [
        ("scheme", "https"),
        ("host", "rickandmortyapi.com"),
        ("path", "/api/character")
    ])
    func charactersEndpointURLComponents(component: String, expected: String) {
        let baseURL = URL(string: "https://rickandmortyapi.com/api/")!
        let url = CharactersEndpoint.getCharacters.url(baseURL: baseURL)
        
        switch component {
        case "scheme": #expect(url.scheme == expected)
        case "host": #expect(url.host == expected)
        case "path": #expect(url.path == expected)
        default: break
        }
    }
}


