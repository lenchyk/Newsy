//
//  CoreDataStack.swift
//  Newsy
//
//  Created by Lena Soroka on 27.09.2022.
//

import Foundation
import CoreData

class CoreDataStack {
    private let modelName: String

    init(modelName: String) {
        self.modelName = modelName
    }

    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    lazy var managedContext: NSManagedObjectContext = storeContainer.viewContext

    func saveContext() {
        managedContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        guard managedContext.hasChanges else { return }
        do {
            try managedContext.save()
            NotificationCenter.default.post(name: Constants.NotificationType.articleSaved, object: nil)
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
}

