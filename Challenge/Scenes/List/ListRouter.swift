//
//  ListRouter.swift
//  Challenge
//
//  Created by Carlos Mario Munoz Perez on 18/10/22.
//

import Foundation

final class ListRouter {

    var dataStore: ListDatastore?
    weak var viewController: ListTableViewController?

    // MARK: Passing data

    private func passDataToDetail(destination: inout MovieDetailDatastore) {
        guard let movieSelected = dataStore?.movieSelected else { fatalError("Datastore invalid") }
        destination.movie = movieSelected
        destination.genres = dataStore?.genredOfMovieSelected ?? []
    }
}

extension ListRouter: ListWireframeLogic {

    func goToDetail() {
        let destinationVC: MovieDetailViewController = MovieDetailBuilder.viewController()
        guard var destinationDataStore = destinationVC.router?.dataStore else { return }
        passDataToDetail(destination: &destinationDataStore)
        destinationVC.modalPresentationStyle = .fullScreen
        viewController?.navigationController?.pushViewController(destinationVC, animated: true)
    }
}
