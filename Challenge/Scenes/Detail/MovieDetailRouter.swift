//
//  MovieDetailRouter.swift
//  Challenge
//
//  Created by Carlos Mario Munoz Perez on 18/10/22.
//

import Foundation

class MovieDetailRouter {

    weak var viewController: MovieDetailViewController?
    var dataStore: MovieDetailDatastore?
}

extension MovieDetailRouter: MovieDetailWireframeLogic {

}
