//
//  GenerarTarjetaViewController.swift
//  FIDICARD
//
//  Created by Miguel Jimenez on 10/12/16.
//  Copyright © 2016 oomovil. All rights reserved.
//

import UIKit
import SWRevealViewController
import Alamofire
import AlamofireImage
import SwiftyJSON
import Haneke

class GenerarTarjetaViewController: UIViewController, allocStandardTableDelegate {
    
    var Marca = CMarca()
    var user = Usuario()
    
    var totalEstadosDicionary = [Int : String]()
    var estadosMexico = [String]()
    var estadosUSA = [String]()
    var paisesArray = [ 1: "México", 2 : "Estados Unidos"]
    var paisesArreglo = ["México","Estados Unidos"]
    var keyBoardIsVisible = false
    
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtApellido: UITextField!
    @IBOutlet weak var txtCOrreo: UITextField!
    @IBOutlet weak var txtTelefono: UITextField!
    @IBOutlet weak var txtDomicilio: UITextField!
    @IBOutlet weak var txtPais: UITextField!
    @IBOutlet weak var txtEstado: UITextField!
    @IBOutlet weak var txtCiudad: UITextField!
    @IBOutlet weak var marcaImg: UIImageView!
    @IBOutlet weak var imgHome: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    
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
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        // Do any additional setup after loading the view.
        loadUser()
        loadingAllstates()                       
        imgHome.userInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
        imgHome.addGestureRecognizer(tapRecognizer)
        
