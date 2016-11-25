//
//  Promos1ViewController.swift
//  FIDICARD
//
//  Created by Martin Viruete Gonzalez on 14/10/16.
//  Copyright © 2016 oomovil. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON
import SWRevealViewController

class Promos1ViewController: UIViewController {
    
    var Marca = CMarca()
    var promociones = [CPromocion]()
    var tarjeta = CTarjeta()
    var pageViewCarrusel: Promos2ViewController? = nil
    var currentPromoIndex = 0
    var senderID = ""
    var padreSenderID = ""
    var abueloSenderVC = ""
    var promosFavoritasIDs = [Int]()
    var user = Usuario()
    var timer1 = NSTimer()
    var isImageLeftSide = true
    var isImageMoving = true
    var contador = 0
   
    @IBOutlet weak var lblVigencia: UILabel!
    @IBOutlet weak var lblDescCorta: UILabel!
    @IBOutlet weak var lblTitulo: UILabel!
    @IBOutlet weak var imagenMarca: UIImageView!
    @IBOutlet weak var btnLikePromo: UIButton!
    @IBOutlet weak var imgMorePromos: UIImageView!
    @IBOutlet weak var btnBadge: UIButton!
    @IBOutlet weak var CenterConstraints: NSLayoutConstraint!
    
    
    @IBAction func goToNotificaciones(sender: AnyObject) {
        
        if let sv = self.revealViewController() {
            
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("NotificacionesViewController") as! NotificacionesViewController
            sv.pushFrontViewController(vc, animated: true)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    override func viewWillDisappear(animated: Bool) {
      //  let loadVC = self.storyboard?.instantiateViewControllerWithIdentifier("ActivityIndicatorViewController") as! ActivityIndicatorViewController
      // presentViewController(loadVC, animated: false, completion: nil)
        timer1.invalidate()
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(promosFavoritasIDs, forKey:"\(self.user.email!)promosFavoritasIDs" )
        defaults.synchronize()
        /*
        for index in 0..<promociones.count {
            
            if let favo = promociones[index].favorita {
               
                if favo {
                    
                    if !promosFavoritasIDs.contains(promociones[index].id!) {
                        
                        promosFavoritasIDs.append(promociones[index].id!)
                        
                    }
                    
                }
                else {
                    
                    if promosFavoritasIDs.contains(promociones[index].id!) {
                        
                        promosFavoritasIDs.removeAtIndex(promosFavoritasIDs.indexOf(promociones[index].id!)!)
                    }
                }

                
                
            }
        }*/
        
        
       // dismissViewControllerAnimated(false, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        loadUser()
        downoadMarcasPromos()
        let url = tarjeta.img_tarjs
        
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
                
                self.imagenMarca.contentMode = .ScaleAspectFill
                
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        
        let segueName = segue.identifier
        if segueName == "PromosSegue" {
            pageViewCarrusel = segue.destinationViewController as? Promos2ViewController
            
        }
        
    }

    
    func downoadMarcasPromos() {
        
        let loadVC = self.storyboard?.instantiateViewControllerWithIdentifier("ActivityIndicatorViewController") as! ActivityIndicatorViewController
        
            presentViewController(loadVC, animated: false, completion: nil)
        
        
        if let promos = self.Marca.promociones2 {
            
            if promos.count < 2 {
                self.imgMorePromos.image = nil
            }
            else{
               timer1 = NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: #selector(self.moveImage), userInfo: nil, repeats: true)
            }
            
            self.promociones = self.Marca.promociones2
            self.pageViewCarrusel!.padre = self
            self.pageViewCarrusel!.promociones = self.promociones
            self.pageViewCarrusel?.iop()
            self.dismissViewControllerAnimated(false, completion: nil)

            
        }
        else {
            
        
        
        
        var todosEndpoint: String = "http://201.168.207.17:8888/fidicard/kuff_api/getAllPromosPerOneMarca?"
        todosEndpoint += "marca_id=\(tarjeta.marca_id)"
        
        Alamofire.request(.GET, todosEndpoint)
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
                            let response = json["response"]
                            
                            for index in 0..<response.count {
                                
                                let promocionTemporal = CPromocion()
                                
                                promocionTemporal.id = Int(response[index]["id"].string ?? "-1")
                                promocionTemporal.cuerpo = response[index]["cuerpo"].string ?? "Null"
                                promocionTemporal.categoria_id = Int(response[index]["categoria_id"].string ?? "-1")
                                promocionTemporal.desc_corta = response[index]["desc_corta"].string ?? "Null"
                                promocionTemporal.img_cfondo = self.tarjeta.marca.img_sfondo
                                promocionTemporal.titulo = response[index]["titulo"].string ?? "Null"
                                promocionTemporal.en_sucurs = [sucursal]()
                                
                                for jdex in 0..<response[index]["en_sucurs"].count {
                                    
                                    let sucursalTemporal = sucursal()
                                    
                                    
                                    sucursalTemporal.latitud = Double(response[index]["en_sucurs"][jdex]["latitud"].string ?? "-1")
                                    sucursalTemporal.longitud = Double(response[index]["en_sucurs"][jdex]["longitud"].string ?? "-1")
                                   sucursalTemporal.id = Int(response[index]["en_sucurs"][jdex]["sucursal_id"].string ?? "-1")
                                    sucursalTemporal.nombre = response[index]["en_sucurs"][jdex]["nombre"].string ?? "Null"
                                    sucursalTemporal.direccion = response[index]["en_sucurs"][jdex]["direccion"].string ?? "Null"
                                    sucursalTemporal.tels = [String]()
                                    sucursalTemporal.tels.append(response[index]["en_sucurs"][jdex]["tels"].string ?? "Null")
                                    
                                    promocionTemporal.en_sucurs.append(sucursalTemporal)
                                    
                                }
                                
                              
                                promocionTemporal.imagen = response[index]["imagen"].string ?? "Null"
                                promocionTemporal.destacada = response[index]["destacada"].string ?? "Null"
                                promocionTemporal.marca_id = Int(response[index]["marca_id"].string ?? "Null")
                                promocionTemporal.restriccciones = response[index]["restricciones"].string ?? "Null"
                                promocionTemporal.link_promo = response[index]["link_promo"].string ?? "Null"
                                promocionTemporal.vigencia = response[index]["vigencia"].string ?? "Null"
                                self.promociones.append(promocionTemporal)
                                
                            }
                            
                            let defaults = NSUserDefaults.standardUserDefaults()
                            
                            if let objeto = defaults.objectForKey("\(self.user.email!)promosFavoritasIDs") {
                                
                                self.promosFavoritasIDs = objeto as! [Int]
                                
                                var ban = false
                                
                                for i in 0..<self.promociones.count {
                                    
                                    
                                    for j in 0..<self.promosFavoritasIDs.count{
                                        
                                        if self.promociones[i].id == self.promosFavoritasIDs[j] {
                                            
                                            self.promociones[i].favorita = true
                                            ban = true
                                        }
                                        
                                    }
                                    if !ban {
                                        self.promociones[i].favorita = false
                                    }
                                    
                                }
                                
                            }
                            if self.promociones.count < 2 {
                                self.imgMorePromos.image = nil
                            }
                            else{
                                self.timer1 = NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: #selector(self.moveImage), userInfo: nil, repeats: true)
                            }
                            
                            self.Marca.promociones2 = self.promociones
                            self.pageViewCarrusel!.padre = self
                            self.pageViewCarrusel!.promociones = self.promociones
                            self.pageViewCarrusel?.iop()
                            self.dismissViewControllerAnimated(false, completion: nil)
                            //self.loadingMarcas()
                            
                        }
                    }
                }
        }
            
            
        }
    }
    
    
    func loadPromoContent(index:Int) {
        
        lblTitulo.text = promociones[index].titulo
        lblDescCorta.text = promociones[index].desc_corta
        let dateStr : String = promociones[index].vigencia
        if dateStr != "Null" && dateStr != "0000-00-00" {
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            var  date = NSDate()
            date = dateFormatter.dateFromString(dateStr)!
            dateFormatter.dateFormat = "dd MMM"
            lblVigencia.text = dateFormatter.stringFromDate(date)
        }
        else {
            lblVigencia.text = "NULL"
        }
        
        
        currentPromoIndex = index
        if let favorita = promociones[index].favorita {
            
            if favorita {
                
                btnLikePromo.setImage(UIImage(named: "desgrane_carrusel_icon_fav_on"), forState: .Normal)
            }
            else {
                btnLikePromo.setImage(UIImage(named: "desgrane_carrusel_icon_fav_off"), forState: .Normal)
            }
            
        }
        else{
            
            btnLikePromo.setImage(UIImage(named: "desgrane_carrusel_icon_fav_off"), forState: .Normal)
            promociones[ index].favorita = false
            
        }

    }
    
    
    
    @IBAction func PromoFavoritaSelected(sender: AnyObject) {
        
        
        
        
        if let favorita = promociones[currentPromoIndex].favorita {
            
            if favorita {
                
                btnLikePromo.setImage(UIImage(named: "desgrane_carrusel_icon_fav_off"), forState: .Normal)
                promociones[currentPromoIndex].favorita = false
            }
            else {
                btnLikePromo.setImage(UIImage(named: "desgrane_carrusel_icon_fav_on"), forState: .Normal)
                promociones[currentPromoIndex].favorita = true
            }
            
        }
        else{
            
            btnLikePromo.setImage(UIImage(named: "desgrane_carrusel_icon_fav_on"), forState: .Normal)
            promociones[currentPromoIndex].favorita = true
            
        }
        
        
        if promosFavoritasIDs.contains(promociones[currentPromoIndex].id!) && !promociones[currentPromoIndex].favorita! {
            
            promosFavoritasIDs.removeAtIndex(promosFavoritasIDs.indexOf(promociones[currentPromoIndex].id!)!)
        }
            
        else if !promosFavoritasIDs.contains(promociones[currentPromoIndex].id!) && promociones[currentPromoIndex].favorita!{
            promosFavoritasIDs.append(promociones[currentPromoIndex].id!)
        }
        
        

        
    }
    
    

    
    
    @IBAction func returnToSender(sender: AnyObject) {
        
        /*
        if let sv = self.revealViewController(){
            
            if senderID == "DetalleTarjFisicaViewController"  {
                
                let  vc = self.storyboard?.instantiateViewControllerWithIdentifier(senderID) as! DetalleTarjFisicaViewController
                vc.tarjeta = tarjeta
                vc.senderVC = padreSenderID
                sv.pushFrontViewController(vc, animated: true)
            
            }
            else if senderID == "detalleTarjtVirtualViewController" {
                
                
                 let  vc = self.storyboard?.instantiateViewControllerWithIdentifier(senderID) as! detalleTarjtVirtualViewController
                  vc.tarjeta = tarjeta
                    vc.senderVC = padreSenderID
                sv.pushFrontViewController(vc, animated: true)
            }
            
            
        }*/
        
        self.navigationController?.popViewControllerAnimated(true)
        
       
        

        
    }
    
    @IBAction func openMenu(sender: AnyObject) {
        
        if let sw = self.revealViewController(){
            sw.revealToggleAnimated(true)
            self.revealViewController().rearViewRevealWidth =  self.view.frame.width * 0.85
        }
    }
    
    
    func goToPromocion(index:Int) {
        
        print("Si se pudo\(index)")
        
        if let sv = self.revealViewController(){
            let vc = storyboard?.instantiateViewControllerWithIdentifier("TodasLasPromosDetalleViewController") as! TodasLasPromosDetalleViewController
            vc.tarjeta = self.tarjeta
            vc.senderVC = "Promos1ViewController"
            vc.padreSenderVC = self.senderID
            vc.abueloSenderVC = padreSenderID
            vc.canAdd = true
            vc.Marca = self.Marca
            vc.promocion = self.promociones[index]
            self.navigationController?.pushViewController(vc, animated: true)
            //sv.pushFrontViewController(vc, animated: true)
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
    
    func loadUser() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let user = defaults.dataForKey("user") {
            
            if let user = NSKeyedUnarchiver.unarchiveObjectWithData(user) as? Usuario {
                self.user = user
                btnBadge.setTitle(String(defaults.integerForKey("\(user.email!)badge")), forState: .Normal)
            }
            
        }
        
        
    }
    
    @IBAction func goToPromoSucurs(sender: AnyObject) {
        
        if let sv = self.revealViewController(){
            
            let  vc = self.storyboard?.instantiateViewControllerWithIdentifier("SucursalesViewController") as! SucursalesViewController
            vc.sucursales = promociones[currentPromoIndex].en_sucurs
            vc.Marca = Marca
            vc.senderVC = "Promos1ViewController"
            vc.padreSenderVC = senderID
            vc.abueloSenderVC = padreSenderID
            vc.tataSenderVC = self.abueloSenderVC
            vc.tarjeta = self.tarjeta
            //sv.pushFrontViewController(vc, animated: true)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @IBAction func goToInicio(sender: AnyObject) {
        
        if let sv = self.revealViewController(){
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("Home")
            sv.pushFrontViewController(vc, animated: true)
        }
        
    }
    
    func moveImage(){
        
        if isImageMoving {
            
            contador += 1
            if isImageLeftSide {
                UIView.animateWithDuration(0.25, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn , animations: {
                    self.CenterConstraints.constant += 10
                    self.view.layoutIfNeeded()
                    }, completion: nil)
                
            }
            else {
                UIView.animateWithDuration(0.25, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut , animations: {
                    self.CenterConstraints.constant -= 10
                    self.view.layoutIfNeeded()
                    }, completion: nil)
                
            }
            isImageLeftSide = !isImageLeftSide
            if contador >= 6 {
                isImageMoving = false
            }
            
        }
        else {
            contador -= 1
            if contador <= 0 {
                isImageMoving = true
            }
        }
        
    }
    
    func restartImageMove(){
        
        if isImageMoving {
            
            
            
        }
        else {
            
        }
        isImageMoving = !isImageMoving
        
    }
    


}
