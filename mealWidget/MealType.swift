//
//  MealType.swift
//  Geupsik
//
//  Created by 박성헌 on 6/7/23.
//  Copyright © 2023 n30gu1. All rights reserved.
//

import Foundation

enum MealType: String, Identifiable, CaseIterable {
    case breakfast = "breakfast"
    case lunch = "lunch"
    case dinner = "dinner"
    case nextDayBreakfast
    
    var id: String {
        if self != .nextDayBreakfast {
            return self.rawValue
        } else {
            return "breakfast"
        }
    }
    var localizedString: String {
        switch self {
        case .breakfast:
            return NSLocalizedString("Breakfast", comment: "Breakfast")
        case .lunch:
            return NSLocalizedString("Lunch", comment: "Lunch")
        case .dinner:
            return NSLocalizedString("Dinner", comment: "Dinner")
        case .nextDayBreakfast:
            return NSLocalizedString("Breakfast", comment: "Breakfast")
        }
    }
}
