//
//  RegistroViewController.swift
//  FIDICARD
//
//  Created by omar on 08/09/16.
//  Copyright © 2016 oomovil. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RegistroViewController: UIViewController, UIScrollViewDelegate {
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    @IBOutlet weak var txtNombres: UITextField!
    
    @IBOutlet weak var txtApellidos: UITextField!
    
    @IBOutlet weak var txtCorreo: UITextField!
    @IBOutlet weak var txtValidarCorreo: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPass: UITextField!
    @IBOutlet weak var btnRegistrar: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //Imagenes de Error
    
    @IBOutlet weak var ImgErrorNombres: UIImageView!
    @IBOutlet weak var ImgErrorApellidos: UIImageView!
    @IBOutlet weak var ImgErrorCorreo: UIImageView!
    @IBOutlet weak var ImgErrorConfCorreo: UIImageView!
    @IBOutlet weak var ImgErrorPass: UIImageView!
    @IBOutlet weak var ImgErrorConfPass: UIImageView!
    
    var amountIncreased : CGFloat = 0
    var keyBoardIsVisible = false
    
  
    var RegistroDePrivacidadFlag : Bool = true
    
    @IBAction func AvisoPrivChnged(sender: AnyObject) {
        
        RegistroDePrivacidadFlag = !RegistroDePrivacidadFlag
        
    }
    
   
    @IBAction func editingPWDS(sender: AnyObject) {
        
        
        
    }
    
    
    @IBAction func finishedEditingText(sender: UITextField) {
        
        if (sender.text! == "") {
            
            switch sender.placeholder! {
                
            case "Nombres(s)":
                ImgErrorNombres.image = UIImage(named: "ErrorIcon")
                break
            case "Apellido":
                
                ImgErrorApellidos.image = UIImage(named: "ErrorIcon")
                
                break
                
            case "Password":
                
                ImgErrorPass.image = UIImage(named: "ErrorIcon")
                
                break
            case "Confirmar Password":
            
                ImgErrorConfPass.image = UIImage(named: "ErrorIcon")

                
            break
                
            default:
                
                break
            }
            
        }
        
        else {
            
            switch sender.placeholder! {
                
            case "Nombres(s)":
                ImgErrorNombres.image = nil
                break
            case "Apellido":
                
                ImgErrorApellidos.image = nil
                
                break
                
            case "Password":
                
                ImgErrorPass.image = nil
                
                break
            case "Confirmar Password":
                
                ImgErrorConfPass.image = nil
                
                
                break
                
            default:
                
                break
            }

            
        }

        
        
        
        
    }
    
    @IBAction func EditingEmailDidEnd(sender: UITextField) {
        
        if !isValidEmail(sender.text!) {
            
            switch sender.placeholder! {
                
            case "Correo":
                ImgErrorCorreo.image = UIImage(named: "ErrorIcon")
                break
            case "Confirmar Correo":
                
                ImgErrorConfCorreo.image = UIImage(named: "ErrorIcon")
                
                break
                
            default:
                
                break
            }
            
            
        }
        else {
            
            switch sender.placeholder! {
                
            case "Correo":
                ImgErrorCorreo.image = nil
                break
            case "Confirmar Correo":
                
                ImgErrorConfCorreo.image = nil
                
                break
                
            default:
                
                break
            }
            

            
            
        }
    
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }

    
    
    
    
    
    @IBAction func registrar(sender: AnyObject) {
        
        if validar(){
        btnRegistrar.enabled = false
        let user = Usuario()
        user.nombre = txtNombres.text!
        user.apellido = txtApellidos.text!
        user.email = txtCorreo.text!
        user.password = txtPassword.text!
            

            
            let todosEndpoint: String = "http://201.168.207.17:8888/fidicard/kuff_api/regUser"
            let newTodo = ["nombre": user.nombre!, "apellido": user.apellido!, "email": user.email!, "pass" : user.password!]
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
                                
                                let id = json["id"].int ?? -1
                                user.id = id
                                
                                let destinationController = self.storyboard!.instantiateViewControllerWithIdentifier("EsperandoConfViewController") as! EsperandoConfViewController
                                
                                destinationController.user = user
                                
                                
                                self.presentViewController(destinationController, animated: true, completion: nil)
                                self.btnRegistrar.enabled = true

                                
                            }
                            else {
                                
                                let destinationController = self.storyboard!.instantiateViewControllerWithIdentifier("PopUp1BtnViewController") as! PopUp1BtnViewController
                                
                                destinationController.imageName = "desgrane_general_icon_alerta"
                                destinationController.labelText = "El correo proporcionado ya se encuentra registrado"
                                destinationController.btnText = "Cerrar"
                                destinationController.btnImage = "desgrane_general_btn_azul"
                                self.presentViewController(destinationController, animated: false, completion: nil)
                                self.btnRegistrar.enabled = true
                                
                            }
                            
                            
                        }
                        
                    }
            }
        
            
            
        }
        else {
        
            
        }
        
        
        
    }
    
    
    @IBAction func cancelar(sender: AnyObject) {
        
        let destinationController = storyboard!.instantiateViewControllerWithIdentifier("PopUp2BtnViewController") as! PopUp2BtnViewController
        
        destinationController.imageName = "desgrane_general_icon_alerta"
        destinationController.labelText = "¿Seguro que deseas cancelar tu registro?"
        destinationController.btnText1 = "SI, CONFIRMAR"
        destinationController.btnText2 = "NO, VOLVER AL REGISTRO"
        destinationController.btnImage1 = "desgrane_general_btn_rosa"
        destinationController.btnImage2 = "desgrane_general_btn_azul"
        destinationController.returntTo1 = "InicioViewController"
        destinationController.returntTo2 = "self"
        
        presentViewController(destinationController, animated: false, completion: nil)

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SelectedImage Flase
        
      NSUserDefaults.standardUserDefaults().setBool(false, forKey: "wasImageSet")
        
        
        // Gesture for removing focus
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegistroViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

        // Add button to keyboard
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        //PLaceholder Font Color
        
        txtPassword.attributedPlaceholder = NSAttributedString(string:"Password",attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
        txtNombres.attributedPlaceholder = NSAttributedString(string:"Nombre(s)",attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
        
        txtApellidos.attributedPlaceholder = NSAttributedString(string:"Apellidos",attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
        txtCorreo.attributedPlaceholder = NSAttributedString(string:"Correo",attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
        txtValidarCorreo.attributedPlaceholder = NSAttributedString(string:"Confirmar Correo",attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
        txtPassword.attributedPlaceholder = NSAttributedString(string:"Password",attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
        txtConfirmPass.attributedPlaceholder = NSAttributedString(string:"Confirmar Password",attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])




      
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
       
       
        
    }

    @IBAction func AvisoDePrivacidad(sender: AnyObject) {
        
        let destinationController = storyboard!.instantiateViewControllerWithIdentifier("AvisoDePrivacidad") as! AvisoPrivacidadViewController
        
        destinationController.howDidCalled = self.restorationIdentifier
        
        presentViewController(destinationController, animated: false, completion: nil)

    }
    
    
    func validar() -> Bool{
        
        var success = false
         if txtCorreo.text! == txtValidarCorreo.text! && txtCorreo.text! != ""{
            
          if  txtPassword.text! == txtConfirmPass.text! && txtPassword.text! != ""   {
                
                if RegistroDePrivacidadFlag {
                    
                    success = true

                    
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
          else {
            ImgErrorConfPass.image = UIImage(named: "ErrorIcon")
            ImgErrorPass.image = UIImage(named: "ErrorIcon")
            
            }
            
        }
        else {
             ImgErrorConfCorreo.image = UIImage(named: "ErrorIcon")
             ImgErrorCorreo.image = UIImage(named: "ErrorIcon")
            
        }
        
        return success
    }
    
    
    // MARK: - Manage Keyboard
    func adjustInsetForKeyboardShow(show: Bool, notification: NSNotification) {
        self.keyBoardIsVisible = show
        guard let value = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.CGRectValue()
        let adjustmentHeight = (CGRectGetHeight(keyboardFrame) + 20) * (show ? 1 : -1)
        self.scrollView.contentInset.bottom += adjustmentHeight
        self.scrollView.scrollIndicatorInsets.bottom += adjustmentHeight
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if !self.keyBoardIsVisible{
            self.adjustInsetForKeyboardShow(true, notification: notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.adjustInsetForKeyboardShow(false, notification: notification)
    }
    
    @IBAction func moveToApellidos(sender: AnyObject) {
        
        txtApellidos.becomeFirstResponder()
    }
    
    @IBAction func moveToEmail(sender: AnyObject) {
        
        txtCorreo.becomeFirstResponder()
    }
    
    @IBAction func moveToConfirmEmail(sender: AnyObject) {
        
        txtValidarCorreo.becomeFirstResponder()
    }
    
    @IBAction func moveToPWD(sender: AnyObject) {
        
        txtPassword.becomeFirstResponder()
       
    }
    
    @IBAction func moveToPWD2(sender: AnyObject) {
        
        txtConfirmPass.becomeFirstResponder()
    }
    
    @IBAction func hideKeyboard(sender: AnyObject) {
        
        
        dismissKeyboard()
        

    }
    
    
    
    

    

    
}
