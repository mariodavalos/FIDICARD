//
//  TodasLasPromosDetalleViewController.swift
//  FIDICARD
//
//  Created by Martin Viruete Gonzalez on 10/10/16.
//  Copyright © 2016 oomovil. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SWRevealViewController
import SwiftyJSON

class TodasLasPromosDetalleViewController: UIViewController, UIWebViewDelegate {

    var senderVC = ""
    var promocion = CPromocion()
    var tarjeta = CTarjeta()
    @IBOutlet weak var promoImage: UIImageView!
    @IBOutlet weak var lblTitulo: UILabel!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var lblWeb: UILabel!
    @IBOutlet weak var btnPromoLiked : UIButton!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgHome: UIImageView!
    
    
    var i1 = 0
    var i2 = 0
    var MarcasDownloaded = [CMarca]()
    var marcasDidLoad: Bool!
    var Marca = CMarca()
    var user = Usuario()
    var padreSenderVC = ""
    var abueloSenderVC = ""
    var tataSenderVC = ""
    var canAdd: Bool!
    var internet : Bool!
    var delegate : allocModifyMarcasArray!
    
    
    func imageTapped(img: AnyObject)
    {
        if let sv = self.revealViewController(){
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("Home")
            sv.pushFrontViewController(vc, animated: true)
        }
        
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        internet = Reachability.isConnectedToNetwork()
        imgHome.userInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
        imgHome.addGestureRecognizer(tapRecognizer)
        marcaViewed()
        loadUser()
        lblTitulo.text = promocion.titulo
        lblWeb.text = promocion.link_promo
        webView.delegate = self
        
        let cuerpo = "<font face='calibri' size='3px'>" + promocion.cuerpo + "</font>"
        
        webView.loadHTMLString(cuerpo, baseURL: nil)
        webView.scrollView.indicatorStyle = .White
        webView.backgroundColor = UIColor.whiteColor()
        webView.opaque = false
        if internet!{
            
        
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
            
            if let datos = promocion.imagenData{
                
                promoImage.image = UIImage(data: datos)
            }
            
        }
        
        
       
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
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
        
        
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        // webView.frame.size.height = 1
        // webView.frame.size = webView.sizeThatFits(CGSizeZero)
        webView.scrollView.scrollEnabled = false
        heightConstraint.constant = webView.scrollView.contentSize.height - self.view.frame.size.height * 0.14
        webView.backgroundColor = UIColor.whiteColor()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    


    
    
    @IBAction func verRestricciones(sender: AnyObject) {
        
        let vc = storyboard!.instantiateViewControllerWithIdentifier("RestriccionesPromocionViewController") as! RestriccionesPromocionViewController
        vc.marcaLink = promocion.img_cfondo
        if !internet!{
            if let data = promocion.img_cfondo_data {
                
                vc.marcaImgData = data
            }

        }
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
                //sv.pushFrontViewController(vc, animated: true)
                self.navigationController?.popViewControllerAnimated(true)
            }

        case "TodasLasPromocionesViewController":
            if let sv = self.revealViewController(){
                let vc = self.storyboard!.instantiateViewControllerWithIdentifier("TodasLasPromocionesViewController") as! TodasLasPromocionesViewController
                    vc.marcasDidLoad = true
                    vc.MarcasDownloaded = MarcasDownloaded
                    vc.MarcasArray = MarcasDownloaded
                    //sv.pushFrontViewController(vc, animated: true)
                    self.navigationController?.popViewControllerAnimated(true)
            }
            
            
            break
            
        case "MarcaViewController":
            if let sv = self.revealViewController(){
                
                
                let vc = storyboard!.instantiateViewControllerWithIdentifier("MarcaViewController") as! MarcaViewController
                
                vc.Marca = self.Marca
                
                sv.pushFrontViewController(vc, animated: true)
            }
            
            break
    
            
            
        case "Promos1ViewController":
            
            if let sv = self.revealViewController(){
                let vc = self.storyboard!.instantiateViewControllerWithIdentifier("Promos1ViewController") as! Promos1ViewController
                vc.tarjeta = self.tarjeta
                vc.senderID = padreSenderVC
                vc.padreSenderID = abueloSenderVC
                vc.Marca = self.Marca
                sv.pushFrontViewController(vc, animated: true)
            }
            
            
            
            break
            
        default:
            break

        }*/
        
