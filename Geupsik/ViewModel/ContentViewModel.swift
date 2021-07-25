//
//  ContentViewModel.swift
//  Geupsik
//
//  Created by 박성헌 on 2021/07/14.
//  Copyright © 2021 n30gu1. All rights reserved.
//

import Foundation
import Combine
import SwiftSoup
import UIKit

class ContentViewModel: ObservableObject {
    @Published var date = Date()
    @Published var showCalendar = false
    @Published var isRefreshing = false
    @Published var dateList = Date().autoWeekday()
    @Published var mealList: [Meal] = []
    @Published var isNotiPhone = UIDevice.current.model != "iPhone"
    @Published var mealType = MealType.lunch
    
    var cancellable = Set<AnyCancellable>()
    
    func fetch() {
        self.mealList = []
        var tempMealList: [Meal] = []
        
        let loader = NetManager(self.mealType)
        self.cancellable = Set<AnyCancellable>()
        
        func clean(_ text: String) -> [String] {
            let first = text.replacingOccurrences(of: "\n", with: "")
            return first.components(separatedBy: "<br>")
        }
    
        func cleanKcal(text: String) -> String { return text.replacingOccurrences(of: "Kcal", with: "") }
    
        func cleanImgLink(text: String) -> String {
            let first = text.replacingOccurrences(of: "<img src=\"", with: "")
            let second = first.replacingOccurrences(of: "\" title=\"이미지\" style=\"width:300px; height:170px;\">", with: "")
            let final = "https://school.gyo6.net\(second)"
            return final
        }
        
        for date in self.dateList {
            print("fetching \(date)")
            loader.fetch(date: date).sink(receiveCompletion: { _ in
                if tempMealList.count == 5 {
                    self.mealList = tempMealList.reorder(by: self.dateList)
                    print(self.mealList.map { $0.date })
                }
            }, receiveValue: { data in
                do {
                    let document: Document = try SwiftSoup.parse(data)
                    
                    let meal: [String] = try {
                        let mealOptional: Element? = try document.select("td > div").first()
                        guard let mealElement = mealOptional else { return ["Error"] }
                        let mealRawText = try mealElement.html()
                        var meal = clean(mealRawText)
                        if meal.count == 1 && meal[0] == "" {
                            meal = ["No meal today."]
                        }
                        return meal
                    }()
                    
                    let origins: [String] = try {
                        let originsOptional: Element? = try document.select("td > div")[1]
                        guard let originsElement = originsOptional else { return ["Error"] }
                        let originsRawText = try originsElement.html()
                        let origins = clean(originsRawText)
                        
                        return origins
                    }()
                    
                    let kcal: String = try {
                        let kcalOptional: Element? = try document.select("tr > td")[1]
                        guard let kcalElement = kcalOptional else { return "Error" }
                        let kcalRawText = try kcalElement.text()
                        let kcal = cleanKcal(text: kcalRawText)
                        return kcal
                    }()
                    
                    tempMealList.append(Meal(date: date, imageLink: nil, meal: meal, origins: origins, kcal: kcal))
                    print(tempMealList)
                } catch {
                    print(error.localizedDescription)
                }
            }).store(in: &cancellable)
        }
        
        print("refreshed")
    }
    
    func refresh() {
        self.fetch()
        self.isRefreshing = false
    }
    
    func changeDate(_ date: Date) {
        self.date = date
        self.dateList = date.autoWeekday()
        self.fetch()
    }
    
    func toggleShowCalendar() {
        self.showCalendar.toggle()
    }
}
