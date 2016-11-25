//
//  EsperandoConfViewController.swift
//  
//
//  Created by Martin Viruete Gonzalez on 20/09/16.
//
//

import UIKit
import Alamofire
import SwiftyJSON

class EsperandoConfViewController: UIViewController {
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    var user = Usuario()
    var response = true
    var timer : NSTimer!
    var status : Bool = false
    var timer2 : NSTimer!

    @IBOutlet weak var lblUserName: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        lblUserName.text = user.nombre
        
       //let thread = NSThread(target:self, selector:#selector(isUserActive), object:nil)
       
        
       timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: #selector(self.isUserActive), userInfo: nil, repeats: false)
    }
    func isUserActive(){
        
        if !response{
            return
        }
        if status == false {
        let todosEndpoint: String = "http://201.168.207.17:8888/fidicard/kuff_api/isUserActive/"
        let newTodo = ["email": user.email!]
        Alamofire.request(.POST, todosEndpoint, parameters: newTodo)
            .responseJSON { response in
                self.response = true
                self.timer2 = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: #selector(self.isUserActive), userInfo: nil, repeats: false)
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
                            
                            self.status = true
                            let destinationController = self.storyboard!.instantiateViewControllerWithIdentifier("RegistroExitosoViewController") as! RegistroExitosoViewController
                            
                            destinationController.user = self.user
                            self.presentViewController(destinationController, animated: true, completion: nil)
                            
                            self.timer.invalidate()
                            self.timer2.invalidate()
                        }
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        timer.invalidate()
        timer2.invalidate()
        
    }
    

    @IBAction func Reenviar(sender: AnyObject) {
        
        let todosEndpoint: String = "http://201.168.207.17:8888/fidicard/kuff_api/resendActiveEmail/"
        let newTodo = ["email": user.email!]
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
                            
                            
                            
                        }
                    }
                }
        }

        
    }
    
    
    @IBAction func Cancelar(sender: AnyObject) {
        
        
        let destinationController = storyboard!.instantiateViewControllerWithIdentifier("PopUp2BtnViewController") as! PopUp2BtnViewController
        
        destinationController.imageName = "desgrane_general_icon_alerta"
        destinationController.labelText = "¿Seguro que deseas cancelar tu registro"
        destinationController.btnText1 = "SI, CONFIRMAR"
        destinationController.btnText2 = "NO, VOLVER AL REGISTRO"
        destinationController.btnImage1 = "desgrane_general_btn_rosa"
        destinationController.btnImage2 = "desgrane_general_btn_azul"
        
        destinationController.returntTo1 = "InicioViewController"
        destinationController.borrar = true
        destinationController.emailToErrase = user.email!
        destinationController.returntTo2 = "self"
        presentViewController(destinationController, animated: false, completion: nil)
        
        
        
        
    }
    
    

}
