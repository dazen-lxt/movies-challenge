//
//  ListInteractorTests.swift
//  ChallengeTests
//
//  Created by Carlos Mario Munoz Perez on 19/10/22.
//

import XCTest
@testable import Challenge

class ListInteractorTests: XCTestCase {
    
    // MARK: - Private properties -
    private var interactor = ListInteractor()
    private var mockPresenter = ListPresenterMock()
    private var mockCoreData = CoreDataManagerMock()
    private var mockApiClient = ApiClientMock()
    
    // MARK: - Module setup -
    override func setUp() {
        interactor.presenter = mockPresenter
        interactor.coreDataManager = mockCoreData
        interactor.apiClient = mockApiClient
        mockApiClient.clearResponses()
    }
    
    // MARK: - Tests -
    func testfetchDataFetchPage1FromTerm() {
        mockPresenter.expectation = self.expectation(description: "PresentMovies")
        let mockPageResponse = PageWrapperModel(
            page: 1,
            results: [stubMovieModel()],
            totalPages: 10,
            totalResults: 100
        )
        let mockGenresResponse = GenresModel(genres: [IdNameModel(id: 1, name: "")])
        mockApiClient.addMoviesPagesResponse(response: mockPageResponse, code: 200)
        mockApiClient.addGenresResponse(response: mockGenresResponse, code: 200)
        interactor.searchByTerm(page: 1, query: "aa")
        waitForExpectations(timeout: 10.0, handler: nil)
        XCTAssert(mockPresenter.firstLoad == true)
        XCTAssert(mockPresenter.models.count == 1)
    }
    
    func testfetchDataFetchPage1NFromTerm() {
        mockPresenter.expectation = self.expectation(description: "PresentMovies")
        let mockPageResponse = PageWrapperModel(
            page: 2,
            results: [stubMovieModel()],
            totalPages: 10,
            totalResults: 100
        )
        let mockGenresResponse = GenresModel(genres: [IdNameModel(id: 1, name: "")])
        mockApiClient.addMoviesPagesResponse(response: mockPageResponse, code: 200)
        mockApiClient.addGenresResponse(response: mockGenresResponse, code: 200)
        interactor.searchByTerm(page: 2, query: "aa")
        waitForExpectations(timeout: 10.0, handler: nil)
        XCTAssert(mockPresenter.firstLoad == false)
        XCTAssert(mockPresenter.models.count == 1)
    }
    
    func testfetchDataFetchPage1() {
        mockPresenter.expectation = self.expectation(description: "PresentMovies")
        let mockPageResponse = PageWrapperModel(
            page: 1,
            results: [stubMovieModel()],
            totalPages: 10,
            totalResults: 100
        )
        let mockGenresResponse = GenresModel(genres: [IdNameModel(id: 1, name: "")])
        mockApiClient.addMoviesPagesResponse(response: mockPageResponse, code: 200)
        mockApiClient.addGenresResponse(response: mockGenresResponse, code: 200)
        interactor.fetchData(page: 1)
        waitForExpectations(timeout: 10.0, handler: nil)
        XCTAssert(mockPresenter.firstLoad == true)
        XCTAssert(mockPresenter.models.count == 1)
    }
    
    func testfetchDataFetchPage1N() {
        mockPresenter.expectation = self.expectation(description: "PresentMovies")
        let mockPageResponse = PageWrapperModel(
            page: 2,
            results: [stubMovieModel()],
            totalPages: 10,
            totalResults: 100
        )
        let mockGenresResponse = GenresModel(genres: [IdNameModel(id: 1, name: "")])
        mockApiClient.addMoviesPagesResponse(response: mockPageResponse, code: 200)
        mockApiClient.addGenresResponse(response: mockGenresResponse, code: 200)
        interactor.fetchData(page: 2)
        waitForExpectations(timeout: 10.0, handler: nil)
        XCTAssert(mockPresenter.firstLoad == false)
        XCTAssert(mockPresenter.models.count == 1)
    }
    
    func testfetchDataFetchWithoutConnection() {
        mockPresenter.expectation = self.expectation(description: "PresentMovies")
        interactor.fetchData(page: 1)
        waitForExpectations(timeout: 10.0, handler: nil)
        XCTAssert(mockPresenter.firstLoad == true)
        XCTAssert(mockPresenter.models.count == 0)
    }
    
    func testfetchDataFetchPageWithTermAndWithoutConnection() {
        mockPresenter.expectation = self.expectation(description: "PresentMovies")
        interactor.searchByTerm(page: 2, query: "aa")
        waitForExpectations(timeout: 10.0, handler: nil)
        XCTAssert(mockPresenter.firstLoad == false)
        XCTAssert(mockPresenter.models.count == 0)
    }
    
    private func stubMovieModel() -> MovieModel {
        return MovieModel(
            id: 1,
            title: "title",
            posterPath: "",
            backdropPath: "",
            genreIds: [],
            releaseYear: 0,
            overview: ""
        )
    }
}
