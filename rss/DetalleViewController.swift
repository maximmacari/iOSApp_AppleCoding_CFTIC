//  DetalleViewController.swift
//  PrimeraAppPrueba
//  Created by Dev1 on 17/07/2019.
//  Copyright © 2019 Dev1. All rights reserved.

import UIKit
import WebKit
import CoreData

enum OrigenLlamada {
    case tabla, coleccion
}

class DetalleViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, WKNavigationDelegate {
    
    @IBOutlet weak var webView: WebViewDetalle!
    @IBOutlet weak var Titulo: UILabel!
    @IBOutlet weak var botonFav: UIBarButtonItem!
    
    //    var rowOrigenDB:IndexPath?
    var favoritos = [Noticias]()
    var seleccionado:Noticias?
    
    //    var oldNoticia:NoticiasDB?
    var row:IndexPath?
    //    var seleccionadoDB:NoticiasDB?
    
    var rowOrigen:Int?
    var origen:OrigenLlamada = .tabla
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let seleccionado = seleccionado{
            Titulo.text = seleccionado.title.rendered.html2String
            Titulo.font = UIFont.boldSystemFont(ofSize: 16)
            webView.loadHTMLString(seleccionado.content.rendered, baseURL: nil)
            webView.allowsBackForwardNavigationGestures = true
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(tocoPantalla(sender:)))
        view.addGestureRecognizer(tap)
    }
    @objc func tocoPantalla(sender:UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    //FALTA
    override func viewWillAppear(_ animated: Bool) {
        favoritos = loadFavoritos()
        if let not = seleccionado {
            if favoritos.contains(where: { (member) -> Bool in
                return not.id == member.id
            }) {
                botonFav.title = "Quitar de favoritos"
            } else {
                botonFav.title = "Añadir a favoritos"
            }
        }
    }
    
    //Al añadir a favortios, la Noticia se guarda.
    @IBAction func añadirFavoritos(_ sender: UIBarButtonItem) {
        guard var noticia = seleccionado else {
            return
        }
        if botonFav.title == "Añadir a favoritos" {
            botonFav.title = "Quitar de favoritos"
            noticia.favorito = true
            favoritos.append(noticia)
            saveFavoritos(Not: favoritos)
        } else {
            botonFav.title = "Añadir a favoritos"
            noticia.favorito = false
            favoritos.removeAll{ $0.id == noticia.id }
            saveFavoritos(Not: favoritos)
        }
    }
    
}
