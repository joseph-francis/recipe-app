//
//  RecipeDetailsViewModelTests.swift
//  RecipeTests
//
//  Created by Joseph Francis on 9/10/24.
//

import XCTest
@testable import Recipe

final class RecipeDetailsViewModelTests: XCTestCase {

    private enum Constants {
        static let mockURL: URL = URL(string: "https://www.apple.com")!
    }

    func testInitialization() {
        let meal = Meal(
            id: "1",
            name: "Test Meal",
            imageUrl: Constants.mockURL
        )
        let mealService = MockMealsNetworkService()
        let viewModel = RecipeDetailsViewModel(
            meal: meal,
            mealService: mealService
        )

        XCTAssertEqual(viewModel.meal, meal)

        XCTAssertNil(viewModel.mealDetails)
        XCTAssertEqual(viewModel.mealDetailsFetchState, .idle)
    }

    func testFetchMealDetailsSuccess() async throws {
        let meal = Meal(
            id: "1",
            name: "Test Meal",
            imageUrl: Constants.mockURL
        )
        let mealService = MockMealsNetworkService()
        let viewModel = RecipeDetailsViewModel(
            meal: meal,
            mealService: mealService
        )

        viewModel.fetchMealDetails()
        try await Task.sleep(for: .milliseconds(500))

        XCTAssertEqual(viewModel.mealDetails, MockMealsNetworkService.mockMealDetails)
        XCTAssertEqual(viewModel.mealDetailsFetchState, .fetched)
    }

    func testFetchMealDetailsFailure() async throws {
        let meal = Meal(
            id: "1",
            name: "Test Meal",
            imageUrl: Constants.mockURL
        )
        let mealService = MockMealsNetworkService()
        mealService.shouldThrowError = true
        let viewModel = RecipeDetailsViewModel(meal: meal, mealService: mealService)

        viewModel.fetchMealDetails()
        try await Task.sleep(for: .milliseconds(500))

        XCTAssertEqual(viewModel.mealDetailsFetchState, .failed)
        XCTAssertNil(viewModel.mealDetails)
    }
}
