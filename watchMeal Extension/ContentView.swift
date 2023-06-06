//
//  ContentView.swift
//  watchMeal Extension
//
//  Created by 박성헌 on 2020/06/14.
//  Copyright © 2020 n30gu1. All rights reserved.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @ObservedObject var viewModel = ContentViewModel()
    @EnvironmentObject var delegate: ExtensionDelegate
    
    var body: some View {
        if viewModel.mealList.count >= 5 {
            List(viewModel.mealList, id: \.self) { meal in
                NavigationLink(destination: MealView(meal: meal)) {
                    Text(meal.date!.formatShort())
                }
            }
            .listStyle(CarouselListStyle())
            .navigationBarTitle("\(viewModel.mealType.localizedString)")
        } else {
            ProgressView()
        }
            .onReceive(delegate.willEnterForegroundPublisher) { _ in
                
                // Add your data refreshing logic here
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
