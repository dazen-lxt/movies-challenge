//
//  ListPresenter.swift
//  Challenge
//
//  Created by Carlos Mario Munoz Perez on 18/10/22.
//

import Foundation

final class ListPresenter {
    weak var viewController: ListDisplayLogic?
}

extension ListPresenter: ListPresentationLogic {

    func presentMovies(model: [MovieModel], isError: Bool) {
        if isError {
            viewController?.displayError()
        } else {
            let viewModel: [MovieViewModel] = model.map {
                MovieViewModel(
                    id: $0.id,
                    title: $0.title,
                    posterPath: URL(string: "https://image.tmdb.org/t/p/w200/\($0.posterPath)")
                )
            }
            viewController?.displayMovies(viewModel: viewModel)
        }
    }
}
