
//  CollectionViewController.swift
//  rss
//  Created by Dev1 on 09/09/2019.
//  Copyright © 2019 Dev1. All rights reserved.

import UIKit
import CoreData

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {
    
    var noticiasFavoritas = loadFavoritos()
    var noticiasUpdated:Noticias?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "coleccionIrDetalle" {
            guard let destino = segue.destination as? DetalleViewController,
                let origen = sender as? NoticiasColeccionViewCell1,
                let indexPath = collectionView.indexPath(for: origen) else {
                    return
            }
            destino.seleccionado = noticiasFavoritas[indexPath.row]
            destino.rowOrigen = indexPath.row
            destino.origen = .coleccion
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           noticiasFavoritas = loadFavoritos()
           self.collectionView.reloadData()
       }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return noticiasFavoritas.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "coleccionNoticia", for: indexPath) as! NoticiasColeccionViewCell1
        let dato = noticiasFavoritas[indexPath.row]
        cell.Titulo.text = dato.title.rendered
        cell.Titulo.font = UIFont.boldSystemFont(ofSize: 16)
        
        //Borde
        cell.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        cell.layer.borderWidth = 1.5
        cell.layer.cornerRadius = 25.0
        
        //Cargar imagen guardada
        if let imagen = loadImage(id: Int(dato.id)) {
            cell.Imagen.image = imagen
        } else {
            getImage(url: dato.jetpack_featured_media_url) { imagen in
                DispatchQueue.main.async {
                    let visible = collectionView.indexPathsForVisibleItems
                    if visible.contains(indexPath){
                        cell.Imagen.image = imagen
                        saveImage(id: Int(dato.id), image: imagen)
                    }
                }
            }
        }
        return cell
    }
    
    //Salir de Detalle a Favoritos
    @IBAction func salidaColeccionDetalle(_ segue:UIStoryboardSegue) {
        if  let update = noticiasUpdated, segue.identifier == "salirCollecion", let source = segue.source as? DetalleViewController, let row = source.rowOrigen{
            
            noticiasFavoritas[row] = update
            saveFavoritos(Not: noticiasFavoritas)
            let indexPath = IndexPath(row: row, section: 0)
            collectionView.reloadItems(at: [indexPath])
            noticiasUpdated = nil
        }
    }
    
}
