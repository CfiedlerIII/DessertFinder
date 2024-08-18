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
    self.fetchDesserts()
  }

  func fetchDesserts() {
    self.mealService.fetchAllInCategory("Dessert") { result in
      switch result {
      case .success(let foundMeals):
        self.meals = foundMeals.sorted(by: { $0.name < $1.name
        })
      case .failure(let error):
        print("\(error.localizedDescription)")
      }
    }
  }
}
