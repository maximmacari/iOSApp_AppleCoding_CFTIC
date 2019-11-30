//
//  ModeloDB.swift
//  rss
//
//  Created by Dev1 on 10/09/2019.
//  Copyright © 2019 Dev1. All rights reserved.


import UIKit
import CoreData

var persistentContainer:NSPersistentContainer = {
   let container = NSPersistentContainer(name: "NoticiasModelo")
   container.loadPersistentStores { store, error in
      if let error = error as NSError? {
         fatalError("No se ha podido abrir la base de datos")
      }
   }
   return container
}()

var ctx:NSManagedObjectContext {
   return persistentContainer.viewContext
}



func saveContext() {
   DispatchQueue.main.async {
      if ctx.hasChanges {
         do {
            try ctx.save()
         } catch {
            print("Error en el commit \(error)")
         }
      }
   }
}

func createNoticiaDB(nuevaNot:Noticias){
    
    let newNoticia = NoticiasDB(context: ctx)
    newNoticia.id = Int64(nuevaNot.id)
    newNoticia.excerpt = nuevaNot.excerpt.rendered
    newNoticia.link = nuevaNot.link
    newNoticia.content = nuevaNot.content.rendered
    newNoticia.title = nuevaNot.title.rendered
    newNoticia.jetpack_featured_media_url = nuevaNot.jetpack_featured_media_url
    newNoticia.date = nuevaNot.date

    saveContext()
    
}
