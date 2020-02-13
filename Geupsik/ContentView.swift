//
//  ContentView.swift
//  Geupsik
//
//  Created by 박성헌 on 2019/12/15.
//  Copyright © 2019 n30gu1. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var showDatePicker = false
    @State var selectedDate = Date()
    
    init() {
        UITableView.appearance().separatorStyle = .none
    }
    
    var body: some View {
        NavigationView {
            List {
                TopNavigator(date: self.$selectedDate)
                if showDatePicker {
                    DatePicker("Enter a Date", selection: $selectedDate, displayedComponents: .date)
                        .labelsHidden()
                        .environment(\.locale, Locale(identifier: "ko"))
                }
                ForEach(selectedDate.autoWeekday(date: selectedDate), id: \.self) { date in
                    MealCell(date: date)
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle("급식 보기")
            .navigationBarItems(leading: Button(action: {
                self.selectedDate = Date()
            }) {
                Text("오늘")
            },
            trailing: Button(action: {
                self.showDatePicker.toggle()
            }) {
                Image(systemName: "calendar")
            })
        }
    }
}

struct TopNavigator: View {
    @Binding var date: Date
    let f = DateFormatter().koreanShortLocale()
    var body: some View {
        HStack(alignment: .center) {
            Button(action: {
                self.date = self.date.addingTimeInterval(-86400*7)
            }) {
                Text("저번 주")
            }
            Spacer()
            Text("\(DateFormatter().formatKR(date: date.autoWeekday(date: date).first!)) ~ \(f.string(from: date.autoWeekday(date: date).last!))")
            Spacer()
            Button(action: {
                self.date = self.date.addingTimeInterval(86400*7)
            }) {
                Text("다음 주")
            }
        }
        .buttonStyle(BorderlessButtonStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

