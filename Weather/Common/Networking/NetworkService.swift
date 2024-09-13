//
//  NetworkService.swift
//  Weather
//
//  Created by Afzaal Ahmad on 09/10/24.
//

import Foundation
import Combine

protocol NetworkService {
    func publisher<T: Decodable>(for endpoint: Endpoint, decoder: JSONDecoder) -> AnyPublisher<T, Error>
}

extension NetworkService {
    func publisher<T: Decodable>(for endpoint: Endpoint) -> AnyPublisher<T, Error> {
        publisher(for: endpoint, decoder: .init())
    }
}
