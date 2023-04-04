//
//  FavoriteProvider.swift
//  GameApps
//
//  Created by PLWEP on 02/04/23.
//

import Foundation
import CoreData
import UIKit

class FavoriteProvider {

  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "FavoriteModel")

    container.loadPersistentStores { _, error in
      guard error == nil else {
        fatalError("Unresolved error \(error!)")
      }
    }
    container.viewContext.automaticallyMergesChangesFromParent = false
    container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    container.viewContext.shouldDeleteInaccessibleFaults = true
    container.viewContext.undoManager = nil

    return container
  }()

  private func newTaskContext() -> NSManagedObjectContext {
    let taskContext = persistentContainer.newBackgroundContext()
    taskContext.undoManager = nil

    taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    return taskContext
  }

  func getAllFavorite(completion: @escaping(_ favoriteGames: [Game]) -> Void) {
    let taskContext = newTaskContext()
    taskContext.perform {
      let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GameData")
      do {
        let results = try taskContext.fetch(fetchRequest)
        var favoriteGames: [Game] = []
        for result in results {
          let game = Game(
            id: result.value(forKeyPath: "id") as? Int,
            name: result.value(forKeyPath: "name") as? String,
            released: result.value(forKeyPath: "released") as? String,
            backgroundImage: result.value(forKeyPath: "backgroundImage") as? String,
            rating: result.value(forKeyPath: "rating") as? Double,
            isFavorite: result.value(forKeyPath: "isFavorite") as! Bool
          )

          favoriteGames.append(game)
        }
        completion(favoriteGames)
      } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
      }
    }
  }

  func addFavorite(
    _ id: Int,
    _ name: String,
    _ released: String,
    _ backgroundImage: String,
    _ rating: Double,
    _ isFavorite: Bool,
    completion: @escaping() -> Void
  ) {
    let taskContext = newTaskContext()
    taskContext.performAndWait {
      if let entity = NSEntityDescription.entity(forEntityName: "GameData", in: taskContext) {
          let member = NSManagedObject(entity: entity, insertInto: taskContext)
          member.setValue(id, forKeyPath: "id")
          member.setValue(name, forKeyPath: "name")
          member.setValue(released, forKeyPath: "released")
          member.setValue(backgroundImage, forKeyPath: "backgroundImage")
          member.setValue(rating, forKeyPath: "rating")
          member.setValue(isFavorite, forKeyPath: "isFavorite")

          do {
            try taskContext.save()
            completion()
          } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
          }
      }
    }
  }
    
  func isDataExist(_ id: Int, completion: @escaping(Bool) -> Void) {
    let taskContext = newTaskContext()
    taskContext.perform {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GameData")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id == \(id)")
        do {
            if let result = try taskContext.fetch(fetchRequest).first  {
                let isStore = result.value(forKeyPath: "isFavorite") as! Bool
                completion(isStore)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
 }
    

  func deleteFavorite(_ id: Int, completion: @escaping() -> Void) {
    let taskContext = newTaskContext()
    taskContext.perform {
      let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GameData")
      fetchRequest.fetchLimit = 1
      fetchRequest.predicate = NSPredicate(format: "id == \(id)")
      let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
      batchDeleteRequest.resultType = .resultTypeCount
      if let batchDeleteResult = try? taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
        if batchDeleteResult.result != nil {
          completion()
        }
      }
    }
  }
}
