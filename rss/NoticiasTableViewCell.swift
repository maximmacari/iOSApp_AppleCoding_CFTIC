//
//  NoticiasTableViewCell.swift
//  rss
//
//  Created by Dev1 on 06/09/2019.
//  Copyright © 2019 Dev1. All rights reserved.
//

import UIKit

class NoticiasTableViewCell: UITableViewCell {
    

    @IBOutlet weak var Titulo: UILabel!
    @IBOutlet weak var Descripcion: UILabel!
    @IBOutlet weak var Imagen: UIImageView!
    @IBOutlet weak var Fecha: UILabel!
    @IBOutlet weak var botFav: UIButton!
    
    
    override func prepareForReuse() {
        Titulo.text = nil
        Descripcion.text = nil
        Imagen.image = nil
        Fecha.text = nil
        botFav.imageView?.image = nil
    }
}
