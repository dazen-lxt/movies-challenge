//
//  ListInteractor.swift
//  Challenge
//
//  Created by Carlos Mario Munoz Perez on 16/10/22.
//

import Combine
import Foundation

final class ListInteractor: ListDatastore {

    // MARK: - Private properties -
    private var moviesData: [MovieModel] = []
    private var nextLoad: [MovieModel] = []
    private var favorites: Set<Int> = []
    private var totalCount: Int = 0
    private var genresData: [IdNameModel] = []
    private var idSelected: Int = 0
    private var isFetchInProgress: Bool = false
    private var searchTerm: String = ""

    // MARK: - Internal properties -
    var presenter: ListPresentationLogic?
    var coreDataManager: CoreDataManagerLogic = CoreDataManager.shared
    var apiClient: ApiClientProtocol = ApiClient.sharedInstance
    var movieSelected: MovieModel? {
        return moviesData.first(where: { $0.id == idSelected })
    }

    var genredOfMovieSelected: [IdNameModel] {
        let genreIds: [Int] = movieSelected?.genreIds ?? []
        return genresData.filter {
            genreIds.contains($0.id)
        }
    }

    // MARK: - Private methods -
    private func updateData(firstLoad: Bool, showError: Bool) {
        self.isFetchInProgress = false
        if !self.genresData.isEmpty && !self.nextLoad.isEmpty {
            self.moviesData.append(contentsOf: self.nextLoad)
            self.presenter?.presentMovies(
                model: self.nextLoad,
                favorites: self.favorites,
                totalPages: self.totalCount,
                firstLoad: firstLoad,
                hasError: false
            )
        } else {
            self.presenter?.presentMovies(
                model: self.nextLoad,
                favorites: self.favorites,
                totalPages: self.totalCount,
                firstLoad: firstLoad,
                hasError: true && showError
            )
        }
    }
}

// MARK: - ListBusinessLogic -
extension ListInteractor: ListBusinessLogic {

    func searchByTerm(page: Int, query: String) {
        guard !isFetchInProgress else { return }
        isFetchInProgress = true
        nextLoad = []
        if page == 1 {
            moviesData = []
        }

        let movieRequest: Endpoint.SearchMovies = Endpoint.SearchMovies(page: page, query: query)
        apiClient.doRequest(
            req: movieRequest
        ) { [weak self] (result: ApiResult<PageWrapperModel<MovieModel>>) in
            guard let self = self else { return }
            if case .success(let data, 200) = result {
                self.nextLoad = data.results
                self.totalCount = data.totalResults
            }
            self.updateData(firstLoad: page == 1, showError: false)
        }
    }

    func fetchData(page: Int) {
        guard !isFetchInProgress else { return }
        isFetchInProgress = true
        nextLoad = []
        if page == 1 {
            moviesData = []
        }
        let group: DispatchGroup = DispatchGroup()

        group.enter()
        let movieRequest: Endpoint.PopularMovies = Endpoint.PopularMovies(page: page)
        apiClient.doRequest(
            req: movieRequest
        ) { [weak self] (result: ApiResult<PageWrapperModel<MovieModel>>) in
            if case .success(let data, 200) = result {
                guard let self = self else { return }
                self.nextLoad = data.results
                self.totalCount = data.totalResults
            }
            group.leave()
        }

        if genresData.isEmpty {
            group.enter()
            let genresRequest: Endpoint.Genres = Endpoint.Genres()
            apiClient.doRequest(req: genresRequest) { [weak self] (result: ApiResult<GenresModel>) in
                if case .success(let data, 200) = result {
                    self?.genresData = data.genres
                } else {
                }
                group.leave()
            }
        }

        if favorites.isEmpty {
            group.enter()
            Task.init {
                favorites = await Set(coreDataManager.getMovies().map { Int($0.id) })
                group.leave()
            }
        }
        group.notify(queue: .main) { [weak self] in
            self?.updateData(firstLoad: page == 1, showError: true)
        }
    }

    func refreshFavorites() {
        Task.init {
            let newFavorites = await Set(coreDataManager.getMovies().map { Int($0.id) })
            let diff = favorites.union(newFavorites).subtracting(favorites.intersection(newFavorites))
            moviesData.indices.filter { diff.contains( moviesData[$0].id) }.forEach { index in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.presenter?.presentUpdateFavorite(
                        isFavorite: newFavorites.contains(self.moviesData[index].id),
                        index: index
                    )
                }
            }
            self.favorites = newFavorites
        }
    }

    func selectMovie(_ id: Int) {
        idSelected = id
    }
}
