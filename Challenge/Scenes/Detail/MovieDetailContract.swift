//
//  MovieDetailContract.swift
//  Challenge
//
//  Created by Carlos Mario Munoz Perez on 18/10/22.
//

import Foundation

protocol MovieDetailBusinessLogic: AnyObject {
    func fetchData()
    func checkIfIsFavorite()
    func saveFavorite()
    func deleteFavorite()
}

protocol MovieDetailPresentationLogic: AnyObject {
    func presentMovies(movie: MovieModel, genres: [IdNameModel])
    func presentIfIsFavorite(_ isFavorite: Bool)
}

protocol MovieDetailDisplayLogic: AnyObject {
    func displayViewModel(_ viewModel: MovieDetailViewModel)
    func displayIfIsFavorite(_ isFavorite: Bool)
}

protocol MovieDetailDatastore {
    var movie: MovieModel! { get set }
    var genres: [IdNameModel] { get set }
}

protocol MovieDetailWireframeLogic: AnyObject {
    var dataStore: MovieDetailDatastore? { get set }
}
