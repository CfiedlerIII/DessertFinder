//
//  MealsService.swift
//  FetchMeals
//
//  Created by Charles Fiedler on 8/15/24.
//

import Foundation

protocol MealServiceable {
  func fetchMealUsingID(_ mealID: String, completion: @escaping (Result<MealRecipeWrapper,NetworkError>) -> Void)
  func fetchAllInCategory(_ mealCategory: String, completion: @escaping (Result<MealPreviewWrapper,NetworkError>) -> Void)
}

class MealsService {
  enum DataServiceType {
    case remote
    case mock
    //case offline
  }

  let activeService: MealServiceable

  init(serviceType: DataServiceType = .remote) {
    switch serviceType {
    case .remote:
      activeService = MealsService.RemoteService()
    default:
      activeService = MealsService.MockService()
    }
  }

  func fetchMealUsingID(_ mealID: String, completion: @escaping (Result<MealDataModel,NetworkError>) -> Void) {
    activeService.fetchMealUsingID(mealID) { result in
      switch result {
      case .success(let mealWrapper):
        guard let meal = mealWrapper.meals.first else {
          print("Failed to fetch first matching meal.")
          return
        }
        completion(.success(meal))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  func fetchAllInCategory(_ mealCategory: String, completion: @escaping (Result<[MealPreviewModel],NetworkError>) -> Void) {
    activeService.fetchAllInCategory(mealCategory) { result in
      switch result {
      case .success(let mealWrapper):
        completion(.success(mealWrapper.meals))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}
