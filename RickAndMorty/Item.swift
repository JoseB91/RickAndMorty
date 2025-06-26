//
//  Item.swift
//  RickAndMorty
//
//  Created by José Briones on 26/6/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
