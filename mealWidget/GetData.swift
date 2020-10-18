//
//  GetData.swift
//  Geupsik
//
//  Created by 박성헌 on 2020/10/17.
//  Copyright © 2020 n30gu1. All rights reserved.
//

import Foundation
import SwiftSoup

class GetData {
    var meal: String? = nil
    
    init(date: Date) {
        getData(date: date)
    }
    
    private func clean(text: String) -> [String] { return text.components(separatedBy: " ") }

    private func cleanKcal(text: String) -> String { return text.replacingOccurrences(of: "Kcal", with: "") }

    private func getData(date: Date) {
        var contents: String = ""
        let dFormatter: DateFormatter = {
            let f = DateFormatter()
            f.dateFormat = "yyyy/MM/dd"
            return f
        }()
        if let url = URL(string: "https://school.gyo6.net/mu-hak/food/\(dFormatter.string(from: date))/lunch") {
            do {
                let getContents = try String(contentsOf: url)
                contents = getContents
            } catch {
                // contents could not be loaded
                self.meal = "인터넷 연결이 없습니다."
            }
        } else {
            // the URL was bad!
            self.meal = "오류"
        }
        
        do {
            let doc: Document = try SwiftSoup.parse(contents)
            
            guard let meal: Element = try doc.select("td > div").first() else {
                self.meal = "오류"
                return
            }
            let mealText = try meal.text()
            let mealResult = self.clean(text: mealText)
            
            if mealResult.count == 1 && mealResult[0] == "" {
                self.meal = "급식이 없습니다."
            } else {
                self.meal = mealResult.joined(separator: "\n")
            }
        } catch Exception.Error(_, _) {
            return
        } catch {
            return
        }
    }
}
