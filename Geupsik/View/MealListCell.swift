//
//  MealListCell.swift
//  MealListCell
//
//  Created by 박성헌 on 2021/07/17.
//  Copyright © 2021 n30gu1. All rights reserved.
//

import SwiftUI

struct MealListCell: View {
    let meal: Meal
    
    var body: some View {
        VStack(spacing: 3) {
            HStack {
                Text(meal.date.format())
                    .font(.system(size: 12))
                    .fontWeight(.semibold)
                    .kerning(1.2)
                    .foregroundColor(.gray)
                Spacer()
                Text("View Details ▼")
                    .font(.system(size: 12))
                    .fontWeight(.light)
                    .kerning(1.2)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 6)
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.gray)
                VStack(alignment: .leading) {
                    ForEach(meal.meal.prefix(5), id: \.self) { meal in
                        Text(meal)
                    }
                    if meal.meal.count > 5 {
                        Text("...")
                    }
                    Spacer()
                    HStack(alignment: .bottom, spacing: 0) {
                        Spacer()
                        Text(meal.kcal)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .offset(y: 1)
                        Text("kcal")
                            .fontWeight(.light)
                    }
                }
                .padding()
            }
            .frame(height: 200)
        }
    }
}

struct MealListCell_Previews: PreviewProvider {
    static var previews: some View {
        MealListCell(meal: Meal(date: Date(), imageLink: nil, meal: ["1", "2", "3", "4", "5", "6", "7", "8"], kcal: "697.4"))
            .previewLayout(.fixed(width: 350, height: 220))
    }
}
