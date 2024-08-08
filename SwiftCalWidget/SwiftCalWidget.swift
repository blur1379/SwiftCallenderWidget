//
//  SwiftCalWidget.swift
//  SwiftCalWidget
//
//  Created by Mohammad Blur on 8/2/24.
//

import WidgetKit
import SwiftUI
import CoreData


struct Provider: TimelineProvider {
    let viewContext = PersistenceController.shared.container.viewContext
    var dayFetchRequest: NSFetchRequest<Day> {
        let request = Day.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Day.date, ascending: true)]
        request.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)",
                                         Date().startOfCalendarWithPrefixDays as CVarArg,
                                         Date().endOfMonth as CVarArg)
        return request
    }
    
    func placeholder(in context: Context) -> CalendarEntry {
        CalendarEntry(date: Date(), days: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (CalendarEntry) -> ()) {
        do {
            let days = try viewContext.fetch(dayFetchRequest)
            let entry = CalendarEntry(date: Date(), days: days)
            completion(entry)
        } catch {
            print("Failed to fetch days: \(error)")
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        do {
            let days = try viewContext.fetch(dayFetchRequest)
            let entry = CalendarEntry(date: Date(), days: days)
            let timeline = Timeline(entries: [entry], policy: .after(.now.endOfDay))
            completion(timeline)
        } catch {
            print("Failed to fetch days: \(error)")
        }
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
