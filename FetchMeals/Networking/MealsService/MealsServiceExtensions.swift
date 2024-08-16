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

    func fetchMealUsingID(_ mealID: String, completion: @escaping (Result<MealDataModel, NetworkError>) -> Void) {
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
        MealDataModel.self,
        urlRequest: request,
        completion: completion
      )
    }
    
    func fetchAllInCategory(_ mealCategory: String, completion: @escaping (Result<MealDataWrapper, NetworkError>) -> Void) {
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
        MealDataWrapper.self,
        urlRequest: request,
        completion: completion
      )
    }
  }

  class MockService: MealServiceable {
    func fetchMealUsingID(_ mealID: String, completion: @escaping (Result<MealDataModel, NetworkError>) -> Void) {
      completion(.success(MealDataModel(id: "0001", name: "Stew", thumbnail: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg")))
    }

    func fetchAllInCategory(_ mealCategory: String, completion: @escaping (Result<MealDataWrapper, NetworkError>) -> Void) {
      let meals = [
        MealDataModel(
          id: "53049",
          name: "Apam balik",
          thumbnail: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg"
        ),
        MealDataModel(
          id: "52893",
          name: "Apple & Blackberry Crumble",
          thumbnail: "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg"
        )
      ]
      let mealWrapper = MealDataWrapper(meals: meals)
      completion(.success(mealWrapper))
    }
  }
}
