//
//  CoreDataManagerMock.swift
//  ChallengeTests
//
//  Created by Carlos Mario Munoz Perez on 19/10/22.
//

import XCTest
@testable import Challenge

class CoreDataManagerMock: CoreDataManagerLogic {
    
    func getMovies(genres: [Int], year: Int?) async -> [Movie] {
        await withCheckedContinuation{ continuation in
            let movie = StubMovie(id: 10)
            let movies = [movie]
            continuation.resume(with: .success(movies))
        }
    }
}

class StubMovie: Movie {
    convenience init(id: Int = 0) {
        self.init()
        self.stubId = id
    }

    var stubId: Int = 0
    override var id: Int64 {
        set {}
        get {
            return Int64(stubId)
        }
    }
}
