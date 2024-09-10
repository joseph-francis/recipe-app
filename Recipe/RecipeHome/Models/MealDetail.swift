//
//  MealDetail.swift
//  Recipe
//
//  Created by Joseph Francis on 9/8/24.
//

import Foundation

struct MealDetail: Decodable, Equatable {
    
    let mealID: String
    let mealName: String
    let drinkAlternate: String?
    let category: String
    let area: String?
    let instructions: String
    let mealThumbURL: String
    let tags: String?
    let youtubeURL: String
    let ingredients: [String]
    let measures: [String]
    let source: String?

    private enum Constants {
        static let totalIngredientsCount = 20
        static let totalMeasuresCount = 20
    }

    enum CodingKeys: String, CodingKey {
        case mealID = "idMeal"
        case mealName = "strMeal"
        case drinkAlternate = "strDrinkAlternate"
        case category = "strCategory"
        case area = "strArea"
        case instructions = "strInstructions"
        case mealThumbURL = "strMealThumb"
        case tags = "strTags"
        case youtubeURL = "strYoutube"
        case source = "strSource"

        // Dynamic keys for ingredients and measures
        case strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5, strIngredient6,
             strIngredient7, strIngredient8, strIngredient9, strIngredient10, strIngredient11, strIngredient12,
             strIngredient13, strIngredient14, strIngredient15, strIngredient16, strIngredient17, strIngredient18,
             strIngredient19, strIngredient20
        case strMeasure1, strMeasure2, strMeasure3, strMeasure4, strMeasure5, strMeasure6,
             strMeasure7, strMeasure8, strMeasure9, strMeasure10, strMeasure11, strMeasure12,
             strMeasure13, strMeasure14, strMeasure15, strMeasure16, strMeasure17, strMeasure18,
             strMeasure19, strMeasure20
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.mealID = try container.decode(String.self, forKey: .mealID)
        self.mealName = try container.decode(String.self, forKey: .mealName)
        self.drinkAlternate = try container.decodeIfPresent(String.self, forKey: .drinkAlternate)
        self.category = try container.decode(String.self, forKey: .category)
        self.area = try container.decodeIfPresent(String.self, forKey: .area)
        self.instructions = try container.decode(String.self, forKey: .instructions)
        self.mealThumbURL = try container.decode(String.self, forKey: .mealThumbURL)
        self.tags = try container.decodeIfPresent(String.self, forKey: .tags)
        self.youtubeURL = try container.decode(String.self, forKey: .youtubeURL)
        self.source = try container.decodeIfPresent(String.self, forKey: .source)

        var ingredients = [String]()
        for count in 1...Constants.totalMeasuresCount {
            guard let key = CodingKeys(stringValue: "strIngredient\(count)") else {
                continue
            }

            if let ingredient = try container.decodeIfPresent(String.self, forKey: key), !ingredient.isEmpty {
                ingredients.append(ingredient)
            }
        }
        self.ingredients = ingredients

        var measures = [String]()
        for count in 1...Constants.totalMeasuresCount {
            guard let key = CodingKeys(stringValue: "strMeasure\(count)") else {
                continue
            }

            if let measure = try container.decodeIfPresent(String.self, forKey: key), !measure.isEmpty {
                measures.append(measure)
            }
        }
        self.measures = measures
    }

    init(
        mealID: String,
        mealName: String,
        drinkAlternate: String? = nil,
        category: String,
        area: String? = nil,
        instructions: String,
        mealThumbURL: String,
        tags: String? = nil,
        youtubeURL: String,
        ingredients: [String],
        measures: [String],
        source: String? = nil
    ) {
        self.mealID = mealID
        self.mealName = mealName
        self.drinkAlternate = drinkAlternate
        self.category = category
        self.area = area
        self.instructions = instructions
        self.mealThumbURL = mealThumbURL
        self.tags = tags
        self.youtubeURL = youtubeURL
        self.ingredients = ingredients
        self.measures = measures
        self.source = source
    }
}
