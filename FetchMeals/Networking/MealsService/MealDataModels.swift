//
//  MealDataModels.swift
//  FetchMeals
//
//  Created by Charles Fiedler on 8/15/24.
//

import Foundation

struct MealPreviewWrapper: Codable {
  let meals: [MealPreviewModel]
}

struct MealRecipeWrapper: Decodable {
  let meals: [MealDataModel]
}

struct MealPreviewModel: Codable {
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

struct DynamicKey: CodingKey {
  var stringValue: String
  var intValue: Int?

  init?(stringValue: String) {
    self.stringValue = stringValue
  }
  
  init?(intValue: Int) {
    self.stringValue = "\(intValue)"
    self.intValue = intValue
  }
}

struct MealDataModel: Decodable {
  typealias IngredientModel = (ingredient: String, measurement: String)

  enum CodingKeys: String, CodingKey {
    case mealID = "idMeal"
    case name = "strMeal"
    case drinkAlt = "srtDrinkAlternative"
    case category = "strCategory"
    case region = "srtArea"
    case instructions = "strInstructions"
    case thumbnail = "strMealThumb"
    case tags = "srtTags"
    case videoLink = "srtYoutube"
    case source = "srtSource"
    case imageSource = "srtImageSource"
    case creativeCommons = "srtCreativeCommonsConfirmed"
    case dateModified
  }

  var id: String
  var name: String?
  var drinkAlt: String?
  var category: String?
  var region: String?
  var instructions: [String]?
  var thumbnail: String?
  var tags: String?
  var videoLink: String?
  var source: String?
  var imageSource: String?
  var creativeCommons: String?
  var dateModified: String?
  var ingredients: [(String,String)] = []

  init(id: String, name: String, thumbnail: String) {
    self.id = id
    self.name = name
    self.thumbnail = thumbnail
  }

  init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(String.self, forKey: .mealID)
    name = try container.decodeIfPresent(String.self, forKey: .name)
    drinkAlt = try container.decodeIfPresent(String.self, forKey: .drinkAlt)
    category = try container.decodeIfPresent(String.self, forKey: .category)
    region = try container.decodeIfPresent(String.self, forKey: .region)
    let fullInstructions = try container.decodeIfPresent(String.self, forKey: .instructions)
    //Split the instructions up by any new-line codes
    instructions = fullInstructions?.components(separatedBy: "\r\n")
    thumbnail = try container.decodeIfPresent(String.self, forKey: .thumbnail)
    tags = try container.decodeIfPresent(String.self, forKey: .tags)
    videoLink = try container.decodeIfPresent(String.self, forKey: .videoLink)
    source = try container.decodeIfPresent(String.self, forKey: .source)
    imageSource = try container.decodeIfPresent(String.self, forKey: .imageSource)
    creativeCommons = try container.decodeIfPresent(String.self, forKey: .creativeCommons)
    dateModified = try container.decodeIfPresent(String.self, forKey: .dateModified)

    let dynamicContainer = try decoder.container(keyedBy: DynamicKey.self)
    var ingredientArray: Array<String> = Array(repeating: "", count: 20)
    var measureArray: Array<String> = Array(repeating: "", count: 20)
    for key in dynamicContainer.allKeys {
      if key.stringValue.contains("strIngredient") {
        let indexString = key.stringValue.replacingOccurrences(of: "strIngredient", with: "")
        guard let index = Int(indexString) else {
          print("Failed to generate index from CodingKey.")
          return
        }
        if let ingredient = try dynamicContainer.decodeIfPresent(String.self, forKey: key) {
          ingredientArray[index-1] = ingredient
        }
      } else if key.stringValue.contains("strMeasure") {
        let indexString = key.stringValue.replacingOccurrences(of: "strMeasure", with: "")
        guard let index = Int(indexString) else {
          print("Failed to generate index from CodingKey.")
          return
        }
        if let measurement = try dynamicContainer.decodeIfPresent(String.self, forKey: key) {
          measureArray[index-1] = measurement
        }
      }
    }
    let ingredientTuples: [IngredientModel] = Array(zip(ingredientArray,measureArray))
    self.ingredients = ingredientTuples.filter {$0.ingredient != ""}
  }
}
