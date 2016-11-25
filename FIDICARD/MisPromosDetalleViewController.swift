//
//  MisPromosDetalleViewController.swift
//  FIDICARD
//
//  Created by Martin Viruete Gonzalez on 25/10/16.
//  Copyright © 2016 oOMovil. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SWRevealViewController
import SwiftyJSON

class MisPromosDetalleViewController: UIViewController, UIWebViewDelegate {

    
    var promocion = CPromocion()
    var tarjeta = CTarjeta()
    @IBOutlet weak var promoImage: UIImageView!
    @IBOutlet weak var lblTitulo: UILabel!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var btnWeb: UIButton!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgHome: UIImageView!
    @IBOutlet weak var btnPromoLiked: UIButton!
    
    
    var MarcasDownloaded = [CMarca]()
    var delegate : allocModifyMarcasArray!
    var marcasDidLoad: Bool!
    var user = Usuario()
    var senderVC = ""
    var padreSenderVC = ""
    var abueloSenderVC = ""
    var i1 = 0
    var i2 = 0
    var filter = false
    var myContext = 0
    var internet : Bool!
    
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

        internet = Reachability.isConnectedToNetwork()
        
        loadUser()
        lblTitulo.text = promocion.titulo
        btnWeb.setTitle(promocion.link_promo, forState: .Normal)
        webView.delegate = self
        let cuerpo = "<font face='calibri' size='3px'>" + promocion.cuerpo + "</font>"
        webView.loadHTMLString(cuerpo, baseURL: nil)
        webView.scrollView.indicatorStyle = .White
        webView.backgroundColor = UIColor.whiteColor()
        webView.opaque = false
        
        if let favo = promocion.favorita {
            
            if favo {
                
                btnPromoLiked.setImage(UIImage(named: "desgrane_carrusel_icon_fav_on"), forState: .Normal)
            }
            else {
                
                btnPromoLiked.setImage(UIImage(named: "desgrane_carrusel_icon_fav_offgray"), forState: .Normal)
            }
            
        }
        else {
            btnPromoLiked.setImage(UIImage(named: "desgrane_carrusel_icon_fav_offgray"), forState: .Normal)
            promocion.favorita = false
        }
                
        if internet! {
        Alamofire.request(.GET, promocion.imagen)
            .responseImage { response in
                debugPrint(response)
                
                debugPrint(response.result)
                
                if let image = response.result.value {
                    print("image downloaded: \(image)")
                    self.promoImage.image = image
                    self.promoImage.contentMode = .ScaleToFill
                }
            }
        }
        
