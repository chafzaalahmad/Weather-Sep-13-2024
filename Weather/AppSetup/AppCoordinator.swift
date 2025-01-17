//
//  AppCoordinator.swift
//  Weather
//
//  Created by Afzaal Ahmad on 09/10/24.
//

import UIKit
import Combine

/// `AppCoordinator` is responsible to manage transition at windows level.
final class AppCoordinator: BaseCoordinator<UINavigationController> {
    // MARK:- Private Properties
    
    private let window: UIWindow
    private var locationCacheManager: LocationCacheManager
    // MARK:- Init
    
    init(window: UIWindow, locationCacheManager: LocationCacheManager) {
        self.window = window
        self.locationCacheManager = locationCacheManager
        super.init(rootViewController: .init())
    }
    
    // MARK:- Public Methods
    
    override func start() {
        
        let coordinator = SearchCityCoordinator(rootViewController: rootViewController)
        
        startChild(coordinator)
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        
        self.loadDetailScreenIfNeeded()
        
    }
    
    func loadDetailScreenIfNeeded() {
        self.getLocation()
    }
    
    func loadDetailScreen(location: Location) {
        let coordinator = WeatherCoordinator(location: location, rootViewController: rootViewController)
        
        startChild(coordinator)
    }
    
    
    
    ///Location Logic
    ///
    
    private var locationManager: UserLocationManager?
    private var cancellableSet = Set<AnyCancellable>()
    
    var location: Location? {
        didSet {
            DispatchQueue.main.async {
                if let location = self.location {
                    self.loadDetailScreen(location: location)
                }
            }
        }
    }
    
}

extension AppCoordinator {
    private func getLocation(){
        let locationManager = UserLocationManager()
        self.locationManager = locationManager
            
        locationManager.$location
            .sink {[weak self] location in
                guard let self = self else { return }
                if let location = location {
                    cancellableSet.forEach { cancellable in
                        cancellable.cancel()
                    }
                    locationCacheManager.setLastLocation(location: self.location)
                    self.location = Location(lat: location.latitude, lon: location.longitude)
                }
                
            }
            .store(in: &cancellableSet)
        
        locationManager.$isLoading.delay(for: 2, scheduler: RunLoop.main)
            .prefix(1)
            .sink { [weak self] isLoading in
                guard let self = self else { return }
                if isLoading == false && locationManager.location == nil {
                    self.location = locationCacheManager.getLastLocation()
                }
            }
            .store(in: &cancellableSet)
        
        DispatchQueue.global().async {
            locationManager.requestLocation()
        }
        
    }
    
}

