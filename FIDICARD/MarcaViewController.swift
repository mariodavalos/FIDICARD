
//
//  MarcaViewController.swift
//  FIDICARD
//
//  Created by Martin Viruete Gonzalez on 04/10/16.
//  Copyright © 2016 oomovil. All rights reserved.
//

import UIKit
import SWRevealViewController
import Alamofire
import AlamofireImage
import SwiftyJSON

class MarcaViewController: UIViewController {

    var Marca = CMarca()
    //MarcasPromosSegue
    @IBOutlet weak var imagenMarca: UIImageView!
    @IBOutlet weak var imagenPromocion: UIImageView!
    var promociones = [CPromocion]()
    var pageViewCarrusel: MarcaPromocionPageViewController?
    var currentPromoIndex = 0
    var promosFavoritasIDs = [Int]()
    var loadVC : UIViewController!
    var misMarcas = [Int]()
    var isImageLeftSide = true
    var isImageMoving = true
    var timer = NSTimer()
    var timer2 = NSTimer()
    var contador = 0
    var internet : Bool!
    
    var user = Usuario()
    
    @IBOutlet weak var lblTituloPromo: UILabel!
    @IBOutlet weak var lbldescripcionCorta: UILabel!
    @IBOutlet weak var lblVigencia: UILabel!
    @IBOutlet weak var btnSolicitarTarjeta: UIButton!
    @IBOutlet weak var btnLikePromo: UIButton!
    @IBOutlet weak var imgMorePromos: UIImageView!
    @IBOutlet weak var imgHome: UIImageView!
    @IBOutlet weak var CenterConstraints: NSLayoutConstraint!
    
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        internet = Reachability.isConnectedToNetwork()
        imgHome.userInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
        imgHome.addGestureRecognizer(tapRecognizer)
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
       // loadVC = self.storyboard?.instantiateViewControllerWithIdentifier("ActivityIndicatorViewController") as! ActivityIndicatorViewController
        
        //presentViewController(loadVC, animated: false, completion: nil)
        
        let url = Marca.img_sfondo
        downoadMarcasPromos()
        
        
        
        if Marca.tipo_tarjs == "VIRTUAL" {
            
            btnSolicitarTarjeta.setImage(UIImage(named: "ios_marcas_btn_generar-2"), forState: .Normal)
            
        }
        else if Marca.tipo_tarjs == "FISICA" || Marca.tipo_tarjs == "AMBAS" {
            btnSolicitarTarjeta.setImage(UIImage(named: "ios_marcas_btn_solicitar-1"), forState: .Normal)
        }
        
        
        
        
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
    
    
    override func viewWillDisappear(animated: Bool) {
        
       
      //let loadVC = self.storyboard?.instantiateViewControllerWithIdentifier("ActivityIndicatorViewController") as! ActivityIndicatorViewController
     // presentViewController(loadVC, animated: false, completion: nil)
        timer.invalidate()
        timer2.invalidate()
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(promosFavoritasIDs, forKey:"\(user.email!)promosFavoritasIDs" )
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
        
    }
    
