//
//  NetManager.swift
//  NetManager
//
//  Created by 박성헌 on 2021/07/16.
//  Copyright © 2021 n30gu1. All rights reserved.
//

import Foundation
import Combine

final class NetManager {
    let mealType: MealType
    
    init(_ mealType: MealType) {
        self.mealType = mealType
    }
    func fetch(date: Date) -> AnyPublisher<String, URLError> {
        let dateFormatter: DateFormatter = {
            let f = DateFormatter()
            f.dateFormat = "yyyy/MM/dd"
            return f
        }()

        return URLSession.shared.dataTaskPublisher(for: URL(string: "https://school.gyo6.net/muhakgo/food/\(dateFormatter.string(from: date))/\(self.mealType.rawValue)")!)
            .receive(on: DispatchQueue.main)
            .map { String(data: $0.data, encoding: .utf8) ?? "nil" }
            .eraseToAnyPublisher()
    }
}
