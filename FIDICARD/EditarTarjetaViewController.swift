//
//  EditarTarjetaViewController.swift
//  FIDICARD
//
//  Created by Martin Viruete Gonzalez on 13/10/16.
//  Copyright © 2016 oomovil. All rights reserved.
//

import UIKit
import SWRevealViewController
import Alamofire
import SwiftyJSON

class EditarTarjetaViewController: UIViewController {

    var tarjeta = CTarjeta()
    var user = Usuario()
    
    @IBOutlet weak var txtNumTarjt: UITextField!
    @IBOutlet weak var txtAliasTarjeta: UITextField!
    @IBOutlet weak var segmentoCaduca: UISegmentedControl!
    @IBOutlet weak var txtFMes: UITextField!
    @IBOutlet weak var txtAño: UITextField!
    @IBOutlet weak var expiracionView: UIView!
    @IBOutlet weak var imgHome: UIImageView!
    
    @IBOutlet weak var btnBadge: UIButton!
    
    
    @IBAction func goToNotificaciones(sender: AnyObject) {
        
        if let sv = self.revealViewController() {
            
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("NotificacionesViewController") as! NotificacionesViewController
            sv.pushFrontViewController(vc, animated: true)
        }
    }


    func imageTapped(img: AnyObject)
    {
        if let sv = self.revealViewController(){
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("Home")
            sv.pushFrontViewController(vc, animated: true)
        }

    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        imgHome.userInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
        imgHome.addGestureRecognizer(tapRecognizer)

        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        txtNumTarjt.text = tarjeta.numero
        txtAliasTarjeta.text = tarjeta.alias
        print(tarjeta.caduca)
        if tarjeta.caduca != "null" {
            segmentoCaduca.setEnabled(true, forSegmentAtIndex: 0)
            
            let fullName = tarjeta.caduca
            let fullNameArr = fullName.characters.split{$0 == "-"}.map(String.init)
            if fullNameArr.count > 2 {
                txtAño.text = fullNameArr[0]
                txtFMes.text = fullNameArr[1]
            }
            
        }
        else {
            segmentoCaduca.setEnabled(true, forSegmentAtIndex: 1)
            segmentoCaduca.selectedSegmentIndex = 1
            
        }
        
        txtNumTarjt.enabled = false
        
        if segmentoCaduca.selectedSegmentIndex == 0 {
            
            expiracionView.hidden = false
        }
        else {
            expiracionView.hidden = true
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
        //Getting Usrs Info from DB
        
        
        
        //Keaybord will show and hide
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)

        
    }
    
