//
//  WeatherViewControllerFactory.swift
//  Weather
//
//  Created by Afzaal Ahmad on 09/10/24.
//

import UIKit

final class WeatherViewControllerFactory {
    static func make(location: Location?) -> WeatherViewController? {
        let useCase: WeatherUseCase = DIContainer.resolve()
        let controller = WeatherViewController(viewModel: .init(weatherUseCase: useCase, location: location))
        
        return controller
    }
}
