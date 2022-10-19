//
//  FavoriteListInteractor.swift
//  Challenge
//
//  Created by Carlos Mario Munoz Perez on 16/10/22.
//

import Foundation

final class FavoriteListInteractor: FavoriteListDatastore {

    // MARK: - Private properties -
    private var moviesData: [Movie] = []
    private var genres: [Genre] = []
    private var idSelected: Int = 0
    private var filterByGenre: [Int] = []

    // MARK: - Internal properties -
    var filterByYear: Int?
    var presenter: FavoriteListPresentationLogic?
    var movieSelected: MovieModel? {
        guard let movie: Movie = moviesData.first(where: { $0.id == idSelected }) else { return nil }
        return MovieModel(
            id: Int(movie.id),
            title: movie.title ?? "",
            posterPath: movie.posterPath ?? "",
            backdropPath: movie.backdropPath ?? "",
            genreIds: [],
            releaseYear: Int(movie.releaseYear),
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

    var favoritesGenres: [IdNameSelectModel] {
        return genres.map { genre in
            return IdNameSelectModel(
                id: Int(genre.id),
                name: genre.name ?? "",
                isSelected: filterByGenre.contains(Int(genre.id))
            )
        }.sorted(by: { $0.name < $1.name })
    }

    var favoritesYears: [Int] = []

    // MARK: - Internal methods -
    func updateFilters(yearSelected: Int?, genresSelected: [Int]) {
        self.filterByYear = yearSelected
        self.filterByGenre = genresSelected
    }
}

// MARK: - FavoriteListBusinessLogic -
extension FavoriteListInteractor: FavoriteListBusinessLogic {

    func fetchData() {
        Task.init {
            moviesData = await CoreDataManager.shared.getMovies(genres: filterByGenre, year: filterByYear)
            favoritesYears = await Array(CoreDataManager.shared.getYears()).sorted()
            genres = await CoreDataManager.shared.getGenres()
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.presenter?.presentMovies(model: self.moviesData)
            }
        }
    }

    func deleteFavorite(id: Int) {
        Task.init {
            await CoreDataManager.shared.deleteMovie(idMovie: id)
            fetchData()
        }
    }

    func selectMovie(_ id: Int) {
        idSelected = id
    }
}