        marcaImg.hnk_setImageFromURL(NSURL(string: Marca.img_sfondo)!)
        marcaImg.contentMode = .ScaleAspectFill
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GenerarTarjetaViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self,selector: #selector(self.keyboardWillShow(_:)),name: UIKeyboardWillShowNotification,object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,selector: #selector(self.keyboardWillHide(_:)),name: UIKeyboardWillHideNotification,object: nil)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   override func viewWillAppear(animated: Bool) {
    
    }
    
   
    
    @IBAction func openMenu(sender: AnyObject) {
        
        if let sw = self.revealViewController(){
            sw.revealToggleAnimated(true)
            self.revealViewController().rearViewRevealWidth =  self.view.frame.width * 0.85
        }
    }
    
    
    func gettingUserDetails() {
        
        let todosEndpoint: String = "http://201.168.207.17:8888/fidicard/kuff_api/getUserPerfil"
        
        
        
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
                                    
                                    self.user.nombre = json["perfil"][0]["nombre"].string ?? ""
                                    self.user.apellido = json["perfil"][0]["apellido"].string ?? ""
                                    self.user.fechaDeNacimiento = json["perfil"][0]["fecha_nac"].string ?? ""
                                    self.user.password = json["perfil"][0]["pass"].string ?? ""
                                    self.user.pais = Int(json["perfil"][0]["pais_id"].string ?? "-1")!
                                    
                                    self.user.estado = Int(json["perfil"][0]["estado_id"].string ?? "-1")!
                                    self.user.ciudad = json["perfil"][0]["ciudad"].string ?? ""
                                    self.user.ocupacion = json["perfil"][0]["otra_ocup"].string ?? ""
                                    
                                    if let nombre = self.user.nombre {
                                        
                                        self.txtNombre.text = nombre
                                        self.txtApellido.text = self.user.apellido!
                                        self.txtCOrreo.text = self.user.email!
                                        self.txtCiudad.text = self.user.ciudad!
                                        self.txtPais.text = self.paisesArray[self.user.pais]
                                        self.txtEstado.text = self.totalEstadosDicionary[self.user.estado]
   
                                    }
                                    else {
                                        print("Usuario Vacio")
                                    }

                                    
                                    
                                }
                                else {
                                    
                                    print ("Error")
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
    

    @IBAction func regresar(sender: AnyObject) {
        
        if let sv = self.revealViewController(){
            
            let  vc = self.storyboard?.instantiateViewControllerWithIdentifier("MarcaViewController") as! MarcaViewController
            
            vc.Marca = self.Marca
            //sv.pushFrontViewController(vc, animated: true)
            self.navigationController?.popViewControllerAnimated(true)
        }

        
    }
    
    
    @IBAction func generar(sender: AnyObject) {
        
        
        if validar() {
        
        user.nombre! = txtNombre.text!
        user.apellido! = txtApellido.text!
        user.ciudad = txtCiudad.text!
        user.telefono = txtTelefono.text!
        user.domicilio = txtDomicilio.text!
        //user.pais = Int(txtPais.text!)!
        //user.estado = Int(txtEstado.text!)!
        
        
        let todosEndpoint: String = "http://201.168.207.17:8888/fidicard/kuff_api/generarTarjeta"
        
        var newTodo = [String : AnyObject]()
        
        newTodo = ["email": user.email!, "alias": Marca.nombre,"marca_id": Marca.id,"nombre":user.nombre!,"apellido":user.apellido!,"tel": txtTelefono.text!,"dom": txtDomicilio.text!,"pais":txtPais.text!,"estado": txtEstado.text!, "ciudad": txtCiudad.text!]
        print (newTodo)
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
                            
                            
                            if let sv = self.revealViewController(){
                                
                                 let  vc = self.storyboard?.instantiateViewControllerWithIdentifier("ConfirmTarjtVirtGenViewController") as! ConfirmTarjtVirtGenViewController
                                
                                vc.Marca = self.Marca
                                vc.user = self.user
                                vc.aviso = "¡Tu tarjeta virtual ha sido generada con éxito!"
                                vc.pleca = "ios_pleca_verde"
                                vc.fromGenerar = true
                                
                                vc.titulo = "ios_titulo_capturar"
                                vc.numTarjt = json["num_tarj"].string ?? "null"
                                
                                let defaults = NSUserDefaults.standardUserDefaults()
                                
                                if let obj = defaults.objectForKey("\(self.user.email!)misMarcasID") {
                                    
                                    var misMarcas = obj as! [Int]
                                    misMarcas.append(self.Marca.id!)
                                    defaults.setObject(misMarcas, forKey: "\(self.user.email!)misMarcasID")
                                    defaults.synchronize()
                                }
                                
                                

                                //sv.pushFrontViewController(vc, animated: true)
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                            
                            
                        }
                        else {
                            
                            let alert = UIAlertController(title: "Tarjeta no se pudo generar", message: "Ya cuentas con una tarjeta virtual para esta marca", preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.Default, handler: nil))
                            self.presentViewController(alert, animated: true, completion: nil)

                        }
                        
                        
                    }
                    
                }
                
                
                
        }
        
        }

    }
    
    
    
    func validar()-> Bool {
        
        if txtPais.text! != "" && txtCiudad.text! != "" && txtCOrreo.text! != "" && txtEstado.text! != "" && txtNombre.text! != "" && txtApellido.text! != ""{
            
            
            return true
            
            
        }
        let alert = UIAlertController(title: "Heads Up", message: "Por favor ingresa todos los campos", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
        return false
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    @IBAction func startEditingPais(sender: AnyObject) {
        
       
        
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
    


   
    @IBAction func startEditingEstado(sender: AnyObject) {
    }
}

extension GenerarTarjetaViewController: UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        let  vc = self.storyboard?.instantiateViewControllerWithIdentifier("dashboardTarjetasListViewController") as! dashboardTarjetasListViewController
        
        if textField.tag == 1{
        vc.titulo = "Selecciona Tu Páis"
        vc.arreglo = paisesArreglo
        vc.delegate = self
        vc.senderInput = "pais"
        presentViewController(vc, animated: true, completion: nil)
            
        }
        else if textField.tag == 2 {
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
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func goToMarcas(sender: AnyObject) {
        
        if let sv = self.revealViewController(){
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("MisMarcas")
            sv.pushFrontViewController(vc, animated: true)
            
            
        }
        
    }
    
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
    
    @IBAction func nombrePrimaryAction(sender: AnyObject) {
        
        txtApellido.becomeFirstResponder()
    }
    
    @IBAction func telefgonoPrimaryAction(sender: AnyObject) {
        
        txtDomicilio.becomeFirstResponder()
    }
    
    @IBAction func paisPrimaryAction(sender: AnyObject) {
        
        txtEstado.becomeFirstResponder()
    }
    
    
    @IBAction func estadoPrimaryAction(sender: AnyObject) {
        txtCiudad.becomeFirstResponder()
    }
    
    
    @IBAction func ciudadPrimaryAction(sender: AnyObject) {
        
        self.view.endEditing(true)
    }
    
    
    
    @IBAction func apellidoPrimaryAction(sender: AnyObject) {
        
        txtCOrreo.becomeFirstResponder()
    }
    
    
    @IBAction func correoPrimaryAction(sender: AnyObject) {
        
        txtTelefono.becomeFirstResponder()
    }
    
    @IBAction func domiciloPrimaryAcition(sender: AnyObject) {
        
        txtPais.becomeFirstResponder()
    }

    

    
}
