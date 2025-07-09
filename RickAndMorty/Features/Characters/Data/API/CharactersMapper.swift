//
//  CharactersMapper.swift
//  RickAndMorty
//
//  Created by José Briones on 26/6/25.
//

import Foundation

public final class CharactersMapper {
    
    private struct Root: Decodable {
        let info: InfoCodable
        let results: [ResultCodable]
        
        struct InfoCodable: Decodable {
            let count, pages: Int
            let next: String?
            let prev: String?
        }
        
        struct ResultCodable: Decodable {
            let id: Int
            let name: String
            let origin, location: LocationCodable
            let image: URL
        }
        
        struct LocationCodable: Decodable {
            let name: String
            let url: String
        }
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [Character] {
        guard response.isOK else {
            throw MapperError.unsuccessfullyResponse
        }
        
        do {
            let root = try JSONDecoder().decode(Root.self, from: data)
            let characters = root.results
                .map { Character(id: $0.id,
                                 name: $0.name,
                                 origin: $0.origin.name,
                                 location: $0.location.name,
                                 image: $0.image) }
            return characters
        } catch {
            throw error
        }
    }
}
