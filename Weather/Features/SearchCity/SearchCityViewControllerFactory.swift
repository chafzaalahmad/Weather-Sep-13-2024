//
//  SearchCityViewControllerFactory.swift
//  Weather
//
//  Created by Afzaal Ahmad on 09/10/24.
//

import UIKit

final class SearchCityViewControllerFactory {
    static func make(navigator: SearchCityNavigator) -> SearchCityViewController? {
        let useCase: SearchCityUseCase = DIContainer.resolve()
        let controller = SearchCityViewController(viewModel: .init(useCase: useCase, navigator: navigator))
        return controller
    }
}
