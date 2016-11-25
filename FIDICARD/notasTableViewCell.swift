//
//  notasTableViewCell.swift
//  FIDICARD
//
//  Created by Martin Viruete Gonzalez on 13/10/16.
//  Copyright © 2016 oomovil. All rights reserved.
//

import UIKit

class notasTableViewCell: UITableViewCell {

    let padre : NotasViewController? = nil
    
    @IBOutlet weak var lblTitulo: UILabel!
    
    @IBOutlet weak var lblCuerpo: UILabel!
    
    @IBOutlet weak var lblFecha: UILabel!
    
    @IBOutlet weak var btnEliminar: UIButton!
    
    @IBOutlet weak var btnEditar: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func eliminar(sender: AnyObject) {
        
        
        
    }

    @IBAction func editar(sender: AnyObject) {
        
      
    }
}
