//
//  FavoriteListInteractor.swift
//  Challenge
//
//  Created by Carlos Mario Munoz Perez on 16/10/22.
//

import Foundation

final class FavoriteListInteractor: FavoriteListDatastore {

    var presenter: FavoriteListPresentationLogic?

    private var moviesData: [Movie] = []
//    private var genresData: [IdNameModel] = []
    private var idSelected: Int = 0

    var movieSelected: MovieModel? {
        guard let movie: Movie = moviesData.first(where: { $0.id == idSelected }) else { return nil }
        return MovieModel(
            id: Int(movie.id),
            title: movie.title ?? "",
            posterPath: movie.posterPath ?? "",
            backdropPath: movie.backdropPath ?? "",
            genreIds: [],
            releaseDate: movie.releaseDate ?? Date(),
            overview: movie.overview ?? ""
        )
    }

    var genredOfMovieSelected: [IdNameModel] {
        guard let movie: Movie = moviesData.first(where: { $0.id == idSelected }) else { return [] }
        let genres: [Genre] = movie.genres?.allObjects as? [Genre] ?? []
        return genres.map { genre in
            return IdNameModel(id: Int(genre.id), name: genre.name ?? "")
        }
    }
}

extension FavoriteListInteractor: FavoriteListBusinessLogic {

    func fetchData() {
        moviesData = CoreDataManager.shared.getMovies()
        presenter?.presentMovies(model: moviesData)
    }

    func selectMovie(_ id: Int) {
        idSelected = id
    }
}
