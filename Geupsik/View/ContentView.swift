//
//  ContentView.swift
//  Geupsik
//
//  Created by 박성헌 on 2019/12/15.
//  Copyright © 2019 n30gu1. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {
    @ObservedObject var viewModel = ContentViewModel()
    @State var showCalendar = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                List {
                    Picker("", selection: $viewModel.mealType) {
                        Text("Breakfast").tag(MealType.breakfast)
                        Text("Lunch").tag(MealType.lunch)
                        Text("Dinner").tag(MealType.dinner)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .listRowSeparator(.hidden)
                    .onChange(of: viewModel.mealType) { _ in
                        viewModel.fetch()
                    }
                    
                    if viewModel.mealList.count >= 5 {
                        ForEach(viewModel.mealList, id: \.date) { meal in
                            if viewModel.isNotiPhone {
                                NavigationLink(destination: MealDetailViewiPad(meal: meal)) {
                                    MealListCelliPad(meal: meal)
                                }
                                .listRowSeparator(.hidden)
                            } else {
                                MealListCell(meal: meal)
                                    .listRowSeparator(.hidden)
                            }
                        }
                    } else {
                        HStack {
                            Spacer()
                            ProgressView("Loading")
                                .progressViewStyle(CircularProgressViewStyle())
                            Spacer()
                        }
                        .listRowSeparator(.hidden)
                    }
                    
                    if !viewModel.isNotiPhone {
                        Rectangle()
                            .listRowSeparator(.hidden)
                            .foregroundColor(.clear)
                            .frame(height: 60)
                    }
                    
                }
                .listStyle(InsetListStyle())
                .refreshable {
                    viewModel.refresh()
                }
                .navigationBarTitle("Meals")
                .navigationBarItems(
                    leading: viewModel.isNotiPhone ? AnyView(showCalendarButton) : AnyView(EmptyView()),
                    trailing: Button(action: {
                        self.viewModel.showAllergyInfo.toggle()
                    }) {
                        Image(systemName: "info.circle")
                    }
                )
            }
            if !viewModel.isNotiPhone {
                DateSelBoxView(date: $viewModel.date)
                    .onChange(of: viewModel.date) { newDate in
                        viewModel.changeDate(newDate)
                    }
            }
        }
        .onAppear {
            viewModel.fetch()
        }
        .sheet(isPresented: $viewModel.showAllergyInfo) {
            AllergyInfoView()
        }
    }
    
    var calendarSelector: some View {
        DatePicker("", selection: $viewModel.date, displayedComponents: .date)
            .datePickerStyle(GraphicalDatePickerStyle())
            .labelsHidden()
            .onChange(of: viewModel.date) { newDate in
                viewModel.changeDate(newDate)
            }
    }
    
    var showCalendarButton: some View {
        Button(action: {
            withAnimation {
                self.showCalendar.toggle()
            }
        }) {
            Image(systemName: "calendar")
        }
        .popover(isPresented: $showCalendar, content: {
            calendarSelector
                .frame(minWidth: 400)
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .environment(\.locale, Locale(identifier: "ko"))
            ContentView()
                .environment(\.colorScheme, .dark)
                .previewDevice("iPhone SE (2nd generation)")
        }
    }
}
