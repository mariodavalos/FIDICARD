//
//  RegistroExitosoViewController.swift
//  FIDICARD
//
//  Created by omar on 09/09/16.
//  Copyright © 2016 oomovil. All rights reserved.
//

import UIKit

class RegistroExitosoViewController: UIViewController {
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var btnIrInicio: UIButton!
    
    var user = Usuario()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        btnIrInicio.hidden = true
        lblUserName.text = user.nombre
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(user.email, forKey: "userEmail")
        defaults.setObject(user.password, forKey: "password")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func completarPerfil(sender: AnyObject) {
        
        let destinationController = storyboard!.instantiateViewControllerWithIdentifier("CompletaTuPerfilViewController") as! CompletaTuPerfilViewController
        destinationController.user = self.user
        
        presentViewController(destinationController, animated: true, completion: nil)

    }
    
    @IBAction func irAlInicio(sender: AnyObject) {
        let destinationController = storyboard!.instantiateViewControllerWithIdentifier("HomeView")
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "userLogged")
        presentViewController(destinationController, animated: true, completion: nil)
        
    }
    
    
    
}
