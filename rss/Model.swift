//  Model.swift
//  rss
//  Created by Dev1 on 02/09/2019.
//  Copyright © 2019 Dev1. All rights reserved.

import Foundation
import CoreData
import UIKit

struct Noticias:Codable{
    let id:Int
    let date:Date
    let link:URL
    let content:Content
    let excerpt:Excerpt
    let title:Title
    let jetpack_featured_media_url:URL
    var favorito:Bool? = false
}

struct Title:Codable{
    let rendered:String
}

struct Content:Codable{
    let rendered:String
}

struct Excerpt:Codable {
    let rendered:String
}

extension DateFormatter {
    static let iso8601Full:DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}

func saveImage(id:Int, image:UIImage) {
   guard let folder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first, let imagenData = image.pngData() else {
      return
   }
   let ruta = folder.appendingPathComponent("imagen_\(id)").appendingPathExtension("png")
   try? imagenData.write(to: ruta, options: .atomicWrite)
}

//cargar imagen Guardada
func loadImage(id:Int) -> UIImage? {
    guard let folder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        return nil
    }
    let ruta = folder.appendingPathComponent("imagen_\(id)").appendingPathExtension("png")
    if let data = try? Data(contentsOf: ruta) {
        return UIImage(data: data)
    }
    return nil
}

//func deletefromDB(not:Noticias) {
//
//    //Quitar de favoritos
//    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Noticia")
//    fetchRequest.predicate = NSPredicate(format: "id = %@", not.id)
//
//    do{
//        let test = try ctx.fetch(fetchRequest)
//        let noticiaABorrar = test[0] as! NSManagedObject
//        ctx.delete(noticiaABorrar)
//
//        saveContext()
//    }catch{
//        print(error)
//    }
//}

//--------------------
//Favoritos
//--------------------
func loadFavoritos() -> [Noticias] {
    guard let folder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        return []
    }
    let rutaDisco = folder.appendingPathComponent("NoticiasFavoritas").appendingPathExtension("json")
    do {
        let datos = try Data(contentsOf: rutaDisco)
        let carga = try JSONDecoder().decode([Noticias].self, from: datos)
        return carga
    } catch {
        print("Error en la serialización \(error)")
    }
    return []
}

func saveFavoritos(Not:[Noticias]) {
    guard let folder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        return
    }
    print(folder)
    let ruta = folder.appendingPathComponent("NoticiasFavoritas").appendingPathExtension("json")
    do {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let datosEmp = try encoder.encode(Not)
        try datosEmp.write(to: ruta, options: .atomicWrite)
    } catch {
        print("Error grabando datos \(error)")
    }
}











