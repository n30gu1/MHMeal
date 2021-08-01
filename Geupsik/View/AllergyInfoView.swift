//
//  AllergyInfoView.swift
//  AllergyInfoView
//
//  Created by Park Seongheon on 2021/08/01.
//  Copyright © 2021 n30gu1. All rights reserved.
//

import SwiftUI

struct AllergyInfoView: View {
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Text("According to 'Act of Showing Allergic Food of School Meal', every food that has an allergy info will show numbers after the food name that correspond with the Allergic Ingredient Number.")
                    Section(header: Text("Allergic Ingredient Numbers")) {
                        Group {
                            AllergyInfoCell(ingredient: "Eggs", number: "1")
                            AllergyInfoCell(ingredient: "Milk", number: "2")
                            AllergyInfoCell(ingredient: "Buckwheat", number: "3")
                            AllergyInfoCell(ingredient: "Peanut", number: "4")
                            AllergyInfoCell(ingredient: "Soy Food", number: "5")
                            AllergyInfoCell(ingredient: "Wheat", number: "6")
                            AllergyInfoCell(ingredient: "Mackerel", number: "7")
                            AllergyInfoCell(ingredient: "Crab", number: "8")
                            AllergyInfoCell(ingredient: "Shrimp", number: "9")
                            AllergyInfoCell(ingredient: "Pork", number: "10")
                        }
                        Group {
                            AllergyInfoCell(ingredient: "Peach", number: "11")
                            AllergyInfoCell(ingredient: "Tomato", number: "12")
                            AllergyInfoCell(ingredient: "Sulfurous Acid (H₂SO₃)", number: "13")
                            AllergyInfoCell(ingredient: "Walnut", number: "14")
                            AllergyInfoCell(ingredient: "Chicken", number: "15")
                            AllergyInfoCell(ingredient: "Meat", number: "16")
                            AllergyInfoCell(ingredient: "Squid", number: "17")
                            AllergyInfoCell(ingredient: "Shells (incl. Oyster, Abalone, Mussel)", number: "18")
                            AllergyInfoCell(ingredient: "Pine Nut", number: "19")
                        }
                    }
                }
                .listStyle(.plain)
            }
            .navigationBarTitle("About Allergy Info")
        }
    }
}

struct AllergyInfoCell: View {
    let ingredient: LocalizedStringKey
    let number: String
    
    var body: some View {
        HStack {
            Text(number)
                .bold()
            Spacer()
            Text(ingredient)
        }
    }
}

struct AllergyInfoView_Previews: PreviewProvider {
    static var previews: some View {
        AllergyInfoView()
    }
}
