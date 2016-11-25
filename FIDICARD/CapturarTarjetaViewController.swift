//
//  CapturarTarjetaViewController.swift
//  FIDICARD
//
//  Created by Martin Viruete Gonzalez on 04/10/16.
//  Copyright © 2016 oomovil. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AVFoundation

class CapturarTarjetaViewController: UIViewController, CardIOPaymentViewControllerDelegate{

    var Marca = CMarca()
    var email = ""
    var aviso = ""
    var user = Usuario()
    
    var session: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var keyBoardIsVisible = false
    
    @IBOutlet weak var fechaView: UIView!
    @IBOutlet weak var btnSolicitarTarjeta: UIButton!
    @IBOutlet weak var segmentoCaduca: UISegmentedControl!
    @IBOutlet weak var txtNoTarjeta: UITextField!
    @IBOutlet weak var txtAliasTarjeta: UITextField!
    @IBOutlet weak var txtMes: UITextField!
    @IBOutlet weak var txtAño: UITextField!
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
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgHome.userInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
        imgHome.addGestureRecognizer(tapRecognizer)
        loadUser()
        CardIOUtilities.preload()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        NSNotificationCenter.defaultCenter().addObserver(self,selector: #selector(self.keyboardWillShow(_:)),name: UIKeyboardWillShowNotification,object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,selector: #selector(self.keyboardWillHide(_:)),name: UIKeyboardWillHideNotification,object: nil)

        
        print(Marca.tipo_tarjs)
        print(Marca.tipo_tarjs)
        
        if Marca.tipo_tarjs == "VIRTUAL" {
            
           btnSolicitarTarjeta.setImage(UIImage(named: "ios_captura_btn_generar"), forState: .Normal)
            
        }
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let user = defaults.dataForKey("user") {
            
            if let usr = NSKeyedUnarchiver.unarchiveObjectWithData(user) as? Usuario {
 
                email = usr.email!
            
            
            }
            
        }

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
    
    
    func loadUser() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let user = defaults.dataForKey("user") {
            
            if let user = NSKeyedUnarchiver.unarchiveObjectWithData(user) as? Usuario {
                self.user = user
                btnBadge.setTitle(String(defaults.integerForKey("\(user.email!)badge")), forState: .Normal)
            }
            
        }
        
    }
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func regresar(sender: AnyObject) {
        
        
        if let sv = self.revealViewController(){
            
            let vc = storyboard!.instantiateViewControllerWithIdentifier("MarcaViewController") as! MarcaViewController
            vc.Marca = Marca
            //sv.pushFrontViewController(vc, animated: true)
            self.navigationController?.popViewControllerAnimated(true)
        }

        
    }

    @IBAction func openMenu(sender: AnyObject) {
        
        if let sw = self.revealViewController(){
            sw.revealToggleAnimated(true)
            self.revealViewController().rearViewRevealWidth =  self.view.frame.width * 0.85
            
        }

        
    }
    
