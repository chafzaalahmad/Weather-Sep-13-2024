//
//  WeatherUseCaseMock.swift
//  WeatherTests
//
//  Created by Afzaal Ahmad on 9/12/24.
//

import Foundation
import Combine
@testable import Weather

final class WeatherUseCaseMock: WeatherUseCase {
    let fetchWeatherSubject = PassthroughSubject<WeatherLocation, Error>()
    
    func fetchWeather(with lat: Double, lon: Double) -> AnyPublisher<WeatherLocation, any Error> {
        fetchWeatherSubject.eraseToAnyPublisher()
    }
}

