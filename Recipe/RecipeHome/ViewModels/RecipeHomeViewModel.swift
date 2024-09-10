//
//  RecipeHomeViewModel.swift
//  Recipe
//
//  Created by Joseph Francis on 9/8/24.
//

import Foundation

final class RecipeHomeViewModel: ObservableObject {

    @Published private(set) var meals: [Meal] = []
    @Published private(set) var categoryFetchState: NetworkFetchState = .idle

    private let mealService: MealsNetworkServiceProtocol

    init(
        mealService: MealsNetworkServiceProtocol = MealsNetworkService()
    ) {
        self.mealService = mealService
    }

    func fetchDessertCategory() {
        guard case .idle = categoryFetchState else {
            return
        }

        categoryFetchState = .fetching
        Task { @MainActor [weak self] in
            guard let self else { return }
            do {
                meals = try await mealService
                    .fetchMeals()
                    .sorted { $0.name < $1.name }
                categoryFetchState = .fetched
            } catch {
                categoryFetchState = .failed
            }
        }
    }
}
