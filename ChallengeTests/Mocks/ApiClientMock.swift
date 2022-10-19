//
//  ApiClientMock.swift
//  ChallengeTests
//
//  Created by Carlos Mario Munoz Perez on 19/10/22.
//

import XCTest
@testable import Challenge

class ApiClientMock: ApiClientProtocol {
    
    // MARK: - Internal properties -
    var mockResponses: [(Int, Any)] = []
    
    // MARK: - Internal methods -
    func doRequest<T>(req: EndpointProtocol, completionHandler: @escaping ((ApiResult<T>) -> Void)) where T : Decodable {
        for (statusCode, response) in mockResponses {
            if let data = response as? T {
                completionHandler(.success(data, statusCode))
                return
            }
        }
        completionHandler(.failure(nil, nil, 0))
    }
    
    func clearResponses() {
        mockResponses = []
    }
    
    func addMoviesPagesResponse(response: PageWrapperModel<MovieModel>, code: Int) {
        mockResponses.append((code, response))
    }
    
    func addGenresResponse(response: GenresModel, code: Int) {
        mockResponses.append((code, response))
    }
}
