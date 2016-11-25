//
//  dashboardTarjetasListViewController.swift
//  FIDICARD
//
//  Created by Martin Viruete Gonzalez on 20/10/16.
//  Copyright © 2016 oOMovil. All rights reserved.
//

import UIKit

class dashboardTarjetasListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let identifier = "CELLAF"
    var arreglo = [String]()
    var titulo  = ""
    var senderInput = ""
    
    @IBOutlet weak var lblTitulo: UILabel!
    var delegate: allocStandardTableDelegate!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       lblTitulo.text = self.titulo
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arreglo.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
            self.delegate.returnOptionSelected(indexPath.row, Selection: arreglo[indexPath.row], senderInput: senderInput)
        
        dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell
        if let cellG = tableView.dequeueReusableCellWithIdentifier(self.identifier){
            cell = cellG
        }else{
            cell = UITableViewCell(style: .Default, reuseIdentifier: self.identifier)
        }
    
        cell.textLabel?.text = arreglo[indexPath.row]
        return cell
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
       
    @IBOutlet weak var CERRAR: UIButton!
    
    @IBAction func close(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
