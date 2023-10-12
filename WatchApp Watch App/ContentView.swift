//
//  ContentView.swift
//  WatchApp Watch App
//
//  Created by Sung Park on 10/8/23.
//  Copyright © 2023 n30gu1. All rights reserved.
//

import SwiftUI
import UIKit

@available(watchOS 10.0, *)
struct ContentView: View {
    @ObservedObject var viewModel = ContentViewModel()
    @State private var present = false
    
    var body: some View {
        NavigationSplitView {
            List(selection: $viewModel.mealType) {
                Text("Breakfast").tag(MealType.breakfast)
                Text("Lunch").tag(MealType.lunch)
                Text("Dinner").tag(MealType.dinner)
            }
            .onDisappear {
                viewModel.determineIsNextDay()
                viewModel.fetch()
            }
        } detail: {
            if viewModel.mealList.count >= 5 {
                TabView {
                    MealView(meal: viewModel.mealList.first!)
                        .background(Color("BackgroundColor").gradient)
                    List {
                        ForEach(viewModel.mealList, id: \.self) { meal in
                            Button {
                                self.present.toggle()
                            } label: {
                                Text(meal.date!.formatShort())
                            }
                            .sheet(isPresented: $present) {
                                MealView(meal: meal)
                            }
                        }
                    }
                    .listStyle(.carousel)
                    .navigationBarTitle("\((viewModel.mealType ?? .lunch).localizedString)")
                    .onReceive(NotificationCenter.default.publisher(for: .watchAppDidBecomeActive)) { _ in
                        viewModel.determineMealType()
                        viewModel.determineIsNextDay()
                        viewModel.fetch()
                    }
                }
                .tabViewStyle(.verticalPage)
            } else {
                ProgressView()
            }
        }
    }
}

@available(watchOS 10.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
