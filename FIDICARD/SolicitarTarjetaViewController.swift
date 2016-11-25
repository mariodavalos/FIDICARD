//
//  SolicitarTarjetaViewController.swift
//  FIDICARD
//
//  Created by Martin Viruete Gonzalez on 04/10/16.
//  Copyright © 2016 oomovil. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SWRevealViewController
import Haneke

class SolicitarTarjetaViewController: UIViewController, allocStandardTableDelegate {

    
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtApellido: UITextField!
    @IBOutlet weak var txtCorreo: UITextField!
    @IBOutlet weak var txtTelefono: UITextField!
    @IBOutlet weak var txtPais: UITextField!
    @IBOutlet weak var txtEstado: UITextField!
    @IBOutlet weak var txtCiudad: UITextField!
    @IBOutlet weak var txtDomicilio: UITextField!
    @IBOutlet weak var imgMarca: UIImageView!
    @IBOutlet weak var imgHome: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    var marcaID = 0
    var Marca = CMarca()
    var totalEstadosDicionary = [Int : String]()
    var estadosMexico = [String]()
    var estadosUSA = [String]()
    var paisesArray = [ 1: "México", 2 : "Estados Unidos"]
    var paisesArreglo = ["México", "Estados Unidos"]
    var user = Usuario()
    var keyBoardIsVisible = false
    
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
    
    func loadUser() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let user = defaults.dataForKey("user") {
            
            if let user = NSKeyedUnarchiver.unarchiveObjectWithData(user) as? Usuario {
                self.user = user
                btnBadge.setTitle(String(defaults.integerForKey("\(user.email!)badge")), forState: .Normal)
                
            }
            
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadUser()
        imgHome.userInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
        imgHome.addGestureRecognizer(tapRecognizer)
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SolicitarTarjetaViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        NSNotificationCenter.defaultCenter().addObserver(self,selector: #selector(self.keyboardWillShow(_:)),name: UIKeyboardWillShowNotification,object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,selector: #selector(self.keyboardWillHide(_:)),name: UIKeyboardWillHideNotification,object: nil)
        
            loadingAllstates()
        imgMarca.hnk_setImageFromURL(NSURL(string: Marca.img_sfondo)!)
        imgMarca.contentMode = .ScaleAspectFill

    }
    
    override func viewWillAppear(animated: Bool) {
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func abrirMenu(sender: AnyObject) {
        
        
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
    
    // MARK: - deinit
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    

    
    
    

    @IBAction func regresar(sender: AnyObject) {
        
        
        if let sv = self.revealViewController(){
            
            let  vc = self.storyboard?.instantiateViewControllerWithIdentifier("MarcaViewController") as! MarcaViewController
            
            vc.Marca = self.Marca
            //sv.pushFrontViewController(vc, animated: true)
            self.navigationController?.popViewControllerAnimated(true)
        }
    
    }
    
    @IBAction func solicitar(sender: AnyObject) {
        
        if validar() {
        
        user.nombre! = txtNombre.text!
        user.apellido! = txtApellido.text!
        user.ciudad = txtCiudad.text!
        user.telefono = txtTelefono.text!
        user.domicilio = txtDomicilio.text!
        //user.pais = Int(txtPais.text!)!
        //user.estado = Int(txtEstado.text!)!
        
        
        let todosEndpoint: String = "http://201.168.207.17:8888/fidicard/kuff_api/solicitarTarjeta"
        
        var newTodo = [String : AnyObject]()
        
        newTodo = ["email": user.email!, "pais": txtPais.text!, "estado": txtEstado.text!, "ciudad" : user.ciudad,"nombre": user.nombre!,"apellido": user.apellido!,"marca_id": String(marcaID), "tel": user.telefono, "dom": user.domicilio]
        print (newTodo)
        Alamofire.request(.POST, todosEndpoint, parameters: newTodo as? [String : AnyObject])
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
                            
                            
                            if let sv = self.revealViewController(){
                                let  vc = self.storyboard?.instantiateViewControllerWithIdentifier("SolTarjetaEnviadaViewController") as! SolTarjetaEnviadaViewController
                                
                                vc.Marca = self.Marca
                                vc.user = self.user
    
                                 self.navigationController?.pushViewController(vc, animated: true)
                               // sv.pushFrontViewController(vc, animated: true)
                            }

 
                        }
                        
                        
                    }
                    
                }
                
                
                
        }
        
        }

        
    }
    
    
    func gettingUserDetails() {
        
        let todosEndpoint: String = "http://201.168.207.17:8888/fidicard/kuff_api/getUserPerfil"
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let user = defaults.dataForKey("user") {
            
            if let user = NSKeyedUnarchiver.unarchiveObjectWithData(user) as? Usuario {
                
                
                let newTodo = ["email": String(user.email!)]
                
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
                                    
                                    user.nombre = json["perfil"][0]["nombre"].string ?? ""
                                    user.apellido = json["perfil"][0]["apellido"].string ?? ""
                                    user.fechaDeNacimiento = json["perfil"][0]["fecha_nac"].string ?? ""
                                    user.password = json["perfil"][0]["pass"].string ?? ""
                                    user.pais = Int(json["perfil"][0]["pais_id"].string ?? "-1")!
                                    
                                    user.estado = Int(json["perfil"][0]["estado_id"].string ?? "-1")!
                                    user.ciudad = json["perfil"][0]["ciudad"].string ?? ""
                                    user.ocupacion = json["perfil"][0]["otra_ocup"].string ?? ""
                                    
                                    
                                    
                                    self.txtNombre.text = user.nombre!
                                    self.txtApellido.text = user.apellido!
                                    self.txtCorreo.text = user.email!
                                    self.txtCiudad.text = user.ciudad!
                                    self.txtPais.text = self.paisesArray[user.pais]
                                    self.txtEstado.text = self.totalEstadosDicionary[user.estado]
                                    
                                    self.user = user
                                    
                                   
                                }
                                else {
                                    
                                    print ("Error")
                                }
                            }
                        }
                }
            }
        }
        
        
        
        
        
    }
    
    func loadingAllstates(){
        
        Alamofire.request(.GET,"http://201.168.207.17:8888/fidicard/kuff_api/getAllStates/" + String("1")).responseJSON {
            (response) in
            if let data = response.data{
                
                let json = JSON(data:data)
                print("JSON: \(json)")
                if json["status"].intValue == 200 {
                    
                    let response = json["mensaje"]
                    
                    self.totalEstadosDicionary.removeAll()
                    for index in 0..<response.count {
                        
                        let indice = Int(response[index]["id"].string ?? "Null")!
                        let data = response[index]["nombre"].string ?? "Null"
                        self.totalEstadosDicionary[indice] = data
                        self.estadosMexico.append(data)
                    }
                    
                }
                
            }
        }
        Alamofire.request(.GET,"http://201.168.207.17:8888/fidicard/kuff_api/getAllStates/" + String("2")).responseJSON {
            (response) in
            if let data = response.data{
                
                let json = JSON(data:data)
                print("JSON: \(json)")
                if json["status"].intValue == 200 {
                    
                    let response = json["mensaje"]
                    for index in 0..<response.count {
                        
                        let indice = Int(response[index]["id"].string ?? "Null")!
                        let data = response[index]["nombre"].string ?? "Null"
                        self.totalEstadosDicionary[indice] = data
                        self.estadosUSA.append(data)
                    }
                    print(self.totalEstadosDicionary)
                    self.gettingUserDetails()
                }
                
                
            }
        }
        
        
        
        
    }
    

    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func validar()-> Bool {
        
        if txtPais.text! != "" && txtCiudad.text! != "" && txtCorreo.text! != "" && txtEstado.text! != "" && txtNombre.text! != "" && txtApellido.text! != "" && txtTelefono.text! != "" && txtDomicilio.text! != ""{
            
            
            return true
            
            
        }
        
        let alert = UIAlertController(title: "Heads Up", message: "Por favor ingresa todos los campos", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)

        return false
        
    }

    
    func returnOptionSelected(selectionIndex: Int,Selection: String, senderInput: String){
        
        print(selectionIndex, Selection)
        if senderInput == "pais" {
            txtPais.text = Selection
            txtEstado.becomeFirstResponder()
        }
        if senderInput == "estado" {
            txtEstado.text = Selection
            txtCiudad.becomeFirstResponder()
        }
        
        
    }
    
    @IBAction func goToMarcas(sender: AnyObject) {
        
        if let sv = self.revealViewController(){
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("MisMarcas")
            sv.pushFrontViewController(vc, animated: true)
            
            
        }
        
    }


    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    
}

