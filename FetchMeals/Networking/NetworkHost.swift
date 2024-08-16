//
//  NetworkHost.swift
//  FetchMeals
//
//  Created by Charles Fiedler on 8/15/24.
//

import Foundation

enum NetworkHost {
  enum Scheme: String, CaseIterable {
    case develop, production
  }

  case mealAPI(Scheme)

  static var ActiveScheme: Scheme {
    #if DEBUG
    return Scheme.develop
    #else
    return Scheme.production
    #endif
  }

  var host: String {
    switch self {
    case .mealAPI(let scheme):
      switch scheme {
      case .develop:
        //In this case, the development backend API has the same base URL
        return "https://themealdb.com/api/json/v1/"
      case .production:
        return "https://themealdb.com/api/json/v1/"
      }
    }
  }
}
