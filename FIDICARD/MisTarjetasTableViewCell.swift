//
//  MisTarjetasTableViewCell.swift
//  FIDICARD
//
//  Created by Martin Viruete Gonzalez on 13/10/16.
//  Copyright © 2016 oomovil. All rights reserved.
//

import UIKit

class MisTarjetasTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lblMarca: UILabel!
    
    @IBOutlet weak var lblMonedero: UILabel!
    
    @IBOutlet weak var lblCategoria: UILabel!
    
    @IBOutlet weak var imgTarjeta: UIImageView!
    
    @IBOutlet weak var btnFavorita: UIButton!
    
    @IBOutlet weak var imgFav: UIImageView!
    
    var favorita: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func favoritaSelected(sender: AnyObject) {
        
        /*
        if !favorita {
            
            imgFav.image = UIImage(named: "ios_mistarjetas_icn_star_on")
            favorita = true
            
        }
        else {
            imgFav.image = UIImage(named: "ios_mistarjetas_icn_star_off")
            favorita = false
        }*/
        
    }

}
