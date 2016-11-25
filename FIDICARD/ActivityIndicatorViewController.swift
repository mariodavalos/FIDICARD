//
//  ActivityIndicatorViewController.swift
//  FIDICARD
//
//  Created by Martin Viruete Gonzalez on 27/10/16.
//  Copyright © 2016 oOMovil. All rights reserved.
//

import UIKit

class ActivityIndicatorViewController: UIViewController {

    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}