    func loadUser() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let user = defaults.dataForKey("user") {
            
            if let user = NSKeyedUnarchiver.unarchiveObjectWithData(user) as? Usuario {
                self.user = user
                btnBadge.setTitle(String(defaults.integerForKey("\(user.email!)badge")), forState: .Normal)
                
            }
            
        }
        if let obk = defaults.objectForKey("\(user.email!)misMarcasID") {
            
            misMarcas = obk as! [Int]
            
        }
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){

        let segueName = segue.identifier
        if segueName == "MarcasPromosSegue" {
            pageViewCarrusel = segue.destinationViewController as? MarcaPromocionPageViewController
            
        }

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    @IBAction func GoToInfo(sender: AnyObject) {
        
       
        
        
        if let sv = self.revealViewController(){
            
            let  vc = self.storyboard?.instantiateViewControllerWithIdentifier("InformacionMarcaViewController") as! InformacionMarcaViewController
            
            vc.nombre = Marca.nombre
            vc.ubicacion = Marca.ubicacion
            vc.telefonos = Marca.tels[0]
            vc.web = Marca.web
            vc.info = Marca.info
            vc.Marca = self.Marca
            vc.senderVC = "MarcaViewController"
            //sv.pushFrontViewController(vc, animated: true)
            self.navigationController?.pushViewController(vc, animated: true)
        }

 
    }
    
    @IBAction func goToSucursales(sender: AnyObject) {
        
        
        
        if let sv = self.revealViewController(){
            
            let  vc = self.storyboard?.instantiateViewControllerWithIdentifier("SucursalesViewController") as! SucursalesViewController
            vc.sucursales = Marca.sucursales
            vc.Marca = self.Marca
            vc.senderVC = "MarcaViewController"
            //sv.pushFrontViewController(vc, animated: true)
            self.navigationController?.pushViewController(vc, animated: true)
        }

        
        
    }
    
    
    
    @IBAction func openMenu(sender: AnyObject) {
        
        if let sw = self.revealViewController(){
            sw.revealToggleAnimated(true)
              self.revealViewController().rearViewRevealWidth =  self.view.frame.width * 0.85
        }

        
    }
    
    
    @IBAction func gotoSolicitarTarjeta(sender: AnyObject) {

       
        if Marca.tipo_tarjs == "FISICA" || Marca.tipo_tarjs == "AMBAS" {
            
        if let sv = self.revealViewController(){

            let  vc = self.storyboard?.instantiateViewControllerWithIdentifier("SolicitarTarjetaViewController") as! SolicitarTarjetaViewController
            vc.marcaID = Marca.id
            vc.Marca = Marca
            //sv.pushFrontViewController(vc, animated: true)
            self.navigationController?.pushViewController(vc, animated: true)
          }
        }
        
        else if Marca.tipo_tarjs == "VIRTUAL" {
            
            if let sv = self.revealViewController(){
            let  vc = self.storyboard?.instantiateViewControllerWithIdentifier("GenerarTarjetaViewController") as! GenerarTarjetaViewController
                vc.Marca = Marca
            //sv.pushFrontViewController(vc, animated: true)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }

    }
    
    @IBAction func gotoCapturarTarjeta(sender: AnyObject) {

        if let sv = self.revealViewController(){
            
            
            let  vc = self.storyboard?.instantiateViewControllerWithIdentifier("CapturarTarjetaViewController") as! CapturarTarjetaViewController
            vc.Marca = Marca
            //sv.pushFrontViewController(vc, animated: true)
            self.navigationController?.pushViewController(vc, animated: true)
        }

        
        
        
        
    }
    

    
    
    func downoadMarcasPromos() {
        
        if let promos = self.Marca.promociones2 {
            
            if promos.count < 2 {
                
                self.imgMorePromos.image = nil
            }
            else{
               timer = NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: #selector(self.moveImage), userInfo: nil, repeats: true)
                
                
            }
            self.promociones = self.Marca.promociones2
            self.pageViewCarrusel!.padre = self
            self.pageViewCarrusel!.promociones = self.promociones
            self.pageViewCarrusel?.iop()
            //self.dismissViewControllerAnimated(false, completion: nil)
            
            
        }
        else {
            
        
        var todosEndpoint: String = "http://201.168.207.17:8888/fidicard/kuff_api/getAllPromosPerOneMarca?"
        todosEndpoint += "marca_id=\(Marca.id)"

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
                                        promocionTemporal.img_cfondo = self.Marca.img_sfondo
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
                                        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: #selector(self.moveImage), userInfo: nil, repeats: true)
                                                                            }
                                    self.Marca.promociones2 = self.promociones
                                    self.pageViewCarrusel!.padre = self
                                    self.pageViewCarrusel!.promociones = self.promociones
                                    self.pageViewCarrusel?.iop()
                                    //self.dismissViewControllerAnimated(false, completion: nil)
                                    //self.loadingMarcas()

                                }
                                else {
                                    
                                    //self.dismissViewControllerAnimated(false, completion: nil)
                                    let alert = UIAlertController(title: "Error de Conexion", message: "Puede que varias funciones no esten activas", preferredStyle: UIAlertControllerStyle.Alert)
                                    alert.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.Default, handler: nil))
                                    self.presentViewController(alert, animated: true, completion: nil)
                                }

                        }
                }
            }
        }
    }


    func loadPromoContent(index:Int) {
        
        lblTituloPromo.text = promociones[index].titulo
        lbldescripcionCorta.text = promociones[index].desc_corta
        let dateStr : String = promociones[index].vigencia
        if dateStr != "Null" && dateStr	!= "0000-00-00"	 {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            var  date = NSDate()
            date = dateFormatter.dateFromString(dateStr)!
            dateFormatter.dateFormat = "dd MMM"
            lblVigencia.text = dateFormatter.stringFromDate(date)
            
        }
        else {
            lblVigencia.text = "Null"
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
    
        if misMarcas.contains(Marca.id!){
        
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
        else {
            marcaNoFavoritaPopUP()
        }
    
    
    }
    
    
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    func goToPromocion(index:Int) {
        
        print("Si se pudo\(index)")
        
        if let sv = self.revealViewController(){
            let vc = storyboard?.instantiateViewControllerWithIdentifier("TodasLasPromosDetalleViewController") as! TodasLasPromosDetalleViewController
            vc.Marca = self.Marca
            vc.senderVC = "MarcaViewController"
            vc.promocion = self.promociones[index]
            
            //vc.sucursales = promociones[currentPromoIndex].en_sucurs
            if misMarcas.contains(Marca.id!){
                
                vc.canAdd = true
            }
            else {
                vc.canAdd = false
            }
            //sv.pushFrontViewController(vc, animated: true)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
   
}

extension MarcaViewController : UIPageViewControllerDelegate {
    
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        
        guard let vc = pageViewController.viewControllers?.first else{
            return
        }
        
        let index =  vc.view.tag
        loadPromoContent(index)
        
    }
    
    
    
    @IBAction func goToMarcas(sender: AnyObject) {
        
        if let sv = self.revealViewController(){
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("MisMarcasView")
            sv.pushFrontViewController(vc, animated: true)

            
        }
        
    }
    
    
    
    @IBAction func goToPromoSucursal(sender: AnyObject) {
        
        if let sv = self.revealViewController(){
            
            let  vc = self.storyboard?.instantiateViewControllerWithIdentifier("SucursalesViewController") as! SucursalesViewController
            vc.sucursales = promociones[currentPromoIndex].en_sucurs
            vc.Marca = Marca
            vc.senderVC = "MarcaViewController"
            //sv.pushFrontViewController(vc, animated: true)
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }
    
    func marcaNoFavoritaPopUP() {
        
        let vc = storyboard?.instantiateViewControllerWithIdentifier("PopUp1BtnViewController") as! PopUp1BtnViewController
        vc.btnText = "CERRAR"
        vc.btnImage = "desgrane_general_btn_azul"
        vc.imageName = "desgrane_general_icon_alerta"
        vc.labelText = "Necesitas tener la tarjeta de esta marca para guardar la promoción como favorita"
        presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction func regresar(sender: AnyObject) {
        
        if let sv = self.revealViewController(){
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("MisMarcasViewController")
            //sv.pushFrontViewController(vc, animated: true)
            self.navigationController?.popViewControllerAnimated(true)
            
            
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








