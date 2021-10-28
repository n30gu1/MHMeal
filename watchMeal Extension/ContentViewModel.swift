//
//  ContentViewModel.swift
//  ContentViewModel
//
//  Created by 박성헌 on 2021/07/28.
//  Copyright © 2021 n30gu1. All rights reserved.
//

import Foundation
import Combine
import SwiftSoup
import UIKit

class ContentViewModel: ObservableObject {
    @Published var mealList: [Meal] = []
    
    let mealType: MealType = {
        let zero = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
        let breakfast = Calendar.current.date(bySettingHour: 7, minute: 00, second: 00, of: Date())!
        let lunch = Calendar.current.date(bySettingHour: 13, minute: 00, second: 00, of: Date())!
        let dinner = Calendar.current.date(bySettingHour: 19, minute: 00, second: 00, of: Date())!
        
        switch Date() {
        case zero...breakfast:
            return MealType.breakfast
        case breakfast...lunch:
            return MealType.lunch
        case lunch...dinner:
            return MealType.dinner
        default:
            return MealType.breakfast
        }
    }()
    
    let isNextDay: Bool = {
        let zero = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
        let dinner = Calendar.current.date(bySettingHour: 19, minute: 00, second: 00, of: Date())!
        
        switch Date() {
        case zero...dinner:
            return false
        default:
            return true
        }
    }()
    
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        fetch()
    }
    
    func fetch() {
        let dateList: [Date] = {
            if isNextDay {
                if mealType == .breakfast {
                    return Date().addingTimeInterval(86400).autoWeekdayInBreakfast()
                }
                return Date().addingTimeInterval(86400).autoWeekday()
            } else {
                return Date().autoWeekday()
            }
        }()
        
        self.mealList = []
        var tempMealList: [Meal] = []
        
        let loader = NetManager(self.mealType)
        self.cancellable = Set<AnyCancellable>()
        
        func clean(_ text: String) -> [String] {
            let first = text.replacingOccurrences(of: "\n", with: "")
            return first.components(separatedBy: "<br>")
        }
        
        func cleanKcal(text: String) -> String { return text.replacingOccurrences(of: "Kcal", with: "") }
        
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
        
        for date in dateList {
            loader.fetch(date: date).sink(receiveCompletion: { _ in
                if tempMealList.count == 5 {
                    self.mealList = tempMealList.reorder(by: dateList)
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
                    
                    tempMealList.append(Meal(date: date, meal: meal, origins: [], kcal: kcal))
                } catch {
                    print(error.localizedDescription)
                }
            }).store(in: &cancellable)
        }
    }
}
