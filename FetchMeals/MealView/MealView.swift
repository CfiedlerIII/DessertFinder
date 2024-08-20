//
//  MealView.swift
//  FetchMeals
//
//  Created by Charles Fiedler on 8/17/24.
//

import SwiftUI

struct MealView: View {
  @ObservedObject var viewModel: MealViewModel

  var body: some View {
    NavigationStack {
      if viewModel.isLoading {
        ProgressView()
      } else {
        ZStack {
          HStack {
            ScrollView {
              VStack {
                Text(viewModel.meal?.name ?? "--")
                  .font(.largeTitle)
                Divider()
                  .frame(height: 1)
                  .overlay(.black)
                HStack {
                  VStack {
                    Text("Ingredients/Measurements:")
                      .font(.headline)
                      .frame(maxWidth: .infinity, alignment: .leading)
                      .padding([.top, .bottom], 5)
                    ForEach(viewModel.meal?.ingredients ?? [], id: \.0) { items in
                      Text("\(items.1) \(items.0)")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    Divider()
                      .frame(height: 1)
                      .overlay(.black)
                    Text("Instructions:")
                      .font(.headline)
                      .frame(maxWidth: .infinity, alignment: .leading)
                      .padding([.top, .bottom], 5)
                    ForEach(viewModel.meal?.instructions ?? [], id: \.self) { instrLine in
                      Text("\(instrLine)")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.bottom], 8)

                    }
                  }
                }
                AsyncImage(url: URL(string: viewModel.meal?.thumbnail ?? "")) { image in
                  image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                } placeholder: {
                  Color.gray
                }
                .clipShape(RoundedRectangle(cornerRadius: 15.0))
                Spacer()
              }
              .padding()
              Spacer()
            }
          }
          .background(
            Color.white
              .opacity(0.8)
          )
        }
        .navigationTitle(("Recipe"))
        .background(
          AsyncImage(url: URL(string: viewModel.meal?.thumbnail ?? "")) { image in
            image
              .resizable()
              .aspectRatio(contentMode: .fill)
          } placeholder: {
            Color.gray
          }
          .ignoresSafeArea(.all, edges: .bottom)
        )
      }
      
    }
    .onAppear() {
      viewModel.fetchMealData()
    }
  }
}

#Preview {
  MealView(
    viewModel: .init(
      mealPreviewModel: .init(
        id: "52893",
        name: "Apple & Blackberry Crumble",
        thumbnail: "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg"
      ),
      mealService: MealsService(serviceType: .mock)
    )
  )
}
