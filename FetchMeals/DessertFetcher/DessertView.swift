//
//  DessertView.swift
//  FetchMeals
//
//  Created by Charles Fiedler on 8/15/24.
//

import SwiftUI

struct DessertView: View {
  @ObservedObject var viewModel: DessertViewModel

  var body: some View {
    VStack {
      Button(action: {
        viewModel.fetchDesserts()
      }, label: {
        Text("Fetch Desserts")
      })
      List {
        ForEach(viewModel.meals, id: \.id) { meal in
          MealView(mealData: meal)
            .listRowSeparator(.hidden)
        }
      }
    }
    .padding()
  }
}

#Preview {
  DessertView(viewModel: DessertViewModel(mealService: MealsService(serviceType: .mock)))
}
