//
//  ListBuilder.swift
//  Challenge
//
//  Created by Carlos Mario Munoz Perez on 18/10/22.
//

import Foundation

enum ListBuilder {

    static func viewController() -> ListTableViewController {
        let viewController: ListTableViewController = ListTableViewController()
        let interactor: ListInteractor = ListInteractor()
        let presenter: ListPresenter = ListPresenter()
        let router: ListRouter = ListRouter()
        router.viewController = viewController
        router.dataStore = interactor
        presenter.viewController = viewController
        interactor.presenter = presenter
        viewController.interactor = interactor
        viewController.router = router
        return viewController
    }
}
