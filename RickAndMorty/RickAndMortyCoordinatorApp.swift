//
//  RickAndMortyCoordinatorApp.swift
//  RickAndMorty
//
//  To switch to the Coordinator architecture:
//  1. Add @main to this struct.
//  2. Remove @main from RickAndMortyApp.swift.
//

import SwiftUI

// @main  ← uncomment this and remove @main from RickAndMortyApp.swift to activate
@main
struct RickAndMortyCoordinatorApp: App {
    private let appCoordinator: AppCoordinator

    init() {
        self.appCoordinator = AppCoordinator.make()
    }

    var body: some Scene {
        WindowGroup {
            CoordinatorView(appCoordinator: appCoordinator)
        }
    }
}
