//
//  InformacionMarcaViewController.swift
//  FIDICARD
//
//  Created by Martin Viruete Gonzalez on 04/10/16.
//  Copyright © 2016 oomovil. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class InformacionMarcaViewController: UIViewController, UIWebViewDelegate {

   

    @IBOutlet weak var lblUbicacion: UILabel!
    //@IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var imagenMarca: UIImageView!
    @IBOutlet weak var webViewInfo: UIWebView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnTelefono: UIButton!
    @IBOutlet weak var btnWeb: UIButton!
    @IBOutlet weak var imgHome: UIImageView!
    
    
    var senderVC = ""
    var nombre: String!
    var ubicacion: String!
    var telefonos: String!
    var web: String!
    var info: String!
    var Marca = CMarca()
    var tarjeta = CTarjeta()
    var padreSenderVC = ""
    
    
    @IBOutlet weak var btnBadge: UIButton!
    
    
    @IBAction func goToNotificaciones(sender: AnyObject) {
        
        if let sv = self.revealViewController() {
            
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("NotificacionesViewController") as! NotificacionesViewController
            sv.pushFrontViewController(vc, animated: true)
        }
    }
    
    func loadUser() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let user = defaults.dataForKey("user") {
            
            if let user = NSKeyedUnarchiver.unarchiveObjectWithData(user) as? Usuario {
                btnBadge.setTitle(String(defaults.integerForKey("\(user.email!)badge")), forState: .Normal)
                
            }
            
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
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        lblUbicacion.text = ubicacion
        btnTelefono.setTitle(telefonos, forState: .Normal)
        btnWeb.setTitle(web, forState: .Normal)
        //lblInfo.text = info
        webViewInfo.delegate = self
        let cuerpo = "<font face='calibri' size='3px' color='#555555'>" + info + "</font>"
        
        webViewInfo.loadHTMLString(cuerpo, baseURL: nil)
        webViewInfo.scrollView.indicatorStyle = .White
        webViewInfo.backgroundColor = UIColor.clearColor()
        webViewInfo.opaque = false

        
        
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        // webView.frame.size.height = 1
        // webView.frame.size = webView.sizeThatFits(CGSizeZero)
        webViewInfo.scrollView.scrollEnabled = false
        heightConstraint.constant = webViewInfo.scrollView.contentSize.height - self.view.frame.size.height * 0.16
        webViewInfo.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        let url = Marca.img_sfondo
        
        
        Alamofire.request(.GET, url)
            .responseImage { response in
                debugPrint(response)
                
                print(response.request)
                print(response.response)
                debugPrint(response.result)
                
                if let imageDownloaded = response.result.value {
                    print("image downloaded: \(imageDownloaded)")
                    self.imagenMarca.image = imageDownloaded
                    
                }
                else {
                    self.imagenMarca.image = UIImage(named: "ios_general_icn_nofound" )
                    
                }
                
                self.imagenMarca.contentMode = .ScaleAspectFit
                
                
                
        }
        
        
        
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func `return`(sender: AnyObject) {
        
        /*
        switch senderVC {
        case "MarcaViewController":
            
            if let sv = self.revealViewController(){
                
                let  vc = self.storyboard?.instantiateViewControllerWithIdentifier("MarcaViewController") as! MarcaViewController
                
                vc.Marca = self.Marca
                sv.pushFrontViewController(vc, animated: true)
            }
            break
            
            
        case "DetalleTarjFisicaViewController":
            
            if let sv = self.revealViewController(){
                let  vc = self.storyboard?.instantiateViewControllerWithIdentifier("DetalleTarjFisicaViewController") as! DetalleTarjFisicaViewController
                vc.tarjeta = tarjeta
                vc.senderVC = padreSenderVC
                sv.pushFrontViewController(vc, animated: true)
            }
            break
        case "detalleTarjtVirtualViewController":
            
            if let sv = self.revealViewController(){
                let  vc = self.storyboard?.instantiateViewControllerWithIdentifier("detalleTarjtVirtualViewController") as! detalleTarjtVirtualViewController
                vc.tarjeta = tarjeta
                vc.senderVC = padreSenderVC
                sv.pushFrontViewController(vc, animated: true)
            }
            
            break
            
        default:
            break
        }*/
        
        self.navigationController?.popViewControllerAnimated(true)

        
    }
    
    @IBAction func callNumber(sender: AnyObject) {
     
        UIApplication.sharedApplication().openURL(NSURL(string: "telprompt://\(telefonos)")!)

        
    }
    
    @IBAction func goToWeb(sender: AnyObject) {
        
        UIApplication.sharedApplication().openURL(NSURL(string: "http://" + self.web)!)
    }
    
   
    @IBAction func openMenu(sender: AnyObject) {
        
        if let sw = self.revealViewController(){
            sw.revealToggleAnimated(true)
            self.revealViewController().rearViewRevealWidth =  self.view.frame.width * 0.85

        }
        
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
