//
//  NotasViewController.swift
//  FIDICARD
//
//  Created by Martin Viruete Gonzalez on 13/10/16.
//  Copyright © 2016 oomovil. All rights reserved.
//

import UIKit
import SWRevealViewController

class NotasViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, allocNotasUpdateDeleate {

    var tarjeta = CTarjeta()
    @IBOutlet weak var imgTarjeta: UIImageView!
    @IBOutlet weak var lblAlias: UILabel!
    var notasArray = [CNota]()
    var user = Usuario()
    var padreSenderVC = ""
    
    @IBOutlet weak var notasTableView: UITableView!
    
    @IBOutlet weak var btnBadge: UIButton!
    
    
    @IBAction func goToNotificaciones(sender: AnyObject) {
        
        if let sv = self.revealViewController() {
            
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("NotificacionesViewController") as! NotificacionesViewController
            sv.pushFrontViewController(vc, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUser()
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        loadNotas()
        
        
    }
    
    func loadUser() {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
        if let user = defaults.dataForKey("user") {
    
            if let user = NSKeyedUnarchiver.unarchiveObjectWithData(user) as? Usuario {
                self.user = user
                btnBadge.setTitle(String(defaults.integerForKey("\(user.email!)badge")), forState: .Normal)
    
            }
    
        }
    
    }

    
    
    func loadNotas() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        
        if let notasRaw = defaults.dataForKey("notas") {
            if let notas = NSKeyedUnarchiver.unarchiveObjectWithData(notasRaw) as? [CNota] {
                ArregloNotas.notas = notas
                notasArray = ArregloNotas.notas
                notasTableView.reloadData()
                notasTableView.rowHeight = UITableViewAutomaticDimension
                notasTableView.estimatedRowHeight = 80
                notasTableView.reloadData()
                
            }
        }else {
            
            ArregloNotas.notas = [CNota]()
            let myData = NSKeyedArchiver.archivedDataWithRootObject(ArregloNotas.notas)
            defaults.setObject(myData, forKey: "notas")
            defaults.synchronize()
            notasArray = ArregloNotas.notas
            notasTableView.reloadData()
            
        }

        
    }
    
   override func viewDidAppear(animated: Bool) {
        
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    @IBAction func abrirMenu(sender: AnyObject) {
        
        if let sw = self.revealViewController(){
            sw.revealToggleAnimated(true)
             self.revealViewController().rearViewRevealWidth =  self.view.frame.width * 0.85
        }
        
    }
    
    
    @IBAction func regresar(sender: AnyObject) {
        
        /*
        if tarjeta.tipo == "VIRTUAL" {
            
            
            if let sv = self.revealViewController(){
                let  vc = self.storyboard?.instantiateViewControllerWithIdentifier("detalleTarjtVirtualViewController") as! detalleTarjtVirtualViewController
                vc.tarjeta = tarjeta
                vc.senderVC = padreSenderVC
                //sv.pushFrontViewController(vc, animated: true)
                self.navigationController?.popViewControllerAnimated(true)
            }
            
            
        }
        else if tarjeta.tipo == "FISICA"{
            
            
            if let sv = self.revealViewController(){
                let  vc = self.storyboard?.instantiateViewControllerWithIdentifier("DetalleTarjFisicaViewController") as! DetalleTarjFisicaViewController
                vc.tarjeta = tarjeta
                vc.senderVC = padreSenderVC
                //sv.pushFrontViewController(vc, animated: true)
            }
        }*/
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func nuevaNota(sender: AnyObject) {
        
        /*
        if let sv = self.revealViewController(){
            let  vc = self.storyboard?.instantiateViewControllerWithIdentifier("NuevaNotaViewController") as! NuevaNotaViewController
            sv.pushFrontViewController(vc, animated: true)
        }*/
        
        let vc = storyboard?.instantiateViewControllerWithIdentifier("NuevaNotaViewController") as! NuevaNotaViewController
        
        vc.delegate = self
        presentViewController(vc, animated: true, completion: nil)
  
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notasArray.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("notasCell", forIndexPath: indexPath) as! notasTableViewCell
        
        cell.lblTitulo.text = notasArray[indexPath.row].titulo
        cell.lblCuerpo.text = notasArray[indexPath.row].cuerpo
        cell.lblFecha.text = notasArray[indexPath.row].fecha
        cell.btnEliminar.addTarget(self, action: #selector(self.elimiarNota(_:)), forControlEvents: .TouchDown)
        cell.btnEliminar.tag = indexPath.row * 2
        
        cell.btnEditar.addTarget(self, action: #selector(self.editarNota(_:)), forControlEvents: .TouchDown)
        cell.btnEditar.tag = (indexPath.row * 2) + 1
        
        return cell
        
        
    }
    
     func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            notasArray.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

    func editarNota(sender: UIButton){
        
     let vc = storyboard?.instantiateViewControllerWithIdentifier("NuevaNotaViewController") as! NuevaNotaViewController
        
        vc.nota = notasArray[(sender.tag-1)/2]
        vc.index = (sender.tag-1)/2
        vc.editingNote = true
        vc.delegate = self
        presentViewController(vc, animated: true, completion: nil)
    }
    
    
    func elimiarNota(sender: UIButton){
        
        print("Elimiar selected")
        notasArray.removeAtIndex((sender.tag / 2))
        notasTableView.reloadData()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let notasRaw = defaults.dataForKey("notas") {
            if let notas = NSKeyedUnarchiver.unarchiveObjectWithData(notasRaw) as? [CNota] {
                ArregloNotas.notas = notas
                ArregloNotas.notas = notasArray
                let myData = NSKeyedArchiver.archivedDataWithRootObject(ArregloNotas.notas)
                defaults.setObject(myData, forKey: "notas")
                defaults.synchronize()
                
            }
        }

        
        
    }
    
    func reloadNotas() {
        
        loadNotas()
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func goToMarcas(sender: AnyObject) {
        
        if let sv = self.revealViewController(){
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("MisMarcasViewController")
            sv.pushFrontViewController(vc, animated: true)
           
            
        }
        
    }
    

    @IBAction func goToInicio(sender: AnyObject) {
        
        if let sv = self.revealViewController(){
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("SlideOutMenUIViewController")
            sv.pushFrontViewController(vc, animated: true)
        }
        
    }



   
}
