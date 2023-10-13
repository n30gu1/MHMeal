//
//  MealGetter.swift
//  MealGetter
//
//  Created by Park Seongheon on 2021/07/29.
//  Copyright © 2021 n30gu1. All rights reserved.
//

import Foundation
import SwiftSoup
import Combine

class MealGetter: ObservableObject {
    var meals: [Meal] = []
    
    let mealType: [MealType] = {
        let zero = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
        let breakfast = Calendar.current.date(bySettingHour: 7, minute: 00, second: 00, of: Date())!
        let lunch = Calendar.current.date(bySettingHour: 13, minute: 00, second: 00, of: Date())!
        let dinner = Calendar.current.date(bySettingHour: 19, minute: 00, second: 00, of: Date())!
        
        switch Date() {
        case zero...breakfast:
            return [MealType.breakfast, MealType.lunch]
        case breakfast...lunch:
            return [MealType.lunch, MealType.dinner]
        case lunch...dinner:
            return [MealType.dinner, MealType.breakfast]
        default:
            return [MealType.breakfast, MealType.lunch]
        }
    }()
    
    let isNextDay: [Bool] = {
        let zero = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
        let lunch = Calendar.current.date(bySettingHour: 13, minute: 00, second: 00, of: Date())!
        let dinner = Calendar.current.date(bySettingHour: 19, minute: 00, second: 00, of: Date())!
        
        switch Date() {
        case zero...lunch:
            return [false, false]
        case lunch...dinner:
            return [false, true]
        default:
            return [true, true]
        }
    }()
    
    var cancellable: AnyCancellable? = nil
    
    private func fetch() {
        var noMealString: String?
        var errorString: String?
        
        switch Locale.current.language.languageCode?.identifier {
        case "ko":
            noMealString = "급식이 없습니다."
            errorString = "오류"
        default:
            noMealString = "No meal today."
            errorString = "Error"
        }
        
        func clean(_ text: String) -> [String] {
            let first = text.replacingOccurrences(of: "\n", with: "")
            return first.components(separatedBy: "<br>")
        }
        
        for i in 0...1 {
            var contents: String = ""
            
            let dFormatter: DateFormatter = {
                let f = DateFormatter()
                f.dateFormat = "yyyy/MM/dd"
                return f
            }()
            
            var mealList: [String] = []
            
            if let url = URL(string: "https://school.gyo6.net/muhakgo/food/\(dFormatter.string(from: isNextDay[i] ? Date().addingTimeInterval(86400) : Date()))/\(self.mealType[i].rawValue)") {
                do {
                    let getContents = try String(contentsOf: url)
                    contents = getContents
                } catch {
                    // contents could not be loaded
                    mealList = [errorString!]
                }
            } else {
                // Bad URL
                mealList = [errorString!]
            }
            
            do {
                let doc: Document = try SwiftSoup.parse(contents)
                
                guard let meal: Element = try doc.select("td > div").first() else {
                    mealList = [errorString!]
                    return
                }
                let mealText = try meal.html()
                let mealResult = clean(mealText)
                
                if mealResult.count == 1 && mealResult[0] == "" {
                    mealList = [noMealString!]
                } else {
                    mealList = mealResult
                }
            } catch Exception.Error(_, _) {
                return
            } catch {
                return
            }
            
            self.meals.append(Meal(meal: mealList))
        }
    }

    init() {
        fetch()
    }
}
