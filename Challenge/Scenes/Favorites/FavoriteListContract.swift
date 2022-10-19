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
}

protocol FavoriteListPresentationLogic: AnyObject {
    func presentMovies(model: [Movie])
}

protocol FavoriteListDisplayLogic: AnyObject {
    func displayFavoriteMovies(viewModel: [FavoriteMovieViewModel])
}

protocol FavoriteListDatastore: AnyObject {
    var movieSelected: MovieModel? { get }
    var genredOfMovieSelected: [IdNameModel] { get }
}

protocol FavoriteListWireframeLogic: AnyObject {
    func goToDetail()
}
