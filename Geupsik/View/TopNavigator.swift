//
//  TopNavigator.swift
//  TopNavigator
//
//  Created by 박성헌 on 2021/07/16.
//  Copyright © 2021 n30gu1. All rights reserved.
//

import SwiftUI

struct TopNavigator: View {
    @Binding var date: Date
    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy MM dd"
        
        return f
    }()
    
    var body: some View {
        HStack(alignment: .center) {
            Button(action: {
                self.date = self.date.addingTimeInterval(-86400*7)
            }) {
                Image(systemName: "chevron.left")
                .padding(12)
                .background(Color("CellColor"))
                .clipShape(Circle())
            }
            .disabled(formatter.date(from: "2018 03 02")! > self.date)
            Spacer()
            Text(date.rangeString())
                .font(.footnote)
            Spacer()
            Button(action: {
                self.date = self.date.addingTimeInterval(86400*7)
            }) {
                Image(systemName: "chevron.right")
                .padding(12)
                .background(Color("CellColor"))
                .clipShape(Circle())
            }
            .disabled(Date().addingTimeInterval(86400*365) < self.date)
        }
        .buttonStyle(BorderlessButtonStyle())
    }
}
