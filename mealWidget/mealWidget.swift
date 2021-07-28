//
//  mealWidget.swift
//  mealWidget
//
//  Created by 박성헌 on 2020/10/17.
//  Copyright © 2020 n30gu1. All rights reserved.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> MealEntry {
        MealEntry(date: Date(), meal: "친환경차수수밥\n순댓국\n돈육고추장불고기\n상추겉절이\n메기순살강정\n배추김치")
    }

    func getSnapshot(in context: Context, completion: @escaping (MealEntry) -> ()) {
        let entry = MealEntry(date: Date(), meal: "친환경차수수밥\n순댓국\n돈육고추장불고기\n상추겉절이\n메기순살강정\n배추김치")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        // TODO: - Make WidgetKit App
        var entries: [MealEntry] = []

        let currentDate = Date()
        
        let mealType: MealType = {
            let zero = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
            let breakfast = Calendar.current.date(bySettingHour: 7, minute: 00, second: 00, of: Date())!
            let lunch = Calendar.current.date(bySettingHour: 13, minute: 00, second: 00, of: Date())!
            let dinner = Calendar.current.date(bySettingHour: 19, minute: 00, second: 00, of: Date())!
            
            switch Date() {
            case zero...breakfast:
                return MealType.breakfast
            case breakfast...lunch:
                return MealType.lunch
            case lunch...dinner:
                return MealType.dinner
            default:
                return MealType.breakfast
            }
        }()
        
        
//        
//        let entry = SimpleEntry(date: currentDate, meal: data.meal!)
//        entries.append(entry)
//
//        let timeline = Timeline(entries: entries, policy: .atEnd)
//        completion(timeline)
    }
}

struct MealEntry: TimelineEntry {
    let date: Date
    let meal: String
}

struct mealWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(entry.date.formatShort())
                    .bold()
                Text(entry.meal)
                    .font(.system(size: 13))
                Spacer()
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 12)
    }
}

@main
struct mealWidget: Widget {
    let kind: String = "mealWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            mealWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("오늘 급식")
        .description("오늘의 급식을 알려줍니다.")
        .supportedFamilies([.systemSmall])
    }
}

struct mealWidget_Previews: PreviewProvider {
    static var previews: some View {
        mealWidgetEntryView(entry: MealEntry(date: Date(), meal: "친환경차수수밥\n순댓국\n돈육고추장불고기\n상추겉절이\n메기순살강정\n배추김치"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

extension Date {
    func formatShort() -> String {
        let f: DateFormatter = DateFormatter()
        f.dateFormat = "M월 d일"
        
        return f.string(from: self)
    }
}
