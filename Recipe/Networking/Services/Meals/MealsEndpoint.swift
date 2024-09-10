//
//  MealsEndpoint.swift
//  Recipe
//
//  Created by Joseph Francis on 9/8/24.
//

import Foundation

enum MealCategory: String {
    case dessert = "Dessert"
}

enum MealsEndpoint: Endpoint {

    // MARK: Meal DB endpoints

    case category(MealCategory)
    case mealDetails(mealId: String)

    // MARK: Endpoint conformance

    var httpMethod: HTTPMethod {
        switch self {
        case .category, .mealDetails: .get
        }
    }

    var path: String {
        switch self {
        case let .category(categoryType):
            "/filter.php?c=\(categoryType.rawValue)"
        case let .mealDetails(mealId):
            "/lookup.php?i=\(mealId)"
        }
    }

    var domain: String {
        switch self {
        case .category, .mealDetails: "https://themealdb.com/api/json/v1/1"
        }
    }
}
