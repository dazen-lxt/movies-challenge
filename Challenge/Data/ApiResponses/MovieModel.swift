//
//  ApiResponse+Movie.swift
//  Challenge
//
//  Created by Carlos Mario Munoz Perez on 14/10/22.
//

import Foundation

struct MovieModel: Decodable {

    var id: Int
    var title: String
    var posterPath: String
    var backdropPath: String
    var genreIds: [Int]
    var releaseDate: Date
    var overview: String

    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case genreIds = "genre_ids"
        case releaseDate = "release_date"
        case backdropPath = "backdrop_path"
    }

    init(
        id: Int,
        title: String,
        posterPath: String,
        backdropPath: String,
        genreIds: [Int],
        releaseDate: Date,
        overview: String
    ) {
        self.id = id
        self.title = title
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.genreIds = genreIds
        self.releaseDate = releaseDate
        self.overview = overview
    }
}
