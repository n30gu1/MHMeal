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
                        ForEach(meal.DDISH_NM, id: \.self) {
                            Text($0)
                        }
                    }
                }
                Section(header: Text("Calories")) {
                    HStack(alignment: .bottom, spacing: 0) {
                        Text(meal.CAL_INFO)
                            .font(.title2)
                            .bold()
                        Text("kcal")
                            .padding(.bottom, 1)
                    }
                }
                Section(header: Text("Nutrients")) {
                    VStack(alignment: .leading) {
                        ForEach(meal.NTR_INFO ?? [], id: \.self) {
                            Text($0)
                        }
                    }
                }
                Section(header: Text("Origins")) {
                    VStack(alignment: .leading) {
                        ForEach(meal.ORPLC_INFO ?? [], id: \.self) {
                            Text($0)
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle(meal.MLSV_YMD!.format())
        }
    }
}

//struct MealDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        MealDetailView(meal: Meal(date: Date(), meal: ["1", "2", "3", "4", "5", "6"], origins: ["1", "2", "3", "4", "5", "6"], kcal: "1911"))
//    }
//}

struct MealDetailViewiPad: View {
    let meal: Meal
    
    var body: some View {
        Form {
            Section(header: Text("Meal")) {
                VStack(alignment: .leading) {
                    ForEach(meal.DDISH_NM, id: \.self) {
                        Text($0)
                    }
                }
            }
            Section(header: Text("Calories")) {
                HStack(alignment: .bottom, spacing: 0) {
                    Text(meal.CAL_INFO)
                        .font(.title2)
                        .bold()
                    Text("kcal")
                        .padding(.bottom, 1)
                }
            }
            Section(header: Text("Nutrients")) {
                VStack(alignment: .leading) {
                    ForEach(meal.NTR_INFO ?? [], id: \.self) {
                        Text($0)
                    }
                }
            }
            Section(header: Text("Origins")) {
                VStack(alignment: .leading) {
                    ForEach(meal.ORPLC_INFO ?? [], id: \.self) {
                        Text($0)
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle(meal.MLSV_YMD!.format())
    }
}
