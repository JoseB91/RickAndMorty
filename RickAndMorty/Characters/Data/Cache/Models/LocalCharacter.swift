//
//  LocalCharacter.swift
//  RickAndMorty
//
//  Created by José Briones on 30/6/25.
//

import SwiftData
import Foundation

@preconcurrency @Model
public final class LocalCharacter: Sendable {
    @Attribute(.unique)
    public var id: Int
    
    var name: String
    var origin: String
    var location: String
    var data: Data?
    var image: URL
    
    @Relationship(inverse: \LocalCache.characters)
    var cache: LocalCache?

    init(id: Int, name: String, origin: String, location: String, data: Data? = nil, image: URL) {
        self.id = id
        self.name = name
        self.origin = origin
        self.location = location
        self.image = image
    }
    
    static func getImageData(with url: URL, in context: ModelContext) throws -> Data? {
        if let cachedData = URLImageCache.shared.getImageData(for: url) {
            return cachedData
        }

        if let character = try getFirst(with: url, in: context), let imageData = character.data {
            URLImageCache.shared.setImageData(imageData, for: url)
            return imageData
        }
        
        return nil
    }
    
    static func getFirst(with url: URL, in context: ModelContext) throws -> LocalCharacter? {
        var descriptor = FetchDescriptor<LocalCharacter>()
        descriptor.predicate = #Predicate<LocalCharacter> { character in
            url == character.image
        }
        descriptor.fetchLimit = 1
        return try context.fetch(descriptor).first
    }
}
