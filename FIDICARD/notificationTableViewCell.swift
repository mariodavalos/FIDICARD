//
//  notificationTableViewCell.swift
//  FIDICARD
//
//  Created by Martin Viruete Gonzalez on 27/10/16.
//  Copyright © 2016 oOMovil. All rights reserved.
//

import UIKit

class notificationTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imgMarca: UIImageView!
    @IBOutlet weak var lblDescripcion: UILabel!
    
    @IBOutlet weak var lblVigencia: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
