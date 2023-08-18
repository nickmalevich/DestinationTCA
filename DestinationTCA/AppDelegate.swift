//
//  AppDelegate.swift
//  DestinationTCA
//
//  Created by NikitaMalevich on 18.08.23.
//

import ComposableArchitecture
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private let storeWith = Store(initialState: ParentWithFeature.State()) { ParentWithFeature() }
    private let storeWithout = Store(initialState: ParentWithoutFeature.State()) { ParentWithoutFeature() }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow()
        self.window = window
//        window.rootViewController = UINavigationController(rootViewController: ParentWithViewController(store: storeWith))
        window.rootViewController = UINavigationController(rootViewController: ParentWithoutViewController(store: storeWithout))

        window.makeKeyAndVisible()

        return true
    }
}

