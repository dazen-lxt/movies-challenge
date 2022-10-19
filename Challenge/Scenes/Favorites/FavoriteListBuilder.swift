//
//  FavoriteListBuilder.swift
//  Challenge
//
//  Created by Carlos Mario Munoz Perez on 18/10/22.
//

import Foundation

enum FavoriteListBuilder {

    static func viewController() -> FavoriteListTableViewController {
        let viewController: FavoriteListTableViewController = FavoriteListTableViewController()
        let interactor: FavoriteListInteractor = FavoriteListInteractor()
        let presenter: FavoriteListPresenter = FavoriteListPresenter()
        let router: FavoriteListRouter = FavoriteListRouter()
        router.viewController = viewController
        router.dataStore = interactor
        presenter.viewController = viewController
        interactor.presenter = presenter
        viewController.interactor = interactor
        viewController.router = router
        return viewController
    }
}
