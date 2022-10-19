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
    var posterPath: String?
    var backdropPath: String?
    var genreIds: [Int]?
    var releaseYear: Int?
    var overview: String?

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
        releaseYear: Int,
        overview: String
    ) {
        self.id = id
        self.title = title
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.genreIds = genreIds
        self.releaseYear = releaseYear
        self.overview = overview
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        title = try values.decode(String.self, forKey: .title)
        posterPath = try? values.decode(String.self, forKey: .posterPath)
        backdropPath = try? values.decode(String.self, forKey: .backdropPath)
        genreIds = try? values.decode([Int].self, forKey: .genreIds)
        overview = try? values.decode(String.self, forKey: .overview)
        if let dateString =  try? values.decode(String.self, forKey: .releaseDate) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let regDate = dateFormatter.date(from: dateString) {
                releaseYear = Calendar.current.component(.year, from: regDate)
            }
        }
    }
}
