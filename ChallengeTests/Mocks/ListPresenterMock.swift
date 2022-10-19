//
//  ListPresentaterMock.swift
//  ChallengeTests
//
//  Created by Carlos Mario Munoz Perez on 19/10/22.
//

import XCTest
@testable import Challenge

class ListPresenterMock: ListPresentationLogic {
    
    var expectation: XCTestExpectation?
    var firstLoad: Bool = false
    var models: [MovieModel] = []
    
    func presentMovies(model: [MovieModel], favorites: Set<Int>, totalPages: Int, firstLoad: Bool, hasError: Bool) {
        if expectation?.description == "PresentMovies" {
            expectation?.fulfill()
        }
        self.firstLoad = firstLoad
        models = model
    }
    func presentUpdateFavorite(isFavorite: Bool, index: Int) {
        
    }
}