extension SolicitarTarjetaViewController: UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        let  vc = self.storyboard?.instantiateViewControllerWithIdentifier("dashboardTarjetasListViewController") as! dashboardTarjetasListViewController
        
        if textField == txtPais{
            vc.titulo = "Selecciona Tu Páis"
            vc.arreglo = paisesArreglo
            vc.delegate = self
            vc.senderInput = "pais"
            presentViewController(vc, animated: true, completion: nil)
            
        }
        else if textField == txtEstado {
            vc.senderInput = "estado"
            vc.titulo = "Selecciona tu Estado"
            if txtPais.text! == "México" {
                vc.arreglo = estadosMexico
                vc.delegate = self
                presentViewController(vc, animated: true, completion: nil)
                
            }
            else if txtPais.text == "Estados Unidos"{
                vc.arreglo = estadosUSA
                vc.delegate = self
                presentViewController(vc, animated: true, completion: nil)
                
            }
        }
        return false
    }
    
    
    @IBAction func nombrePrimaryAction(sender: AnyObject) {
        
        txtApellido.becomeFirstResponder()
    }
    
    @IBAction func telefgonoPrimaryAction(sender: AnyObject) {
        
        txtPais.becomeFirstResponder()
    }
    
    @IBAction func paisPrimaryAction(sender: AnyObject) {
        
        txtEstado.becomeFirstResponder()
    }
    
    
    @IBAction func estadoPrimaryAction(sender: AnyObject) {
        txtCiudad.becomeFirstResponder()
    }
    
    
    @IBAction func ciudadPrimaryAction(sender: AnyObject) {
        
        txtDomicilio.becomeFirstResponder()
    }
    
    
    
    @IBAction func apellidoPrimaryAction(sender: AnyObject) {
        
        txtCorreo.becomeFirstResponder()
    }
    
    
    @IBAction func correoPrimaryAction(sender: AnyObject) {
        
        txtTelefono.becomeFirstResponder()
    }
    
    @IBAction func domiciloPrimaryAcition(sender: AnyObject) {
        
        self.dismissKeyboard()
    }
    
    
    
    
}
