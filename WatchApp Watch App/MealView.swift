//
//  MealView.swift
//  watchMeal Extension
//
//  Created by 박성헌 on 2020/06/14.
//  Copyright © 2020 n30gu1. All rights reserved.
//

import SwiftUI

struct MealView: View {
    let meal: Meal
    
    var body: some View {
        List {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(meal.DDISH_NM, id: \.self) {
                    Text($0)
                }
            }
            HStack(alignment: .bottom, spacing: 0) {
                Text(meal.CAL_INFO)
                    .font(.system(size: 24))
                    .bold()
                Text("kcal")
                    .padding(.bottom, 1)
            }
        }
        .listStyle(CarouselListStyle())
        .navigationTitle("\(meal.MLSV_YMD!.formatShort())")
    }
}

//struct MealView_Previews: PreviewProvider {
//    static var previews: some View {
//        MealView(date: Date())
//    }
//}
