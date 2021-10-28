//
//  mealWidget.swift
//  mealWidget
//
//  Created by 박성헌 on 2020/10/17.
//  Copyright © 2020 n30gu1. All rights reserved.
//

import WidgetKit
import SwiftUI
import Combine
import SwiftSoup

// Getter

class MealGetter: ObservableObject {
    var meals: [Meal] = []
    
    let mealType: [MealType] = {
        let zero = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
        let breakfast = Calendar.current.date(bySettingHour: 7, minute: 00, second: 00, of: Date())!
        let lunch = Calendar.current.date(bySettingHour: 13, minute: 00, second: 00, of: Date())!
        let dinner = Calendar.current.date(bySettingHour: 19, minute: 00, second: 00, of: Date())!
        
        switch Date() {
        case zero...breakfast:
            return [MealType.breakfast, MealType.lunch]
        case breakfast...lunch:
            return [MealType.lunch, MealType.dinner]
        case lunch...dinner:
            return [MealType.dinner, MealType.breakfast]
        default:
            return [MealType.breakfast, MealType.lunch]
        }
    }()
    
    let isNextDay: Bool = {
        let zero = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
        let dinner = Calendar.current.date(bySettingHour: 19, minute: 00, second: 00, of: Date())!
        
        switch Date() {
        case zero...dinner:
            return false
        default:
            return true
        }
    }()
    
    var cancellable: AnyCancellable? = nil
    
    private func fetch() {
        var noMealString: String?
        var errorString: String?
        
        switch Locale.current.languageCode {
        case "ko":
            noMealString = "급식이 없습니다."
            errorString = "오류"
        default:
            noMealString = "No meal today."
            errorString = "Error"
        }
        
        func clean(_ text: String) -> [String] {
            let first = text.replacingOccurrences(of: "\n", with: "")
            return first.components(separatedBy: "<br>")
        }
        
        for i in 0...1 {
            var contents: String = ""
            
            let dFormatter: DateFormatter = {
                let f = DateFormatter()
                f.dateFormat = "yyyy/MM/dd"
                return f
            }()
            
            var mealList: [String] = []
            
            if let url = URL(string: "https://school.gyo6.net/muhakgo/food/\(dFormatter.string(from: isNextDay ? Date().addingTimeInterval(86400) : Date()))/\(self.mealType[i].rawValue)") {
                do {
                    let getContents = try String(contentsOf: url)
                    contents = getContents
                } catch {
                    // contents could not be loaded
                    mealList = [errorString!]
                }
            } else {
                // Bad URL
                mealList = [errorString!]
            }
            
            do {
                let doc: Document = try SwiftSoup.parse(contents)
                
                guard let meal: Element = try doc.select("td > div").first() else {
                    mealList = [errorString!]
                    return
                }
                let mealText = try meal.html()
                let mealResult = clean(mealText)
                
                if mealResult.count == 1 && mealResult[0] == "" {
                    mealList = [noMealString!]
                } else {
                    mealList = mealResult
                }
            } catch Exception.Error(_, _) {
                return
            } catch {
                return
            }
            
            self.meals.append(Meal(meal: mealList))
        }
    }

    init() {
        fetch()
    }
}

// Timeline Provider

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> MealEntry {
        MealEntry(
            date: Date(),
            meal: [
                Meal(meal: ["친환경차수수밥", "순댓국", "돈육고추장불고기", "상추겉절이", "메기순살강정", "배추김치"]),
                Meal(meal: ["친환경차수수밥", "순댓국", "돈육고추장불고기", "상추겉절이", "메기순살강정", "배추김치"])
            ],
            mealType: [MealType.lunch, MealType.breakfast]
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (MealEntry) -> ()) {
        let entry = MealEntry(
            date: Date(),
            meal: [
                Meal(meal: ["친환경차수수밥", "순댓국", "돈육고추장불고기", "상추겉절이", "메기순살강정", "배추김치"]),
                Meal(meal: ["친환경차수수밥", "순댓국", "돈육고추장불고기", "상추겉절이", "메기순살강정", "배추김치"])
            ],
            mealType: [MealType.lunch, MealType.breakfast]
        )
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [MealEntry] = []
        
        let getter = MealGetter()
        
        var date = Date()
        
        if getter.isNextDay {
            date = date.addingTimeInterval(86400)
        }
            
        let entry = MealEntry(date: date, meal: getter.meals, mealType: getter.mealType)
        entries.append(entry)

        let timeline = Timeline(entries: entries, policy: .after(Date().addingTimeInterval(3600)))
        completion(timeline)
    }
}

// Entry

struct MealEntry: TimelineEntry {
    var date: Date
    let meal: [Meal]
    let mealType: [MealType]
}

// Entry View

struct mealWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var widgetFamily

    var body: some View {
        if widgetFamily == .systemSmall {
            SystemSmallWidgetView(entry: entry)
        } else if widgetFamily == .systemMedium {
            SystemMediumWidgetView(entry: entry)
        } else {
            Text("error")
        }
    }
}

