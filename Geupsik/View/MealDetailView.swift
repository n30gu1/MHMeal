//
//  MealDetailView.swift
//  MealDetailView
//
//  Created by 박성헌 on 2021/07/21.
//  Copyright © 2021 n30gu1. All rights reserved.
//

import SwiftUI

struct MealDetailView: View {
    let meal: Meal
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Meal")) {
                    VStack(alignment: .leading) {
                        ForEach(meal.meal, id: \.self) {
                            Text($0)
                        }
                    }
                }
                Section(header: Text("Calories")) {
                    HStack(alignment: .bottom, spacing: 0) {
                        Text(meal.kcal)
                            .font(.title2)
                            .bold()
                        Text("kcal")
                            .padding(.bottom, 1)
                    }
                }
                Section(header: Text("Origins")) {
                    VStack(alignment: .leading) {
                        ForEach(meal.origins, id: \.self) {
                            Text($0)
                        }
                    }
                }
                if let url = self.meal.imageLink {
                    Section(header: Text("Image")) {
                        AsyncImage(url: URL(string: url)!, placeholder: {
                            ProgressView("Loading")
                                .progressViewStyle(CircularProgressViewStyle())
                        }, image: {
                            Image(uiImage: $0)
                                .resizable()
                        })
                            .scaledToFit()
                            .padding(.horizontal, -16)
                            .padding(.vertical, -6)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle(meal.date.format())
        }
    }
}

struct MealDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MealDetailView(meal: Meal(date: Date(), meal: ["1", "2", "3", "4", "5", "6"], origins: ["1", "2", "3", "4", "5", "6"], kcal: "1911"))
    }
}

struct MealDetailViewiPad: View {
    let meal: Meal
    
    var body: some View {
        Form {
            Section(header: Text("Meal")) {
                VStack(alignment: .leading) {
                    ForEach(meal.meal, id: \.self) {
                        Text($0)
                    }
                }
            }
            Section(header: Text("Calories")) {
                HStack(alignment: .bottom, spacing: 0) {
                    Text(meal.kcal)
                        .font(.title2)
                        .bold()
                    Text("kcal")
                        .padding(.bottom, 1)
                }
            }
            Section(header: Text("Origins")) {
                VStack(alignment: .leading) {
                    ForEach(meal.origins, id: \.self) {
                        Text($0)
                    }
                }
            }
            if let url = self.meal.imageLink {
                Section(header: Text("Image")) {
                    AsyncImage(url: URL(string: url)!, placeholder: {
                        ProgressView("Loading")
                            .progressViewStyle(CircularProgressViewStyle())
                    }, image: {
                        Image(uiImage: $0)
                            .resizable()
                    })
                        .scaledToFit()
                        .padding(.horizontal, -16)
                        .padding(.vertical, -6)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle(meal.date.format())
    }
}
