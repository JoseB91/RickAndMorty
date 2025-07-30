//
//  CharactersEndpoint.swift
//  RickAndMorty
//
//  Created by José Briones on 26/6/25.
//

import Foundation

enum CharactersEndpoint {
    case getCharacters
    
    func url(baseURL: URL) -> URL {
        switch self {
        case .getCharacters:
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "/character"
            
            guard let url = components.url else { return baseURL }
            return url
        }
    }
}