struct SystemSmallWidgetView : View {
    var entry: Provider.Entry
    
    var body: some View {
        ZStack {
            VStack {
                Rectangle()
                    .frame(height: 74)
                    .foregroundColor(Color("BoxColor"))
                    .shadow(radius: 2)
                Spacer()
            }
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 4) {
                    Text(entry.date.formatShort())
                        .fontWeight(.light)
                    Spacer()
                }
                Text(LocalizedStringKey(entry.mealType[0].rawValue))
                    .font(.title)
                    .fontWeight(.regular)
                Spacer()
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(entry.meal[0].meal.prefix(3), id: \.self) {
                        Text($0)
                            .font(.system(size: 16))
                    }
                }
            }
            .padding(13)
        }
            .background(Color("WidgetBackground"))
    }
}

struct SystemMediumWidgetView : View {
    var entry: Provider.Entry
    
    let monthFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "MMMM"
        return f
    }()
    let dayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "d"
        return f
    }()
    
    var body: some View {
        ZStack {
            VStack {
                Rectangle()
                    .frame(height: 30)
                    .foregroundColor(Color("BoxColor"))
                    .shadow(radius: 2)
                Spacer()
            }
            HStack(spacing: 8) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(monthFormatter.string(from: entry.date))
                        .font(.system(size: 14))
                        .padding(.bottom, 4)
                    Text(dayFormatter.string(from: entry.date))
                        .font(.system(size: 50))
                        .fontWeight(.semibold)
                    Spacer()
                }
                Spacer()
                VStack(alignment: .leading, spacing: 0) {
                    Text(LocalizedStringKey(entry.mealType[0].rawValue))
                        .font(.system(size: 14))
                        .bold()
                        .padding(.bottom, 12)
                    ForEach(entry.meal[0].meal.prefix(6), id: \.self) {
                        Text($0)
                            .font(.system(size: 14))
                    }
                    Spacer()
                }
                VStack(alignment: .leading, spacing: 0) {
                    Text(LocalizedStringKey(entry.mealType[1].rawValue))
                        .font(.system(size: 14))
                        .bold()
                        .padding(.bottom, 12)
                    ForEach(entry.meal[1].meal.prefix(6), id: \.self) {
                        Text($0)
                            .font(.system(size: 14))
                    }
                    Spacer()
                }
            }
            .padding(8)
            .padding(.horizontal, 8)
        }
            .background(Color("WidgetBackground"))
    }
}

// Widget

@main
struct mealWidget: Widget {
    let kind: String = "mealWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            mealWidgetEntryView(entry: entry)
        }
        .configurationDisplayName(LocalizedStringKey("Today's meal"))
        .description(LocalizedStringKey("Informs today's meal."))
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// Entry View Preview

struct mealWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            mealWidgetEntryView(entry: MealEntry(
                date: Date(),
                meal: [
                    Meal(meal: ["친환경차수수밥", "순댓국", "돈육고추장불고기", "상추겉절이", "메기순살강정", "배추김치"]),
                    Meal(meal: ["친환경차수수밥", "순댓국", "돈육고추장불고기", "상추겉절이", "메기순살강정", "배추김치"])
                ],
                mealType: [MealType.lunch, MealType.breakfast]
            ))
                .preferredColorScheme(.light)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            mealWidgetEntryView(entry: MealEntry(
                date: Date(),
                meal: [
                    Meal(meal: ["친환경차수수밥", "순댓국", "돈육고추장불고기", "상추겉절이", "메기순살강정", "배추김치"]),
                    Meal(meal: ["친환경차수수밥", "순댓국", "돈육고추장불고기", "상추겉절이", "메기순살강정", "배추김치"])
                ],
                mealType: [MealType.lunch, MealType.breakfast]
            ))
                .preferredColorScheme(.dark)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
        }
        
        Group {
            mealWidgetEntryView(entry: MealEntry(
                date: Date(),
                meal: [
                    Meal(meal: ["친환경차수수밥", "순댓국", "돈육고추장불고기", "상추겉절이", "메기순살강정", "배추김치"]),
                    Meal(meal: ["친환경차수수밥", "순댓국", "돈육고추장불고기", "상추겉절이", "메기순살강정", "배추김치"])
                ],
                mealType: [MealType.lunch, MealType.breakfast]
            ))
                .preferredColorScheme(.light)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            mealWidgetEntryView(entry: MealEntry(
                date: Date(),
                meal: [
                    Meal(meal: ["친환경차수수밥", "순댓국", "돈육고추장불고기", "상추겉절이", "메기순살강정", "배추김치"]),
                    Meal(meal: ["친환경차수수밥", "순댓국", "돈육고추장불고기", "상추겉절이", "메기순살강정", "배추김치"])
                ],
                mealType: [MealType.lunch, MealType.breakfast]
            ))
                .preferredColorScheme(.dark)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
        }
    }
}
