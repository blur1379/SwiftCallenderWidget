//
//  SwiftCalWidget.swift
//  SwiftCalWidget
//
//  Created by Mohammad Blur on 8/2/24.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> CalendarEntry {
        CalendarEntry(date: Date(), days: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (CalendarEntry) -> ()) {
        let request = Day.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Day.date, ascending: true)]
        request.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)",
                                         Date().startOfCalendarWithPrefixDays as CVarArg,
                                         Date().endOfMonth as CVarArg)
        let context
        
        let entry = CalendarEntry(date: Date(), days: [])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [CalendarEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = CalendarEntry(date: entryDate, days: [])
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct CalendarEntry: TimelineEntry {
    let date: Date
    let days: [Day]
}

struct SwiftCalWidgetEntryView : View {
    var entry: Provider.Entry
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    var body: some View {
        HStack {
            VStack {
                Text("30")
                    .font(.system(size: 70, design: .rounded))
                    .bold()
                    .foregroundStyle(.orange)
                Text("day streak")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            VStack {
                CalendarHeaderView(font: .caption)
                LazyVGrid(columns: columns, spacing: 7) {
                    ForEach(0..<31){ _ in
                        Text("30")
                            .font(.caption)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.secondary)
                            .background(
                            Circle()
                                .foregroundStyle(.orange.opacity(0.3))
                                .scaleEffect(1.5)
                            )
                    }
                }
            }
            .padding(.leading, 6)
        }
      
       
    }
}

struct SwiftCalWidget: Widget {
    let kind: String = "SwiftCalWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                SwiftCalWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                SwiftCalWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemMedium) {
    SwiftCalWidget()
} timeline: {
    CalendarEntry(date: .now, days: [])
    CalendarEntry(date: .now, days: [])
}
