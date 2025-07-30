////
////  CharactersRepositoryTests.swift
////  RickAndMortyTests
////
////  Created by José Briones on 21/7/25.
////
//
//import Testing
//import Foundation
//@testable import RickAndMorty
//
//@Suite("CharactersRepositoryImpl Tests")
//struct CharactersRepositoryImplTests {
//        
//
//    private func makeStore() -> CharactersStore & ImageStore {
//        do {
//            return try SwiftDataStore(isStoredInMemoryOnly: false)
//        } catch {
//            return InMemoryStore()
//        }
//    }
//    
//    // MARK: - Test Setup Helpers
//    
//    private func makeSUT() -> (
//        sut: CharactersRepositoryImpl,
//        httpClient: HTTPClient,
//        localStorage: LocalCharactersStorage
//    ) {
//        let store = makeStore()
//        let baseURL = URL(string: "https://rickandmortyapi.com")!
//        let httpClient = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
//        let localStorage = LocalCharactersStorage(store: store, currentDate: Date.init)
//        
//        let sut = CharactersRepositoryImpl(
//            baseURL: baseURL,
//            httpClient: httpClient,
//            localCharactersStorage: localStorage
//        )
//        
//        return (sut, httpClient, localStorage)
//    }
//    
//    // MARK: - Tests
//    
//    @Test("loadCharacters returns characters from local storage when available")
//    func loadCharacters_WithLocalStorageSuccess_ReturnsLocalCharacters() async throws {
//        let (sut, httpClient, localStorage) = makeSUT()
//        let expectedCharacters = makeCharacters()
//        localStorage.loadResult = .success(expectedCharacters)
//        
//        let result = try await sut.loadCharacters()
//        
//        #expect(result == expectedCharacters)
//        #expect(localStorage.loadCallCount == 1)
//        #expect(httpClient.getCallCount == 0)
//        #expect(localStorage.saveCallCount == 0)
//    }
//    
//    @Test("loadCharacters fetches from network when local storage fails")
//    func loadCharacters_WithLocalStorageFailure_FetchesFromNetwork() async throws {
//        let (sut, httpClient, localStorage) = makeSUT()
//        let expectedCharacters = makeCharacters()
//        
//        localStorage.loadResult = .failure(TestError.generic)
//        
//        // Mock successful network response
//        let responseData = try JSONEncoder().encode(CharactersResponse(results: expectedCharacters))
//        let httpResponse = makeValidHTTPResponse()
//        httpClient.getResult = .success((responseData, httpResponse))
//        
//        let result = try await sut.loadCharacters()
//        
//        #expect(result == expectedCharacters)
//        #expect(localStorage.loadCallCount == 1)
//        #expect(httpClient.getCallCount == 1)
//        #expect(httpClient.getCalledWithURL?.absoluteString.contains("character") == true)
//    }
//    
//    @Test("loadCharacters saves network response to local storage")
//    func loadCharacters_WithNetworkSuccess_SavesCharactersLocally() async throws {
//        let (sut, httpClient, localStorage) = makeSUT()
//        let expectedCharacters = makeCharacters()
//        
//        localStorage.loadResult = .failure(TestError.generic)
//        localStorage.saveResult = .success(())
//        
//        let responseData = try JSONEncoder().encode(CharactersResponse(results: expectedCharacters))
//        let httpResponse = makeValidHTTPResponse()
//        httpClient.getResult = .success((responseData, httpResponse))
//        
//        let result = try await sut.loadCharacters()
//        
//        #expect(result == expectedCharacters)
//        #expect(localStorage.saveCallCount == 1)
//        #expect(localStorage.savedCharacters == expectedCharacters)
//    }
//    
//    @Test("loadCharacters continues when local storage save fails")
//    func loadCharacters_WithSaveFailure_StillReturnsNetworkResult() async throws {
//        let (sut, httpClient, localStorage) = makeSUT()
//        let expectedCharacters = makeCharacters()
//        
//        localStorage.loadResult = .failure(TestError.generic)
//        localStorage.saveResult = .failure(TestError.generic)
//        
//        let responseData = try JSONEncoder().encode(CharactersResponse(results: expectedCharacters))
//        let httpResponse = makeValidHTTPResponse()
//        httpClient.getResult = .success((responseData, httpResponse))
//        
//        let result = try await sut.loadCharacters()
//        
//        #expect(result == expectedCharacters)
//        #expect(localStorage.saveCallCount == 1)
//    }
//    
//    @Test("loadCharacters throws when network request fails")
//    func loadCharacters_WithNetworkFailure_ThrowsError() async {
//        let (sut, httpClient, localStorage) = makeSUT()
//        
//        localStorage.loadResult = .failure(TestError.generic)
//        httpClient.getResult = .failure(TestError.networkError)
//        
//        await #expect(throws: TestError.networkError) {
//            try await sut.loadCharacters()
//        }
//        
//        #expect(localStorage.loadCallCount == 1)
//        #expect(httpClient.getCallCount == 1)
//        #expect(localStorage.saveCallCount == 0)
//    }
//    
//    @Test("loadCharacters throws when mapping fails")
//    func loadCharacters_WithMappingFailure_ThrowsError() async {
//        let (sut, httpClient, localStorage) = makeSUT()
//        
//        localStorage.loadResult = .failure(TestError.generic)
//        
//        // Invalid JSON data that will cause mapping to fail
//        let invalidData = "invalid json".data(using: .utf8)!
//        let httpResponse = makeValidHTTPResponse()
//        httpClient.getResult = .success((invalidData, httpResponse))
//        
//        await #expect(throws: Error.self) {
//            try await sut.loadCharacters()
//        }
//        
//        #expect(localStorage.loadCallCount == 1)
//        #expect(httpClient.getCallCount == 1)
//        #expect(localStorage.saveCallCount == 0)
//    }
//    
//    @Test("loadCharacters uses correct endpoint URL")
//    func loadCharacters_UsesCorrectEndpointURL() async throws {
//        let (sut, httpClient, localStorage) = makeSUT()
//        let characters = makeCharacters()
//        
//        localStorage.loadResult = .failure(TestError.generic)
//        
//        let responseData = try JSONEncoder().encode(CharactersResponse(results: characters))
//        let httpResponse = makeValidHTTPResponse()
//        httpClient.getResult = .success((responseData, httpResponse))
//        
//        _ = try await sut.loadCharacters()
//        
//        let expectedURL = CharactersEndpoint.getCharacters.url(
//            baseURL: URL(string: "https://rickandmortyapi.com")!
//        )
//        #expect(httpClient.getCalledWithURL == expectedURL)
//    }
//}
