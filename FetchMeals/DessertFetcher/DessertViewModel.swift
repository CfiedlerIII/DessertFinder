//
//  DessertViewModel.swift
//  FetchMeals
//
//  Created by Charles Fiedler on 8/16/24.
//

import Foundation

class DessertViewModel: ObservableObject {
  private var mealService: MealsService
  @Published var meals: [MealDataModel] = []

  init(mealService: MealsService = MealsService(serviceType: .remote)) {
    self.mealService = mealService
  }

  func fetchDesserts() {
    self.mealService.fetchAllInCategory("Dessert") { result in
      switch result {
      case .success(let foundMeals):
        print("Success!")
        print("\(foundMeals)")
        self.meals = foundMeals
      case .failure(let error):
        print("Failure...")
        print("\(error.localizedDescription)")
      }
    }
  }
}
