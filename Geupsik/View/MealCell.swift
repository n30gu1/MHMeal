//
//  MealCell.swift
//  Geupsik
//
//  Created by 박성헌 on 2020/02/02.
//  Copyright © 2020 n30gu1. All rights reserved.
//

import SwiftUI

struct MealCell: View {
    @State var showDetails = false
    let selDate: Date
    let date: Date
    let meals: [String]
    let kcal: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(spacing: 0) {
                Text(date.format())
                    .tracking(0.9)
                    .font(.footnote)
                    .bold()
                    .padding(.horizontal, 5)
                if date.format() == Date().format() {
                    Text("Today")
                        .tracking(0.9)
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                Spacer()
                Text("Show Details ")
                    .tracking(0.9)
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .bold()
                Text("▾")
                    .font(.system(size: 28))
                    .frame(height: 3)
                    .padding([.bottom, .trailing], 5)
                    .foregroundColor(.gray)
            }
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(Color(white: 0, opacity: 0.1))
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
//                        ForEach(meals, id: \.self) { meal in
//                            Text(meal)
//                        }
                        Spacer()
                    }
                    Spacer()
                    VStack {
                        Spacer()
                        HStack(spacing: 1) {
                            Text(kcal)
                                .font(.system(size: 22))
                                .bold()
                            Text("kcal")
                                .padding(.bottom, -3)
                        }
                    }
                }
                .padding(5)
            }
        }
        .frame(height: date.format() == self.selDate.format() ? 300 : 150)
//        .onTapGesture {
//            self.showDetails.toggle()
//        }
//        .sheet(isPresented: self.$showDetails) {
//            ShowDetailsView(data: self.data)
//        }
    }
}
struct MealCell_Previews: PreviewProvider {
    static var previews: some View {
        MealCell(selDate: Date(), date: Date(), meals: [], kcal: "")
            .previewLayout(.fixed(width: 375, height: 300))
    }
}
