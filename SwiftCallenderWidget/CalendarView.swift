//
//  ContentView.swift
//  SwiftCallenderWidget
//
//  Created by Mohammad Blur on 7/25/24.
//

import SwiftUI
import CoreData

struct CalendarView: View {
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
                CalendarHeaderView()
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                    ForEach(days) { day in
                        if day.date!.monthInt != Date().monthInt {
                            Text(" ")
                        } else {
                            Text(day.date!.formatted(.dateTime.day()))
                                .fontWeight(.bold)
                                .foregroundStyle(day.didStudy ? .orange : .secondary)
                                .frame(maxWidth: .infinity, minHeight: 40)
                                .background(
                                    Circle()
                                        .fill(.orange.opacity(day.didStudy ? 0.3 : 0.0))
                                )
                                .onTapGesture {
                                    if day.date!.dayInt <= Date().dayInt {
                                        day.didStudy.toggle()
                                        do {
                                            try viewContext.save()
                                            print("\(day.date!.dayInt) now studied !")
                                        } catch {
                                            print("Error saving data: \(error.localizedDescription)")
                                        }
                                      
                                    } else {
                                        print("you can't study in the future !")
                                    }
                                   
                                }
                        }
                    }
                }
                Spacer()
            }
            .padding()
            .navigationTitle(Date().formatted(.dateTime.month(.wide)))
            .onAppear {
                if days.isEmpty {
                    createMonthDays(for: .now.startOfPreviousMonth)
                    createMonthDays(for: .now)
                } else if days.count < 10 {
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
    CalendarView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
