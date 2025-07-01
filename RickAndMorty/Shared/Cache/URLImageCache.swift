//
//  URLImageCache.swift
//  RickAndMorty
//
//  Created by José Briones on 30/6/25.
//

import Foundation

class URLImageCache {
    static let shared = URLImageCache()
    
    private let cache = NSCache<NSURL, NSData>()
    
    private init() {
        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1024 * 1024
    }
    
    func setImageData(_ data: Data, for url: URL) {
        cache.setObject(data as NSData, forKey: url as NSURL)
    }
    
    func getImageData(for url: URL) -> Data? {
        return cache.object(forKey: url as NSURL) as Data?
    }
}