        self.navigationController?.popViewControllerAnimated(true)
        
        
    }
    
    @IBAction func openMenu(sender: AnyObject) {
        
        if let sw = self.revealViewController(){
            sw.revealToggleAnimated(true)
            self.revealViewController().rearViewRevealWidth =  self.view.frame.width * 0.85
        }
    }
    
    func marcaViewed() {
        
        if internet! {
            
        
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
        

        if canAdd! {
            if promocion.favorita! {
                
                btnPromoLiked.setImage(UIImage(named: "desgrane_carrusel_icon_fav_offgray"), forState: .Normal)
                promocion.favorita = false
                delegate.updatePromosIDArray(false, id: promocion.id, i1: i1, i2: i2)
                
            }
            else {
                btnPromoLiked.setImage(UIImage(named: "desgrane_carrusel_icon_fav_on"), forState: .Normal)
                promocion.favorita = true
                delegate.updatePromosIDArray(true, id: promocion.id, i1: i1, i2: i2)
            }
            
            
            
            let defaults = NSUserDefaults.standardUserDefaults()
            if let objeto = defaults.objectForKey("\(user.email!)promosFavoritasIDs") {
                
                var promosFavoritasIDs = objeto as! [Int]
                if promosFavoritasIDs.contains(promocion.id!) && !promocion.favorita! {
                    
                    promosFavoritasIDs.removeAtIndex(promosFavoritasIDs.indexOf(promocion.id!)!)
                }
                    
                else if !promosFavoritasIDs.contains(promocion.id!) && promocion.favorita!{
                    promosFavoritasIDs.append(promocion.id!)
                }
                
                defaults.setObject(promosFavoritasIDs, forKey: "\(user.email!)promosFavoritasIDs")
                
                
                
            }

        }
        else {
            marcaNoFavoritaPopUP()
        }
        
        
    }
    func marcaNoFavoritaPopUP() {
        
        let vc = storyboard?.instantiateViewControllerWithIdentifier("PopUp1BtnViewController") as! PopUp1BtnViewController
        vc.btnText = "CERRAR"
        vc.btnImage = "desgrane_general_btn_azul"
        vc.imageName = "desgrane_general_icon_alerta"
        vc.labelText = "Para seleccionar esta promocion como favorita necesitas agregar su tarjeta"
        presentViewController(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func goToSucursales(sender: AnyObject) {
        
        if let sv = self.revealViewController(){
            
            let  vc = self.storyboard?.instantiateViewControllerWithIdentifier("SucursalesViewController") as! SucursalesViewController
            
            /*
            if senderVC == "TodasLasPromocionesViewController" {
                
                vc.sucursales = MarcasDownloaded[i1].promociones2![i2].en_sucurs
                
                vc.Marca = MarcasDownloaded[i1]
                vc.MarcasDownloaded = self.MarcasDownloaded
                vc.marcasDidLoad = self.marcasDidLoad
                vc.promocion = self.promocion

            }
            else {
                
                vc.sucursales = promocion.en_sucurs
                if let Marca = promocion.marca {
                    
                    vc.Marca = Marca
                }
                
                vc.promocion = self.promocion
                if senderVC == "Promos1ViewController" {
                    
                    vc.Marca.sucursales = promocion.en_sucurs
                }

            }*/
            
            switch senderVC {
            case "TodasLasPromocionesViewController":
                
                vc.sucursales = MarcasDownloaded[i1].promociones2![i2].en_sucurs
                
            break
            
            case "Promos1ViewController":
                
                vc.sucursales = promocion.en_sucurs
                vc.Marca.sucursales = promocion.en_sucurs

                
                break
            
            case "SlideOutMenUIViewController":
                
                vc.sucursales = promocion.marca.sucursales

                
                break
                
            case "MarcaViewController":
                
                vc.sucursales = promocion.en_sucurs

                break
            
            default:
                
                break
            }
            /*
            vc.abueloSenderVC = padreSenderVC
            vc.padreSenderVC = senderVC
            vc.tataSenderVC = abueloSenderVC
            vc.senderVC = "TodasLasPromosDetalleViewController"*/
            //sv.pushFrontViewController(vc, animated: true)
            vc.Marca = self.Marca
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        }
        
        
        
    }
    
    @IBOutlet weak var btnBadge: UIButton!
    
    
    @IBAction func goToNotificaciones(sender: AnyObject) {
        
        if let sv = self.revealViewController() {
            
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("NotificacionesViewController") as! NotificacionesViewController
            sv.pushFrontViewController(vc, animated: true)
        }
    }
    


}
