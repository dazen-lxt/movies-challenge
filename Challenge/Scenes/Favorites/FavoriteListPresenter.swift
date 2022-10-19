//
//  FavoriteListPresenter.swift
//  Challenge
//
//  Created by Carlos Mario Munoz Perez on 18/10/22.
//

import Foundation

final class FavoriteListPresenter {
    weak var viewController: FavoriteListDisplayLogic?
}

extension FavoriteListPresenter: FavoriteListPresentationLogic {

    func presentMovies(model: [Movie]) {
        let viewModel: [FavoriteMovieViewModel] = model.map { movie in
            let year: Int = Calendar.current.component(.year, from: movie.releaseDate ?? Date())
            return FavoriteMovieViewModel(
                id: Int(movie.id),
                title: movie.title ?? "",
                overview: movie.overview ?? "",
                year: "\(year)",
                posterPath: URL(string: "https://image.tmdb.org/t/p/w200/\(movie.posterPath  ?? "")")
            )
        }
        viewController?.displayFavoriteMovies(viewModel: viewModel)
    }
}
