//
//  AddFirstCardViewController.swift
//  FIDICARD
//
//  Created by Martin Viruete Gonzalez on 31/10/16.
//  Copyright © 2016 oOMovil. All rights reserved.
//

import UIKit

class AddFirstCardViewController: UIViewController {

   
    var delegate : allocAddFirstCardDelegate!
    var logged : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addFirstCard(sender: AnyObject) {
        
        if logged! {
            self.delegate.goToMarcas()
        }
        else {
            
            self.delegate.userNotLoggedPopUp()
        }
        
        
    }
    

}
