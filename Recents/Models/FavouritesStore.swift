//
//  FavouritesStore.swift
//  Recents
//
//  Created by Dimitar Dinev on 15.06.21.
//

import CoreData

class FavouritesStore {
    static var shared = FavouritesStore()
    let persistentContainer = ContactStore.shared.persistentContainer
    var allFavourites: [Favourite]
    
    init() {
        do {
            allFavourites = try persistentContainer.viewContext.fetch(Favourite.fetchRequest())
        } catch {
            print(error)
            allFavourites = []
        }
    }
    
    func remove(at index: Int) {
        let favorite = allFavourites.remove(at: index)
        persistentContainer.viewContext.delete(favorite)
        saveChanges()
    }
    
    func add(_ favorite: Favourite) {
        allFavourites.append(favorite)
        saveChanges()
    }
    
    func move(fromIndex: Int, toIndex: Int) {
        let (start, end, step) = fromIndex < toIndex ?
            (fromIndex, toIndex - 1, 1) :
            (toIndex + 1, fromIndex, -1)
        
        let movedItem = allFavourites[fromIndex]
        
        for i in start...end {
            allFavourites[i] = allFavourites[i + step]
        }
        allFavourites[toIndex] = movedItem
    }
    
    func saveChanges() {
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print(error)
        }
    }
}
