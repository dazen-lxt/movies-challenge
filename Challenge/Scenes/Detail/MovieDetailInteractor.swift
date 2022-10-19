//
//  MovieDetailInteractor.swift
//  Challenge
//
//  Created by Carlos Mario Munoz Perez on 18/10/22.
//

import Foundation

final class MovieDetailInteractor: MovieDetailDatastore {

    var movie: MovieModel!
    var genres: [IdNameModel] = []

    var presenter: MovieDetailPresentationLogic?
}

extension MovieDetailInteractor: MovieDetailBusinessLogic {

    func fetchData() {
        presenter?.presentMovies(movie: movie, genres: genres)
    }

    func checkIfIsFavorite() {
        let isFavorite: Bool = CoreDataManager.shared.existMovie(id: movie.id)
        presenter?.presentIfIsFavorite(isFavorite)
    }

    func saveFavorite() {
        CoreDataManager.shared.saveMovie(movie: movie, genres: genres)
        presenter?.presentIfIsFavorite(true)
    }

    func deleteFavorite() {
        CoreDataManager.shared.deleteMovie(idMovie: movie.id)
        presenter?.presentIfIsFavorite(false)
    }
}
