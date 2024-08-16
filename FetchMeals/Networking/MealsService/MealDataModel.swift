//
//  MealDataModel.swift
//  FetchMeals
//
//  Created by Charles Fiedler on 8/15/24.
//

import Foundation

struct MealDataWrapper: Codable {
  let meals: [MealDataModel]
}

struct MealDataModel: Codable {
  enum CodingKeys: String, CodingKey {
    case name = "strMeal"
    case thumbnail = "strMealThumb"
    case mealID = "idMeal"
  }

  var id: String
  var name: String
  var thumbnail: String

  init(id: String, name: String, thumbnail: String) {
    self.id = id
    self.name = name
    self.thumbnail = thumbnail
  }

  init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(String.self, forKey: .mealID)
    name = try container.decode(String.self, forKey: .name)
    thumbnail = try container.decode(String.self, forKey: .thumbnail)
  }

  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .mealID)
    try container.encode(name, forKey: .name)
    try container.encode(thumbnail, forKey: .thumbnail)
  }
}
