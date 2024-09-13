//
//  DessertView.swift
//  FetchMeals
//
//  Created by Charles Fiedler on 8/15/24.
//

import SwiftUI

struct DessertView: View {
  @ObservedObject var viewModel: DessertViewModel
  @State private var searchText = ""

  var body: some View {
    NavigationStack {
      VStack {
        if viewModel.isLoading {
          ProgressView()
        } else {
          List {
            ForEach(searchResults, id: \.id) { meal in
              NavigationLink {
                MealView(
                  viewModel: .init(
                    mealPreviewModel: meal,
                    mealsAsyncService: viewModel.mealsAsyncService
                  )
                )
              } label: {
                MealPreview(mealData: meal)
              }
              .listRowSeparator(.hidden)
              .listRowBackground(Color.clear)
            }
            if searchResults.isEmpty {
              HStack {
                Spacer()
                Text("No Results...")
                Spacer()
              }
              .listRowSeparator(.hidden)
              .listRowBackground(Color.clear)
            }
          }
          .navigationTitle("Dessert Finder")
          .searchable(text: $searchText)
          .clipShape(RoundedRectangle(cornerRadius: 15.0))
          .padding()
        }
      }
    }
  }

  var searchResults: [MealPreviewModel] {
    if searchText.isEmpty {
      return viewModel.meals
    } else {
      let filteredMeals = viewModel.meals.filter {
        $0.name.lowercased().contains(searchText.lowercased())
      }
      if !filteredMeals.isEmpty {
        return filteredMeals
      }
      return []
    }
  }
}

#Preview {
  DessertView(viewModel: DessertViewModel(mealsAsyncService: MealsAsyncService(serviceType: .mock)))
}
