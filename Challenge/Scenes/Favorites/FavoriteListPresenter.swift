//
//  FavoriteListPresenter.swift
//  Challenge
//
//  Created by Carlos Mario Munoz Perez on 18/10/22.
//

import Foundation

final class FavoriteListPresenter {

    // MARK: - Internal properties -
    weak var viewController: FavoriteListDisplayLogic?
}

// MARK: - FavoriteListPresentationLogic -
extension FavoriteListPresenter: FavoriteListPresentationLogic {

    func presentMovies(model: [Movie]) {
        let viewModel: [FavoriteMovieViewModel] = model.map { movie in
            return FavoriteMovieViewModel(
                id: Int(movie.id),
                title: movie.title ?? "",
                overview: movie.overview ?? "",
                year: "\(movie.releaseYear)",
                posterPath: URL(string: "https://image.tmdb.org/t/p/w200/\(movie.posterPath  ?? "")")
            )
        }
        viewController?.displayFavoriteMovies(viewModel: viewModel)
    }
}
