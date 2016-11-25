//
//  RecuperarContraseñaViewController.swift
//  FIDICARD
//
//  Created by omar on 13/09/16.
//  Copyright © 2016 oomovil. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RecuperarContrasen_aViewController: UIViewController {
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    
    @IBOutlet var txtCorreo: UITextField!
    @IBOutlet weak var errorIconEmail: UIImageView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtCorreo.attributedPlaceholder = NSAttributedString(string:"Correo",attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RecuperarContrasen_aViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func solicitarContrasena(sender: AnyObject) {
        
        
        if (isValidEmail(txtCorreo.text!)) {
        
        errorIconEmail.image = nil
        
        let todosEndpoint: String = "http://201.168.207.17:8888/fidicard/kuff_api/recoverPassword"
        let newTodo = ["email": String(txtCorreo.text!)]
        Alamofire.request(.POST, todosEndpoint, parameters: newTodo)
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
                    let destinationController = self.storyboard!.instantiateViewControllerWithIdentifier("PopUp1BtnViewController") as! PopUp1BtnViewController
                        
                        
                        let json = JSON(data:data)
                        print("JSON: \(json)")
                        if json["status"].intValue == 200 {
                            
                            
                            destinationController.imageName = "desgrane_general_icon_succes"
                            destinationController.labelText = "Hemos enviado un nuevo password a tu correo, ¡Verifícalo!"
                            destinationController.btnText = "CERRAR"
                            
                            destinationController.btnImage = "desgrane_general_btn_azul"
                        }
                        else {
                            
                            destinationController.imageName = "desgrane_general_icon_alerta"
                            destinationController.labelText = "No hemos encontrado este correo en nuestra base de datos, por favor verifícalo"
                            destinationController.btnText = "Cerrar"
                            destinationController.btnImage = "desgrane_general_btn_azul"
                            }
                        
                       self.presentViewController(destinationController, animated: false, completion: nil)
                    }
                    
                    
                }
        }
        }else {errorIconEmail.image = UIImage(named: "ErrorIcon")}
        
    }
    
    
    @IBAction func Regresar(sender: AnyObject) {
        
       dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func endEditingEmail(sender: AnyObject) {
        
        if (!isValidEmail(txtCorreo.text!)) {
            
            
            errorIconEmail.image = UIImage(named: "ErrorIcon")
            
            
        }
        else {
            
            errorIconEmail.image = nil
        }
        
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    



   
}

