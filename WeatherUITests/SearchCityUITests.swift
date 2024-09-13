//
//  SearchCityUITests.swift
//  WeatherUITests
//
//  Created by Afzaal Ahmad on 9/12/24.
//

import XCTest

final class SearchCityUITests: XCTestCase {

    private var app: XCUIApplication!
    
    override func setUp() {
        // UI tests must launch the application that they test.
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        app = nil
    }


    func testNavBar() throws {
        let title = app.staticTexts["Find weather for city"]
        let navBar = app.navigationBars.element
            
        XCTAssert(navBar.exists)
        XCTAssert(title.waitForExistence(timeout: 0.5))
    }
    
    func testSearchBar() throws {
        let searchCityTextField = app.searchFields["Search City"]
        XCTAssertTrue(searchCityTextField.exists, "Search city text field not found")
    }
    
    func testSearchCity() throws {
        let searchCityTextField = app.searchFields["Search City"]
        
        searchCityTextField.tap()
        
        searchCityTextField.typeText("Dallas")

        XCTAssertTrue(app.collectionViews.cells.element.waitForExistence(timeout: 10))
    }
}
