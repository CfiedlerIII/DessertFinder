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
        List {
          ForEach(searchResults, id: \.id) { meal in
            NavigationLink {
              Text(meal.name)
            } label: {
              MealPreview(mealData: meal)
            }
              .listRowSeparator(.hidden)
              .listRowBackground(Color.clear)
              .buttonStyle(.plain)
          }
        }
        .navigationTitle("Dessert Finder")
        .searchable(text: $searchText)
        .listStyle(PlainListStyle())
        .background(
          Color(
            UIColor(
              red: 0.85,
              green: 0.85,
              blue: 0.85,
              alpha: 1.0
            )
          )
        )
        .clipShape(RoundedRectangle(cornerRadius: 15.0))
        .padding()
      }
    }
  }

  var searchResults: [MealDataModel] {
    if searchText.isEmpty {
      return viewModel.meals
    } else {
      let filteredMeals = viewModel.meals.filter {
        $0.name.lowercased().contains(searchText.lowercased())
      }
      if !filteredMeals.isEmpty {
        return filteredMeals
      }
      return [MealDataModel(id: "0000", name: "No Results", thumbnail: "")]
    }
  }
}

#Preview {
  DessertView(viewModel: DessertViewModel(mealService: MealsService(serviceType: .mock)))
}
