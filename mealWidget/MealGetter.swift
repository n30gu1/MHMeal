//
//  MealGetter.swift
//  MealGetter
//
//  Created by Park Seongheon on 2021/07/29.
//  Copyright © 2021 n30gu1. All rights reserved.
//

import Foundation
import Combine
import WidgetKit

func fetchMeal(mealType: [MealType], isNextDay: [Bool]) async -> [Meal] {
    var meals: [Meal] = []
    
    // Fetcher
    let jsonDecoder = JSONDecoder()
    
    for i in 0...1 {
        let dFormatter: DateFormatter = {
            let f = DateFormatter()
            f.dateFormat = "yyyyMMdd"
            return f
        }()
        
        let mealCode = {
            switch mealType[i] {
            case .breakfast:
                return "1"
            case .lunch:
                return "2"
            case .dinner:
                return "3"
            default:
                return "2"
            }
        }()
        
        if let url = URL(
            string: "https://open.neis.go.kr/hub/mealServiceDietInfo?KEY=0c78f44ac03648f49ce553a199fc0389&Type=json&ATPT_OFCDC_SC_CODE=R10&SD_SCHUL_CODE=8750594&MLSV_YMD=\(dFormatter.string(from: isNextDay[i] ? Date().addingTimeInterval(86400) : Date()))&MMEAL_SC_CODE=\(mealCode)") {
            do {
                let data = try await URLSession.shared.data(from: url).0
                guard let data = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else { throw NSError() }
                guard let data = data["mealServiceDietInfo"] as? [Any] else { throw NSError() }
                guard let data = data[1] as? [String : Any] else { throw NSError() }
                let serialized = try JSONSerialization.data(withJSONObject: (data["row"] as! [[String : Any]]), options: .prettyPrinted)
                let meal = try jsonDecoder.decode([Meal].self, from: serialized)
                if let meal = meal.first {
                    meals.append(meal)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    return meals
}
