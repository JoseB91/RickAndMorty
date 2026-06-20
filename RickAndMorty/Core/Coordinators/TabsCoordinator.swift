////
////  TabsCoordinator.swift
////  RickAndMorty
////
////  Created by José Briones on 20/6/26.
////
//
//
//// Each tab coordinator owns its own stack
//@Observable
//final class CharactersCoordinator {
//    var path: [Character] = []
//}
//
//@Observable
//final class EpisodesCoordinator {
//    var path: [Episode] = []
//}
//
//@Observable
//final class LocationsCoordinator {
//    var path: [Location] = []
//}
//
//// AppCoordinator wires them together
//final class AppCoordinator {
//    let characters = CharactersCoordinator()
//    let episodes = EpisodesCoordinator()
//    let locations = LocationsCoordinator()
//}
//
//// Root view
//struct CoordinatorView: View {
//    let appCoordinator: AppCoordinator
//
//    var body: some View {
//        TabView {
//            CharactersFlowView(coordinator: appCoordinator.characters)
//                .tabItem { Label("Characters", systemImage: "person") }
//
//            EpisodesFlowView(coordinator: appCoordinator.episodes)
//                .tabItem { Label("Episodes", systemImage: "tv") }
//
//            LocationsFlowView(coordinator: appCoordinator.locations)
//                .tabItem { Label("Locations", systemImage: "map") }
//        }
//    }
//}
