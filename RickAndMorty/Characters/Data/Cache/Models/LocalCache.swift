//
//  LocalCache.swift
//  RickAndMorty
//
//  Created by José Briones on 30/6/25.
//

import SwiftData
import Foundation

@Model
class LocalCache {
    var timestamp: Date

    @Relationship(deleteRule: .cascade)
    var characters: [LocalCharacter]

    init(timestamp: Date, characters: [LocalCharacter] = []) {
        self.timestamp = timestamp
        self.characters = characters
    }
    
    static func find(in context: ModelContext) throws -> LocalCache? {
        return try context.fetch(FetchDescriptor<LocalCache>()).first
    }
    
    static func deleteCache(in context: ModelContext) throws {
        try find(in: context).map(context.delete).map(context.save)
    }
    
    static func cacheExists(in context: ModelContext) throws -> Bool {
        try find(in: context) != nil
    }
}

