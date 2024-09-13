//
//  SeachCityRowViewModel.swift
//  Weather
//
//  Created by Afzaal Ahmad on 09/10/24.
//

import Foundation


struct SeachCityRowViewModel: Hashable {
    let id: String
    let name: String
    let lat: Double
    let lon: Double
    let state: String?
    let country: String?
}
