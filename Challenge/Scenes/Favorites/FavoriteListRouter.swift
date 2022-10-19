//
//  FavoriteListRouter.swift
//  Challenge
//
//  Created by Carlos Mario Munoz Perez on 18/10/22.
//

import Foundation
import UIKit

final class FavoriteListRouter {

    // MARK: - Internal properties -
    var dataStore: FavoriteListDatastore?
    weak var viewController: FavoriteListTableViewController?

    // MARK: Passing data
    private func passDataToDetail(destination: inout MovieDetailDatastore) {
        guard let movieSelected = dataStore?.movieSelected else { fatalError("Datastore invalid") }
        destination.movie = movieSelected
        destination.genres = dataStore?.genredOfMovieSelected ?? []
    }
}

// MARK: - FavoriteListWireframeLogic -
extension FavoriteListRouter: FavoriteListWireframeLogic {

    func goToDetail() {
        let destinationVC: MovieDetailViewController = MovieDetailBuilder.viewController()
        guard var destinationDataStore = destinationVC.router?.dataStore else { return }
        passDataToDetail(destination: &destinationDataStore)
        destinationVC.modalPresentationStyle = .fullScreen
        viewController?.navigationController?.pushViewController(destinationVC, animated: true)
    }

    func showFilters() {
        let filterViewController = FilterViewController()
        filterViewController.years = dataStore?.favoritesYears ?? []
        filterViewController.genres = dataStore?.favoritesGenres ?? []
        filterViewController.yearSelected = dataStore?.filterByYear
        filterViewController.delegate = dataStore
        viewController?.navigationController?.pushViewController(filterViewController, animated: true)
    }
}
