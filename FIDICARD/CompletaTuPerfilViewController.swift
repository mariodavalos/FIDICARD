//
//  CompletaTuPerfilViewController.swift
//  FIDICARD
//
//  Created by omar on 09/09/16.
//  Copyright © 2016 oomovil. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CompletaTuPerfilViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate,
UINavigationControllerDelegate,allocPopUpActionsDelegate {
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    var keyBoardIsVisible = false
    var user = Usuario()
    @IBOutlet weak var profileImage = UIImageView(frame: CGRectMake(0, 0, 100, 100))
    
    @IBOutlet weak var txtFechaNacimiento: UITextField!
    
    @IBOutlet weak var txtPAis: UITextField!
    
    @IBOutlet weak var txtEstado: UITextField!
    
    @IBOutlet weak var txtCiudad: UITextField!
   
    @IBOutlet weak var txtEstadoCivil: UITextField!
    
    @IBOutlet weak var txtOcupacion: UITextField!
    
    @IBOutlet weak var SegmentoOcupacion: UISegmentedControl!
    
    @IBOutlet weak var imageButton: UIButton!
    
    @IBOutlet weak var ViewOcupacion: UIView!
    
    @IBOutlet var superView: UIView!
    @IBOutlet weak var viewForTextFields: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var errorIconBirthDay: UIImageView!
    @IBOutlet weak var errorIconContry: UIImageView!
    @IBOutlet weak var errorIconCity: UIImageView!
    @IBOutlet weak var errorIconState: UIImageView!
    @IBOutlet weak var errorIconCivil: UIImageView!
    @IBOutlet weak var errorIconOcupation: UIImageView!
    
    
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    
    var amountIncreased : CGFloat = 0
    
    
    @IBAction func TakePhoto(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    
    
    }
    
    @IBAction func finishedEditing(sender: UITextField) {
        
        if (sender.text! == "") {
            
            switch sender.placeholder! {
                
            case "Fecha de nacimento":
                errorIconBirthDay.image = UIImage(named: "ErrorIcon")
                break
            case "País":
                
                errorIconContry.image = UIImage(named: "ErrorIcon")
                txtEstado.enabled = false
                
                break
                
            case "Ciudad":
                
                errorIconState.image = UIImage(named: "ErrorIcon")
                
                break
            case "Estado":
                
                errorIconCity.image = UIImage(named: "ErrorIcon")
                
                
                break
            case "Escribe tu ocupación":
                
                errorIconOcupation.image = UIImage(named: "ErrorIcon")
                dismissKeyboard()
                
                break
            case "Estado civil":
                
                errorIconCivil.image = UIImage(named: "ErrorIcon")
                
                
                break
            
                
            default:
                
                break
            }
            
        }
            
        else {
            
            switch sender.placeholder! {
                
            case "Fecha de nacimento":
                errorIconBirthDay.image = nil
                break
            case "País":
                
                errorIconContry.image = nil
                txtEstado.enabled = true
                
                break
                
            case "Ciudad":
                
                errorIconState.image = nil
                
                break
            case "Estado":
                
                errorIconCity.image = nil
                
                
                break
            case "Escribe tu ocupación":
                
                errorIconOcupation.image = nil
                dismissKeyboard()
                
                break
            case "Estado civil":
                
                errorIconCivil.image = nil
               
                
                break
                
                
            default:
                
                break
            }
            
            
        }
        
    }
    
    func circularImage(photoImageView: UIImageView?)
    {
        photoImageView!.contentMode = .ScaleAspectFill
        photoImageView!.layer.cornerRadius = photoImageView!.frame.width / 2
        photoImageView!.clipsToBounds = true
        photoImageView!.contentMode = .ScaleAspectFill

    }

    var paisesArray = ["México","Estados Unidos"]
    var estadoCivilArray = ["Soltero","Padre o Madre", "Casado", "Viudo", "Divorciado"]
    var estadosArray = [String]()
    var estadosIDArray = [Int]()
    var PaispickerView = UIPickerView()
    var EstadosPickerView = UIPickerView()
    var EstadoCivilPickerView = UIPickerView()
    var datePickerView = UIDatePicker()
    

        

    
    func loadingStates(paisID: Int) {
        
        Alamofire.request(.GET,"http://201.168.207.17:8888/fidicard/kuff_api/getAllStates/" + String(paisID)).responseJSON {
            (response) in
            if let data = response.data{
                
                let json = JSON(data:data)
                print("JSON: \(json)")
                if json["status"].intValue == 200 {
                    
                    let response = json["mensaje"]
                    
                    self.estadosArray.removeAll()
                    self.estadosIDArray.removeAll()
                    for index in 0..<response.count {
                        
                    
                        self.estadosArray.append(response[index]["nombre"].string ?? "Null")
                        self.estadosIDArray.append(Int(response[index]["id"].string ?? "Null")!)
                        self.EstadosPickerView.reloadComponent(0)
                        
                    }
                    
                }
                
                
            }
        }

        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // Roundinf Profile Image
        
        
        txtFechaNacimiento.attributedPlaceholder = NSAttributedString(string:"Fecha de nacimento",attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
        txtPAis.attributedPlaceholder = NSAttributedString(string:"País",attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
        txtEstado.attributedPlaceholder = NSAttributedString(string:"Estado",attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
        txtCiudad.attributedPlaceholder = NSAttributedString(string:"Ciudad",attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
        txtEstadoCivil.attributedPlaceholder = NSAttributedString(string:"Estado civil",attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
        txtOcupacion.attributedPlaceholder = NSAttributedString(string:"Ocupación",attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])






        

        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

 
        
        
        //Setting Profile Image
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        
        if defaults.boolForKey("wasImageSet")  == true
        {
            let imageData = defaults.dataForKey("profileImage")
            
            profileImage!.image = UIImage(data: imageData!)
        }

        
        
        
        // Disablieng txt Ocupacion
        txtOcupacion.enabled = false
        
        // Roundinf Profile Image
        circularImage(profileImage)
        
        
        // Keboard Setting for Date

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CompletaTuPerfilViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

          
            datePickerView.datePickerMode = UIDatePickerMode.Date
            txtFechaNacimiento.inputView = datePickerView
            datePickerView.addTarget(self, action: #selector(CompletaTuPerfilViewController.handleDatePicker(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        // Loading Estates
        loadingStates(0)
        
        // Picker Views for Pais field and Estado Field
        
        PaispickerView.delegate = self
        PaispickerView.showsSelectionIndicator = true
        PaispickerView.dataSource = self
        txtPAis.inputView = PaispickerView
        PaispickerView.tag = 0
        
        EstadosPickerView.delegate = self
        EstadosPickerView.showsSelectionIndicator = true
        EstadosPickerView.dataSource = self
        EstadosPickerView.tag = 1
        txtEstado.inputView = EstadosPickerView
        
        
        EstadoCivilPickerView.showsSelectionIndicator = true
        EstadoCivilPickerView.dataSource = self
        
        EstadoCivilPickerView.delegate = self
        txtEstadoCivil.inputView = EstadoCivilPickerView
        EstadoCivilPickerView.tag = 2
        
        dismissKeyboard()

        
        
        //PhotoStuff
        imagePicker.delegate = self
        
        // Ocupacion Stuff
        
        ViewOcupacion.hidden = true
        
        //pickerview customization part 2
        
        
        let toolBarNac = UIToolbar()
        toolBarNac.barStyle = UIBarStyle.Default
        toolBarNac.translucent = true
        toolBarNac.tintColor = UIColor(red: 4/255, green: 128/255, blue: 224/255, alpha: 1)
        toolBarNac.sizeToFit()
        
       
        
        let toolBarPais = UIToolbar()
        toolBarPais.barStyle = UIBarStyle.Default
        toolBarPais.translucent = true
        toolBarPais.tintColor = UIColor(red: 4/255, green: 128/255, blue: 224/255, alpha: 1)
        toolBarPais.sizeToFit()
        
        let toolBarEstado = UIToolbar()
        toolBarEstado.barStyle = UIBarStyle.Default
        toolBarEstado.translucent = true
        toolBarEstado.tintColor = UIColor(red: 4/255, green: 128/255, blue: 224/255, alpha: 1)
        toolBarEstado.sizeToFit()
        
        let toolBarCivil = UIToolbar()
        toolBarCivil.barStyle = UIBarStyle.Default
        toolBarCivil.translucent = true
        toolBarCivil.tintColor = UIColor(red: 4/255, green: 128/255, blue: 224/255, alpha: 1)
        toolBarCivil.sizeToFit()
        
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancelar", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CompletaTuPerfilViewController.dismissKeyboard))
        
        
                let cancelButton2 = UIBarButtonItem(title: "Cancelar", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CompletaTuPerfilViewController.dismissKeyboard))
        
                let cancelButton3 = UIBarButtonItem(title: "Cancelar", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CompletaTuPerfilViewController.dismissKeyboard))
        
                let cancelButton4 = UIBarButtonItem(title: "Cancelar", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CompletaTuPerfilViewController.dismissKeyboard))
        
        
        let doneButton = UIBarButtonItem(title: "Siguiente", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CompletaTuPerfilViewController.donePaisPicker))
        toolBarPais.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBarPais.userInteractionEnabled = true
        txtPAis.inputAccessoryView = toolBarPais
        
        
        
        
        toolBarEstado.items?.removeAll()
        let doneEstadosButton = UIBarButtonItem(title: "Siguiente", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CompletaTuPerfilViewController.doneEstadosPicker))
        toolBarEstado.setItems([cancelButton4, spaceButton, doneEstadosButton], animated: false)
        toolBarEstado.userInteractionEnabled = true
        txtEstado.inputAccessoryView = toolBarEstado
        
       
        
        toolBarCivil.items?.removeAll()
        let doneCivilButton = UIBarButtonItem(title: "Fin", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CompletaTuPerfilViewController.doneCivilPicker))
        
        toolBarCivil.setItems([cancelButton2, spaceButton, doneCivilButton], animated: false)
        toolBarCivil.userInteractionEnabled = true
        txtEstadoCivil.inputAccessoryView = toolBarCivil
        
        
        
        toolBarNac.items?.removeAll()
        let doneNacButton = UIBarButtonItem(title: "Siguiente", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CompletaTuPerfilViewController.doneNacimientoPicker))
        toolBarNac.setItems([cancelButton3, spaceButton, doneNacButton], animated: false)
        toolBarNac.userInteractionEnabled = true
        txtFechaNacimiento.inputAccessoryView = toolBarNac
        
        //Keaybord will show and hide
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        
        
        
       
        
    }
    
    override func viewWillAppear(animated: Bool) {
        circularImage(profileImage)
    }
    
    func donePaisPicker(){
        
        print("done Pais")
        
        if txtPAis.text! == ""{
         
            txtPAis.text = paisesArray[0]
            loadingStates(1)
            txtEstado.enabled = true
            user.pais =  1
        }
        
        txtEstado.becomeFirstResponder()
        
     
    }
    func doneEstadosPicker(){
        
        print("done Estado")
        
        if txtEstado.text! == ""{
            
            txtEstado.text = estadosArray[0]
            user.estado = 1
        }
        
        txtCiudad.becomeFirstResponder()
        

        
    }
    func doneCivilPicker(){
        
        if txtEstadoCivil.text! == "" {
            
            txtEstadoCivil.text = estadoCivilArray[0]
            user.estadoCivil = 1
        }
        print("done civil")
        dismissKeyboard()

    }
    func doneNacimientoPicker(){
        
       print("done nacimiento")
        txtPAis.becomeFirstResponder()
            }
       
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    
    func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        txtFechaNacimiento.text = dateFormatter.stringFromDate(sender.date)
    }
    
    @IBAction func siguiente(sender: AnyObject) {
        
        
        if validar() {
         
         user.fechaDeNacimiento = txtFechaNacimiento.text!
        
         user.ciudad = txtCiudad.text!
         user.estadoNombre = txtEstado.text!
         //user.estadoCivil = txtEstadoCivil.text!
         user.ocupacion = txtOcupacion.text!
         user.ocupacionArray = SegmentoOcupacion.selectedSegmentIndex + 1
         let destinationController = storyboard!.instantiateViewControllerWithIdentifier("CompletarTuPerfil2ViewController") as! CompletarTuPerfil2ViewController
         destinationController.user = user
            
         presentViewController(destinationController, animated: true, completion: nil)
        }

        
    }
    

    @IBAction func Cancelar(sender: AnyObject) {
        
        /*
        let destinationController = storyboard!.instantiateViewControllerWithIdentifier("PopUp2BtnViewController") as! PopUp2BtnViewController
        
        destinationController.imageName = "desgrane_general_icon_alerta"
        destinationController.labelText = "¿Seguro que deseas salir de completar tu registro"
        destinationController.btnText1 = "SI, LO HARÉ DESPUÉS"
        destinationController.btnText2 = "NO, VOLVER AL REGISTRO"
        destinationController.btnImage1 = "desgrane_general_btn_rosa"
        destinationController.btnImage2 = "desgrane_general_btn_azul"
        destinationController.returntTo2 = "self"
        destinationController.returntTo1 = "HomeView"
        presentViewController(destinationController, animated: false, completion: nil)*/
        
        let destinationController = storyboard!.instantiateViewControllerWithIdentifier("PopUp2BtnViewController") as! PopUp2BtnViewController
        destinationController.delegate = self
        destinationController.imageName = "desgrane_general_icon_alerta"
        destinationController.labelText = "¿Seguro que deseas salir de completar tu registro"
        destinationController.btnText1 = "SI, LO HARÉ DESPUÉS"
        destinationController.btnText2 = "NO, VOLVER AL REGISTRO"
        destinationController.btnImage1 = "desgrane_general_btn_rosa"
        destinationController.btnImage2 = "desgrane_general_btn_azul"
        destinationController.returntTo2 = "self"
        destinationController.returntTo1 = "HomeView"
        presentViewController(destinationController, animated: false, completion: nil)
        
    }
    
    func action1() {
        
    //LogOut
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(Usuario()), forKey: "user")
        defaults.setBool(false, forKey: "userLogged")
        defaults.setObject(false, forKey: "wasImageSet")
        defaults.setObject("", forKey: "userEmail")
        defaults.setObject("", forKey: "password")
        
        defaults.synchronize()
        dismissViewControllerAnimated(true, completion: nil)
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("InicioViewController") as! InicioViewController
        presentViewController(vc, animated: true, completion: nil)
    
        
        
    }
    func action2() {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView.tag == 0 {
            
            return paisesArray.count
        }
        else if pickerView.tag == 1 {
            return estadosArray.count
        }
        else  {
            return estadoCivilArray.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView.tag == 0 {
            
            return paisesArray[row]
        }
        else if pickerView.tag == 1 {
            
            return estadosArray[row]
        }
        else {
            
            return estadoCivilArray[row]
        }

    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        

       
        
        if pickerView.tag == 0 {
            
            if paisesArray[row] == "México"{
            
                loadingStates(1)
            }
            else {
                loadingStates(2)
            }
            user.pais = row + 1
            return txtPAis.text =  paisesArray[row]
        }
        else if pickerView.tag == 1 {
            
            user.estado = estadosIDArray[row]
            return txtEstado.text = estadosArray[row]
        }
        else {
            user.estadoCivil = row + 1
            return txtEstadoCivil.text = estadoCivilArray[row]
        }

    }
    
    @IBAction func cambioOcupacionSgmento(sender: AnyObject) {
        
        if SegmentoOcupacion.selectedSegmentIndex == 2 {
            
            txtOcupacion.enabled = true
            ViewOcupacion.hidden = false
        }
        else {
            txtOcupacion.enabled = false
            ViewOcupacion.hidden = true
        }
        
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
        
        
        }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImage!.contentMode = .ScaleAspectFill
            profileImage!.image = pickedImage
            
            let img = pickedImage
            
            
            let defaults = NSUserDefaults.standardUserDefaults()
            let imageData = UIImagePNGRepresentation(img)
            defaults.setObject(imageData, forKey: "profileImage")
            defaults.setBool(true, forKey: "wasImageSet")
            defaults.synchronize()
            
            imageButton.setImage(UIImage(named: "desgrane_registro_btn_seleccionar"), forState: .Normal)
            
            
        

        }
        
        else {
            
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(false, forKey: "wasImageSet")
            defaults.synchronize()}
        
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func validar () -> Bool {
        
        if txtFechaNacimiento.text != "" {
            
            if txtPAis.text != "" {
                
                if txtCiudad.text != "" {
                    
                    if txtEstado.text != "" {
                        
                        if txtEstadoCivil.text != "" {
                            
                            return true
                        }
                        else {  errorIconCivil.image = UIImage(named: "ErrorIcon")}
                    }
                    else {  errorIconCity.image = UIImage(named: "ErrorIcon")}
                }
                else {  errorIconState.image = UIImage(named: "ErrorIcon")}
                
            }
            else {  errorIconContry.image = UIImage(named: "ErrorIcon")}
           
        } else {  errorIconBirthDay.image = UIImage(named: "ErrorIcon")}
        
    
        return false
    }
    
    /*
    
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

    */
    
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

       

    
    @IBAction func CiudadEntered(sender: AnyObject) {
        
        
        txtEstadoCivil.becomeFirstResponder()

    }
    
    
    @IBAction func finishOcupacionPrimaryKey(sender: AnyObject) {
        
        dismissKeyboard()
    }
    
    

    

}
