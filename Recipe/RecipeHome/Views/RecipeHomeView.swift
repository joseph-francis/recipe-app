//
//  ContentView.swift
//  Recipe
//
//  Created by Joseph Francis on 9/8/24.
//

import SwiftUI

struct RecipeHomeView: View {

    @ObservedObject private var viewModel: RecipeHomeViewModel
    @State private var selectedMeal: Meal?

    private enum Constants {
        static let imageCornerRadius: CGFloat = 12
        static let imageHeight = 200
        static let contentBottomPadding: CGFloat = 14
        static let navigationTitle = "Recipes"
    }

    init(
        viewModel: RecipeHomeViewModel = RecipeHomeViewModel()
    ) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            contentView
                .listStyle(.plain)
                .navigationTitle(
                    Text(Constants.navigationTitle)
                )
                .onAppear {
                    viewModel.fetchDessertCategory()
                }
                .sheet(item: $selectedMeal) { meal in
                    RecipeDetailsView(
                        viewModel: RecipeDetailsViewModel(meal: meal)
                    )
                }
        }
    }

    private var contentView: some View {
        Group {
            switch viewModel.categoryFetchState {
            case .idle, .fetching:
                Text("Loading...")
                    .font(.subheadline)
            case .fetched:
                List(viewModel.meals) { meal in
                    Button {
                        selectedMeal = meal
                    } label: {
                        createMealView(meal: meal)
                    }
                }
            case .failed:
                Text("Something went wrong. Try again later.")
                    .font(.subheadline)
            }
        }
    }

    @ViewBuilder
    private func createMealView(meal: Meal) -> some View {
        AsyncImage(url: meal.imageUrl) { phase in
            switch phase {
            case .empty:
                RoundedRectangle(cornerRadius: Constants.imageCornerRadius)
                    .fill(Color.gray.opacity(0.2))
                    .frame(maxWidth: .infinity)
                    .aspectRatio(contentMode: .fit)
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(Constants.imageCornerRadius)
            case .failure:
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.red.opacity(0.5))
                    .setImageSizing()
            @unknown default:
                EmptyView()
            }
        }

        Text(meal.name)
            .font(.title)

        Text(meal.id)
            .font(.subheadline)
            .foregroundColor(.gray)
            .padding(.bottom, Constants.contentBottomPadding)
    }
}
