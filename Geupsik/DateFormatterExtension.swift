//
//  DateFormatterExtension.swift
//  Geupsik
//
//  Created by 박성헌 on 2020/02/03.
//  Copyright © 2020 n30gu1. All rights reserved.
//

import Foundation

extension DateFormatter {
    func formatKR(date: Date) -> String {
        let formatter: DateFormatter = {
            let f = DateFormatter()
            f.locale = Locale(identifier: "ko_KR")
            f.timeStyle = .none
            f.dateStyle = .long
            return f
        }()
        
        return formatter.string(from: date)
    }
    
    func koreanLocale() -> DateFormatter {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ko_KR")
        f.dateStyle = .long
        f.timeStyle = .none
        return f
    }
    
    func koreanShortLocale() -> DateFormatter {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ko_KR")
        f.dateFormat = "M월 d일"
        return f
    }
    
    func barFormat() -> DateFormatter {
        let f: DateFormatter = {
            let form = DateFormatter()
            form.dateFormat = "yyyy-M-d"
            return form
        }()
        return f
    }
}
