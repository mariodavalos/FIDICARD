//
//  CategoriasViewController.swift
//  FIDICARD
//
//  Created by Martin Viruete Gonzalez on 04/10/16.
//  Copyright © 2016 oomovil. All rights reserved.
//

import UIKit

class CategoriasViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    var categorias = ["TODAS","DEPORTE","RESTAURANTE","ENTRETENIMIENTO",
        "OSCIO","MODA","MEDICO","HOGAR","GOURMET",
        "TIENDA DPT.",
        "BANCARIA","FINAZAS","BEBES","INFANTIL"]
    var senderVC :String!
    
    var delegate: allocCategoriasSelecionDelegate!
    
    @IBOutlet weak var categoriasTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
               
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

 
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categorias.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("categoriasCell", forIndexPath: indexPath) as! CategoriasTableViewCell
        
        cell.lblCategoria.text   = categorias[indexPath.row]
        
        
        return cell
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
        
        if self.delegate != nil {
            self.delegate.returnCategoria(indexPath.row, value: categorias[indexPath.row])
            if let sv = self.revealViewController(){
                sv.rightRevealToggleAnimated(true)
            }
            
        }

        
        
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) { /*
        let DestVC = segue.destinationViewController as! MisMarcasViewController
        let indexPath : NSIndexPath = categoriasTableView.indexPathForSelectedRow!
        
        DestVC.CategoriaSelection = indexPath.row 
        
        */

        
    }

    
    

}
