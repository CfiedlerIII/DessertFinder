//
//  FetchMealsHome.swift
//  FetchMeals
//
//  Created by Charles Fiedler on 8/17/24.
//

import SwiftUI

struct FetchMealsHomeView: View {

  var body: some View {
    NavigationStack {
      VStack {
        NavigationLink {
          Text("")
        } label: {
          Text("Find Meal by ID")
        }
        NavigationLink {
          DessertView(viewModel: DessertViewModel(mealsAsyncService: MealsAsyncService(serviceType: .remote)))
        } label: {
          Text("Dessert Finder")
        }
        Spacer()
      }
      .navigationTitle("Fetch Meals")
      .padding()
    }
  }
}

#Preview {
  FetchMealsHomeView()
}
