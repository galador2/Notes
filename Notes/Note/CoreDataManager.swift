//
//  CoreDataManager.swift
//  Note
//
//  Created by Kiryl Rakk on 12/2/23.
//

import Foundation
import CoreData


class CoreDataManager {
    
    static var shared = CoreDataManager()
    init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NoteCoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    func delete(post: Post) {
        if  let note = checkId(in: post.id) {
            persistentContainer.viewContext.delete(note)
            }
        do {
           try persistentContainer.viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    
    
    func saveNewNote(note: Post ) {
            
        let noteCore = Notes(context: persistentContainer.viewContext)
            noteCore.text = note.text
            noteCore.id = note.id
            do {
                try persistentContainer.viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
            print("saved note")
        
    }
    
    
    func updateNote(post: Post) {
        let notes = checkId(in: post.id)
        notes?.text = post.text
        do {
            try persistentContainer.viewContext.save()

        } catch {
            print(error.localizedDescription)

        }
        print("updated note")

    }
    
        
         func checkId(in id: String) -> Notes? {
            let fetchRequest = Notes.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id)
             return (try? persistentContainer.viewContext.fetch(fetchRequest))?.first
        }
        
       
    func getNotes() -> [Notes] {
        let fetchRequest = Notes.fetchRequest()
        return (try? persistentContainer.viewContext.fetch(fetchRequest)) ?? []
    }
        
    
}
