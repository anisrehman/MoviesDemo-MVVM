//
//  MoviesViewModelTests.swift
//  MoviesDemo-MVVM-Tests
//
//  Created by Anis Rehman on 15/11/2022.
//

import XCTest
import Combine

final class MoviesViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchSearchAndClearSearch() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        DependencyContainer.shared.register(type: MovieStoring.self, value: MockMoviesRepository(), overwrite: true)

        var subscribers: [AnyCancellable] = []
        let viewModel = MoviesViewModel()

        var expectation = self.expectation(description: "Movies Fetched")
        var result: [Movie]?
        viewModel.$movies.dropFirst().sink { movies in
            result = movies
            expectation.fulfill()
        }.store(in: &subscribers)

        viewModel.fetchMovies(.topRated)
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(result)
        if let result {
            XCTAssertGreaterThan(result.count, 0)
        }

        subscribers[0].cancel()
        subscribers.removeFirst()

        var searchResult: [Movie]?
        expectation = self.expectation(description: "Movie search")
        viewModel.$movies.dropFirst().sink { movies in
            debugPrint(movies.count)
            searchResult = movies
            expectation.fulfill()
        }.store(in: &subscribers)

        viewModel.searchMovies(text: "Godfather", category: .topRated)
        waitForExpectations(timeout: 5, handler: nil)
        let searchMovies =  try XCTUnwrap(searchResult)
        XCTAssertGreaterThan(searchMovies.count, 0, "No movie searched")

        subscribers[0].cancel()
        subscribers.removeFirst()

        var clearSearchResult: [Movie]?
        expectation = self.expectation(description: "Clear search")
        viewModel.$movies.dropFirst().sink { movies in
            debugPrint(movies.count)
            clearSearchResult = movies
            expectation.fulfill()
        }.store(in: &subscribers)
        viewModel.clearSearch(category: .topRated)
        waitForExpectations(timeout: 5, handler: nil)

        let clearSearchMovies =  try XCTUnwrap(clearSearchResult)
        XCTAssertEqual(result!.count, clearSearchMovies.count)

        subscribers[0].cancel()
        subscribers.removeFirst()
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
