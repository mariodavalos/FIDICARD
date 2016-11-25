//
//  PromoMenuViewController.swift
//  FIDICARD
//
//  Created by omar on 16/09/16.
//  Copyright © 2016 oomovil. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class PromoMenuViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var topView: UIView!
    
    
    var logged: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Setting Profile Image
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
                // Roundin Profile Image
        self.profileImage!.contentMode = .ScaleAspectFill
        self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
        self.profileImage.clipsToBounds = true
        self.profileImage.contentMode = .ScaleAspectFill
        
        //Getting User from User dfaults
        
        if defaults.boolForKey("userLogged") {
           
        logged = true
        topView.hidden = false
            
        if let user = defaults.dataForKey("user") {
            
            if let user = NSKeyedUnarchiver.unarchiveObjectWithData(user) as? Usuario {
                
                lblUserName.text = user.nombre
                
                
                Alamofire.request(.GET, user.imageLink!)
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

                
            }
        }
        
        
        if defaults.boolForKey("wasImageSet")  == true
        {
            let imageData = defaults.dataForKey("profileImage")
            
            profileImage.image = UIImage(data: imageData!)
        }
        
    }
    else{
            
    logged = false
    topView.hidden = true
    
    }

    
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // Roundin Profile Image
        self.profileImage!.contentMode = .ScaleAspectFill
        self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
        self.profileImage.clipsToBounds = true
        self.profileImage.contentMode = .ScaleAspectFill
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.boolForKey("userLogged") {
            
            logged = true
        }
        else {
            logged = false
        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func logOut(sender: AnyObject) {
        
        let destinationController = storyboard!.instantiateViewControllerWithIdentifier("InicioViewController")
        
        let defauls = NSUserDefaults.standardUserDefaults()
        defauls.setBool(false, forKey: "wasImageSet")
        defauls.setBool(false, forKey: "userLogged")
        defauls.setObject(NSKeyedArchiver.archivedDataWithRootObject(Usuario()), forKey: "user")
        
        
        defauls.setObject("", forKey: "userEmail")
        defauls.setObject("", forKey: "password")
        presentViewController(destinationController, animated: true, completion: nil)
        
    }
   
    
    
    
    
    
    @IBAction func Home(sender: AnyObject) {
        
        if let sv = self.revealViewController(){
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("Home")
            sv.pushFrontViewController(vc, animated: true)
        }

       
    }
    
    
    
  
    @IBAction func MisTarjetas(sender: AnyObject) {
        
        if logged! {
            
            if let sv = self.revealViewController(){
                let vc = self.storyboard!.instantiateViewControllerWithIdentifier("MisTarjetas")
                sv.pushFrontViewController(vc, animated: true)
            }

            
        }
        else {
            
            userNotLoggedPopUp()
        }
        
       
        
    }
    
    @IBAction func MisPromociones(sender: AnyObject) {
        
        
        if logged! {
            
            if let sv = self.revealViewController(){
                let vc = self.storyboard!.instantiateViewControllerWithIdentifier("MisPromociones")
                sv.pushFrontViewController(vc, animated: true)
            }

            
            
        }
        else {
            
            userNotLoggedPopUp()
        }
        
        
        
    }
    
    @IBAction func Marcas(sender: AnyObject) {
        if let sv = self.revealViewController(){
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("MisMarcas")
            sv.pushFrontViewController(vc, animated: true)
        }

        
        
    }
    
    @IBAction func TodasLasPromociones(sender: AnyObject) {
        
        if let sv = self.revealViewController(){
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("TodasLasPromociones")
            sv.pushFrontViewController(vc, animated: true)
        }

    }
    
    
    @IBAction func editarPerfil(sender: AnyObject) {
        
        if let sv = self.revealViewController(){
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("EditarPerfilViewController")
            sv.pushFrontViewController(vc, animated: true)
        }

        
        
    }
   
    
    @IBAction func Notificaciones(sender: AnyObject) {
        
       
        if logged! {
            
            if let sv = self.revealViewController(){
                let vc = self.storyboard!.instantiateViewControllerWithIdentifier("NotificacionesViewController")
                sv.pushFrontViewController(vc, animated: true)
            }
            
        }
        else {
            userNotLoggedPopUp()
        }
        
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    func userNotLoggedPopUp() {
        
        
        let destinationController = storyboard!.instantiateViewControllerWithIdentifier("PopUp2BtnViewController") as! PopUp2BtnViewController
        
        destinationController.imageName = "desgrane_general_icon_alerta"
        destinationController.labelText = "Para tener una mejor experiencia inicia sesion o crea una cuenta"
        destinationController.btnText1 = "Ir al Inicio"
        destinationController.btnText2 = "Registrarme"
        destinationController.btnImage1 = "desgrane_general_btn_rosa"
        destinationController.btnImage2 = "desgrane_general_btn_azul"
        
        destinationController.returntTo1 = "InicioViewController"
        destinationController.returntTo2 = "RegistroViewController"
        
        presentViewController(destinationController, animated: false, completion: nil)
        
        
    }
    
    

}
