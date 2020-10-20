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
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), meal: "친환경차수수밥\n순댓국\n돈육고추장불고기\n상추겉절이\n메기순살강정\n배추김치")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), meal: "친환경차수수밥\n순댓국\n돈육고추장불고기\n상추겉절이\n메기순살강정\n배추김치")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        let currentDate = Date()
        
        let data = GetData(date: currentDate)
        
        let entry = SimpleEntry(date: currentDate, meal: data.meal!)
        entries.append(entry)

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
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
        mealWidgetEntryView(entry: SimpleEntry(date: Date(), meal: "친환경차수수밥\n순댓국\n돈육고추장불고기\n상추겉절이\n메기순살강정\n배추김치"))
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
