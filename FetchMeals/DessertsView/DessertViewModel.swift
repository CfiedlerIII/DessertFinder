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
  @Published var isLoading: Bool = true

  init(mealService: MealsService = MealsService(serviceType: .remote)) {
    self.mealService = mealService
    self.fetchDesserts()
  }

  func fetchDesserts() {
    isLoading = true
    self.mealService.fetchAllInCategory("Dessert") { result in
      switch result {
      case .success(let foundMeals):
        self.meals = foundMeals.sorted(by: { $0.name < $1.name
        })
        self.isLoading = false
      case .failure(let error):
        print("\(error.localizedDescription)")
        self.isLoading = false
      }
    }
  }
}
