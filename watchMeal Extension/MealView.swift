//
//  MealView.swift
//  watchMeal Extension
//
//  Created by 박성헌 on 2020/06/14.
//  Copyright © 2020 n30gu1. All rights reserved.
//

import SwiftUI

struct MealView: View {
//    @ObservedObject var data = GetData()
    let date: Date
//
    init(date: Date) {
        self.date = date
//        data.getData(date: date, image: false)
    }
    
    var body: some View {
        List {
//            if data.mealIsLoaded {
//                Text("\(data.meal!)")
//            }
//            if data.mealIsLoaded {
//                Text("\(data.kcal!)kcal")
//            }
        }
        .listStyle(CarouselListStyle())
        .navigationTitle(date.formatShort())
    }
}

struct MealView_Previews: PreviewProvider {
    static var previews: some View {
        MealView(date: Date())
    }
}
