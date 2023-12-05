//
//  ContentViewModel.swift
//  ContentViewModel
//
//  Created by 박성헌 on 2021/07/28.
//  Copyright © 2021 n30gu1. All rights reserved.
//

import Foundation
import Combine
import UIKit

class ContentViewModel: ObservableObject {
    @Published var lastUpdated = Date()
    @Published var mealList: [Meal] = []
    @Published var mealType: MealType? = .lunch
    @Published var isNextDay: Bool = false
    
    @Published var didLoad = false
    
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        determineMealType()
        determineIsNextDay()
        fetch()
    }
    
    func determineMealType() {
        self.mealType = {
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
    }
    
    func determineIsNextDay() {
        self.isNextDay = {
            let zero = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
            let dinner = Calendar.current.date(bySettingHour: 19, minute: 00, second: 00, of: Date())!
            
            switch Date() {
            case zero...dinner:
                return false
            default:
                return true
            }
        }()
    }
    
    func fetch() {
        self.didLoad = false
        
        let date = {
            if isNextDay {
                return Date().addingTimeInterval(86400)
            } else {
                return Date()
            }
        }()
        
        let loader = NetManager()
        self.cancellable = Set<AnyCancellable>()
        
        // Fetcher
        let dateRange = date.range()
        let jsonDecoder = JSONDecoder()
        
        loader.fetch(from: dateRange.lowerBound, to: dateRange.upperBound).sink { _ in
            self.didLoad = true
        } receiveValue: { data in
            do {
                guard let data = data as? [String : Any] else { throw NSError() }
                guard let data = data["mealServiceDietInfo"] as? [Any] else { throw NSError() }
                guard let data = data[1] as? [String : Any] else { throw NSError() }
                let serialized = try JSONSerialization.data(withJSONObject: (data["row"] as! [[String : Any]]), options: .prettyPrinted)
                self.mealList = try jsonDecoder.decode([Meal].self, from: serialized)
            } catch {
#if DEBUG
                print(String(describing: error))
#endif
            }
        }.store(in: &cancellable)
    }
}
