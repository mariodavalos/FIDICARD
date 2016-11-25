//
//  SolTarjetaEnviadaViewController.swift
//  FIDICARD
//
//  Created by Martin Viruete Gonzalez on 04/10/16.
//  Copyright © 2016 oomovil. All rights reserved.
//

import UIKit
import SWRevealViewController
import Haneke

class SolTarjetaEnviadaViewController: UIViewController {

    var user = Usuario()
    var Marca = CMarca()
    
    @IBOutlet weak var lblNombreUsuario: UILabel!
    @IBOutlet weak var imgHome: UIImageView!
    
    @IBOutlet weak var marcaImg: UIImageView!
    
    
    
    @IBOutlet weak var btnBadge: UIButton!
    
    func loadUser() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let user = defaults.dataForKey("user") {
            
            if let user = NSKeyedUnarchiver.unarchiveObjectWithData(user) as? Usuario {
                self.user = user
                btnBadge.setTitle(String(defaults.integerForKey("\(user.email!)badge")), forState: .Normal)
                
            }
            
        }
        
    }
    
    
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
        loadUser()
        imgHome.userInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
        imgHome.addGestureRecognizer(tapRecognizer)

        
        marcaImg.hnk_setImageFromURL(NSURL(string: Marca.img_sfondo)!)
        marcaImg.contentMode = .ScaleAspectFill
        lblNombreUsuario.text = user.nombre!
        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SolicitarTarjetaViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func volverAInicio(sender: AnyObject) {
        
        
        if let sv = self.revealViewController(){
            
            let views = self.navigationController!.viewControllers as Array
            if views.first!.isKindOfClass(SlideOutMenUIViewController){
                
                    self.navigationController?.popToRootViewControllerAnimated(true)
            }
            else {
             
                let  vc = self.storyboard?.instantiateViewControllerWithIdentifier("HomeView")
                sv.pushFrontViewController(vc, animated: true)
            }
        }

        
    }

    @IBAction func irDetallesMarca(sender: AnyObject) {
        
        if let sv = self.revealViewController(){
            
            let  vc = self.storyboard?.instantiateViewControllerWithIdentifier("MarcaViewController") as! MarcaViewController
            
            //vc.Marca = self.Marca
            //sv.pushFrontViewController(vc, animated: true)
            
            
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKindOfClass(MarcaViewController) {
                    self.navigationController?.popToViewController(controller as! MarcaViewController, animated: true)
                    break
                }
            }

        }
    }
    
    
    @IBAction func openMenu(sender: AnyObject) {
        
        if let sw = self.revealViewController(){
            sw.revealToggleAnimated(true)
            self.revealViewController().rearViewRevealWidth =  self.view.frame.width * 0.85
        }

    }
    
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
