//
//  MealReorderable.swift
//  Geupsik
//
//  Created by 박성헌 on 2021/10/28.
//  Copyright © 2021 n30gu1. All rights reserved.
//

import Foundation

extension Meal: Reorderable {
    typealias OrderElement = Date
    var orderElement: OrderElement { date ?? Date() }
}
