//
//  ContentView.swift
//  Geupsik
//
//  Created by 박성헌 on 2019/12/15.
//  Copyright © 2019 n30gu1. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @StateObject var model = ContentViewModel()
    @State var date = Date()
    @State var trigger = false
    
    var body: some View {
        NavigationView {
            List {
                if model.showCalender {
                    DatePicker(selection: $date, displayedComponents: .date) {}
                        .labelsHidden()
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .onChange(of: date, perform: { value in
                            print("value changed")
                            model.changeDate(date: value)
                            model.get()
                        })
                } else {
                    TopNavigator(model: model, trigger: $trigger)
                }
                ForEach(model.meals, id: \.self) { meal in
                    MealCell(selDate: date, date: meal.date, meals: meal.meal, kcal: meal.kcal)
                }
            }
            .listStyle(InsetListStyle())
            .navigationBarTitle("Meals")
            .navigationBarItems(leading: Button(action: {
                self.model.date = Date()
            }) {
                Text("Today")
            },
            trailing: Button(action: {
                withAnimation {
                    model.toggle()
                }
            }) {
                Image(systemName: "calendar")
                    .font(.system(size: 20))
            })
        }
    }
}

struct TopNavigator: View {
    @StateObject var model: ContentViewModel
    @Binding var trigger: Bool
    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy MM dd"
        
        return f
    }()
    
    var body: some View {
        HStack(alignment: .center) {
            Button(action: {
                model.jumpBwdAWeek()
                model.get()
            }) {
                Image(systemName: "chevron.left")
                .padding(12)
                .background(Color("CellColor"))
                .clipShape(Circle())
            }
            .disabled(formatter.date(from: "2018 03 02")! > model.date)
            Spacer()
            Text(model.date.rangeString())
                .font(.footnote)
            Spacer()
            Button(action: {
                model.jumpFwdAWeek()
                model.get()
            }) {
                Image(systemName: "chevron.right")
                .padding(12)
                .background(Color("CellColor"))
                .clipShape(Circle())
            }
            .disabled(Date().addingTimeInterval(86400*365) < model.date)
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