    override func viewWillAppear(animated: Bool) {
        loadUser()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
    @IBAction func abrirMenu(sender: AnyObject) {
        
        if let sw = self.revealViewController(){
            sw.revealToggleAnimated(true)
             self.revealViewController().rearViewRevealWidth =  self.view.frame.width * 0.85
        }
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y == 0{
                self.view.frame.origin.y -= (keyboardSize.height * 0.3)
            }
            else {
                
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y != 0 {
                self.view.frame.origin.y += (keyboardSize.height * 0.3)
            }
            else {
                
            }
        }
        
    }

    
    
    @IBAction func regresar(sender: AnyObject) {
      /*
        if let sv = self.revealViewController(){
            let  vc = self.storyboard?.instantiateViewControllerWithIdentifier("MisTarjetasViewController") as! MisTarjetasViewController
            
            //sv.pushFrontViewController(vc, animated: true)
        }*/
        self.navigationController?.popViewControllerAnimated(true)
        
        
        
    }
    
    
    @IBAction func guardar(sender: AnyObject) {
        
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let userName = defaults.stringForKey("userEmail") {
            
            let todosEndpoint: String = "http://201.168.207.17:8888/fidicard/kuff_api/updateTarjData"
            
            var parameters = [String : AnyObject]()
            
            if segmentoCaduca.selectedSegmentIndex == 0 {
                
                let date = txtAño.text! + "-" + "" + txtFMes.text! + "-01"
                
                parameters = ["email" : userName, "tarj_id": String(tarjeta.id) , "marca_id" : String(tarjeta.marca_id), "alias" : txtAliasTarjeta.text!, "caduca" : date]
                
            }
            else {
                
                parameters = ["email" : userName, "tarj_id": String(tarjeta.id) , "marca_id" : String(tarjeta.marca_id), "alias" : txtAliasTarjeta.text!]
            }
            
           
            
            Alamofire.request(.POST, todosEndpoint, parameters:  parameters)
                .responseJSON { response in
                    guard response.result.error == nil else {
                        // got an error in getting the data, need to handle it
                        print("error calling POST on /todos/1")
                        print(response.result.error!)
                        return
                    }
                    
                    if let value = response.result.value {
                        let todo = JSON(value)
                        print("The todo is: " + todo.description)
                        
                        if let data = response.data{
                            
                            let json = JSON(data:data)
                            print("JSON: \(json)")
                            if json["status"].intValue == 200 {
                                // let response = json["response"]
                                
                                let alert = UIAlertController(title: "Tarjeta Actualizada", message: "Esta tarjeta fue actualizada correctamente", preferredStyle: UIAlertControllerStyle.Alert)
                                alert.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.Default, handler: nil))
                                self.presentViewController(alert, animated: true, completion: nil)
                                
                                
                              
                            }
                            else {
                                
                                let alert = UIAlertController(title: "Error al Actualizar", message: "Ocurrio un error al actualizar la tarjeta, por favor intentalo mas tarje", preferredStyle: UIAlertControllerStyle.Alert)
                                alert.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.Default, handler: nil))
                                self.presentViewController(alert, animated: true, completion: nil)
                            }
                        }
                    }
            }
            
        }

        
    }
    
    
    @IBAction func eliminar(sender: AnyObject) {
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let userName = defaults.stringForKey("userEmail") {
        
        let todosEndpoint: String = "http://201.168.207.17:8888/fidicard/kuff_api/delTarjetaFromUser"
        
        let parameters = ["email" : userName, "tarj_id": String(tarjeta.id) , "marca_id" : String(tarjeta.marca_id)]
        
        print(parameters)
            Alamofire.request(.POST, todosEndpoint, parameters:  parameters)
            .responseJSON { response in
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling POST on /todos/1")
                    print(response.result.error!)
                    return
                }
                
                if let value = response.result.value {
                    let todo = JSON(value)
                    print("The todo is: " + todo.description)
                    
                    if let data = response.data{
                        
                        let json = JSON(data:data)
                        print("JSON: \(json)")
                        if json["status"].intValue == 200 {
                           // let response = json["response"]
                            
                            let alert = UIAlertController(title: "Tarjeta Eliminada", message: "Esta tarjeta fue eliminada correctamente", preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.Default, handler: nil))
                            self.presentViewController(alert, animated: true, completion: nil)
                            
                            
                            if let tem = defaults.objectForKey("\(self.user.email!)tarjetasFavID") {
                                
                                var tarjetasFavID = tem as! [Int]
                                for i in 0..<tarjetasFavID.count {
                                    
                                    if tarjetasFavID[i] == self.tarjeta.id {
                                        
                                        tarjetasFavID.removeAtIndex(i)
                                        
                                        break
                                    }
                                    
                                    
                                }
                                defaults.setObject(tarjetasFavID, forKey: "tarjetasFavID")
                                defaults.synchronize()
                            
                            }
                            
                            
                           
                            
                            
                            if let sv = self.revealViewController(){
                                let vc = self.storyboard?.instantiateViewControllerWithIdentifier("MisTarjetasViewController")
                                
                                sv.pushFrontViewController(vc, animated: true)
                            }

                        }
                        else {
                            
                            let alert = UIAlertController(title: "Error al Eliminar", message: "Ocurrio un error al eliminar la tarjeta, por favor intentalo mas tarje", preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.Default, handler: nil))
                            self.presentViewController(alert, animated: true, completion: nil)
                        }
                    }
                }
        }

        }
    }
    
    
    @IBAction func segmentoCambio(sender: AnyObject) {
        
        if segmentoCaduca.selectedSegmentIndex == 0 {
            
            expiracionView.hidden = false
        }
        else {
            expiracionView.hidden = true
        }
    }
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

    
    
    @IBAction func aliasPrimaryAction(sender: AnyObject) {
        
        dismissKeyboard()
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func goToMarcas(sender: AnyObject) {
        
        if let sv = self.revealViewController(){
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("MisMarcas")
            sv.pushFrontViewController(vc, animated: true)
           
            
        }
        
    }
    

}
