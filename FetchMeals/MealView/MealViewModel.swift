//
//  MealViewModel.swift
//  FetchMeals
//
//  Created by Charles Fiedler on 8/19/24.
//

import Foundation

class MealViewModel: ObservableObject {
  private var mealService: MealsService
  private var mealPreviewModel: MealPreviewModel
  @Published var meal: MealDataModel?
  @Published var isLoading: Bool = true

  init(mealPreviewModel: MealPreviewModel, mealService: MealsService = MealsService(serviceType: .remote)) {
    self.mealService = mealService
    self.mealPreviewModel = mealPreviewModel
  }

  func fetchMealData() {
    isLoading = true
    self.mealService.fetchMealUsingID(mealPreviewModel.id) { result in
      switch result {
      case .success(let matchingMeal):
        self.meal = matchingMeal
        print("Model:")
        print("\(matchingMeal)")
        self.isLoading = false
      case .failure(let error):
        print("\(error.localizedDescription)")
        self.isLoading = false
      }
    }
  }
}
