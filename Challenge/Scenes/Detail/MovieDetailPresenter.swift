//
//  MovieDetailPresenter.swift
//  Challenge
//
//  Created by Carlos Mario Munoz Perez on 18/10/22.
//

import Foundation

final class MovieDetailPresenter {
    weak var viewController: MovieDetailDisplayLogic?
}

extension MovieDetailPresenter: MovieDetailPresentationLogic {

    func presentMovies(movie: MovieModel, genres: [IdNameModel]) {
        let year: Int = Calendar.current.component(.year, from: movie.releaseDate)
        let genresString: String = genres.map { $0.name }.joined(separator: ", ")
        let detailViewModel: MovieDetailViewModel = MovieDetailViewModel(
            title: movie.title,
            year: "\(year)",
            genres: genresString,
            body: movie.overview,
            backdropPath: URL(string: "https://image.tmdb.org/t/p/w780/\(movie.backdropPath)")
        )
        viewController?.displayViewModel(detailViewModel)
    }

    func presentIfIsFavorite(_ isFavorite: Bool) {
        viewController?.displayIfIsFavorite(isFavorite)
    }
}
