//
//  DataController.swift
//  Sikke
//
//  Created by Gokhan Namal on 19.04.2020.
//  Copyright © 2020 Gokhan Namal. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    let persistentContainer: NSPersistentContainer!
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { storeDesc, error in
            if let error = error {
                fatalError(error.localizedDescription)
            }
            completion?()
        }
    }
}
