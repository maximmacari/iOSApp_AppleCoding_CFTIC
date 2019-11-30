//  network.swift
//  rss
//  Created by Dev1 on 04/09/2019.
//  Copyright © 2019 Dev1. All rights reserved.
//

import Foundation
import UIKit

//NETWORK
func getData(url:URL, callback:@escaping (Data) -> Void) {
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
            if let error = error {
                print("Error de red \(error)")
            }
            return
        }
        if response.statusCode == 200 {
            callback(data)
        } else {
            print("Estado devuelto: \(response.statusCode)")
        }
        }.resume()
}

func getNoticias(callback: @escaping ([Noticias]) -> Void)  {
    
    let url = URL(string: "https://applecoding.com/wp-json/wp/v2/posts?per_page=20")
    
    getData(url: url!) { (data) in
        DispatchQueue.main.async {
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                let result = try decoder.decode([Noticias].self, from: data)
                callback(result)
            } catch {
                print("Cant get the post. Error: \(error)")
            }
        }
    }
}

//URL -> UIImage
func getImage(url:URL, callback:@escaping (UIImage) -> Void) {
    getData(url: url) { data in
        if let imagen = UIImage(data: data), let resized = imagen.resize(width: 350) {
            callback(resized)
        } else {
            print("Los datos de imagen no se han validado")
        }
    }
}




