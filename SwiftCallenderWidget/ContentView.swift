//
//  ContentView.swift
//  SwiftCallenderWidget
//
//  Created by Mohammad Blur on 7/25/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Day.date, ascending: true)],
        animation: .default)
    private var days: FetchedResults<Day>
    
    let daysOfWeek = ["S","M","T","W","T","F","S"]
    
    var body: some View {
        NavigationView {
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
                    }
                }
                
            }
            .padding()
            
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
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
