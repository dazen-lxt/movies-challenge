//
//  BaseViewController.swift
//  Challenge
//
//  Created by Carlos Mario Munoz Perez on 17/10/22.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {

    private var loadingViewController: LoadingViewController?

    func showLoading() {
        hideLoading()
        loadingViewController = LoadingViewController.show(in: self)
    }

    func hideLoading() {
        loadingViewController?.hide()
    }
}
