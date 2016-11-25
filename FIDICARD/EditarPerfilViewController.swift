//
//  EditarPerfilViewController.swift
//  FIDICARD
//
//  Created by Martin Viruete Gonzalez on 30/09/16.
//  Copyright © 2016 oomovil. All rights reserved.
//

import UIKit
import SWRevealViewController
import Alamofire
import SwiftyJSON
import AlamofireImage


class EditarPerfilViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate,UIPickerViewDataSource {
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtApellido: UITextField!
    @IBOutlet weak var txtCorreo: UITextField!
    @IBOutlet weak var txtFechaNacimiento: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtDomicilio: UITextField!
    @IBOutlet weak var txtPais: UITextField!
    @IBOutlet weak var txtEstado: UITextField!
    @IBOutlet weak var txtCiudad: UITextField!
    @IBOutlet weak var txtOcupacion: UITextField!
    @IBOutlet weak var segmentoOcupacion: UISegmentedControl!
    @IBOutlet weak var viewOcupacion: UIView!

    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    
    
    var keyBoardIsVisible = false
    var user = Usuario()
    var paisesArray = [ 1: "México", 2 : "Estados Unidos"]
    var TipoOcupacionDictionary = [ 1: "TRABAJO",2 : "ESTUDIO", 3 : "OTRO"]
    var totalEstadosDicionary = [Int : String]()
    var estadosMexico = [String]()
    var estadosUSA = [String]()
    var datePickerView = UIDatePicker()
    var PaispickerView = UIPickerView()
    var EstadosPickerView = UIPickerView()
    
    
    @IBOutlet weak var btnBadge: UIButton!
    
    
    @IBAction func goToNotificaciones(sender: AnyObject) {
        
        if let sv = self.revealViewController() {
            
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("NotificacionesViewController") as! NotificacionesViewController
            sv.pushFrontViewController(vc, animated: true)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentoOcupacion.layer.cornerRadius = segmentoOcupacion.frame.size.height * 0.5
        
        self.profileImage!.contentMode = .ScaleAspectFill
        self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
        self.profileImage.clipsToBounds = true
        self.profileImage.contentMode = .ScaleAspectFill
        loadingAllstates()
        customizePickersView()
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
         viewOcupacion.hidden = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditarPerfilViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        datePickerView.datePickerMode = UIDatePickerMode.Date
        txtFechaNacimiento.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(EditarPerfilViewController.handleDatePicker(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        
        let toolBarNac = UIToolbar()
        toolBarNac.barStyle = UIBarStyle.Default
        toolBarNac.translucent = true
        toolBarNac.tintColor = UIColor(red: 4/255, green: 128/255, blue: 224/255, alpha: 1)
        toolBarNac.barStyle = .Default
        toolBarNac.sizeToFit()
        
        
        let cancelButton3 = UIBarButtonItem(title: "Cancelar", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(EditarPerfilViewController.dismissKeyboard))
                let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)

        
        
        toolBarNac.items?.removeAll()
        let doneNacButton = UIBarButtonItem(title: "Siguiente", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(EditarPerfilViewController.doneNacimientoPicker))
        toolBarNac.setItems([cancelButton3, spaceButton, doneNacButton], animated: false)
        toolBarNac.userInteractionEnabled = true
        txtFechaNacimiento.inputAccessoryView = toolBarNac
        
        
        self.profileImage!.contentMode = .ScaleAspectFill
        self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
        self.profileImage.clipsToBounds = true
        self.profileImage.contentMode = .ScaleAspectFill

        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        print("voy a aparecer")
        //Making Image Circular
        self.profileImage!.contentMode = .ScaleAspectFill
        self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
        self.profileImage.clipsToBounds = true
        self.profileImage.contentMode = .ScaleAspectFill

        // Rounding Segment
       // segmentoOcupacion.layer.cornerRadius = segmentoOcupacion.frame.size.width/2
        //segmentoOcupacion.clipsToBounds = true
        
        
    }
    func customizePickersView(){
        
        
        PaispickerView.delegate = self
        PaispickerView.showsSelectionIndicator = true
        PaispickerView.dataSource = self
        txtPais.inputView = PaispickerView
        PaispickerView.tag = 0
        
        EstadosPickerView.delegate = self
        EstadosPickerView.showsSelectionIndicator = true
        EstadosPickerView.dataSource = self
        EstadosPickerView.tag = 1
        txtEstado.inputView = EstadosPickerView
        
        
        let toolBarPais = UIToolbar()
        toolBarPais.barStyle = UIBarStyle.Default
        toolBarPais.translucent = true
        toolBarPais.tintColor = UIColor(red: 4/255, green: 128/255, blue: 224/255, alpha: 1)
        toolBarPais.sizeToFit()
        toolBarPais.barStyle = .Default
        
        let toolBarEstado = UIToolbar()
        toolBarEstado.barStyle = UIBarStyle.Default
        toolBarEstado.translucent = true
        toolBarEstado.tintColor = UIColor(red: 4/255, green: 128/255, blue: 224/255, alpha: 1)
        toolBarEstado.sizeToFit()
        toolBarEstado.barStyle = .Default
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancelar", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(EditarPerfilViewController.dismissKeyboard))
        
        
        let cancelButton4 = UIBarButtonItem(title: "Cancelar", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(EditarPerfilViewController.dismissKeyboard))
        
        
        let doneButton = UIBarButtonItem(title: "Siguiente", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(EditarPerfilViewController.donePaisPicker))
        toolBarPais.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBarPais.userInteractionEnabled = true
        txtPais.inputAccessoryView = toolBarPais
        
        
        toolBarEstado.items?.removeAll()
        let doneEstadosButton = UIBarButtonItem(title: "Siguiente", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(EditarPerfilViewController.doneEstadosPicker))
        toolBarEstado.setItems([cancelButton4, spaceButton, doneEstadosButton], animated: false)
        toolBarEstado.userInteractionEnabled = true
        txtEstado.inputAccessoryView = toolBarEstado
        
        
        
        //customize Text fields
        
        customizeTExtFields()
        


        

        
    }
    
    
    func customizeTExtFields() {
        
        let toolBar: UIToolbar = UIToolbar()
        toolBar.barStyle = .Default
        toolBar.barTintColor = UIColor(red: 4/255, green: 128/255, blue: 224/255, alpha: 1)
        toolBar.sizeToFit()
        
        var barItems = [UIBarButtonItem]()
        
        let flexSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil)
        barItems.insert(flexSpace, atIndex: 0)
        
        let cancelButton5 = UIBarButtonItem()
        cancelButton5.title = "Siguiente"
        cancelButton5.target = self
        cancelButton5.style = UIBarButtonItemStyle.Plain
        cancelButton5.action = #selector(self.doneNombre)
        cancelButton5.tintColor = UIColor.whiteColor()
        barItems.insert(cancelButton5, atIndex: 1)
        toolBar.setItems(barItems, animated: false)
        self.txtNombre.inputAccessoryView = toolBar
        
        
        let toolBar2: UIToolbar = UIToolbar()
        toolBar2.barStyle = .Default
        toolBar2.barTintColor = UIColor(red: 4/255, green: 128/255, blue: 224/255, alpha: 1)
        toolBar2.sizeToFit()
        
        var barItems2 = [UIBarButtonItem]()
        
        let flexSpace2: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil)
        barItems2.insert(flexSpace2, atIndex: 0)
        
        let cancelButton2 = UIBarButtonItem()
        cancelButton2.title = "Siguiente"
        cancelButton2.target = self
        cancelButton2.style = UIBarButtonItemStyle.Plain
        cancelButton2.action = #selector(self.doneApellido)
        cancelButton2.tintColor = UIColor.whiteColor()
        barItems2.insert(cancelButton2, atIndex: 1)
        
        toolBar2.setItems(barItems2, animated: false)
        self.txtApellido.inputAccessoryView = toolBar2
        
        
        
        let toolBar3: UIToolbar = UIToolbar()
        toolBar3.barStyle = .Default
        toolBar3.barTintColor = UIColor(red: 4/255, green: 128/255, blue: 224/255, alpha: 1)
        toolBar3.sizeToFit()
        
        var barItems3 = [UIBarButtonItem]()
        
        let flexSpace3: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil)
        barItems3.insert(flexSpace3, atIndex: 0)
        
