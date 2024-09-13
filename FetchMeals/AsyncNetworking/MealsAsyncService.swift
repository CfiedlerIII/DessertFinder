//
//  MealsAsyncService.swift
//  FetchMeals
//
//  Created by Charles Fiedler on 9/10/24.
//

import Foundation

protocol MealsAsyncServiceable {
  func fetchMealUsingID(_ mealID: String) async throws -> Result<MealRecipeWrapper,NetworkError>
  func fetchAllInCategory(_ mealCategory: String) async throws -> Result<MealPreviewWrapper,NetworkError>
}

class MealsAsyncService {
  let activeService: MealsAsyncServiceable

  init(serviceType: DataServiceType = .remote) {
    switch serviceType {
    case .remote:
      activeService = MealsAsyncService.RemoteService()
    default:
      activeService = MealsAsyncService.MockService()
    }
  }

  func fetchMealUsingID(_ mealID: String) async throws -> Result<MealDataModel, NetworkError> {
    let result = try await activeService.fetchMealUsingID(mealID)
    switch result {
    case .success(let mealWrapper):
      guard let meal = mealWrapper.meals.first else {
        print("Failed to fetch first matching meal.")
        return .failure(.genericError(APIError(message: "No results in list."), .notFound, nil))
      }
      return .success(meal)
    case .failure(let error):
      return .failure(error)
    }
  }

  func fetchAllInCategory(_ mealCategory: String) async throws -> Result<[MealPreviewModel], NetworkError> {
    let result = try await activeService.fetchAllInCategory(mealCategory)
    switch result {
    case .success(let mealWrapper):
      return .success(mealWrapper.meals)
    case .failure(let error):
      return .failure(error)
    }
  }
}

extension MealsAsyncService {
  class RemoteService: MealsAsyncServiceable {
    
    func fetchMealUsingID(_ mealID: String) async throws -> Result<MealRecipeWrapper, NetworkError> {
      let host = NetworkHost.mealAPI(NetworkHost.ActiveScheme).host
      let urlString = "\(host)1/lookup.php?i=\(mealID)"

      guard let url = URL(string: urlString) else {
        let badURLError = NetworkError.badURL("Error: 0xA001 - Unable to generate a valid URL")
        return .failure(badURLError)
      }

      let (data, response) = try await URLSession.shared.data(from: url)
      guard let httpResponse = response as? HTTPURLResponse,
            let statusCode = HTTPStatusCode(rawValue: httpResponse.statusCode) else {
        return .failure(.unsatisfiableConnection)
      }
      if statusCode == .ok {
        do {
          let model = try JSONDecoder().decode(MealRecipeWrapper.self, from: data)
          return .success(model)
        } catch let decodingError {
          return .failure(NetworkError.decodingError(decodingError, data, statusCode))
        }
      } else {
        if let apiError = try? JSONDecoder().decode(APIError.self, from: data) {
          return .failure(.genericError(apiError, statusCode, data))
        } else {
          return .failure(.badResponse("Unknown Error", statusCode))
        }
      }
    }
    
    func fetchAllInCategory(_ mealCategory: String) async throws -> Result<MealPreviewWrapper, NetworkError> {

      let host = NetworkHost.mealAPI(NetworkHost.ActiveScheme).host
      let urlString = "\(host)1/filter.php?c=\(mealCategory)"
      guard let url = URL(string: urlString) else {
        let badURLError = NetworkError.badURL("Error: 0xA002 - Unable to generate a valid URL")
        return .failure(badURLError)
      }

      let (data, response) = try await URLSession.shared.data(from: url)
      guard let httpResponse = response as? HTTPURLResponse,
            let statusCode = HTTPStatusCode(rawValue: httpResponse.statusCode) else {
        return .failure(.unsatisfiableConnection)
      }
      if statusCode == .ok {
        do {
          let model = try JSONDecoder().decode(MealPreviewWrapper.self, from: data)
          return .success(model)
        } catch let decodingError {
          return .failure(NetworkError.decodingError(decodingError, data, statusCode))
        }
      } else {
        if let apiError = try? JSONDecoder().decode(APIError.self, from: data) {
          return .failure(.genericError(apiError, statusCode, data))
        } else {
          return .failure(.badResponse("Unknown Error", statusCode))
        }
      }
    }
  }

  class MockService: MealsAsyncServiceable {
    func fetchMealUsingID(_ mealID: String) async throws -> Result<MealRecipeWrapper, NetworkError> {
      let meals = [
        MealDataModel(id: "0001", name: "Stew", thumbnail: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg")
      ]
      let mealWrapper = MealRecipeWrapper(meals: meals)
      return .success(mealWrapper)
    }

    func fetchAllInCategory(_ mealCategory: String) async throws -> Result<MealPreviewWrapper, NetworkError> {
      let meals = [
        MealPreviewModel(
          id: "53049",
          name: "Apam balik",
          thumbnail: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg"
        ),
        MealPreviewModel(
          id: "52893",
          name: "Apple & Blackberry Crumble",
          thumbnail: "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg"
        )
      ]
      let mealWrapper = MealPreviewWrapper(meals: meals)
      return .success(mealWrapper)
    }
  }
}
