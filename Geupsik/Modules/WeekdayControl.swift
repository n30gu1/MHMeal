//
//  WeekdayControl.swift
//  Geupsik
//
//  Created by 박성헌 on 2020/02/03.
//  Copyright © 2020 n30gu1. All rights reserved.
//

import Foundation

private func appendDates(date: Date, start: Int, end: Int) -> [Date] {
    var dateList: [Date] = []
    for i in start...end {
        dateList.append(date.addingTimeInterval(TimeInterval(86400*i)))
    }
    return dateList
}

private func rearrange<T>(array: Array<T>, fromIndex: Int, toIndex: Int) -> Array<T>{
    var arr = array
    let element = arr.remove(at: fromIndex)
    arr.insert(element, at: toIndex)

    return arr
}

extension Date {
    func autoWeekday() -> [Date] {
        switch Calendar.current.component(.weekday, from: self) {
        case 1: // Sunday
            return appendDates(date: self, start: 1, end: 6)
        case 2: // Monday
            return appendDates(date: self, start: 0, end: 5)
        case 3: // Tuesday
            let dateList: [Date] = appendDates(date: self, start: -1, end: 4)
            var result = rearrange(array: dateList, fromIndex: 1, toIndex: 0)
            result = rearrange(array: result, fromIndex: 1, toIndex: 5)
            return result
        case 4: // Wednesday
            let dateList: [Date] = appendDates(date: self, start: -2, end: 3)
            var result = rearrange(array: dateList, fromIndex: 2, toIndex: 0)
            
            for _ in 0..<2 {
                result = rearrange(array: result, fromIndex: 1, toIndex: 5)
            }
            return result
        case 5: // Thursday
            let dateList: [Date] = appendDates(date: self, start: -3, end: 2)
            var result = rearrange(array: dateList, fromIndex: 3, toIndex: 0)

            for _ in 0..<3 {
                result = rearrange(array: result, fromIndex: 1, toIndex: 5)
            }
            return result
        case 6: // Friday
            let dateList: [Date] = appendDates(date: self, start: -4, end: 1)
            let result = rearrange(array: dateList, fromIndex: 4, toIndex: 0)
            return result
        case 7: // Saturday
            var dateList: [Date] = appendDates(date: self, start: 0, end: 6)
            dateList.remove(at: 1)
            return dateList
        default:
            return [Date()]
        }
    }
    
    func rangeString() -> String {
        switch Calendar.current.component(.weekday, from: self) {
        case 1:
            let list = appendDates(date: self, start: 1, end: 5)
            return "\(list.first!.format()) ~ \(list.last!.formatShort())"
        case 2:
            let list = appendDates(date: self, start: 0, end: 4)
            return "\(list.first!.format()) ~ \(list.last!.formatShort())"
        case 3:
            let list = appendDates(date: self, start: -1, end: 3)
            return "\(list.first!.format()) ~ \(list.last!.formatShort())"
        case 4:
            let list = appendDates(date: self, start: -2, end: 2)
            return "\(list.first!.format()) ~ \(list.last!.formatShort())"
        case 5:
            let list = appendDates(date: self, start: -3, end: 1)
            return "\(list.first!.format()) ~ \(list.last!.formatShort())"
        case 6:
            let list = appendDates(date: self, start: -4, end: 0)
            return "\(list.first!.format()) ~ \(list.last!.formatShort())"
        case 7:
            let list = appendDates(date: self, start: 2, end: 6)
            return "\(list.first!.format()) ~ \(list.last!.formatShort())"
        default:
            return ""
        }
    }
    
    func range() -> ClosedRange<Date> {
        switch Calendar.current.component(.weekday, from: self) {
        case 1:
            let list = appendDates(date: self, start: 1, end: 6)
            return list.first!...list.last!
        case 2:
            let list = appendDates(date: self, start: 0, end: 5)
            return list.first!...list.last!
        case 3:
            let list = appendDates(date: self, start: -1, end: 4)
            return list.first!...list.last!
        case 4:
            let list = appendDates(date: self, start: -2, end: 3)
            return list.first!...list.last!
        case 5:
            let list = appendDates(date: self, start: -3, end: 2)
            return list.first!...list.last!
        case 6:
            let list = appendDates(date: self, start: -4, end: 1)
            return list.first!...list.last!
        case 7:
            let list = appendDates(date: self, start: 2, end: 7)
            return list.first!...list.last!
        default:
            return Date()...Date()
        }
    }
}
