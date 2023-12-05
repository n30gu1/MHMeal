//
//  ContentViewModel.swift
//  Geupsik
//
//  Created by 박성헌 on 2021/07/14.
//  Copyright © 2021 n30gu1. All rights reserved.
//

import Foundation
import Combine
import UIKit

class ContentViewModel: ObservableObject {
    @Published var date = Date()
    @Published var showCalendar = false
    @Published var mealList: [Meal] = []
    @Published var isNotiPhone = UIDevice.current.model != "iPhone"
    @Published var mealType = MealType.lunch
    @Published var showAllergyInfo = false
    
    @Published var didLoad = false
    
    private var cancellable = Set<AnyCancellable>()
    
    // Fetcher Function
    func fetch() {
        didLoad = false
        
        // Declare Network Loader and Reset Cancellable
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
    
    // Refresh Function
    func refresh() {
        self.fetch()
    }
    
    // Date Changer Function
    func changeDate(_ date: Date) {
        self.date = date
        self.fetch()
    }
    
    // Function to Control Date Selector Box
    func toggleShowCalendar() {
        self.showCalendar.toggle()
    }
}
