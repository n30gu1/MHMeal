//
//  MealType.swift
//  MealType
//
//  Created by 박성헌 on 2021/07/28.
//  Copyright © 2021 n30gu1. All rights reserved.
//

import Foundation

enum MealType: String, Identifiable, CaseIterable {
    case breakfast = "breakfast"
    case lunch = "lunch"
    case dinner = "dinner"
    
    var id: String { self.rawValue }
}
