//
//  Character.swift
//  RickAndMorty
//
//  Created by José Briones on 26/6/25.
//

import Foundation

public struct Character: Identifiable, Equatable {
    public let id: Int
    public let name: String
    public let origin: String
    public let location: String
    public let image: URL
    
    public init(id: Int, name: String, origin: String, location: String, image: URL) {
        self.id = id
        self.name = name
        self.origin = origin
        self.location = location
        self.image = image
    }

}
