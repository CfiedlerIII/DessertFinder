//
//  MealView.swift
//  FetchMeals
//
//  Created by Charles Fiedler on 8/16/24.
//

import SwiftUI

struct MealView: View {

  var mealData: MealDataModel

  var body: some View {
    VStack(alignment: .center) {
      Spacer()
      Text(mealData.name)
        .padding(4)
        .background(
          .white
            .opacity(0.75)
        )
        .clipShape(RoundedRectangle(cornerRadius: 6.0))
      Spacer()
    }
    .padding([.top, .bottom], 24)
    .padding([.leading, .trailing], 4)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(
      AsyncImage(url: URL(string: mealData.thumbnail)) { image in
        image
          .resizable()
          .aspectRatio(contentMode: .fill)
      } placeholder: {
        Color.gray
      }
    )
    .clipShape(RoundedRectangle(cornerRadius: 15.0))
  }
}

#Preview {
  MealView(
    mealData: .init(
      id: "52889",
      name: "Summer Pudding",
      thumbnail: "https://www.themealdb.com/images/media/meals/rsqwus1511640214.jpg"
    )
  )
}
