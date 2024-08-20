//
//  MealsServiceExtensions.swift
//  FetchMeals
//
//  Created by Charles Fiedler on 8/15/24.
//

import Foundation

extension MealsService {
  class RemoteService: MealServiceable {

    private var networkingService: NetworkingService

    init(service: NetworkingService = NetworkingService.shared) {
      self.networkingService = service
    }

    func fetchMealUsingID(_ mealID: String, completion: @escaping (Result<MealRecipeWrapper, NetworkError>) -> Void) {
      let host = NetworkHost.mealAPI(NetworkHost.ActiveScheme).host
      let urlString = "\(host)1/lookup.php?i=\(mealID)"

      guard let url = URL(string: urlString) else {
        let badURLError = NetworkError.badURL("Error: 0xA001 - Unable to generate a valid URL")
        completion(.failure(badURLError))
        return
      }
      
      let headers = ["accept": "*/*",
                     "Content-Type": "application/json"]

      let request = networkingService.createRequest(
        forURL: url,
        serializedParameteres: nil,
        bearerToken: nil,
        httpMethod: .GET,
        headers: headers
      )

      networkingService.executeRequest(
        MealRecipeWrapper.self,
        urlRequest: request,
        completion: completion
      )
    }
    
    func fetchAllInCategory(_ mealCategory: String, completion: @escaping (Result<MealPreviewWrapper, NetworkError>) -> Void) {
      let host = NetworkHost.mealAPI(NetworkHost.ActiveScheme).host
      let urlString = "\(host)1/filter.php?c=\(mealCategory)"

      guard let url = URL(string: urlString) else {
        let badURLError = NetworkError.badURL("Error: 0xA002 - Unable to generate a valid URL")
        completion(.failure(badURLError))
        return
      }

      let headers = ["accept": "*/*",
                     "Content-Type": "application/json"]

      let request = networkingService.createRequest(
        forURL: url,
        serializedParameteres: nil,
        bearerToken: nil,
        httpMethod: .GET,
        headers: headers
      )

      networkingService.executeRequest(
        MealPreviewWrapper.self,
        urlRequest: request,
        completion: completion
      )
    }
  }

  class MockService: MealServiceable {
    func fetchMealUsingID(_ mealID: String, completion: @escaping (Result<MealRecipeWrapper, NetworkError>) -> Void) {
      let meals = [
        MealDataModel(id: "0001", name: "Stew", thumbnail: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg")
      ]
      let mealWrapper = MealRecipeWrapper(meals: meals)
      completion(.success(mealWrapper))
    }

    func fetchAllInCategory(_ mealCategory: String, completion: @escaping (Result<MealPreviewWrapper, NetworkError>) -> Void) {
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
      completion(.success(mealWrapper))
    }
  }
}
