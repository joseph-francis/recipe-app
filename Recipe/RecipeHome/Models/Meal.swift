//
//  Meal.swift
//  Recipe
//
//  Created by Joseph Francis on 9/8/24.
//

import Foundation

struct MealResponse<DecodableType: Decodable>: Decodable {
    let meals: [DecodableType]
}

struct Meal: Decodable, Identifiable, Equatable {
    let id: String
    let name: String
    let imageUrl: URL

    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case imageUrl = "strMealThumb"
    }
}
