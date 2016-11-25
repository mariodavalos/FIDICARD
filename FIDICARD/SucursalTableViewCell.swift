//
//  SucursalTableViewCell.swift
//  FIDICARD
//
//  Created by Martin Viruete Gonzalez on 04/10/16.
//  Copyright © 2016 oomovil. All rights reserved.
//

import UIKit

class SucursalTableViewCell: UITableViewCell {

    
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var direccion: UILabel!
    @IBOutlet weak var telefono: UILabel!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
