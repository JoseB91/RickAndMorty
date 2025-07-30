//
//  Character.swift
//  RickAndMorty
//
//  Created by José Briones on 26/6/25.
//

import Foundation

struct Character: Identifiable, Equatable {
    let id: Int
    let name: String
    let origin: String
    let location: String
    let image: URL
}
