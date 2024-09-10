//
//  MockMealsNetworkService.swift
//  RecipeTests
//
//  Created by Joseph Francis on 9/10/24.
//

import Foundation
@testable import Recipe

class MockMealsNetworkService: MealsNetworkServiceProtocol {

    func fetchMealDetails(with id: String) async throws -> Recipe.MealDetail {
        if shouldThrowError {
            throw NSError(domain: "MealDetailTestError", code: 1, userInfo: nil)
        }

        return MockMealsNetworkService.mockMealDetails
    }

    var meals: [Meal] = []
    var shouldThrowError = false
    var fetchMealsCallCount = 0
    static let mockMealDetails = Recipe.MealDetail(
        mealID: "1",
        mealName: "Cake",
        category: "Dessert",
        instructions: "Make it for 2 hours",
        mealThumbURL: "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg",
        youtubeURL: "https://www.youtube.com/watch?v=4vhcOwVBDO4",
        ingredients: ["Flour",
        "Water"],
        measures: ["120g",
        "1 cup"]
    )

    func fetchMeals() async throws -> [Meal] {
        fetchMealsCallCount += 1
        if shouldThrowError {
            throw NSError(domain: "TestError", code: 1, userInfo: nil)
        }
        return meals
    }
}
