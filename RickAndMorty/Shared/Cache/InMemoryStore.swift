//
//  InMemoryStore.swift
//  RickAndMorty
//
//  Created by José Briones on 3/7/25.
//

import Foundation

actor InMemoryStore {
    var charactersCache: CachedCharacters?
    var imageData = NSCache<NSURL, NSData>()
}
