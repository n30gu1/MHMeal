//
//  GetData.swift
//  Geupsik-UI
//
//  Created by 박성헌 on 2019/12/22.
//  Copyright © 2019 n30gu1. All rights reserved.
//

import Foundation
import UIKit
import SwiftSoup
import Combine

class GetData: ObservableObject {
    @Published var dataIsLoaded: Bool = false
    @Published var image: UIImage? = nil
    @Published var meal: String? = nil
    @Published var kcal: String? = nil
    @Published var mealIsLoaded: Bool = false
    var date: Date = Date()
    
    func loadImage(url: String) {
        let url = URL(string: url)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard error == nil else {
                print ("error: \(error!)")
                return
            }
            
            guard let content = data else {
                print("No data")
                return
            }
            
                                                              
            DispatchQueue.main.async {
                self.image = UIImage(data: content)
                self.dataIsLoaded = true
            }
            print("Data loaded")
            
        }
        task.resume()
    }
    
    func clean(text: String) -> [String] { return text.components(separatedBy: " ") }

    func cleanKcal(text: String) -> String { return text.replacingOccurrences(of: "Kcal", with: "") }

    func cleanImgLink(text: String) -> String {
        let first = text.replacingOccurrences(of: "<img src=\"", with: "")
        let second = first.replacingOccurrences(of: "\" title=\"이미지\" style=\"width:300px; height:170px;\">", with: "")
        let final = "https://school.gyo6.net\(second)"
        return final
    }

    func getData(date: Date) {
        var contents: String = ""
        let dFormatter: DateFormatter = {
            let f = DateFormatter()
            f.dateFormat = "yyyy/MM/dd"
            return f
        }()
        
        DispatchQueue.main.async {
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
                
                let meal: Element = try doc.select("td > div").first()!
                let mealText = try meal.text()
                let mealResult = self.clean(text: mealText)
                
                if mealResult.count == 1 && mealResult[0] == "" {
                    self.meal = "급식이 없습니다."
                } else {
                    self.meal = mealResult.joined(separator: "\n")
                }
                
                let kcal: Element = try doc.select("tr > td")[1]
                let kcalText = try kcal.text()
                let kcalResult = self.cleanKcal(text: kcalText)
                
                if kcalResult == "" {
                    self.kcal = "???"
                } else {
                    self.kcal = kcalResult
                }
                
                let image: Element? = try doc.select("img[src]").first()
                if let imageUnwpd = image {
                    let imageString = "\(imageUnwpd)"
                    self.loadImage(url: self.cleanImgLink(text: imageString))
                }
                
            } catch Exception.Error(_, _) {
                return
            } catch {
                return
            }
            self.mealIsLoaded = true
        }
    }
}
