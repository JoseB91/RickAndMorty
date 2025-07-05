//
//  InMemoryStore.swift
//  RickAndMorty
//
//  Created by José Briones on 3/7/25.
//

import Foundation

public class InMemoryStore {
    var charactersCache: CachedCharacters?
    var imageData = NSCache<NSURL, NSData>()
}
