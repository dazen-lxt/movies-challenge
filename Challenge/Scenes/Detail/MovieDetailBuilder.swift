//
//  MovieDetailBuilder.swift
//  Challenge
//
//  Created by Carlos Mario Munoz Perez on 18/10/22.
//

import Foundation

enum MovieDetailBuilder {

    static func viewController() -> MovieDetailViewController {
        let viewController: MovieDetailViewController = MovieDetailViewController()
        let interactor: MovieDetailInteractor = MovieDetailInteractor()
        let presenter: MovieDetailPresenter = MovieDetailPresenter()
        let router: MovieDetailRouter = MovieDetailRouter()
        router.viewController = viewController
        router.dataStore = interactor
        presenter.viewController = viewController
        interactor.presenter = presenter
        viewController.interactor = interactor
        viewController.router = router
        return viewController
    }
}
