//
//  SearchCityUseCase.swift
//  Weather
//
//  Created by Afzaal Ahmad on 09/10/24.
//

import Foundation
import Combine

protocol SearchCityUseCase {
    var locationCacheManager: LocationCacheManager? { get }
    
    func setLocation(location: Location)
    
    func fetchCities(with query: String) -> AnyPublisher<[SearchCity], Error>
}

final class NetworkSearchCityUseCase: SearchCityUseCase {
    func setLocation(location: Location) {
        self.locationCacheManager?.setLastLocation(location: location)
    }
    
    internal var locationCacheManager: LocationCacheManager?
    
    private let service: NetworkService

    init(service: NetworkService = URLSession.shared, locationCacheManager: LocationCacheManager) {
        self.service = service
        self.locationCacheManager = locationCacheManager
    }

    func fetchCities(with query: String) -> AnyPublisher<[SearchCity], Error> {
        service.publisher(for: .cities(with: query + ", US"))
    }
}
