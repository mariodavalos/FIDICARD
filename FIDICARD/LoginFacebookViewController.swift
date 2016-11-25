//
//  LoginFacebookViewController.swift
//  FIDICARD
//
//  Created by Martin Viruete Gonzalez on 21/09/16.
//  Copyright © 2016 oomovil. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON




class LoginFacebookViewController: UIViewController {
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    
    var switchState = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

    @IBAction func switchChanged(sender: AnyObject) {
        
        switchState = !switchState
        
    }
    
    @IBAction func showAvisoPriv(sender: AnyObject) {
        
        let destinationController = storyboard!.instantiateViewControllerWithIdentifier("AvisoDePrivacidad") as! AvisoPrivacidadViewController
        
        destinationController.howDidCalled = self.restorationIdentifier
        
        presentViewController(destinationController, animated: true, completion: nil)
    }
    
    @IBAction func continuar(sender: AnyObject) {
        
        
        if switchState {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        
        if let user = defaults.dataForKey("user") {
           
        if let user = NSKeyedUnarchiver.unarchiveObjectWithData(user) as? Usuario {
            
            let fb_token: String = "ab51f5acb40977296fce11daed3feb1991e4579c"
            let todosEndpoint: String = "http://201.168.207.17:8888/fidicard/kuff_api/regUser"
            let newTodo = ["nombre": user.nombre!, "apellido": user.apellido!, "email": user.email!, "fb_token" : fb_token]
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
                                    
                                    let destinationController = self.storyboard!.instantiateViewControllerWithIdentifier("RegistroExitosoViewController") as! RegistroExitosoViewController
                                    
                                    destinationController.user = user
                                    self.presentViewController(destinationController, animated: true, completion: nil)
                                    
                                    defaults.setObject(user.email!, forKey: "userEmail")
                                    defaults.setObject(fb_token, forKey: "password")
                                    
                                    
                                    if let objeto = defaults.objectForKey("token"){
                                        let token = objeto as! String
                                        
                                        let newTodo2 = ["email": String(user.email!),"token":String(token)]
                                        
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
                                    
                                    
                                }
                                    
                                else if json["status"].intValue == 400 && json["mensaje"].stringValue == "El correo ingresado ya esta registrado en el sistema." {
                                
                                    ///////////////////////////////////////////////////
                                    
                                    let todosEndpoint: String = "http://201.168.207.17:8888/fidicard/kuff_api/loginUser"
                                    let newTodo = ["uname": String(user.email!),"fb_token":String(fb_token)]
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
                                                        
                                                        let temporalUser = Usuario()
                                                        temporalUser.nombre = json["user"]["nombre"].string ?? "null"
                                                        temporalUser.apellido = json["user"]["apellido"].string ?? "null"
                                                        temporalUser.email = json["user"]["email"].string ?? "null"
                                                        temporalUser.imageLink = json["user"]["imagen"].string ?? "null"
                                                        temporalUser.fechaDeNacimiento = json["user"]["fecha_nac"].string ?? "null"
                                                        defaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(temporalUser), forKey: "user")
                                                        defaults.setBool(true, forKey: "userLogged")
                                                        defaults.setObject(false, forKey: "wasImageSet")
                                                        
                                                        if let objeto = defaults.objectForKey("token"){
                                                            let token = objeto as! String
                                                            
                                                            let newTodo2 = ["email": String(user.email!),"token":String(token)]
                                                            
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
                                                            
                                                            let destinationController = self.storyboard!.instantiateViewControllerWithIdentifier("CompletaTuPerfilViewController") as! CompletaTuPerfilViewController
                                                            destinationController.user = temporalUser
                                                            self.presentViewController(destinationController, animated: true, completion: nil)
                                                            
                                                        }
                                                        else {
                                                            
                                                        let destinationController = self.storyboard!.instantiateViewControllerWithIdentifier("HomeView")
                                                        defaults.setObject(user.email!, forKey: "userEmail")
                                                        defaults.setObject(fb_token, forKey: "password")
                                                        defaults.setBool(true, forKey: "userLogged")
                                                        defaults.synchronize()
                                                        self.presentViewController(destinationController, animated: true, completion: nil)

                                                            
                                                        }
   
                                                    }
                                                    else {
                                                        defaults.setObject("", forKey: "userEmail")
                                                        defaults.setObject("", forKey: "password")
                                                    }
                                                    
                                                    
                                                }
                                                
                                                
                                            }
 
                                    }

                                    ////////////////////////////////////////////////////

                                }
                                
                                
                            }
                            
                        }
                    }
                
                }
            
            }
        }
        else {
            
            
            let destinationController = storyboard!.instantiateViewControllerWithIdentifier("PopUp1BtnViewController") as! PopUp1BtnViewController
            
            destinationController.imageName = "desgrane_general_icon_alerta"
            destinationController.labelText = "Debes aceptar los terminos y condiciones del aviso de privacidad"
            destinationController.btnText = "CERRAR"
            destinationController.btnImage = "desgrane_general_btn_azul"
            presentViewController(destinationController, animated: true, completion: nil)
            
        }
        
    }
    
   
}
