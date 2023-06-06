//
//  DateExtensions.swift
//  MHGeupsik
//
//  Created by 박성헌 on 2020/02/26.
//  Copyright © 2020 n30gu1. All rights reserved.
//

import Foundation

extension Date {
    func format() -> String {
        let locale = Locale.current.language.languageCode!.identifier
        
        let f: DateFormatter = DateFormatter()
        if locale == "ko" {
            f.dateFormat = "yyyy년 M월 d일"
        } else {
            f.dateFormat = "MMM. d yyyy"
        }
        
        return f.string(from: self)
    }
    
    func formatShort() -> String {
        let locale = Locale.current.language.languageCode!.identifier
        
        let f: DateFormatter = DateFormatter()
        if locale == "ko" {
            f.dateFormat = "M월 d일"
        } else {
            f.dateFormat = "MMM. d"
        }
        
        return f.string(from: self)
    }
}
