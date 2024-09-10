//
//  RecipeTests.swift
//  RecipeTests
//
//  Created by Joseph Francis on 9/8/24.
//

import XCTest
@testable import Recipe

final class RecipeHomeViewModelTests: XCTestCase {

    private enum Constants {
        static let mockURL: URL = URL(string: "https://www.apple.com")!
    }

    func testFetchDessertCategorySuccess() async throws {
        let mockMealService = MockMealsNetworkService()
        let viewModel = RecipeHomeViewModel(mealService: mockMealService)
        mockMealService.meals = [
            Meal(id: "1", name: "Cake", imageUrl: Constants.mockURL),
            Meal(id: "2", name: "Pie", imageUrl: Constants.mockURL)
        ]

        viewModel.fetchDessertCategory()
        try await Task.sleep(for: .milliseconds(500))

        XCTAssertEqual(viewModel.meals.count, 2)
        XCTAssertEqual(viewModel.meals.first?.name, "Cake")
        XCTAssertEqual(viewModel.categoryFetchState, .fetched)
        XCTAssertEqual(mockMealService.fetchMealsCallCount, 1)
    }

    func testFetchDessertCategoryFailure() async throws {
        let mockMealService = MockMealsNetworkService()
        let viewModel = RecipeHomeViewModel(mealService: mockMealService)
        mockMealService.shouldThrowError = true

        viewModel.fetchDessertCategory()
        try await Task.sleep(for: .milliseconds(500))

        XCTAssertTrue(viewModel.meals.isEmpty)
        XCTAssertEqual(viewModel.categoryFetchState, .failed)
        XCTAssertEqual(mockMealService.fetchMealsCallCount, 1)
    }

    func testFetchDessertCategoryDoesNotFetchInNonIdleState() async throws {
        let mockMealService = MockMealsNetworkService()
        let viewModel = RecipeHomeViewModel(mealService: mockMealService)

        viewModel.fetchDessertCategory()
        try await Task.sleep(for: .milliseconds(500))
        viewModel.fetchDessertCategory()

        XCTAssertEqual(mockMealService.fetchMealsCallCount, 1)
    }
}
