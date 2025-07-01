//
//  LocalCharacter.swift
//  RickAndMorty
//
//  Created by José Briones on 30/6/25.
//

import SwiftData
import Foundation

@Model
public class LocalCharacter {
    @Attribute(.unique)
    var id: Int
    
    var name: String
    var origin: String
    var location: String
    var image: URL
    
    @Relationship(inverse: \LocalCache.characters)
    var cache: LocalCache?

    init(id: Int, name: String, origin: String, location: String, image: URL) {
        self.id = id
        self.name = name
        self.origin = origin
        self.location = location
        self.image = image
    }
}
