//
//  LoginViewController.swift
//  FIDICARD
//
//  Created by omar on 08/09/16.
//  Copyright © 2016 oomovil. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    @IBOutlet var txtUsuario: UITextField!
    @IBOutlet weak var errorImage: UIImageView!
    @IBOutlet weak var SwitchSession: UISwitch!
    @IBOutlet var txtPassword: UITextField!
    
    
    var switchState: Bool = true


    override func viewWillAppear(animated: Bool) {
        
        
        
        txtUsuario.attributedPlaceholder = NSAttributedString(string:"Usuario",attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        txtPassword.attributedPlaceholder = NSAttributedString(string:"Contraseña",attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        

        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    
    override func viewDidLoad() {
        
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.whiteColor().CGColor
        border.frame = CGRect(x: 0, y: txtUsuario.frame.size.height - width, width:  txtUsuario.frame.size.width, height: 1)
        border.borderWidth = width
        txtUsuario.layer.addSublayer(border)
        txtUsuario.layer.masksToBounds = true
        
        
        
        let border2 = CALayer()
        let width2 = CGFloat(1.0)
        border2.borderColor = UIColor.whiteColor().CGColor
        border2.frame = CGRect(x: 0, y: txtPassword.frame.size.height - width2, width:  txtPassword.frame.size.width, height: 1)
        border2.borderWidth = width2
        txtPassword.layer.addSublayer(border2)
        txtPassword.layer.masksToBounds = true
        
        
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Add button to keyboard
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        
        
       
         let defaults = NSUserDefaults.standardUserDefaults()

         if let userName = defaults.stringForKey("userEmail") {
            
            txtUsuario.text! = String(userName)
        }
        if let pass = defaults.stringForKey("password"){
            
             txtPassword.text! = String(pass)
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func recuperarPWD(sender: AnyObject) {
        
        let destinationController = storyboard!.instantiateViewControllerWithIdentifier("RecuperarContrasen_aViewController")
        
        presentViewController(destinationController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func Accesar(sender: AnyObject) {
        
        
        if txtUsuario.text != "" && txtPassword.text != "" {
        
        let todosEndpoint: String = "http://201.168.207.17:8888/fidicard/kuff_api/loginUser"
        let newTodo = ["uname": String(txtUsuario.text!),"upass":String(txtPassword.text!)]
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
                       
                        
                        
                        let json = JSON(data:data)
                        print("JSON: \(json)")
                        if json["status"].intValue == 200 {
                            
                            let defaults = NSUserDefaults.standardUserDefaults()
                            if self.switchState {
                                
                                
                                defaults.setObject(self.txtUsuario.text!, forKey: "userEmail")
                                defaults.setObject(self.txtPassword.text!, forKey: "password")
                            }
                            else {
                                defaults.setObject("", forKey: "userEmail")
                                defaults.setObject( "",forKey: "password")
                            }
                            defaults.setBool(true, forKey: "userLogged")
                            
                            let temporalUser = Usuario()
                            temporalUser.nombre = json["user"]["nombre"].string ?? "null"
                            temporalUser.apellido = json["user"]["apellido"].string ?? "null"
                            temporalUser.email = json["user"]["email"].string ?? "null"
                            temporalUser.imageLink = json["user"]["imagen"].string ?? "null"
                            temporalUser.fechaDeNacimiento = json["user"]["fecha_nac"].string ?? "null"
                            defaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(temporalUser), forKey: "user")
                            
                            
                            if let objeto = defaults.objectForKey("token"){
                                let token = objeto as! String
                                
                                let newTodo2 = ["email": String(temporalUser.email!),"token":String(token)]
                                
                                let todosEndpoint2: String = "http://201.168.207.17:8888/fidicard/kuff_api/regToken"
                                
                                Alamofire.request(.POST, todosEndpoint2, parameters: newTodo2)
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
                                                    
                                                    print("Token Enviado con exito")
                                                    
                                                }
                                            }
                                        }
                                        
                                }
                                
                                
                            }
                            
                            
                            if temporalUser.fechaDeNacimiento == "null" {
                                //Manejar TerminarPerfil
                                let destinationController = self.storyboard!.instantiateViewControllerWithIdentifier("CompletaTuPerfilViewController") as! CompletaTuPerfilViewController
                                destinationController.user = temporalUser
                                self.presentViewController(destinationController, animated: false, completion: nil)
                            }
                            else{
                                let destinationController = self.storyboard!.instantiateViewControllerWithIdentifier("HomeView")
                                self.presentViewController(destinationController, animated: false, completion: nil)
                            }
                            
                        }
                        else {
                            let destinationController = self.storyboard!.instantiateViewControllerWithIdentifier("PopUp1BtnViewController") as! PopUp1BtnViewController
                            destinationController.imageName = "desgrane_general_icon_alerta"
                            destinationController.labelText = "Por favor, verifica tu usuario y/o contraseña."
                            destinationController.btnText = "Cerrar"
                            destinationController.btnImage = "desgrane_general_btn_azul"
                            self.presentViewController(destinationController, animated: false, completion: nil)
                        }
                        
                        
                    }
                    
                    
                }
        
        
        }
        
            
        }
        
        else {
            let destinationController = self.storyboard!.instantiateViewControllerWithIdentifier("PopUp1BtnViewController") as! PopUp1BtnViewController
            
            destinationController.imageName = "desgrane_general_icon_alerta"
            destinationController.labelText = "Por favor, verifica tu usuario y/o contraseña."
            destinationController.btnText = "Cerrar"
            destinationController.btnImage = "desgrane_general_btn_azul"
            self.presentViewController(destinationController, animated: false, completion: nil)
        }

    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }

    
    @IBAction func endEditing(sender: AnyObject) {
        
        if (!isValidEmail(txtUsuario.text!)) {
            
            
          
            errorImage.image = UIImage(named: "ErrorIcon")
            
            
        }
        else {
            
            errorImage.image = nil
        }

    }
    
    
    @IBAction func changeSwitchState(sender: AnyObject) {
        
        switchState = !switchState
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height * 0.6
            }
            else {
                
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height  * 0.6
            }
            else {
                
            }
        }
    }
    

    @IBAction func moveToPassword(sender: AnyObject) {
        
        txtPassword.becomeFirstResponder()
        
    }
    
    @IBAction func hideKeyboard(sender: AnyObject) {
        
        dismissKeyboard()
    }
    
    
    @IBAction func REGRESAR(sender: AnyObject) {
        
      dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    
}
