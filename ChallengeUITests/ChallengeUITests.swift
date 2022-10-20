//
//  ChallengeUITests.swift
//  ChallengeUITests
//
//  Created by Carlos Mario Munoz Perez on 14/10/22.
//

import XCTest

class ChallengeUITests: XCTestCase {
    
    var app: XCUIApplication!
    var detailFavoriteButton: XCUIElement!
    var moviesCollection: XCUIElement!
    var cellFavoriteImageView: XCUIElement!
    var loadingIndicatorView: XCUIElement!
    var firstMovieCell: XCUIElement!
    var firstFavoriteCell: XCUIElement!
    var backNavigationButton: XCUIElement!
    var tabBarFavoriteButton: XCUIElement!
    var favoriteTable: XCUIElement!
    
    override func setUp() {
        app = XCUIApplication()
        continueAfterFailure = false
        app.launchArguments.append("--UITests")
        loadingIndicatorView = app.activityIndicators[Identifiers.loadingIndicatorView]
        moviesCollection = app.collectionViews[Identifiers.moviesCollection]
        detailFavoriteButton = app.buttons[Identifiers.detailFavoriteButton]
        favoriteTable = app.tables[Identifiers.favoritesTable]
        firstMovieCell = moviesCollection.cells.element(boundBy: 1)
        firstFavoriteCell = favoriteTable.cells.element(boundBy: 0)
        cellFavoriteImageView = firstMovieCell.images[Identifiers.cellFavoriteImageView]
        backNavigationButton = app.navigationBars.buttons.element(boundBy: 0)
        tabBarFavoriteButton = app.tabBars.buttons.element(boundBy: 1)
        app.launch()
    }

    func testSelectFavoriteAndChangeOnCollection() {
        waitLoadingHide()
        let wasFavorite: Bool = cellFavoriteImageView.exists
        toggleFavoriteAndBack()
        XCTAssert(wasFavorite != cellFavoriteImageView.exists)
    }
    
    func testRemoteFavoriteFromDetail() {
        waitLoadingHide()
        if !cellFavoriteImageView.exists {
            toggleFavoriteAndBack()
        }
        tabBarFavoriteButton.tap()
        XCTAssertTrue(favoriteTable.exists)
        XCTAssertTrue(firstFavoriteCell.exists)
        let favoriteCount: Int = favoriteTable.cells.count
        firstFavoriteCell.tap()
        detailFavoriteButton.tap()
        backNavigationButton.tap()
        let newFavoriteCount: Int = favoriteTable.cells.count
        XCTAssertEqual(favoriteCount - 1, newFavoriteCount)
    }
    
    private func toggleFavoriteAndBack() {
        firstMovieCell.tap()
        detailFavoriteButton.tap()
        backNavigationButton.tap()
    }
    
    private func waitLoadingHide() {
        let expectation = XCTNSPredicateExpectation(predicate: NSPredicate(format: "exists == false"), object: loadingIndicatorView)
        let result = XCTWaiter().wait(for: [ expectation ], timeout: 10.0)
        XCTAssert(result == .completed)
    }
}

public enum Identifiers {
    
    static let detailFavoriteButton = "detail_favorite_button"
    static let moviesCollection = "movies_collection"
    static let cellFavoriteImageView = "cell_favorite_image_view"
    static let loadingIndicatorView = "loading_indicator_view"
    static let favoritesTable = "favorite_table_view"
}
