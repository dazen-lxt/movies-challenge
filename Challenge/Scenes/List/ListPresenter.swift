//
//  ListPresenter.swift
//  Challenge
//
//  Created by Carlos Mario Munoz Perez on 18/10/22.
//

import Foundation

final class ListPresenter {

    // MARK: - Internal properties -
    weak var viewController: ListDisplayLogic?
}

// MARK: - ListPresentationLogic -
extension ListPresenter: ListPresentationLogic {

    func presentUpdateFavorite(isFavorite: Bool, index: Int) {
        viewController?.updateFavorite(isFavorite: isFavorite, index: index)
    }

    func presentMovies(model: [MovieModel], favorites: Set<Int>, totalPages: Int, firstLoad: Bool, hasError: Bool) {
        if hasError && firstLoad {
            viewController?.displayError()
        } else {
            let list: [MovieViewModel] = model.map {
                MovieViewModel(
                    id: $0.id,
                    title: $0.title,
                    posterPath: URL(string: "https://image.tmdb.org/t/p/w200/\($0.posterPath ?? "")"),
                    isFavorite: favorites.contains($0.id)
                )
            }
            viewController?.displayMovies(
                viewModel: ListViewModel(
                    totalResults: totalPages,
                    list: list
                )
            )
        }
    }
}
