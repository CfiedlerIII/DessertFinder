//
//  FetchMealsApp.swift
//  FetchMeals
//
//  Created by Charles Fiedler on 8/15/24.
//

import SwiftUI

@main
struct FetchMealsApp: App {
    var body: some Scene {
        WindowGroup {
          DessertView(viewModel: DessertViewModel(mealService: MealsService(serviceType: .remote)))
        }
    }
}
