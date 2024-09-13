//
//  SearchCityContentView.swift
//  Weather
//
//  Created by Afzaal Ahmad on 09/10/24.
//

import SwiftUI

class SearchCityData: ObservableObject {
    @Published var searchCities: [SeachCityRowViewModel]
    
    init(searchCities: [SeachCityRowViewModel]) {
        self.searchCities = searchCities
    }
}

struct SearchCityContentView: View {
    let viewModel: SearchCityViewModel?
    
    @ObservedObject var data: SearchCityData
    
    @State private var searchTerm = ""
    
    var body: some View {
        NavigationStack {
            let citiesCount = data.searchCities.count
            if citiesCount == 0 {
                Text("Sorry! We could not find weather for search query. Type again city name.").padding(EdgeInsets(top: 0, leading: 5, bottom: 5, trailing: 5))
            }
            else {
                Text("Weather found for \(data.searchCities.count) cities")
            }
            
            Spacer()
            List(data.searchCities, id: \.id) { city in
                CityRow(city: city).buttonStyle(PlainButtonStyle())
                    .onTapGesture {
                        viewModel?.didSelectLocation(location: Location(lat: city.lat, lon: city.lon))
                    }
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .searchable(text: $searchTerm, prompt: Text("Search City")).accessibilityIdentifier("searchCityBar")
        .onChange(of: searchTerm) {
            Task.init {
                viewModel?.searchQuery = searchTerm
            }
        }
        
    }
    
    struct CityRow: View {
        @Environment(\.horizontalSizeClass) var horizontalSizeClass
        let city: SeachCityRowViewModel
        
        var body: some View {
            HStack {
                VStack(alignment: .leading, content: {
                    Text(LocalizedStringKey("City")).fontWeight(.light).foregroundStyle(.secondary)
                    Text(city.name).font(.title).fontWeight(.bold)
                })
                
                Spacer()
                if horizontalSizeClass == .regular {
                    Text(city.state ?? "").fontWeight(.light)
                }
                Text(city.country ?? "").fontWeight(.light).foregroundStyle(.secondary)
            }
        }
    }
}


#Preview ("English"){
    let cities = [
        SeachCityRowViewModel(id: "1", name: "Elmont 1", lat: 1, lon: 1, state: "NY", country: "USA"),
        SeachCityRowViewModel(id: "2", name: "Elmont 2", lat: 2, lon: 1, state: "NY", country: "USA"),
        SeachCityRowViewModel(id: "3", name: "Elmont 3", lat: 3, lon: 1, state: "NY", country: "USA"),
        SeachCityRowViewModel(id: "4", name: "Elmont 4", lat: 4, lon: 1, state: "NY", country: "USA"),
        SeachCityRowViewModel(id: "5", name: "Elmont 5", lat: 5, lon: 1, state: "NY", country: "USA"),
        SeachCityRowViewModel(id: "6", name: "Deonton", lat: 5, lon: 1, state: "TX", country: "USA")
    ]
    return SearchCityContentView(viewModel: nil, data: SearchCityData(searchCities: cities)).environment(\.locale, Locale(identifier: "EN"))
}

#Preview ("Chinese"){
    let cities = [
        SeachCityRowViewModel(id: "1", name: "查找城市", lat: 1, lon: 1, state: "纽约", country: "美国"),
        SeachCityRowViewModel(id: "2", name: "艾尔蒙特2号", lat: 2, lon: 1, state: "纽约", country: "美国"),
        SeachCityRowViewModel(id: "3", name: "艾尔蒙特3号", lat: 3, lon: 1, state: "纽约", country: "美国"),
        SeachCityRowViewModel(id: "4", name: "埃尔蒙特 4 号", lat: 4, lon: 1, state: "纽约", country: "美国"),
        SeachCityRowViewModel(id: "5", name: "艾尔蒙特5号", lat: 5, lon: 1, state: "纽约", country: "美国"),
        SeachCityRowViewModel(id: "6", name: "艾尔蒙特6号", lat: 5, lon: 1, state: "纽约", country: "美国")
    ]
    return SearchCityContentView(viewModel: nil, data: SearchCityData(searchCities: cities)).environment(\.locale, Locale(identifier: "zh-HK"))
}
