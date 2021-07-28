//
//  ContentView.swift
//  watchMeal Extension
//
//  Created by 박성헌 on 2020/06/14.
//  Copyright © 2020 n30gu1. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = ContentViewModel()
    var body: some View {
        List(viewModel.mealList, id: \.self) { meal in
            if viewModel.mealList.count == 5 {
                NavigationLink(destination: MealView(meal: meal)) {
                    Text(meal.date.formatShort())
                }
            }
        }
    .listStyle(CarouselListStyle())
    .navigationBarTitle("Meals")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
            ContentView()
    }
}
