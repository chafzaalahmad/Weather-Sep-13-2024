//
//  AppDIContainer.swift
//  Weather
//
//  Created by Afzaal Ahmad on 09/10/24.
//

import Foundation

let DIContainer = AppDIContainer.shared

///`AppDIContainer` is responsible to create/manage all dependencies of the application.
final class AppDIContainer {
    static let shared = AppDIContainer()
    
    // MARK:- Private Properties
    private var container: [String: Any] = [:]
    
    // MARK:- Init
    
    private init(){
        //Register dependencies
        self.register(type: NetworkService.self, service: URLSession(configuration: URLSessionConfiguration.default))
        self.register(type: LocationCacheManager.self, service: DefaultLocationCacheManager())
        self.register(type: WeatherUseCase.self, service: NetworkWeatherUseCase(service: self.resolve()))
        self.register(type: NetworkSearchCityUseCase.self, service: NetworkSearchCityUseCase(service: self.resolve(), locationCacheManager: self.resolve()))
        self.register(type: SearchCityUseCase.self, service: NetworkSearchCityUseCase(service: self.resolve(), locationCacheManager: self.resolve()))
    }
    
    func register<T>(type: T.Type, service: Any) {
          container["\(type)"] = service
      }
    
    /// Generic function which will resolve the dependency of type T.
    /// - Returns: object of type T from the container.
    func resolve<T>() -> T {
        return container["\(T.self)"] as! T
    }
}
