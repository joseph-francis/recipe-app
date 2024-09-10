//
//  RecipeDetailsView.swift
//  Recipe
//
//  Created by Joseph Francis on 9/8/24.
//

import SwiftUI

struct RecipeDetailsView: View {

    @ObservedObject private var viewModel: RecipeDetailsViewModel
    @Environment(\.dismiss) var dismiss

    private enum Constants {
        static let imageHeight: CGFloat = 300
        static let imageCornerRadius: CGFloat = 18
        static let closeIconSize = CGSize(width: 26, height: 26)
        static let imageTopSpacing: CGFloat = 24
    }

    init(viewModel: RecipeDetailsViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView(.vertical) {
            VStack {
                closeView
                imageView
                contentView
            }
            .padding(.vertical)
            .onAppear {
                viewModel.fetchMealDetails()
            }
        }
    }

    private var contentView: some View {
        VStack {
            Text(viewModel.meal.name)
                .font(.title)
                .padding()

            switch viewModel.mealDetailsFetchState {
            case .idle, .fetching:
                Text("Loading...")
            case .fetched:
                VStack(alignment: .leading) {
                    if let instructions = viewModel.mealDetails?.instructions {
                        Text("Instructions")
                            .font(.callout)
                            .foregroundColor(.gray)
                            .padding(.horizontal)

                        Text(instructions)
                            .font(.body)
                            .padding([.horizontal, .bottom])
                    }

                    VStack(alignment: .leading) {
                        Text("Ingredients & Measurements")
                            .font(.callout)
                            .foregroundColor(.gray)
                            .padding(.bottom)

                        preparationInfoView
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            case .failed:
                Text("Failed to load ingredients & measurements")
            }
        }
    }

    private var preparationInfoView: some View {
        Grid {
            ForEach(viewModel.mealIngredientsAndMeasures, id: \.self) { preparationInfo in
                GridRow {
                    Text(preparationInfo.ingredient)
                    Spacer()
                    Text(preparationInfo.measure)
                }

                Divider()
            }
        }
    }

    private var closeView: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(
                        width: Constants.closeIconSize.width,
                        height: Constants.closeIconSize.height
                    )
                    .foregroundColor(.gray.opacity(0.6))
            }
            .padding(.leading)

            Spacer()
        }
    }

    private var imageView: some View {
        AsyncImage(url: viewModel.meal.imageUrl) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(Constants.imageCornerRadius)
                    .padding(.top, Constants.imageTopSpacing)
            case .empty, .failure:
                EmptyView()
            @unknown default:
                EmptyView()
            }
        }
        .frame(height: Constants.imageHeight)
    }
}
