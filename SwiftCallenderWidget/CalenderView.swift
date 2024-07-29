//
//  ContentView.swift
//  SwiftCallenderWidget
//
//  Created by Mohammad Blur on 7/25/24.
//

import SwiftUI
import CoreData

struct CalenderView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Day.date, ascending: true)],
        predicate: NSPredicate(format: "(date >= %@) AND (date <= %@)",
                               Date().startOfCalendarWithPrefixDays as CVarArg,
                               Date().endOfMonth as CVarArg),
        animation: .default)
    private var days: FetchedResults<Day>
    
    let daysOfWeek = ["S","M","T","W","T","F","S"]
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    ForEach(daysOfWeek, id: \.self) { day in
                        Text(day)
                            .fontWeight(.black)
                            .foregroundStyle(.orange)
                            .frame(maxWidth: .infinity)
                    }
                }
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                    ForEach(days) { day in
                        Text(day.date!.formatted(.dateTime.day()))
                            .fontWeight(.bold)
                            .foregroundStyle(day.didStudy ? .orange : .secondary)
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .background(
                                Circle()
                                    .fill(.orange.opacity(day.didStudy ? 0.3 : 0.0))
                            )
                    }
                }
                Spacer()
            }
            .padding()
            .navigationTitle(Date().formatted(.dateTime.month(.wide)))
            .onAppear {
                if days.isEmpty {
                    createMonthDays(for: .now)
                }
            }
        }
    }
    
    func createMonthDays(for date: Date) {
        for dayOffset in 0...date.numberOfDaysInMonth {
            let newItem = Day(context: viewContext)
            newItem.date = Calendar.current.date(byAdding: .day, value: dayOffset, to: date.startOfMonth)
            newItem.didStudy = false
        }
        do {
            try viewContext.save()
        } catch {
            print("faile d to save context")
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    CalenderView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