        else {
            
            self.promoImage.image = UIImage(data: promocion.imagenData)
            self.promoImage.contentMode = .ScaleToFill
        }
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        

        
        
    }
    
    
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
       // webView.frame.size.height = 1
       // webView.frame.size = webView.sizeThatFits(CGSizeZero)
       webView.scrollView.scrollEnabled = false
        heightConstraint.constant = webView.scrollView.contentSize.height - self.view.frame.size.height * 0.15
        webView.backgroundColor = UIColor.whiteColor()
    }
    
    
    
    @IBAction func verRestricciones(sender: AnyObject) {
        
        let vc = storyboard!.instantiateViewControllerWithIdentifier("RestriccionesPromocionViewController") as! RestriccionesPromocionViewController
        vc.marcaLink = MarcasDownloaded[i1].img_sfondo
        vc.restriccion = promocion.restriccciones
        presentViewController(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func openURL(sender: AnyObject) {
        
        // UIApplication.sharedApplication().openURL(NSURL(string: promocion.link_promo)!)
        UIApplication.sharedApplication().openURL(NSURL(string: "http://ww.google.com")!)
    }
    
    
    @IBAction func regresar(sender: AnyObject) {
        
        /*
        switch senderVC {
        case "SlideOutMenUIViewController":
            
            if let sv = self.revealViewController(){
                let vc = self.storyboard!.instantiateViewControllerWithIdentifier("SlideOutMenUIViewController")
                sv.pushFrontViewController(vc, animated: true)
            }
            
        case "MisPromocionesViewController":
            if let sv = self.revealViewController(){
                let vc = self.storyboard!.instantiateViewControllerWithIdentifier("MisPromocionesViewController") as! MisPromocionesViewController
                vc.marcasDidLoad = true
                vc.MarcasDownloaded = MarcasDownloaded
                vc.MarcasArray = MarcasDownloaded
                vc.filter = filter
                sv.pushFrontViewController(vc, animated: true)
            }
            break
            
        case "Promos1ViewController":
            
            if let sv = self.revealViewController(){
                let vc = self.storyboard!.instantiateViewControllerWithIdentifier("Promos1ViewController") as! Promos1ViewController
                vc.tarjeta = self.tarjeta
                vc.senderID = padreSenderVC
                vc.padreSenderID = abueloSenderVC
                sv.pushFrontViewController(vc, animated: true)
            }
            
            
            
            break
            
        default:
            break
            
        }
        */
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    @IBAction func openMenu(sender: AnyObject) {
        
        if let sw = self.revealViewController(){
            sw.revealToggleAnimated(true)
            self.revealViewController().rearViewRevealWidth =  self.view.frame.width * 0.85
            

        }
    }
    
    func marcaViewed() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let user = defaults.dataForKey("user") {
            
            if let user = NSKeyedUnarchiver.unarchiveObjectWithData(user) as? Usuario {
                
                
                
                let todosEndpoint: String = "http://201.168.207.17:8888/fidicard/kuff_api/sumaVistaPromocion"
                let newTodo = ["promo_id": String(promocion.id),"email": user.email!]
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
                                    
                                    print("Promocion Marcada como vista")
                                    
                                    
                                }
                                else {
                                    print("Promocion ya visitada")
                                    
                                }
                                
                            }
                            
                        }
                }
                
            }
            
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
    
    
    @IBAction func promoLiked(sender: AnyObject) {
        
       /*
        if filter {
            
            if let object = NSUserDefaults.standardUserDefaults().objectForKey("\(user.email!)promosFavoritasIDs") {
                
                var promosFavoritasIDs  = object as! [Int]
                if promosFavoritasIDs.contains(MarcasDownloaded[i1].promociones2![i2].id!){
                    
                    promosFavoritasIDs.removeAtIndex(promosFavoritasIDs.indexOf(MarcasDownloaded[i1].promociones2![i2].id!)!)
                    NSUserDefaults.standardUserDefaults().setObject(promosFavoritasIDs, forKey: "\(user.email!)promosFavoritasIDs")
                    NSUserDefaults.standardUserDefaults().synchronize()
                }
                
            }
            self.delegate.deletePromoFromArray(i1, i2: i2)
            self.navigationController?.popViewControllerAnimated(true)
        }
        
        else {*/
            
            if promocion.favorita! {
                
                btnPromoLiked.setImage(UIImage(named: "desgrane_carrusel_icon_fav_offgray"), forState: .Normal)
                promocion.favorita = false
                self.delegate.updatePromosIDArray(false, id: promocion.id, i1: i1, i2: i2)
            }
            else {
                btnPromoLiked.setImage(UIImage(named: "desgrane_carrusel_icon_fav_on"), forState: .Normal)
                promocion.favorita = true
                self.delegate.updatePromosIDArray(true, id: promocion.id, i1: i1, i2: i2)
            }
            
            /*
            print(user.email)
            let defaults = NSUserDefaults.standardUserDefaults()
            if let objeto = defaults.objectForKey("\(user.email!)promosFavoritasIDs") {
                
                var promosFavoritasIDs = objeto as! [Int]
                print(promosFavoritasIDs)
                if promosFavoritasIDs.contains(promocion.id!) && !promocion.favorita! {
                    
                    promosFavoritasIDs.removeAtIndex(promosFavoritasIDs.indexOf(promocion.id!)!)
                    
                }
                    
                else if !promosFavoritasIDs.contains(promocion.id!) && promocion.favorita!{
                    promosFavoritasIDs.append(promocion.id!)
                }
                print(promosFavoritasIDs)
                //defaults.setObject(promosFavoritasIDs, forKey: "\(user.email!)promosFavoritasIDs")
                
                 NSUserDefaults.standardUserDefaults().setObject(promosFavoritasIDs, forKey: "\(user.email!)promosFavoritasIDs")
                defaults.synchronize()*/
        

        
    }
    
    @IBAction func goToSucursales(sender: AnyObject) {
        
        if internet! {
        
        if let sv = self.revealViewController(){
            
            let  vc = self.storyboard?.instantiateViewControllerWithIdentifier("SucursalesViewController") as! SucursalesViewController
            vc.sucursales = MarcasDownloaded[i1].promociones2![i2].en_sucurs
            vc.Marca = MarcasDownloaded[i1]
            vc.promocion = self.promocion
            vc.i1 = self.i1
            vc.i2 = self.i2
            //sv.pushFrontViewController(vc, animated: true)
             self.navigationController?.pushViewController(vc, animated: true)
        }
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
        //logged = defaults.boolForKey("userLogged")
        
    }
    


    
    

}
