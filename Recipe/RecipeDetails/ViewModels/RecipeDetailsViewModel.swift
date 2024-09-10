//
//  RecipeDetailsViewModel.swift
//  Recipe
//
//  Created by Joseph Francis on 9/9/24.
//

import Foundation

extension RecipeDetailsViewModel {

    struct RecipePreparationInfo: Hashable {
        let ingredient: String
        let measure: String
    }
}

final class RecipeDetailsViewModel: ObservableObject {

    let meal: Meal
    private let mealService: MealsNetworkServiceProtocol

    @Published private(set) var mealDetails: MealDetail?
    @Published private(set) var mealDetailsFetchState: NetworkFetchState = .idle

    var ingredientsPresentableText: String? {
        mealDetails?.ingredients.joined(separator: ", ")
    }

    var measurementsPresentableText: String? {
        mealDetails?.measures.joined(separator: ", ")
    }

    var mealIngredientsAndMeasures: [RecipePreparationInfo] {
        guard let mealDetails else { return [] }
        return zip(mealDetails.ingredients, mealDetails.measures).map { (ingredient, measure) in
            RecipePreparationInfo(
                ingredient: ingredient,
                measure: measure
            )
        }
    }

    init(
        meal: Meal,
        mealService: MealsNetworkServiceProtocol = MealsNetworkService()
    ) {
        self.meal = meal
        self.mealService = mealService
    }

    func fetchMealDetails() {
        guard case .idle = mealDetailsFetchState else {
            return
        }

        mealDetailsFetchState = .fetching
        Task { @MainActor [weak self] in
            guard let self else { return }

            do {
                mealDetails = try await mealService.fetchMealDetails(with: meal.id)
                mealDetailsFetchState = .fetched
            } catch {
                mealDetailsFetchState = .failed
            }
        }
    }
}
