//
//  LegacyContentView.swift
//  WatchApp Watch App
//
//  Created by Sung Park on 10/9/23.
//  Copyright © 2023 n30gu1. All rights reserved.
//

import SwiftUI
import UIKit

struct LegacyContentView: View {
    @ObservedObject var viewModel = ContentViewModel()
    
    var body: some View {
        if viewModel.mealList.count >= 5 {
            NavigationStack {
                List(viewModel.mealList, id: \.self) { meal in
                    NavigationLink(destination: MealView(meal: meal)) {
                        Text(meal.MLSV_YMD!.formatShort())
                    }
                }
                .listStyle(CarouselListStyle())
                .navigationBarTitle("\(viewModel.mealType!.localizedString)")
                .onReceive(NotificationCenter.default.publisher(for: .watchAppDidBecomeActive)) { _ in
                    viewModel.determineMealType()
                    viewModel.determineIsNextDay()
                    viewModel.fetch()
                }
            }
        } else {
            ProgressView()
        }
    }
}

struct LegacyContentView_Previews: PreviewProvider {
    static var previews: some View {
        LegacyContentView()
    }
}
