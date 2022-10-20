//
//  AppDelegate.swift
//  Challenge
//
//  Created by Carlos Mario Munoz Perez on 14/10/22.
//

import CoreData
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        if CommandLine.arguments.contains("--UITests") {
            UIView.setAnimationsEnabled(false)
        }
        let tabBarApperance: UITabBarAppearance = UITabBarAppearance()
        tabBarApperance.configureWithOpaqueBackground()
        tabBarApperance.backgroundColor = Colors.tintColor
        UITabBar.appearance().scrollEdgeAppearance = tabBarApperance
        UITabBar.appearance().standardAppearance = tabBarApperance
        UITabBar.appearance().tintColor = Colors.defaultBackground
        UITabBarItem.appearance().setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: Colors.defaultBackground],
            for: .normal
        )
        let navigationBarAppearance: UINavigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: Colors.defaultBackground
        ]
        UINavigationBar.appearance().tintColor = Colors.defaultBackground
        navigationBarAppearance.backgroundColor = Colors.tintColor
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        CoreDataManager.shared.saveContext()
        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
