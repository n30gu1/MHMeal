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
    @Published var showAllergyInfo = false
    
    private var cancellable = Set<AnyCancellable>()
    
    // Fetcher Function
    func fetch() {
        if mealType == .breakfast {
            self.dateList = date.autoWeekdayInBreakfast()
        } else {
            self.dateList = date.autoWeekday()
        }
        // Reset Meal List and Declare Temporary List
        self.mealList = []
        var tempMealList: [Meal] = []
        
        // Declare Network Loader and Reset Cancellable
        let loader = NetManager(self.mealType)
        self.cancellable = Set<AnyCancellable>()
        
        // Declare "No Meal" and "Error" and Set by Locale
        var noMealString: String?
        var errorString: String?
        
        switch Locale.current.languageCode {
        case "ko":
            noMealString = "급식이 없습니다."
            errorString = "오류"
        default:
            noMealString = "No meal today."
            errorString = "Error"
        }
        
        // HTML Cleaning Functions
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
        
        // Parser
        for date in self.dateList {
            loader.fetch(date: date).sink(receiveCompletion: { _ in
                // Reorder by Date List
                if self.mealType == .breakfast {
                    if tempMealList.count == 6 {
//                        print(tempMealList.map {
//                            $0.date
//                        })
                        self.mealList = tempMealList.reorder(by: self.dateList)
                    }
                } else {
                    if tempMealList.count == 5 {
                        self.mealList = tempMealList.reorder(by: self.dateList)
                    }
                }
            }, receiveValue: { data in
                do {
                    let document: Document = try SwiftSoup.parse(data)
                    
                    let meal: [String] = try {
                        let mealOptional: Element? = try document.select("td > div").first()
                        guard let mealElement = mealOptional else { return [errorString!] }
                        let mealRawText = try mealElement.html()
                        var meal = clean(mealRawText)
                        if meal.count == 1 && meal[0] == "" {
                            meal = [noMealString!]
                        }
                        return meal
                    }()
                    
                    let origins: [String] = try {
                        let originsOptional: Element? = try document.select("td > div")[1]
                        guard let originsElement = originsOptional else { return [errorString!] }
                        let originsRawText = try originsElement.html()
                        let origins = clean(originsRawText)
                        
                        return origins
                    }()
                    
                    let kcal: String = try {
                        let kcalOptional: Element? = try document.select("tr > td")[1]
                        guard let kcalElement = kcalOptional else { return errorString! }
                        let kcalRawText = try kcalElement.text()
                        var kcal = cleanKcal(text: kcalRawText)
                        if kcal == "" {
                            kcal = "???"
                        }
                        return kcal
                    }()
                    
                    let imageLink: String? = try {
                        let imageOptional: Element? = try document.select("img[src]").first()
                        if let imageElement = imageOptional {
                            let imageLink = "\(imageElement)"
                            return cleanImgLink(text: imageLink)
                        } else { return nil }
                    }()
                    
                    // Add to Meal List
                    tempMealList.append(Meal(date: date, imageLink: imageLink, meal: meal, origins: origins, kcal: kcal))
                } catch {
                    print(error.localizedDescription)
                }
            }).store(in: &cancellable)
        }
        
    }
    
    // Refresh Function
    func refresh() {
        self.fetch()
        self.isRefreshing = false
    }
    
    // Date Changer Function
    func changeDate(_ date: Date) {
        self.date = date
        self.dateList = date.autoWeekday()
        self.fetch()
    }
    
    // Function to Control Date Selector Box
    func toggleShowCalendar() {
        self.showCalendar.toggle()
    }
}
