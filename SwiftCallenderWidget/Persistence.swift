//
//  Persistence.swift
//  SwiftCallenderWidget
//
//  Created by Mohammad Blur on 7/25/24.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    let databaseName = "SwiftCallenderWidget.sqlite"
    
    
    var oldStoreUrl: URL {
        let directory = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        return directory.appendingPathComponent(databaseName)
    }
    
    var sharedStoreUrl: URL {
        let fileManager = FileManager.default
        var url = fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.app.blur.SwiftCallenderWidget")!
        url.appendPathComponent(databaseName)
        return url
    }
    
    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        let startDate = Calendar.current.dateInterval(of: .month, for: .now)!.start
        for dayOffset in 0..<30 {
            let newItem = Day(context: viewContext)
            newItem.date = Calendar.current.date(byAdding: .day, value: dayOffset, to: startDate)
            newItem.didStudy = Bool.random()
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "SwiftCallenderWidget")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        } else if !FileManager.default.fileExists(atPath: oldStoreUrl.path) {
            print("old store dose not exist, creating new one")
            container.persistentStoreDescriptions.first!.url = sharedStoreUrl
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        migrateStore(for: container)
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func migrateStore(for container: NSPersistentContainer) {
        let coordinator = container.persistentStoreCoordinator
        guard let oldStore = coordinator.persistentStore(for: oldStoreUrl) else { return }
        
        do {
            let _ = try coordinator.migratePersistentStore(oldStore, to: sharedStoreUrl, type: .sqlite)
            print("migration successful")
        } catch {
            fatalError("unable to migrate store: \(error.localizedDescription)")
        }
        
        do {
            try FileManager.default.removeItem(at: oldStoreUrl)
            print("old store removed")
        } catch {
            print("unable to remove old store: \(error.localizedDescription)")
        }
    }
}
