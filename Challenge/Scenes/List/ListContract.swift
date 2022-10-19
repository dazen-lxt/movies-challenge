//
//  ListContract.swift
//  Challenge
//
//  Created by Carlos Mario Munoz Perez on 18/10/22.
//

import Foundation

protocol ListBusinessLogic: AnyObject {
    func fetchData()
    func selectMovie(_ id: Int)
}

protocol ListPresentationLogic: AnyObject {
    func presentMovies(model: [MovieModel], isError: Bool)
}

protocol ListDisplayLogic: AnyObject {
    func displayMovies(viewModel: [MovieViewModel])
    func displayError()
}

protocol ListDatastore: AnyObject {
    var movieSelected: MovieModel? { get }
    var genredOfMovieSelected: [IdNameModel] { get }
}

protocol ListWireframeLogic: AnyObject {
    func goToDetail()
}
