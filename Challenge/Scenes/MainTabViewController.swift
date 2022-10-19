//
//  MainTabViewController.swift
//  Challenge
//
//  Created by Carlos Mario Munoz Perez on 14/10/22.
//

import UIKit

class MainTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Movies"
    }

    func setupViewControllers() {
        let listViewController: ListTableViewController = ListBuilder.viewController()
        listViewController.tabBarItem = UITabBarItem(title: "Movies", image: UIImage(systemName: "tv"), tag: 0)

        let favoriteListViewController: FavoriteListTableViewController = FavoriteListBuilder.viewController()
        favoriteListViewController.tabBarItem = UITabBarItem(
            title: "Favorites",
            image: UIImage(systemName: "heart"),
            tag: 1
        )
        viewControllers =  [listViewController, favoriteListViewController]
    }

}
