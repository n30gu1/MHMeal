//
//  WeekdayControl.swift
//  Geupsik
//
//  Created by 박성헌 on 2020/02/03.
//  Copyright © 2020 n30gu1. All rights reserved.
//

import Foundation

extension Date {
    func autoWeekday(date: Date) -> [Date] {
        switch Calendar.current.component(.weekday, from: date) {
        case 1:
            var dateList: [Date] = []
            for i in 1...5 {
                dateList.append(date.addingTimeInterval(TimeInterval(86400*i)))
            }
            return dateList
        case 2:
            var dateList: [Date] = []
            for i in 0...4 {
                dateList.append(date.addingTimeInterval(TimeInterval(86400*i)))
            }
            return dateList
        case 3:
            var dateList: [Date] = []
            for i in -1...3 {
                dateList.append(date.addingTimeInterval(TimeInterval(86400*i)))
            }
            let result = rearrange(array: dateList, fromIndex: 1, toIndex: 0)
            return result
        case 4:
            var dateList: [Date] = []
            for i in -2...2 {
                dateList.append(date.addingTimeInterval(TimeInterval(86400*i)))
            }
            let result = rearrange(array: dateList, fromIndex: 2, toIndex: 0)
            return result
        case 5:
            var dateList: [Date] = []
            for i in -3...1 {
                dateList.append(date.addingTimeInterval(TimeInterval(86400*i)))
            }
            let result = rearrange(array: dateList, fromIndex: 3, toIndex: 0)
            return result
        case 6:
            var dateList: [Date] = []
            for i in -4...0 {
                dateList.append(date.addingTimeInterval(TimeInterval(86400*i)))
            }
            let result = rearrange(array: dateList, fromIndex: 4, toIndex: 0)
            return result
        case 7:
            var dateList: [Date] = []
            for i in 2...6 {
                dateList.append(date.addingTimeInterval(TimeInterval(86400*i)))
            }
            return dateList
        default:
            return [Date()]
        }
    }

}

func rearrange<T>(array: Array<T>, fromIndex: Int, toIndex: Int) -> Array<T>{
    var arr = array
    let element = arr.remove(at: fromIndex)
    arr.insert(element, at: toIndex)

    return arr
}
