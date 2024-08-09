//
//  SwiftCallenderWidgetApp.swift
//  SwiftCallenderWidget
//
//  Created by Mohammad Blur on 7/25/24.
//

import SwiftUI

@main
struct SwiftCallenderWidgetApp: App {
    let persistenceController = PersistenceController.shared
    @State private var selectedTab = 0
    var body: some Scene {
        WindowGroup {
            TabView(selection: $selectedTab) {
                CalendarView()
                    .tabItem {
                        Image(systemName: "calendar")
                        Text("Calendar")
                    }
                
                StreakView()
                    .tabItem {
                        Image(systemName: "swift")
                        Text("Streak")
                    }
            }
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .onOpenURL { url in
                selectedTab = url.absoluteString == "streak" ? 1 : 0
            }
        }
    }
}
