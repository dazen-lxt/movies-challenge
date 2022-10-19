//
//  MovieDetailPresenter.swift
//  Challenge
//
//  Created by Carlos Mario Munoz Perez on 18/10/22.
//

import Foundation

final class MovieDetailPresenter {

    // MARK: - Internal properties -
    weak var viewController: MovieDetailDisplayLogic?
}

// MARK: - MovieDetailPresentationLogic -
extension MovieDetailPresenter: MovieDetailPresentationLogic {

    func presentMovies(movie: MovieModel, genres: [IdNameModel]) {
        let genresString: String = genres.map { $0.name }.joined(separator: ", ")
        let detailViewModel: MovieDetailViewModel = MovieDetailViewModel(
            title: movie.title,
            year: "\(movie.releaseYear ?? 0)",
            genres: genresString,
            body: movie.overview ?? "",
            backdropPath: URL(string: "https://image.tmdb.org/t/p/w780/\(movie.backdropPath ?? "")")
        )
        viewController?.displayViewModel(detailViewModel)
    }

    func presentIfIsFavorite(_ isFavorite: Bool) {
        viewController?.displayIfIsFavorite(isFavorite)
    }
}
