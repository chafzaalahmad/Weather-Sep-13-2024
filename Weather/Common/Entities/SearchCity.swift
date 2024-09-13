//
//  SearchCity.swift
//  Weather
//
//  Created by Afzaal Ahmad on 09/10/24.
//

struct SearchCity: Decodable {
    let name: String
    let lat: Double
    let lon: Double
    let state: String?
    let country: String?
}
