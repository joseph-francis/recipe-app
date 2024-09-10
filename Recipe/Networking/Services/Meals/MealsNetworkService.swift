//
//  MealsNetworkService.swift
//  Recipe
//
//  Created by Joseph Francis on 9/8/24.
//

import Foundation

protocol MealsNetworkServiceProtocol: AnyObject {
    func fetchMeals() async throws -> [Meal]
    func fetchMealDetails(with id: String) async throws -> MealDetail
}

final class MealsNetworkService: MealsNetworkServiceProtocol {

    private let dependencies: Dependencies

    enum MealErrorTypes: Error {
        case noMealDetails
    }

    init(dependencies: Dependencies = Dependencies()) {
        self.dependencies = dependencies
    }

    func fetchMeals() async throws -> [Meal] {
        let response = try await dependencies.networkService.fetch(
            from: MealsEndpoint.category(.dessert),
            as: MealResponse<Meal>.self
        )
        return response.meals
    }

    func fetchMealDetails(with id: String) async throws -> MealDetail {
        let endpoint = MealsEndpoint.mealDetails(mealId: id)
        let response = try await dependencies.networkService.fetch(
            from: endpoint,
            as: MealResponse<MealDetail>.self
        )

        guard let details = response.meals.first else {
            throw MealErrorTypes.noMealDetails
        }
        return details
    }
}

extension MealsNetworkService {

    struct Dependencies {
        let networkService: NetworkServiceProtocol

        init(
            networkService: some NetworkServiceProtocol = NetworkService()
        ) {
            self.networkService = networkService
        }
    }
}
