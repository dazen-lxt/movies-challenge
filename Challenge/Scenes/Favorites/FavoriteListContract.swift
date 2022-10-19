//
//  FavoriteListContract.swift
//  Challenge
//
//  Created by Carlos Mario Munoz Perez on 18/10/22.
//

import Foundation

protocol FavoriteListBusinessLogic: AnyObject {
    func fetchData()
    func selectMovie(_ id: Int)
    func deleteFavorite(id: Int)
}

protocol FavoriteListPresentationLogic: AnyObject {
    func presentMovies(model: [Movie])
}

protocol FavoriteListDisplayLogic: AnyObject {
    func displayFavoriteMovies(viewModel: [FavoriteMovieViewModel])
}

protocol FavoriteListDatastore: FilterDelegate {
    var movieSelected: MovieModel? { get }
    var genredOfMovieSelected: [IdNameModel] { get }
    var favoritesGenres: [IdNameSelectModel] { get }
    var favoritesYears: [Int] { get }
    var filterByYear: Int? { get }
}

protocol FavoriteListWireframeLogic: AnyObject {
    func goToDetail()
    func showFilters()
}
