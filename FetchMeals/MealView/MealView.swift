//
//  MealView.swift
//  FetchMeals
//
//  Created by Charles Fiedler on 8/17/24.
//

import SwiftUI

struct MealView: View {
  let meal: MealDataModel

  var body: some View {
    NavigationStack {
      VStack {

      }
      .navigationTitle((meal.name))
    }
  }
}

#Preview {
  MealView(
    meal: MealDataModel(
      id: "52893",
      name: "Apple & Blackberry Crumble",
      thumbnail: "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg"
    )
  )
}
