//
//  StreakView.swift
//  SwiftCallenderWidget
//
//  Created by Mohammad Blur on 7/31/24.
//

import SwiftUI
import CoreData

struct StreakView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Day.date, ascending: true)],
        predicate: NSPredicate(format: "(date >= %@) AND (date <= %@)",
                               Date().startOfMonth as CVarArg,
                               Date().endOfMonth as CVarArg),
        animation: .default)
    private var days: FetchedResults<Day>
    
    @State private var streakValue = 0
    var body: some View {
        VStack {
            Text("\(streakValue)")
                .font(.system(size: 200, weight: .semibold, design: .rounded))
                .foregroundStyle(streakValue > 0 ? .orange : .pink)
            Text("Current Streak")
                .font(.title2)
                .bold()
                .foregroundColor(.secondary)
        }
        .offset(y: -50)
    }
}

#Preview {
    StreakView()
}
