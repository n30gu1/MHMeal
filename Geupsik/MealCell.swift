//
//  MealCell.swift
//  Geupsik
//
//  Created by 박성헌 on 2020/02/02.
//  Copyright © 2020 n30gu1. All rights reserved.
//

import SwiftUI
import ImageWithActivityIndicator

struct MealCell: View {
    @ObservedObject var data = GetData()
    @State var showDetails = false
    var isToday = false
    
    init(date: Date) {
        data.date = date
        self.isToday = date == Date() ? true : false
        data.getData(date: date)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(spacing: 0) {
                Text(DateFormatter().formatKR(date: data.date))
                    .tracking(0.9)
                    .font(.footnote)
                    .bold()
                    .padding(.horizontal, 5)
                if DateFormatter().formatKR(date: data.date) == DateFormatter().formatKR(date: Date()) {
                    Text("오늘")
                        .tracking(0.9)
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                Spacer()
                Text("자세히 보기 ")
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
                Rectangle()
                    .foregroundColor(Color("CellColor"))
                .cornerRadius(8)
                if data.mealIsLoaded {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            Text(data.meal!)
                            Spacer()
                        }
                        Spacer()
                        VStack {
                            Spacer()
                            HStack(spacing: 1) {
                                Text(data.kcal!)
                                    .font(.system(size: 22))
                                    .bold()
                                Text("kcal")
                                    .padding(.bottom, -3)
                            }
                        }
                    }
                    .padding()
                } else {
                    VStack {
                        ActivityIndicator(isAnimating: .constant(true), style: .large)
                    }
                }
            }
        }
        .frame(height: isToday ? 300 : 150)
        .onTapGesture {
            self.showDetails.toggle()
        }
        .sheet(isPresented: self.$showDetails) {
            ShowDetailsView(date: self.data.date)
        }
    }
}
struct MealCell_Previews: PreviewProvider {
    static var previews: some View {
        MealCell(date: Date())
    }
}
