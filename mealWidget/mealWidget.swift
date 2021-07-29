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

class MealGetter: ObservableObject {
    var meal: [String]? = nil
    
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
    
    var cancellable: AnyCancellable? = nil
    
    private func fetch() {
        func clean(_ text: String) -> [String] {
            let first = text.replacingOccurrences(of: "\n", with: "")
            return first.components(separatedBy: "<br>")
        }
        var contents: String = ""
        let dFormatter: DateFormatter = {
            let f = DateFormatter()
            f.dateFormat = "yyyy/MM/dd"
            return f
        }()
        if let url = URL(string: "https://school.gyo6.net/mu-hak/food/\(dFormatter.string(from: Date()))/\(self.mealType.rawValue)") {
            do {
                let getContents = try String(contentsOf: url)
                contents = getContents
            } catch {
                // contents could not be loaded
                self.meal = ["No internet connection."]
            }
        } else {
            // Bad URL
            self.meal = ["Error"]
        }
        
        do {
            let doc: Document = try SwiftSoup.parse(contents)
            
            guard let meal: Element = try doc.select("td > div").first() else {
                self.meal = ["Error"]
                return
            }
            let mealText = try meal.text()
            let mealResult = clean(mealText)
            
            if mealResult.count == 1 && mealResult[0] == "" {
                self.meal = ["No meal today."]
            } else {
                self.meal = mealResult
            }
        } catch Exception.Error(_, _) {
            return
        } catch {
            return
        }
    }

    init() {
        fetch()
    }
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> MealEntry {
        MealEntry(date: Date(), meal: ["친환경차수수밥", "순댓국", "돈육고추장불고기", "상추겉절이", "메기순살강정", "배추김치"], mealType: MealType.lunch)
    }

    func getSnapshot(in context: Context, completion: @escaping (MealEntry) -> ()) {
        let entry = MealEntry(date: Date(), meal: ["친환경차수수밥", "순댓국", "돈육고추장불고기", "상추겉절이", "메기순살강정", "배추김치"], mealType: MealType.lunch)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [MealEntry] = []
        
        let getter = MealGetter()
        
        let entry = MealEntry(date: Date(), meal: getter.meal ?? ["Failed"], mealType: getter.mealType)
        entries.append(entry)

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct MealEntry: TimelineEntry {
    var date: Date
    let meal: [String]
    let mealType: MealType
}

struct mealWidgetEntryView : View {
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
                Text(entry.mealType.rawValue)
                    .font(.title)
                    .fontWeight(.regular)
                Spacer()
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(entry.meal.prefix(3), id: \.self) {
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

@main
struct mealWidget: Widget {
    let kind: String = "mealWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            mealWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Today's meal")
        .description("Informs today's meal.")
        .supportedFamilies([.systemSmall])
    }
}

struct mealWidget_Previews: PreviewProvider {
    static var previews: some View {
        mealWidgetEntryView(entry: MealEntry(date: Date(), meal: ["친환경차수수밥\n순댓국\n돈육고추장불고기\n상추겉절이\n메기순살강정\n배추김치"], mealType: MealType.lunch))
            .preferredColorScheme(.light)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        mealWidgetEntryView(entry: MealEntry(date: Date(), meal: ["친환경차수수밥\n순댓국\n돈육고추장불고기\n상추겉절이\n메기순살강정\n배추김치"], mealType: MealType.dinner))
            .preferredColorScheme(.dark)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
