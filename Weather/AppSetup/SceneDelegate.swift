//
//  SceneDelegate.swift
//  Weather
//
//  Created by Afzaal Ahmad on 09/10/24.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var coordinator: AppCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        let locationCacheManager: LocationCacheManager = DIContainer.resolve()
        let coordinator = AppCoordinator(window: window, locationCacheManager: locationCacheManager)
        self.window = window
        self.coordinator = coordinator
        coordinator.start()
    }
}

