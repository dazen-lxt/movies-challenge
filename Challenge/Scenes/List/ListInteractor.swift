//
//  ListInteractor.swift
//  Challenge
//
//  Created by Carlos Mario Munoz Perez on 16/10/22.
//

import Foundation

final class ListInteractor: ListDatastore {

    var presenter: ListPresentationLogic?

    private var moviesData: [MovieModel] = []
    private var genresData: [IdNameModel] = []
    private var idSelected: Int = 0

    var movieSelected: MovieModel? {
        return moviesData.first(where: { $0.id == idSelected })
    }

    var genredOfMovieSelected: [IdNameModel] {
        let genreIds: [Int] = movieSelected?.genreIds ?? []
        return genresData.filter {
            genreIds.contains($0.id)
        }
    }
}

extension ListInteractor: ListBusinessLogic {

    func fetchData() {
        let group: DispatchGroup = DispatchGroup()

        group.enter()
        let movieRequest: Endpoint.PopularMovies = Endpoint.PopularMovies()
        ApiClient.sharedInstance.doRequest(
            req: movieRequest
        ) { [weak self] (result: ApiResult<PageWrapperModel<MovieModel>>) in
            if case .success(let data, 200) = result {
                self?.moviesData = data.results
            }
            group.leave()
        }

        group.enter()
        let genresRequest: Endpoint.Genres = Endpoint.Genres()
        ApiClient.sharedInstance.doRequest(req: genresRequest) { [weak self] (result: ApiResult<GenresModel>) in
            if case .success(let data, 200) = result {
                self?.genresData = data.genres
            }
            group.leave()
        }

        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            if !self.genresData.isEmpty && !self.moviesData.isEmpty {
                self.presenter?.presentMovies(model: self.moviesData, isError: false)
            } else {
                self.presenter?.presentMovies(model: self.moviesData, isError: true)
           }
        }
    }

    func selectMovie(_ id: Int) {
        idSelected = id
    }
}
