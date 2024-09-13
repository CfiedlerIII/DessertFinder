//
//  DessertViewModel.swift
//  FetchMeals
//
//  Created by Charles Fiedler on 8/16/24.
//

import Foundation

class DessertViewModel: ObservableObject {
  var mealsAsyncService: MealsAsyncService
  @Published var meals: [MealPreviewModel] = []
  @Published var isLoading: Bool = true

  init(mealsAsyncService: MealsAsyncService = MealsAsyncService(serviceType: .remote)) {
    self.mealsAsyncService = mealsAsyncService
    self.fetchDesserts()
  }

  func fetchDesserts() {
    isLoading = true
    Task { @MainActor in
      do {
        let result = try await self.mealsAsyncService.fetchAllInCategory("Dessert")
        switch result {
        case .success(let foundMeals):
          self.meals = foundMeals.sorted(by: { $0.name < $1.name
          })
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
