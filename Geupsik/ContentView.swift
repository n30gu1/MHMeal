//
//  ContentView.swift
//  Geupsik
//
//  Created by 박성헌 on 2019/12/15.
//  Copyright © 2019 n30gu1. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var date = Date()
    @State var showCalendar = false
    
    var body: some View {
        NavigationView {
            List {
                if showCalendar {
                    DatePicker(selection: self.$date, displayedComponents: .date) {}
                        .labelsHidden()
                        .datePickerStyle(GraphicalDatePickerStyle())
                } else {
                    TopNavigator(date: $date)
                }
                ForEach(date.autoWeekday(), id: \.self) { date in
                    MealCell(date: date, selectedDate: self.date)
                }
            }
            .listStyle(InsetListStyle())
            .navigationBarTitle("Meals")
            .navigationBarItems(leading: Button(action: {
                self.date = Date()
            }) {
                Text("Today")
            },
            trailing: Button(action: {
                withAnimation {
                    self.showCalendar.toggle()
                }
            }) {
                Image(systemName: "calendar")
                    .font(.system(size: 20))
            })
            
        }
    }
}

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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .environment(\.locale, Locale(identifier: "ko"))
            ContentView()
                .environment(\.colorScheme, .dark)
        }
    }
}
