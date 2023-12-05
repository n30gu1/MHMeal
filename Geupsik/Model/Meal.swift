//
//  Meal.swift
//  Meal
//
//  Created by 박성헌 on 2021/07/28.
//  Copyright © 2021 n30gu1. All rights reserved.
//

import Foundation

class Meal: Decodable {
    let MLSV_YMD: Date?         // Date of the meal
    let DDISH_NM: [String]      // Array of meal served
    let ORPLC_INFO: [String]?   // Origins of ingredients in a meal
    let NTR_INFO: [String]?     // Amount of nutrients
    let CAL_INFO: String        // Calories of the meal
    let MMEAL_SC_CODE: MealType // Type of the meal
    
    init(date: Date? = nil, meal: [String], origins: [String]? = nil, kcal: String? = nil) {
        self.MLSV_YMD = date
        self.DDISH_NM = meal
        self.ORPLC_INFO = origins
        self.CAL_INFO = kcal ?? "???"
        self.NTR_INFO = nil
        self.MMEAL_SC_CODE = .lunch
    }
    
    enum CodingKeys: CodingKey {
        case MLSV_YMD
        case DDISH_NM
        case ORPLC_INFO
        case NTR_INFO
        case CAL_INFO
        case MMEAL_SC_CODE
    }
    
    required init(from decoder: Decoder) throws {
        let dateFormatter = {
            let f = DateFormatter()
            f.dateFormat = "yyyyMMdd"
            return f
        }()
        
        let noMeal = {
            switch Locale.current.language.languageCode?.identifier {
            case "ko":
                return "급식이 없습니다."
            default:
                return "No meal today."
            }
        }()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.MLSV_YMD = dateFormatter.date(from: try container.decodeIfPresent(String.self, forKey: .MLSV_YMD) ?? "")
        self.DDISH_NM = try {
            let str = try container.decodeIfPresent(String.self, forKey: .DDISH_NM)
            return str?.components(separatedBy: "<br/>") ?? [noMeal]
        }()
        self.ORPLC_INFO = try {
            let str = try container.decodeIfPresent(String.self, forKey: .ORPLC_INFO)
            return str?.components(separatedBy: "<br/>")
        }()
        self.NTR_INFO = try {
            let str = try container.decodeIfPresent(String.self, forKey: .NTR_INFO)
            return str?.components(separatedBy: "<br/>")
        }()
        
        self.CAL_INFO = try {
            if let calories = try container.decodeIfPresent(String.self, forKey: .CAL_INFO) {
                return calories.replacingOccurrences(of: " Kcal", with: "")
            } else {
                return "???"
            }
        }()
        
        self.MMEAL_SC_CODE = try {
            switch try container.decodeIfPresent(String.self, forKey: .MMEAL_SC_CODE) {
            case "1":
                return MealType.breakfast
            case "2":
                return MealType.lunch
            case "3":
                return MealType.dinner
            default:
                return MealType.lunch
            }
        }()
    }
}

extension Meal: Hashable {
    static func == (lhs: Meal, rhs: Meal) -> Bool {
        return lhs.MLSV_YMD == rhs.MLSV_YMD && lhs.DDISH_NM == rhs.DDISH_NM && lhs.ORPLC_INFO == rhs.ORPLC_INFO && lhs.CAL_INFO == rhs.CAL_INFO && lhs.NTR_INFO == rhs.NTR_INFO && lhs.MMEAL_SC_CODE == rhs.MMEAL_SC_CODE
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(MLSV_YMD)
        hasher.combine(DDISH_NM)
        hasher.combine(ORPLC_INFO)
        hasher.combine(CAL_INFO)
        hasher.combine(NTR_INFO)
        hasher.combine(MMEAL_SC_CODE)
    }
}
