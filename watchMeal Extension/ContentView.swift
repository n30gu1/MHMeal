//
//  ContentView.swift
//  watchMeal Extension
//
//  Created by 박성헌 on 2020/06/14.
//  Copyright © 2020 n30gu1. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        List(Date().autoWeekday(), id: \.self) { date in
            NavigationLink(destination: MealView(date: date)) {
                Text(date.formatShort())
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
