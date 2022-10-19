//
//  ListContract.swift
//  Challenge
//
//  Created by Carlos Mario Munoz Perez on 18/10/22.
//

import Foundation

protocol ListBusinessLogic: AnyObject {
    func fetchData(page: Int)
    func selectMovie(_ id: Int)
    func refreshFavorites()
    func searchByTerm(page: Int, query: String)
}

protocol ListPresentationLogic: AnyObject {
    func presentMovies(model: [MovieModel], favorites: Set<Int>, totalPages: Int, firstLoad: Bool, hasError: Bool)
    func presentUpdateFavorite(isFavorite: Bool, index: Int)
}

protocol ListDisplayLogic: AnyObject {
    func displayMovies(viewModel: ListViewModel)
    func displayError()
    func updateFavorite(isFavorite: Bool, index: Int)
}

protocol ListDatastore: AnyObject {
    var movieSelected: MovieModel? { get }
    var genredOfMovieSelected: [IdNameModel] { get }
}

protocol ListWireframeLogic: AnyObject {
    func goToDetail()
}
