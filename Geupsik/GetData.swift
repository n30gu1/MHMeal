//
//  GetData.swift
//  Geupsik-UI
//
//  Created by 박성헌 on 2019/12/22.
//  Copyright © 2019 n30gu1. All rights reserved.
//
import Foundation

class Meal {
    let date: Date
    let imageLink: String?
    let meal: [String]
    let origins: [String]
    let kcal: String
    
    init(date: Date, imageLink: String?, meal: [String], origins: [String], kcal: String) {
        self.date = date
        self.imageLink = imageLink
        self.meal = meal
        self.origins = origins
        self.kcal = kcal
    }
    
    init(date: Date, meal: [String], origins: [String], kcal: String) {
        self.date = date
        self.imageLink = nil
        self.meal = meal
        self.origins = origins
        self.kcal = kcal
    }
}

extension Meal: Hashable {
    static func == (lhs: Meal, rhs: Meal) -> Bool {
        return lhs.date == rhs.date && lhs.imageLink == rhs.imageLink && lhs.meal == rhs.meal && lhs.origins == rhs.origins && lhs.kcal == rhs.kcal
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(date)
        hasher.combine(imageLink)
        hasher.combine(meal)
        hasher.combine(origins)
        hasher.combine(kcal)
    }
}

extension Meal: Reorderable {
    typealias OrderElement = Date
    var orderElement: OrderElement { date }
}

enum MealType: String, Identifiable, CaseIterable {
    case breakfast = "breakfast"
    case lunch = "lunch"
    case dinner = "dinner"
    
    var id: String { self.rawValue }
}

//class GetData {
//    @Published var dataIsLoaded: Bool = false
//    @Published var image: UIImage? = nil
//    @Published var meal: String? = nil
//    @Published var kcal: String? = nil
//    @Published var imageLink: String? = nil
//    @Published var mealIsLoaded: Bool = false
//    @Published var imageExists: Bool = false
//    var date: Date = Date()
//
//    func loadImage(url: String) {
//        let url = URL(string: url)!
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//
//        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
//            guard error == nil else {
//                print ("error: \(error!)")
//                return
//            }
//
//            guard let content = data else {
//                print("No data")
//                return
//            }
//
//
//            DispatchQueue.main.async {
//                self.image = UIImage(data: content)
//                self.dataIsLoaded = true
//            }
//            print("Data loaded")
//
//        }
//        task.resume()
//    }
//
//    func clean(text: String) -> [String] { return text.components(separatedBy: " ") }
//
//    func cleanKcal(text: String) -> String { return text.replacingOccurrences(of: "Kcal", with: "") }
//
//    func cleanImgLink(text: String) -> String {
//        let first = text.replacingOccurrences(of: "<img src=\"", with: "")
//        let second = first.replacingOccurrences(of: "\" title=\"이미지\" style=\"width:300px; height:170px;\">", with: "")
//        let final = "https://school.gyo6.net\(second)"
//        return final
//    }
//
//    func getData(date: Date, image: Bool) {
//        let locale = Locale.current.languageCode
//        let isLcKr = locale == "ko" ? true : false
//        let noInternetConnection = isLcKr ? "인터넷 연결이 없습니다." : "No internet connection."
//        let error = isLcKr ? "오류" : "Error"
//        let noMeal = isLcKr ? "급식이 없습니다." : "No meal today."
//
//        var contents: String = ""
//        let dFormatter: DateFormatter = {
//            let f = DateFormatter()
//            f.dateFormat = "yyyy/MM/dd"
//            return f
//        }()
//
//        DispatchQueue.global(qos: .background).async {
//            if let url = URL(string: "https://school.gyo6.net/mu-hak/food/\(dFormatter.string(from: date))/lunch") {
//                //declare data task
//                var task: URLSessionDataTask?
//
//                //setup the session
//                let conf = URLSessionConfiguration.default
//                let session = URLSession(configuration: conf)
//
//                task = session.dataTask(with: url){ (data, res, error) -> Void in
//                        if let e = error {
//                            print("dataTaskWithURL fail: \(e.localizedDescription)")
//                            return
//                        }
//                        if let d = data {
//                            contents = String(data: d, encoding: .utf8) ?? noInternetConnection
//                            do {
//                                let doc: Document = try SwiftSoup.parse(contents)
//
//                                if image {
//                                    if self.imageExists {
//                                        self.loadImage(url: self.imageLink!)
//                                    }
//                                } else {
//                                    let meal: Element? = try doc.select("td > div").first()
//                                    if let unwpd = meal {
//                                        let mealText = try unwpd.text()
//                                        let mealResult = self.clean(text: mealText)
//
//                                        DispatchQueue.main.async {
//                                            if mealResult.count == 1 && mealResult[0] == "" {
//                                                self.meal = noMeal
//                                            } else {
//                                                self.meal = mealResult.joined(separator: "\n")
//                                            }
//                                        }
//
//                                        let kcal: Element = try doc.select("tr > td")[1]
//                                        let kcalText = try kcal.text()
//                                        let kcalResult = self.cleanKcal(text: kcalText)
//
//                                        DispatchQueue.main.async {
//                                            if kcalResult == "" {
//                                                self.kcal = "???"
//                                            } else {
//                                                self.kcal = kcalResult
//                                            }
//                                        }
//
//                                    } else {
//                                        DispatchQueue.main.async {
//                                            self.meal = noMeal
//                                            self.kcal = "???"
//                                        }
//                                    }
//
//                                    let image: Element? = try doc.select("img[src]").first()
//                                    if let imageUnwpd = image {
//                                        let imageRaw = "\(imageUnwpd)"
//                                        DispatchQueue.main.async {
//                                            self.imageLink = self.cleanImgLink(text: imageRaw)
//                                            self.imageExists = true
//                                        }
//                                    }
//                                }
//                            } catch Exception.Error(_, _) {
//                                return
//                            } catch {
//                                return
//                            }
//
//                            DispatchQueue.main.async {
//                                self.mealIsLoaded = true
//                            }
//                        }
//                    }
//                    task!.resume()
//            } else {
//                // the URL was bad!
//                self.meal = error
//            }
//        }
//    }
//}


