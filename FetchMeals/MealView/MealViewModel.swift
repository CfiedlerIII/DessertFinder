//
//  MealViewModel.swift
//  FetchMeals
//
//  Created by Charles Fiedler on 8/19/24.
//

import Foundation

class MealViewModel: ObservableObject {
  private var mealsAsyncService: MealsAsyncService
  private var mealPreviewModel: MealPreviewModel
  @Published var meal: MealDataModel?
  @Published var isLoading: Bool = true

  init(mealPreviewModel: MealPreviewModel, mealsAsyncService: MealsAsyncService = MealsAsyncService(serviceType: .remote)) {
    self.mealsAsyncService = mealsAsyncService
    self.mealPreviewModel = mealPreviewModel
  }

  func fetchMealData() {
    isLoading = true
    Task { @MainActor in
      do {
        let result = try await self.mealsAsyncService.fetchMealUsingID(mealPreviewModel.id)
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
      } catch {
        print("Error: \(error)")
        self.isLoading = false
      }
    }
  }
}