    @IBAction func solicitarTarjeta(sender: AnyObject) {
        
        
        if Marca.tipo_tarjs == "FISICA" || Marca.tipo_tarjs == "AMBAS"  {
            if let sv = self.revealViewController(){
                
                let vc = storyboard!.instantiateViewControllerWithIdentifier("SolicitarTarjetaViewController") as! SolicitarTarjetaViewController
                    vc.marcaID = Marca.id
                    vc.Marca = Marca
                    self.navigationController?.popViewControllerAnimated(false)
                    self.navigationController?.pushViewController(vc, animated: true)
                    //sv.pushFrontViewController(vc, animated: true)
            }

        
        }else if Marca.tipo_tarjs == "VIRTUAL" {
            
            if let sv = self.revealViewController(){
                
                let vc = storyboard!.instantiateViewControllerWithIdentifier("GenerarTarjetaViewController") as! GenerarTarjetaViewController
                vc.Marca = Marca
                //sv.pushFrontViewController(vc, animated: true)
                self.navigationController?.popViewControllerAnimated(false)
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            
            
        }

    }
    
    @IBAction func tomarFoto(sender: AnyObject) {
        
        let cardIOVC = CardIOPaymentViewController(paymentDelegate: self)
        
        cardIOVC.modalPresentationStyle = .FormSheet
        cardIOVC.collectCVV = false
        cardIOVC.hideCardIOLogo = true
        cardIOVC.scanExpiry = false
        
        presentViewController(cardIOVC, animated: true, completion: nil)
        
       
        
        
    }
    
    
    func userDidCancelPaymentViewController(paymentViewController: CardIOPaymentViewController!) {
        print( "user canceled")
        paymentViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func userDidProvideCreditCardInfo(cardInfo: CardIOCreditCardInfo!, inPaymentViewController paymentViewController: CardIOPaymentViewController!) {
        if let info = cardInfo {
            //let str = NSString(format: "Received card info.\n Number: %@\n expiry: %02lu/%lu\n cvv: %@.", info.redactedCardNumber, info.expiryMonth, info.expiryYear, info.cvv)
            txtNoTarjeta.text = String(info.cardNumber)
            txtAño.text = String(info.expiryYear)
            txtMes.text = String(info.expiryMonth)
        }
        paymentViewController?.dismissViewControllerAnimated(true, completion: nil)
    }  

    
    
    
    @IBAction func avisodePrivacidad(sender: AnyObject) {
        
        
        let vc = storyboard?.instantiateViewControllerWithIdentifier("AvisoDePrivacidad") as! AvisoPrivacidadViewController
        vc.aviso = Marca.aviso_priv!
        presentViewController(vc, animated: true, completion: nil)
        
        
    }
    
    
   
    @IBAction func segmentoCambio(sender: AnyObject) {
        
        
        if segmentoCaduca.selectedSegmentIndex == 0 {
            
            fechaView.hidden = false
        }
        else {
            fechaView.hidden = true
        }

        
    }
    
    
    func validar() ->Bool {
        
    var message = ""
        
    if txtNoTarjeta.text != "" {
        
        if  txtAliasTarjeta.text != ""  {
        
            if (txtAño.text! != "" && txtMes.text! != "" && segmentoCaduca.selectedSegmentIndex == 0) || (segmentoCaduca.selectedSegmentIndex == 1){
                
                return true
                
            }
            else {
                message = "Por favor ingresa el alias de tarjeta"
            }
            
        }
        else {
            message = "Por favor selecciona una fecha de expiracion"
        }
    }
    else {
        
        message = "Por favor ingresa un numero de tarjeta"
    }
        
        let alert = UIAlertController(title: "Heads Up", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
        return false
    }
    
    
    @IBAction func añadir(sender: AnyObject) {
        
        
        if Marca.tipo_tarjs! == "FISICA" || Marca.tipo_tarjs == "AMBAS"{
        
        if validar() {
            
            
            
            // Get NSDate given the above date components
            
            
            let todosEndpoint: String = "http://201.168.207.17:8888/fidicard/kuff_api/altaTarjeta"
            
            var parameters = [String : AnyObject]()
            
            if segmentoCaduca.selectedSegmentIndex == 0 {
                
                let date = txtAño.text! + "-" + "" + txtMes.text! + "-01"
                
            parameters = ["num_tarj": txtNoTarjeta.text!, "alias": txtAliasTarjeta.text!, "marca_id": Marca.id, "email": email, "caduca" :date]
                
            }
            else {
                
            parameters = ["num_tarj": txtNoTarjeta.text!, "alias": txtAliasTarjeta.text!, "marca_id": Marca.id, "email": email]
            }
            
            
            print (parameters)
            Alamofire.request(.POST, todosEndpoint, parameters: parameters)
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
                                
                                print("Success ")
                                if let sv = self.revealViewController(){
                                    
                                    let  vc = self.storyboard?.instantiateViewControllerWithIdentifier("ConfirmTarjtVirtGenViewController") as! ConfirmTarjtVirtGenViewController
                                    
                                    vc.Marca = self.Marca
                                    vc.user = self.user
                                    vc.numTarjt = self.txtNoTarjeta.text!
                                    vc.pleca = "ios_pleca_verde"
                                    vc.titulo = "ios_titulo_generar"
                                    vc.aviso = "Tu tarjeta ha sido ingresada con Exito."
                                    
                                    
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
 
                        }
                        
                    }
                }
            }
        }
        else {
            let alert = UIAlertController(title: "Tarjeta no disponible", message: "Este tipo de marca no provee tarjetas fisicas. Puedes crear una tarjeta virtual", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    
    @IBAction func primaryKey(sender: AnyObject) {
        
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
