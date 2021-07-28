//
//  ContentView.swift
//  Geupsik
//
//  Created by 박성헌 on 2019/12/15.
//  Copyright © 2019 n30gu1. All rights reserved.
//

import SwiftUI
import Combine
import SwiftUIRefresh

struct ContentView: View {
    @ObservedObject var viewModel = ContentViewModel()
    
    var body: some View {
        ZStack {
            NavigationView {
                List {
                    Picker("", selection: $viewModel.mealType) {
                        Text("Breakfast").tag(MealType.breakfast)
                        Text("Lunch").tag(MealType.lunch)
                        Text("Dinner").tag(MealType.dinner)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: viewModel.mealType) { _ in
                        viewModel.fetch()
                    }
                    if viewModel.mealList.count == 5 {
                        ForEach(viewModel.mealList, id: \.date) { meal in
                            if viewModel.isNotiPhone {
                                NavigationLink(destination: MealDetailViewiPad(meal: meal)) {
                                    MealListCelliPad(meal: meal)
                                }
                            } else {
                                MealListCell(meal: meal)
                            }
                        }
                    } else {
                        HStack {
                            Spacer()
                            ProgressView("Loading")
                                .progressViewStyle(.circular)
                            Spacer()
                        }
                    }
                    
                    if !viewModel.isNotiPhone {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(height: 60)
                    }
                }
                .introspectTableView { tableView in
                    tableView.separatorStyle = .none
                }
                .listStyle(InsetListStyle())
                .pullToRefresh(isShowing: $viewModel.isRefreshing) {
                    viewModel.refresh()
                }
                .navigationBarTitle("Meals")
                .navigationBarItems(leading: viewModel.isNotiPhone ? AnyView(calendarButton) : AnyView(EmptyView()))
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
    }
    
    var calendarButton: some View {
        DatePicker("", selection: $viewModel.date, displayedComponents: .date)
            .labelsHidden()
            .onChange(of: viewModel.date) { newDate in
                viewModel.changeDate(newDate)
                print("onchange")
            }
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