        let cancelButton3 = UIBarButtonItem()
        cancelButton3.title = "Aceptar"
        cancelButton3.target = self
        cancelButton3.style = UIBarButtonItemStyle.Plain
        cancelButton3.action = #selector(self.donePassword)
        cancelButton3.tintColor = UIColor.whiteColor()
        barItems3.insert(cancelButton3, atIndex: 1)
        
        toolBar3.setItems(barItems3, animated: false)
        self.txtPassword.inputAccessoryView = toolBar3
        
        
        
        let toolBar4: UIToolbar = UIToolbar()
        toolBar4.barStyle = .Default
        toolBar4.barTintColor = UIColor(red: 4/255, green: 128/255, blue: 224/255, alpha: 1)
        toolBar4.sizeToFit()
        
        var barItems4 = [UIBarButtonItem]()
        
        let flexSpace4: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil)
        barItems4.insert(flexSpace4, atIndex: 0)
        
        let cancelButton4 = UIBarButtonItem()
        cancelButton4.title = "Aceptar"
        cancelButton4.target = self
        cancelButton4.style = UIBarButtonItemStyle.Plain
        cancelButton4.action = #selector(self.donePassword)
        cancelButton4.tintColor = UIColor.whiteColor()
        barItems4.insert(cancelButton4, atIndex: 1)
        toolBar4.setItems(barItems4, animated: false)
        self.txtPassword.inputAccessoryView = toolBar4
        
        
        let toolBar6: UIToolbar = UIToolbar()
        toolBar6.barStyle = .Default
        toolBar6.barTintColor = UIColor(red: 4/255, green: 128/255, blue: 224/255, alpha: 1)
        toolBar6.sizeToFit()
        
        var barItems6 = [UIBarButtonItem]()
        
        let flexSpace6: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil)
        barItems6.insert(flexSpace6, atIndex: 0)
        
        let cancelButton6 = UIBarButtonItem()
        cancelButton6.title = "Aceptar"
        cancelButton6.target = self
        cancelButton6.style = UIBarButtonItemStyle.Plain
        cancelButton6.action = #selector(self.doneConfirmPassword)
        cancelButton6.tintColor = UIColor.whiteColor()
        barItems6.insert(cancelButton6, atIndex: 1)
        
        toolBar6.setItems(barItems6, animated: false)
        self.txtConfirmPassword.inputAccessoryView = toolBar6
        
        
        
        
        
        
        
    }
 
    
    func doneNacimientoPicker(){
        
        print("done nacimiento")
        txtPassword.becomeFirstResponder()
        
    }
    
    func doneNombre(){
        print("done doneNombre")
        txtApellido.becomeFirstResponder()
    }
    
    func doneApellido(){
        
        txtFechaNacimiento.becomeFirstResponder()
        
    }
    
    func donePassword(){
        
        txtConfirmPassword.becomeFirstResponder()
        
    }
    
    func doneConfirmPassword(){
        
        txtPais.becomeFirstResponder()
        
    }
    
    func doneCiudad(){
        
        segmentoOcupacion.becomeFirstResponder()
        
    }
    
    
    func donePaisPicker(){
        
        print("done Pais")
        EstadosPickerView.reloadAllComponents()
        EstadosPickerView.reloadInputViews()
        txtEstado.becomeFirstResponder()
        
    }
    func doneEstadosPicker(){
        
        print("done Estado")
        EstadosPickerView.reloadAllComponents()
        txtCiudad.becomeFirstResponder()
        
    }


    
    func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        txtFechaNacimiento.text = dateFormatter.stringFromDate(sender.date)
    }

    
    func gettingUserDetails() {
        
        let todosEndpoint: String = "http://201.168.207.17:8888/fidicard/kuff_api/getUserPerfil"
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let user = defaults.dataForKey("user") {
            
            if let user = NSKeyedUnarchiver.unarchiveObjectWithData(user) as? Usuario {
                
                btnBadge.setTitle(String(defaults.integerForKey("\(user.email!)badge")), forState: .Normal)
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
                                    
                                    var ocupacionIndex = self.findKeyForValue(json["perfil"][0]["tipo_ocupacion"].string!, dictionary: self.TipoOcupacionDictionary)
                                    ocupacionIndex -= 1

                                    if ocupacionIndex >= 0 {
                                        self.segmentoOcupacion.setEnabled(true, forSegmentAtIndex: ocupacionIndex )}
                                    
                                    self.txtNombre.text = user.nombre!
                                    self.txtApellido.text = user.apellido!
                                    self.txtCorreo.text = user.email!
                                    self.txtFechaNacimiento.text = user.fechaDeNacimiento
                                    self.txtPassword.text = "paswrod pwejosdgdsfg"
                                    self.txtConfirmPassword.text = "paswrod pwejosdgdsfg"
                                    self.txtPais.text = self.paisesArray[user.pais]
                                    //self.loadingStates(user.pais)
                                    print(self.totalEstadosDicionary)
                                    print(self.totalEstadosDicionary[user.estado])
                                    self.txtEstado.text = self.totalEstadosDicionary[user.estado]
                                    self.txtOcupacion.text = user.ocupacion
                                    self.txtCiudad.text = user.ciudad
                                    
     
                                    if self.txtPassword.text! == "" {
                                        
                                        self.txtPassword.enabled = false
                                        self.txtConfirmPassword.enabled = false
                                        user.fb_reg = true
                                    }
                                    
                                    
                                    Alamofire.request(.GET, json["perfil"][0]["imagen"].string ?? "")
                                        .responseImage { response in
                                            debugPrint(response)
                                            
                                            print(response.request)
                                            print(response.response)
                                            debugPrint(response.result)
                                            
                                            if let image = response.result.value {
                                                print("image downloaded: \(image)")
                                                self.profileImage.image = image
                                                self.profileImage!.contentMode = .ScaleAspectFill
                                                self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
                                                self.profileImage.clipsToBounds = true
                                                self.profileImage.contentMode = .ScaleAspectFill
                                            }
                                    }

                                    
                                    
                                    
                                    
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
    
    @IBAction func TakePhoto(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }

        
        
    }
    
    
    
    
    func circularImage(photoImageView: UIImageView?)
    {
        photoImageView!.layer.frame = CGRectInset(photoImageView!.layer.frame, 0, 0)
        photoImageView!.layer.borderColor = UIColor.grayColor().CGColor
        
        //photoImageView!.layer.masksToBounds = false
        photoImageView!.layer.cornerRadius = CGFloat(roundf(Float(self.profileImage!.frame.size.width/2.0)))
        // photoImageView!.layer.masksToBounds = false
        photoImageView!.clipsToBounds = true
        photoImageView!.layer.borderWidth = 0.5
        photoImageView!.contentMode = UIViewContentMode.ScaleAspectFill
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImage!.contentMode = .ScaleAspectFill
            profileImage!.image = pickedImage
            
        }
            
        else {
            
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(false, forKey: "wasImageSet")
            defaults.synchronize()}
        
            dismissViewControllerAnimated(true, completion: nil)
        }
    
    @IBAction func EditNombreBegin(sender: AnyObject) {
        
        txtNombre.textColor = UIColor(red: 4/255, green: 128/255, blue: 224/255, alpha: 1)

        
    }
    
    
    @IBAction func EditNombreEnded(sender: AnyObject) {
        
        txtNombre.textColor = UIColor.grayColor()
        
        
    }
    
    @IBAction func EditApellidoBegin(sender: AnyObject) {
        
        txtApellido.textColor = UIColor(red: 4/255, green: 128/255, blue: 224/255, alpha: 1)
    }
    
    @IBAction func EditApellidoEnded(sender: AnyObject) {
        
        txtApellido.textColor = UIColor.grayColor()

    }
    
    
    @IBAction func EdicNacBegin(sender: AnyObject) {
        
        txtFechaNacimiento.textColor = UIColor(red: 4/255, green: 128/255, blue: 224/255, alpha: 1)
    
    }
    
    @IBAction func EditNacEnded(sender: AnyObject) {
        
        txtFechaNacimiento.textColor = UIColor.grayColor()
    }
    
    @IBAction func EditPWDBegin(sender: AnyObject) {
        
        txtPassword.textColor = UIColor(red: 4/255, green: 128/255, blue: 224/255, alpha: 1)
    }
    
    @IBAction func EditPWDENded(sender: AnyObject) {
        txtPassword.textColor = UIColor.grayColor()
        
    }
    
    @IBAction func EditConfPWDBegin(sender: AnyObject) {
        
        txtConfirmPassword.textColor = UIColor(red: 4/255, green: 128/255, blue: 224/255, alpha: 1)
    }
    
    @IBAction func EditConfPWFEnded(sender: AnyObject) {
        txtConfirmPassword.textColor = UIColor.grayColor()
    }
    
    @IBAction func EditPaisBegin(sender: AnyObject) {
        
        txtPais.textColor = UIColor(red: 4/255, green: 128/255, blue: 224/255, alpha: 1)
    }
    
    @IBAction func EditPaisEnded(sender: AnyObject) {
        txtPais.textColor = UIColor.grayColor()
    }
    
    @IBAction func EditEstadoBegin(sender: AnyObject) {
        txtEstado.textColor = UIColor(red: 4/255, green: 128/255, blue: 224/255, alpha: 1)
    }
    
    @IBAction func EditEstadoEnded(sender: AnyObject) {
         txtEstado.textColor = UIColor.grayColor()
    }
    
    @IBAction func EditCiudadBegin(sender: AnyObject) {
        txtCiudad.textColor = UIColor(red: 4/255, green: 128/255, blue: 224/255, alpha: 1)
    }
    
    @IBAction func EditCiudadEnded(sender: AnyObject) {
        txtCiudad.textColor = UIColor.grayColor()
    }
    
    @IBAction func EditOtroBegin(sender: AnyObject) {
        txtOcupacion.textColor = UIColor(red: 4/255, green: 128/255, blue: 224/255, alpha: 1)
    }
    
    @IBAction func EditOtroEnded(sender: AnyObject) {
        txtOcupacion.textColor = UIColor.grayColor()
    }
    
    func findKeyForValue(value: String, dictionary:[Int: String]) ->Int
    {
        for (key, string) in dictionary
        {
            if (string == value)
            {
                return key
            }
        }
        
        return 0
    }
    
    @IBAction func Guardar(sender: AnyObject) {
        
        if validar() {
        user.nombre! = txtNombre.text!
        user.apellido! = txtApellido.text!
        user.fechaDeNacimiento = txtFechaNacimiento.text!
        user.password = txtPassword.text!
        user.ocupacion = txtOcupacion.text!
        user.ciudad = txtCiudad.text!

        user.estado = findKeyForValue(txtEstado.text!, dictionary: totalEstadosDicionary)
        user.pais = findKeyForValue(txtPais.text!, dictionary: paisesArray)
        user.ocupacionArray = segmentoOcupacion.selectedSegmentIndex+1
        let image = ResizeImage(profileImage.image!, targetSize: CGSizeMake(500.0, 500.0))
        let imageData = UIImagePNGRepresentation(image)
        
        
        let todosEndpoint: String = "http://201.168.207.17:8888/fidicard/kuff_api/updatePerfil2"
        
       // var newTodo = [String : AnyObject]()
        
        //newTodo = ["email": user.email!,"fecha_nac": user.fechaDeNacimiento, "pais_id": user.pais, "estado_id": user.estado, "ciudad" : user.ciudad,"estciv_id": user.estadoCivil, "ocup_id" : user.ocupacionArray, "otra_ocup": user.ocupacion,"nombre": user.nombre!,"apellido": user.apellido!, "pass": user.password!]
        
        Alamofire.upload(
            .POST,
            todosEndpoint,
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(data: imageData!, name: "imagen", fileName: "file.png", mimeType: "image/png")
                multipartFormData.appendBodyPart(data: self.user.email!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"email")
                multipartFormData.appendBodyPart(data: self.user.fechaDeNacimiento .dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"fecha_nac")
                multipartFormData.appendBodyPart(data: String(self.user.pais).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"pais_id")
                multipartFormData.appendBodyPart(data:String(self.user.estado).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"estado_id")
                multipartFormData.appendBodyPart(data: String(self.user.ciudad).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"ciudad")
                multipartFormData.appendBodyPart(data: String(self.user.estadoCivil).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"estciv_id")
                
                multipartFormData.appendBodyPart(data: String(self.user.ocupacionArray).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"ocup_id")
                
                multipartFormData.appendBodyPart(data: String(self.user.ocupacion).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"otra_ocup")
                
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                    }
                    
                    
                    NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(self.user), forKey: "user")
                    let destinationController = self.storyboard!.instantiateViewControllerWithIdentifier("PopUp1BtnViewController") as! PopUp1BtnViewController
                    
                    
                    destinationController.imageName = "desgrane_general_icon_succes"
                    destinationController.labelText = "Hemos actualizado tu perfil"
                    destinationController.btnText = "CERRAR"
                    destinationController.btnImage = "desgrane_general_btn_azul"
                    let defaults = NSUserDefaults.standardUserDefaults()
                    let imageData = UIImagePNGRepresentation(self.profileImage.image!)
                    defaults.setObject(imageData, forKey: "profileImage")
                    self.presentViewController(destinationController, animated:true, completion: nil)
                    
                    break
                case .Failure(let encodingError):
                    print(encodingError)
                }
            }
        )

        }

        
        
    }
    
    func ResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
        } else {
            newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    

    func validarEmpty() -> Bool{
        
        
        
        
        
        return true
    }

    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    func keyboardWillShow(notification: NSNotification) {
        if !self.keyBoardIsVisible{
            self.adjustInsetForKeyboardShow(true, notification: notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.adjustInsetForKeyboardShow(false, notification: notification)
    }
    
    
    func adjustInsetForKeyboardShow(show: Bool, notification: NSNotification) {
        self.keyBoardIsVisible = show
        guard let value = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.CGRectValue()
        let adjustmentHeight = (CGRectGetHeight(keyboardFrame) + 20) * (show ? 1 : -1)
        self.scrollView.contentInset.bottom += adjustmentHeight
        self.scrollView.scrollIndicatorInsets.bottom += adjustmentHeight
    }
    
    
    
    @IBAction func NombrePrimaryAction(sender: AnyObject) {
        
        
        dismissKeyboard()
    }
    
    
    @IBAction func PrimaryActionApellido(sender: AnyObject) {
        
        dismissKeyboard()
        
    }
    
    
    @IBAction func PasswordPrimiaryAction(sender: AnyObject) {
        dismissKeyboard()
    }
    
    @IBAction func ConfirmPasswordPrimaryAction(sender: AnyObject) {
        
        dismissKeyboard()
    }
    
    @IBAction func CiudadPrimaryAction(sender: AnyObject) {
        dismissKeyboard()
    }
    
    @IBAction func OtroPrimaryAction(sender: AnyObject) {
        
        dismissKeyboard()
    }
    
    @IBAction func EditingPais(sender: AnyObject) {
    }
    
    @IBAction func EditingEstado(sender: AnyObject) {
    }
    
    @IBAction func EditingFechaNacimiento(sender: AnyObject) {
        
        
        
    }
    
    

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView.tag == 0 {
            
            return paisesArray.count
        }
        if pickerView.tag == 1 {
            if txtPais.text! == "México"{
            
                return estadosMexico.count
            
            }
            if txtPais.text! == "Estados Unidos" {
               return  estadosUSA.count
            }
            
        }
        return 0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
        if pickerView.tag == 0 {
            EstadosPickerView.reloadAllComponents()
            return paisesArray[row+1]
        }
        if pickerView.tag == 1 {
            if txtPais.text! == "México"{
                
                return estadosMexico[row]
                
            }
           if txtPais.text! == "Estados Unidos" {
              return  estadosUSA[row]
            }

        }
        return "NUll"
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        
        
        if pickerView.tag == 0 {
            
            EstadosPickerView.reloadAllComponents()
            user.pais = row + 1
            return txtPais.text =  paisesArray[row+1]
        }
        else if pickerView.tag == 1 {
            
            if txtPais.text! == "México"{
                
               return   txtEstado.text! = estadosMexico[row]
                
            }
            if txtPais.text! == "Estados Unidos"  {
                return txtEstado.text! =   estadosUSA[row]
            }

        }
       
        
    }
    
    @IBAction func cambioOcupacionSgmento(sender: AnyObject) {
        
        if segmentoOcupacion.selectedSegmentIndex == 2 {
            
            txtOcupacion.enabled = true
            viewOcupacion.hidden = false
        }
        else {
            txtOcupacion.enabled = false
            viewOcupacion.hidden = true
        }
        
    }
    
    func validar() -> Bool{
        
        
        
        
        
        
        if txtNombre.text! != "" && txtApellido.text! != "" && txtFechaNacimiento.text != "" && txtPais.text! != "" && txtEstado.text! != "" {
            
            
            
            if user.fb_reg {
                
                return true
            }
            if !user.fb_reg && txtPassword.text! != "" && txtPassword.text! == txtConfirmPassword.text!{
                return true
            }
            else {
                let destinationController = storyboard?.instantiateViewControllerWithIdentifier("PopUp1BtnViewController") as! PopUp1BtnViewController
                destinationController.imageName = "desgrane_general_icon_alerta"
                destinationController.labelText = "Por favor Verifica que tus contraseñas coincidan"
                destinationController.btnText = "CERRAR"
                destinationController.btnImage = "desgrane_general_btn_azul"
                presentViewController(destinationController, animated: true, completion: nil)
            }
        }
        else{
            
            let destinationController = storyboard?.instantiateViewControllerWithIdentifier("PopUp1BtnViewController") as! PopUp1BtnViewController
            destinationController.imageName = "desgrane_general_icon_alerta"
            destinationController.labelText = "Por favor acegurate que todos los campos esten llenos"
            destinationController.btnText = "CERRAR"
            destinationController.btnImage = "desgrane_general_btn_azul"
            presentViewController(destinationController, animated: true, completion: nil)
        }
        
        
        return false
    }
    
    @IBAction func cancelar(sender: AnyObject) {
        
        let destinationController = storyboard?.instantiateViewControllerWithIdentifier("HomeView")
        presentViewController(destinationController!, animated: true, completion: nil)
        
        
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
    @IBAction func goToMarcas(sender: AnyObject) {
        
        if let sv = self.revealViewController(){
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("MisMarcas")
            sv.pushFrontViewController(vc, animated: true)
            
            
        }
        

    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    
    @IBAction func goToInicio(sender: AnyObject) {
        
        if let sv = self.revealViewController(){
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("Home")
            sv.pushFrontViewController(vc, animated: true)
        }
        
    }
    
        
}
    

