//
//  AvisoPrivacidadViewController.swift
//  FIDICARD
//
//  Created by Martin Viruete Gonzalez on 20/09/16.
//  Copyright © 2016 oomovil. All rights reserved.
//

import UIKit

class AvisoPrivacidadViewController: UIViewController {
    
    var aviso = ""
    @IBOutlet weak var txtAviso: UILabel!
    
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    
    var howDidCalled : String! 
    

    override func viewDidLoad() {
        super.viewDidLoad()
        txtAviso.text = aviso
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    
    @IBAction func Cerrar(sender: AnyObject) {
        
        
       
        dismissViewControllerAnimated(true, completion: nil)

        
    }

}
