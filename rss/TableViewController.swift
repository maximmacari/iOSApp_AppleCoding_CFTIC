//  TableViewController.swift
//  rss
//  Created by Max on 03/09/2019.
//  Copyright © 2019 Dev1. All rights reserved.

import UIKit
class TableViewController: UITableViewController {
    
    var noticias = [Noticias]()
    var empUpdated:Noticias?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        getNoticias { (not) in
            self.noticias = not
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return noticias.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celdaTable", for: indexPath) as! NoticiasTableViewCell
        
        let dato = noticias[indexPath.row]
        cell.Titulo.text = dato.title.rendered.html2String
        cell.Descripcion.text = dato.excerpt.rendered.html2String
        
        //Fecha
        let date = dato.date
        let format = DateFormatter()
        format.dateFormat = "dd-MM-yyyy"
        let formattedDate = format.string(from: date)
        cell.Fecha.text = formattedDate
        
        if let imagen = loadImage(id: Int(dato.id)) {
            cell.Imagen.image = imagen
        } else {
            //if let avatar:URL = dato.jetpack_featured_media_url {
            //Imagen
            getImage(url: dato.jetpack_featured_media_url) { imagen in
                DispatchQueue.main.async {
                    if let visible = tableView.indexPathsForVisibleRows, visible.contains(indexPath) {
                        cell.Imagen.image = imagen
                    }
                    saveImage(id: dato.id, image: imagen)
                }
            }
            //}
        }
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView.isEditing {
            return .delete
        }
        
        return .none
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tablaIrDetalle" {
            guard let destino = segue.destination as? DetalleViewController,
                let origen = sender as? NoticiasTableViewCell,
                let indexPath = tableView.indexPath(for: origen) else {
                    return
            }
            destino.seleccionado = noticias[indexPath.row]
            destino.rowOrigen = indexPath.row
        }
    }
    
    //Salir de detalle
    //falta
    @IBAction func salidaTablaDetalle(_ segue:UIStoryboardSegue) {
        if let update = empUpdated, segue.identifier == "salirTabla", let source = segue.source as? DetalleViewController, let row = source.rowOrigen {
            noticias[row] = update
            _ = IndexPath(row: row, section: 0)
            empUpdated = nil
        }
    }
}
