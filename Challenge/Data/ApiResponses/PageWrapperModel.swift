//
//  ApiResponse+Page.swift
//  Challenge
//
//  Created by Carlos Mario Munoz Perez on 14/10/22.
//

import Foundation

struct PageWrapperModel<T: Decodable>: Decodable {
    var page: Int
    var results: [T]
    var totalPages: Int
    var totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
