//
//  Meal.swift
//  Meal
//
//  Created by 박성헌 on 2021/07/28.
//  Copyright © 2021 n30gu1. All rights reserved.
//

import Foundation

class Meal {
    let date: Date?
    let imageLink: String?
    let meal: [String]
    let origins: [String]?
    let kcal: String?
    
    init(date: Date, imageLink: String?, meal: [String], origins: [String], kcal: String) {
        self.date = date
        self.imageLink = imageLink
        self.meal = meal
        self.origins = origins
        self.kcal = kcal
    }
    
    init(date: Date, meal: [String], origins: [String], kcal: String) {
        self.date = date
        self.imageLink = nil
        self.meal = meal
        self.origins = origins
        self.kcal = kcal
    }
    
    init(meal: [String]) {
        self.date = nil
        self.meal = meal
        self.imageLink = nil
        self.origins = nil
        self.kcal = nil
    }
}

extension Meal: Hashable {
    static func == (lhs: Meal, rhs: Meal) -> Bool {
        return lhs.date == rhs.date && lhs.imageLink == rhs.imageLink && lhs.meal == rhs.meal && lhs.origins == rhs.origins && lhs.kcal == rhs.kcal
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(date)
        hasher.combine(imageLink)
        hasher.combine(meal)
        hasher.combine(origins)
        hasher.combine(kcal)
    }
}
