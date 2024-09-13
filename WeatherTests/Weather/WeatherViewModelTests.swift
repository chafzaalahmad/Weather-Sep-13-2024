//
//  WeatherViewModelTests.swift
//  WeatherTests
//
//  Created by Afzaal Ahmad on 9/12/24.
//

import XCTest
import Combine
@testable import Weather

final class WeatherViewModelTests: XCTestCase {
    private var sut: WeatherViewModel!
    private var useCase: WeatherUseCaseMock!
    private var cancellable = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        useCase = WeatherUseCaseMock()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        useCase = nil
        cancellable = []
    }
    
    func testViewModel_whenServerReturnSuccess_shallReturnWeatherState() {
        // Given
        var currentContent: WeatherViewContent?
        
        let weather = Weather(id: 800, main: "Clear", description: "overcast clouds", icon: "01n")
        let weatherMain = WeatherMain(temp: 79.74, feels_like: 79.74, temp_min: 76.96, temp_max: 82.69, pressure: 1010, humidity: 61)
        let location = Location(lat: 32.7763, lon: -96.7969)
        let currentContentWeatherLocation = WeatherLocation(id: 4684888, name: "Dallas", weather: [weather], main: weatherMain, coord: location)
        
        let expectation = self.expectation(description: #function)
        let expectedWeatherLocation = WeatherViewContent(temperature: "79.7°", weatherCitiName: "Dallas", fullDayTemperature: "Min: 77° Max: 82.7°", description: "Clear", weatherIconUrl: URL(string: "https://openweathermap.org/img/wn/01n@2x.png"))
        
        sut = .init(weatherUseCase: useCase, location: location)
        
        sut.output.sink { state in
            guard case let .weather(content) = state else {
                return
            }
            
            currentContent = content
            expectation.fulfill()
        }
        .store(in: &cancellable)
        
        // When
        sut.viewDidLoad()
        useCase.fetchWeatherSubject.send(currentContentWeatherLocation)
        
        waitForExpectations(timeout: 1)
        
        // Then
        XCTAssertEqual(expectedWeatherLocation, currentContent)
    }
    
    func testViewModel_whenServerReturnFailure_shallReturnMessageStateWithErrorMessage() {
        // Given
        var currentMessage: String?
        let expectation = self.expectation(description: #function)
        let location = Location(lat: 32.7763, lon: -96.7969)
        sut = .init(weatherUseCase: useCase, location: location)
        
        sut.output.sink { state in
            guard case let .message(message) = state else {
                return
            }
            
            currentMessage = message
            expectation.fulfill()
        }
        .store(in: &cancellable)
        
        // When
        sut.viewDidLoad()
        useCase.fetchWeatherSubject.send(completion: .failure(MockError()))
        
        waitForExpectations(timeout: 1)
        
        // Then
        XCTAssertEqual(currentMessage, MockError().localizedDescription)
    }
}

struct MockError: LocalizedError {
    var errorDescription: String? {
        "mock error message"
    }
}
