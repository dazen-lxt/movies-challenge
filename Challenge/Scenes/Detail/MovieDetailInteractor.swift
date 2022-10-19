//
//  MovieDetailInteractor.swift
//  Challenge
//
//  Created by Carlos Mario Munoz Perez on 18/10/22.
//

import Foundation

final class MovieDetailInteractor: MovieDetailDatastore {

    // MARK: - Internal properties -
    var movie: MovieModel!
    var genres: [IdNameModel] = []
    var presenter: MovieDetailPresentationLogic?
}

// MARK: - MovieDetailBusinessLogic -
extension MovieDetailInteractor: MovieDetailBusinessLogic {

    func fetchData() {
        presenter?.presentMovies(movie: movie, genres: genres)
    }

    func checkIfIsFavorite() {
        Task.init {
            let isFavorite: Bool = await CoreDataManager.shared.existMovie(id: movie.id)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.presenter?.presentIfIsFavorite(isFavorite)
            }
        }
    }

    func saveFavorite() {
        Task.init {
            await CoreDataManager.shared.saveMovie(movie: movie, genres: genres)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.presenter?.presentIfIsFavorite(true)
            }
        }
    }

    func deleteFavorite() {
        Task.init {
            await CoreDataManager.shared.deleteMovie(idMovie: movie.id)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.presenter?.presentIfIsFavorite(false)
            }
        }
    }
}
