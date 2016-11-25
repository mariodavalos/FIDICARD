//
//  SlideOutMenUIViewController.swift
//  
//
//  Created by omar on 15/09/16.
//
//

import UIKit
import SWRevealViewController
import AlamofireImage
import Alamofire
import SwiftyJSON
import FirebaseMessaging
import Firebase
import FirebaseAnalytics
import FirebaseInstanceID

class SlideOutMenUIViewController: UIViewController, allocAddFirstCardDelegate {
    
    
    var pageViewCarrusel: CarruselPromoViewController?
    var VCTarjetasFavoritas: TarjetasFavoritasViewController?
    var VCAddFirstView: AddFirstCardViewController?
    var isImageLeftSide = true
    var isImageMoving = true
    var promociones = [CPromocion]()
    var timer = NSTimer()
    var timer2 = NSTimer()
    var contador = 0
    
    @IBOutlet weak var contenedor: UIView!
    @IBOutlet weak var lblTituloPromo: UILabel!
    @IBOutlet weak var lbldescripcionCorta: UILabel!
    @IBOutlet weak var btnMarca: UIButton!
    @IBOutlet weak var lblVigencia: UILabel!
    @IBOutlet weak var contenedorMisTarjetas: UIView!
    @IBOutlet weak var btnPromoFavorita: UIButton!
    @IBOutlet weak var btnLikePromo: UIButton!
    @IBOutlet weak var viewAddCard: UIView!
    @IBOutlet weak var btnBadge: UIButton!
    @IBOutlet weak var imgmorePromos: UIImageView!
    @IBOutlet weak var CenterConstraints: NSLayoutConstraint!
   
    var MarcasArray = [CMarca]()
    var currentPromoIndex = 0
    var TarjetasFavID = [Int]()
    var tarjetasFavoritas = [CTarjeta]()
    var tarjetas =  [CTarjeta]()
    var tarjetasNoFavoritas = [CTarjeta]()
    var promosFavoritasIDs = [Int]()
    var loadingVC: ActivityIndicatorViewController!
    var user = Usuario()
    var misMarcas = [Int]()
    var internetConection : Bool!
    var dictionaryCards = [Int : Int]()
    
    var logged : Bool!
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    @IBAction func goToNotificaciones(sender: AnyObject) {
        
        if let sv = self.revealViewController() {
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("NotificacionesViewController") as! NotificacionesViewController
            
            sv.pushFrontViewController(vc, animated: true)
        }
    }
       

   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("View did load")
        self.btnMarca.imageView!.contentMode = .ScaleAspectFill
        let imageViewSize = self.btnMarca.imageView!.frame.size
        self.btnMarca.imageView?.layer.cornerRadius = imageViewSize.height * 0.5
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        internetConection = Reachability.isConnectedToNetwork()
        findUser()
        timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: #selector(SlideOutMenUIViewController.movingForward), userInfo: nil, repeats: true)
        timer2 = NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: #selector(self.moveImage), userInfo: nil, repeats: true)
        
    }

    override func viewWillAppear(animated: Bool) {
        
        
        print("View will Appear")

    }
    
    override func shouldAutorotate() -> Bool {
        
        return false
    }
    
   override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        timer2.invalidate()
        timer.invalidate()
        if internetConection! {
        
        //loadingVC = storyboard!.instantiateViewControllerWithIdentifier("ActivityIndicatorViewController") as! ActivityIndicatorViewController
        //presentViewController(loadingVC, animated: true, completion: nil)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        for index in 0..<promociones.count {
            
            if let fav = promociones[index].favorita {
                
                if fav {
                    
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
            
        }
            if let email = user.email {
                
                defaults.setObject(promosFavoritasIDs, forKey:"\(email)promosFavoritasIDs" )

                
            }
        
            
        //loadingVC.dismissViewControllerAnimated(false, completion: nil)
        }
        
    }
    
   
    
    @IBAction func abrirMenu(){
        if let sw = self.revealViewController(){
            sw.revealToggleAnimated(true)
            
            self.revealViewController().rearViewRevealWidth =  self.view.frame.width * 0.85
            
        }
    }
    
    
    func findUser(){
        
    //loadingVC = self.storyboard!.instantiateViewControllerWithIdentifier("ActivityIndicatorViewController") as! ActivityIndicatorViewController
        
    //presentViewController(loadingVC, animated: false, completion: nil)
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    
        if internetConection! {
        
        if defaults.boolForKey("userLogged"){
        
        self.logged = true
        
        if let userName = defaults.stringForKey("userEmail"){
            
            if let pass = defaults.stringForKey("password"){
                
                if userName != "" && pass != "" {
                    
                    
                    
        var newTodo = [String:String]()
        
        if pass == "ab51f5acb40977296fce11daed3feb1991e4579c" {
            newTodo = ["uname": String(userName),"fb_token":String(pass)]
        }
        else {
            newTodo = ["uname": String(userName),"upass":String(pass)]
        }
        let todosEndpoint: String = "http://201.168.207.17:8888/fidicard/kuff_api/loginUser"
        
        
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
                            
                            let temporalUser = Usuario()
                            temporalUser.nombre = json["user"]["nombre"].string ?? "null"
                            temporalUser.apellido = json["user"]["apellido"].string ?? "null"
                            temporalUser.email = json["user"]["email"].string ?? "null"
                            temporalUser.imageLink = json["user"]["imagen"].string ?? "null"
                            defaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(temporalUser), forKey: "user")
                            self.user = temporalUser
                            self.btnBadge.setTitle(String(defaults.integerForKey("\(self.user.email!)badge")), forState: .Normal)
                            defaults.synchronize()
                            
                            
                            (UIApplication.sharedApplication().delegate as! AppDelegate).connectToFcm()
                            
                            if let objeto = defaults.stringForKey("token"){
                                let token = objeto 
                                
                                let newTodo2 = ["email": String(temporalUser.email!),"token":String(token), "android" : 0]
                            
                            let todosEndpoint2: String = "http://201.168.207.17:8888/fidicard/kuff_api/regToken"
                                
                                Alamofire.request(.POST, todosEndpoint2, parameters: newTodo2 as! [String : AnyObject])
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
                                                
                                                print("Token Enviado con exito")
                                                
                                                }
                                            }
                                        }
                                        
                                }
                                
                                
                            }

                            //self.loadingPromocionesDestacadas()
                            self.gettingCards()//1
                        }
                        else if json["status"].intValue == 400 {
                            
                            self.userNotLoggedPopUp()
                        }
                        
                        
                    }
                    
                }
              }
                    
            }
          }
        
        }
            
        }
    else {
        self.logged = false
        //self.loadingPromocionesDestacadas()
        user.email = "noEmail"
        self.gettingCards() //2
        
        
    }
            
        }
        else {

            let defaults = NSUserDefaults.standardUserDefaults()
            
            logged = defaults.boolForKey("userLogged")
            
            if let user = defaults.dataForKey("user") {
                
                if let user = NSKeyedUnarchiver.unarchiveObjectWithData(user) as? Usuario {
                    self.user = user
                    
                }
                
            }

            
            let alert = UIAlertController(title: "Error de Conexion", message: "Puede que varias funciones no esten activas", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            
            if let obj = defaults.dataForKey("promocionesDestacadas") {
                
                self.gettingCards()
                ArregloPromociones.promociones = NSKeyedUnarchiver.unarchiveObjectWithData(obj) as! [CPromocion]
                promociones = ArregloPromociones.promociones
                self.pageViewCarrusel!.padre = self
                self.pageViewCarrusel!.promociones = self.promociones
                self.pageViewCarrusel?.iop()

            }
            
            
        }
        
        
        
    }
    
    
    func addSubview(subView:UIView, toView parentView:UIView) {
        parentView.addSubview(subView)
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
    }
    
    func loadingPromocionesDestacadas() {

        
        //loadingVC = self.storyboard!.instantiateViewControllerWithIdentifier("ActivityIndicatorViewController") as! ActivityIndicatorViewController
        //presentViewController(loadingVC, animated: false, completion: nil)
        Alamofire.request(.GET,"http://201.168.207.17:8888/fidicard/kuff_api/getPromocionesForHome/" ).responseJSON {
            (response) in
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
                        promocionTemporal.img_cfondo = response[index]["img_cfondo"].string ?? "Null"
                        promocionTemporal.titulo = response[index]["titulo"].string ?? "Null"
                        promocionTemporal.en_sucurs = [sucursal]()
                        
                        for jdex in 0..<response[index]["en_sucurs"].count{
                            
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
                        
                    if self.logged! {
                        
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
                        
                        
                    }

                    
                    self.loadingMarcas()

                }
            }
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        
        
        
        
        let segueName = segue.identifier
        if segueName == "carruselPromoSegue" {
            pageViewCarrusel = segue.destinationViewController as? CarruselPromoViewController
            
            
            
        }
        if segueName == "segueTarjetasFavoritas" {
            VCTarjetasFavoritas = segue.destinationViewController as? TarjetasFavoritasViewController
        }
        
        
    }
    
    
    func loadCarrusel() {
        
        if let myViewControllers = pageViewCarrusel!.viewControllers as? [PromoCarruselModeloViewController] {
            
            for viewController in myViewControllers {
                
                //viewController.imagen =
                
                Alamofire.request(.GET, promociones[0].imagen)
                    .responseImage { response in
                        debugPrint(response)
                        
                        debugPrint(response.result)
                        
                        if let image = response.result.value {
                            print("image downloaded: \(image)")
                            viewController.imagen.image = image
                        }
                }

               
            
            }
        }
        
        
    }
    
    @IBAction func goToMarca(sender: AnyObject) {
        
        if internetConection!{
        
        if logged! {
           
            print("Marca Elejida")
            if let sv = self.revealViewController(){
                
                if let Marca = promociones[currentPromoIndex].marca {
                    
                    let vc = storyboard!.instantiateViewControllerWithIdentifier("MarcaViewController") as! MarcaViewController
                    vc.Marca = Marca
                    //sv.pushFrontViewController(vc, animated: true)
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                else {
                    print("No hay Marca")
                }
            }

            
        }
        else {
            userNotLoggedPopUp()
        }
            
        }
        else {
            let alert = UIAlertController(title: "Error de Conexion", message: "Puede que varias funciones no esten activas", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            

        }
        
        
        
    }
    
    @IBAction func goToAddCard(sender: AnyObject) {
        
       
        if internetConection! {
        
        if logged! {
            
            
            let Marca = promociones[currentPromoIndex].marca
            
            if Marca.tipo_tarjs == "FISICA" || Marca.tipo_tarjs == "AMBAS"  {
                
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
        else {
            userNotLoggedPopUp()
        }
        }
        
    }
    
    
    
    
    
    
    @IBAction func goToSucursales(sender: AnyObject) {
        
      
        if logged! {
            
            if let sv = self.revealViewController(){
                
                let  vc = self.storyboard?.instantiateViewControllerWithIdentifier("SucursalesViewController") as! SucursalesViewController
                vc.sucursales = promociones[currentPromoIndex].marca.sucursales
                vc.Marca = promociones[currentPromoIndex].marca
                vc.senderVC = "SlideOutMenUIViewController"
                //sv.pushFrontViewController(vc, animated: true)
                self.navigationController?.pushViewController(vc, animated: true)
            }

        }
        else {
            userNotLoggedPopUp()
        }
        
    }
    
    func goToPromocion(index:Int) {
        
        if logged! {
            
            print("Si se pudo\(index)")
            
            if let sv = self.revealViewController(){
                let vc = storyboard?.instantiateViewControllerWithIdentifier("TodasLasPromosDetalleViewController") as! TodasLasPromosDetalleViewController
                vc.senderVC = "SlideOutMenUIViewController"
                vc.promocion = self.promociones[index]
                vc.Marca = self.self.promociones[index].marca
                if misMarcas.contains(promociones[index].marca_id!){
                vc.canAdd = true
                }
                else {
                vc.canAdd = false
                }
                
                self.navigationController?.pushViewController(vc, animated: true)
                //sv.pushFrontViewController(vc, animated: true)
            }

        }
        else {
            userNotLoggedPopUp()
        }
            
        
        
        
    }
    
    
    @IBAction func PromoFavoritaSelected(sender: AnyObject) {

        if internetConection! {
        
        if logged! {
            
            
            if misMarcas.contains(promociones[currentPromoIndex].marca_id)  {
            
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
            
            
            
            }
            else {
                
                marcaNoFavoritaPopUP()
            }


            
        }
        else {
            
            userNotLoggedPopUp()
        }
        
        
        }
        else {
            
            let alert = UIAlertController(title: "Error de Conexion", message: "Puede que varias funciones no esten activas", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            

        }
    }
    
    
    @IBAction func goToMarcas(sender: AnyObject) {
        
        if let sv = self.revealViewController(){
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("MisMarcas")
            sv.pushFrontViewController(vc, animated: true)
            
            
        }

       
    }
    
    func goToMarcas(){
       
        if logged!{
            
            if let sv = self.revealViewController(){
                let vc = self.storyboard!.instantiateViewControllerWithIdentifier("MisMarcas")
                sv.pushFrontViewController(vc, animated: true)
                
                
            }

            
            
        } else {
            
            userNotLoggedPopUp()
        }
        
       
        
    }
    
    
    func loadingMarcas() {
        
        Alamofire.request(.GET,"http://201.168.207.17:8888/fidicard/kuff_api/getAllDataForMarcas/" ).responseJSON {
            (response) in
            if let data = response.data{
                
                let json = JSON(data:data)
                print("JSON: \(json)")
                if json["status"].intValue == 200 {
                    
                    let response = json["response"]
                    
                    self.MarcasArray.removeAll()
                    for index in 0..<response.count {
                        
                        
                        // self.estadosArray.append(response[index]["nombre"].string ?? "Null")
                        let marcaTemporal = CMarca()
                        marcaTemporal.id = Int(response[index]["id"].string ?? "-1")
                        marcaTemporal.tipo_tarjs = response[index]["tipo_tarjs"].string ?? "-1"
                        marcaTemporal.img_tarjs = response[index]["img_tarjs"].string ?? "-1"
                        marcaTemporal.img_cfondo = response[index]["img_cfondo"].string ?? "-1"
                        marcaTemporal.longitud = Double(response[index]["longitud"].string ?? "-1")
                        marcaTemporal.categorias_id = Int(response[index]["categoria_id"].string ?? "-1")
                        marcaTemporal.tels = [String]()
                        marcaTemporal.tels.append(response[index]["tels"].string ?? "-1")
                        marcaTemporal.fecha_reg = response[index]["fecha_reg"].string ?? "-1"
                        marcaTemporal.admin_id = Int(response[index]["admin_id"].string ?? "-1")
                        marcaTemporal.latitud = Double(response[index]["latitud"].string ?? "-1")
                        marcaTemporal.priv_marca_id = Int(response[index]["priv_marca_id"].string ?? "-1")
                        marcaTemporal.web = response[index]["web"].string ?? "-1"
                        marcaTemporal.info = response[index]["info"].string ?? "-1"
                        marcaTemporal.ubicacion = response[index]["ubicacion"].string ?? "-1"
                        marcaTemporal.aviso_priv = response[index]["aviso_priv"].string ?? "-1"
                        marcaTemporal.sucursales = [sucursal]()
                        let sucursales = response[index]["sucursales"]
                        for indexSuc in 0..<sucursales.count {
                            let sucursalTemporal = sucursal()
                            sucursalTemporal.nombre = sucursales[indexSuc]["nombre"].string ?? "-1"
                            sucursalTemporal.direccion = sucursales[indexSuc]["direccion"].string ?? "-1"
                            sucursalTemporal.id = Int(sucursales[indexSuc]["id"].string ?? "-1")
                            sucursalTemporal.latitud = Double(sucursales[indexSuc]["latitud"].string ?? "-1")
                            sucursalTemporal.marca_id = Int(sucursales[indexSuc]["marca_id"].string ?? "-1")
                            sucursalTemporal.tels = [String]()
                            sucursalTemporal.tels.append(sucursales[indexSuc]["tels"].string ?? "-1")
                            sucursalTemporal.longitud = Double(sucursales[indexSuc]["longitud"].string ?? "-1")
                            marcaTemporal.sucursales.append(sucursalTemporal)
                            
                            
                        }
                        marcaTemporal.nombre =  response[index]["nombre"].string ?? "-1"
                        marcaTemporal.img_sfondo =  response[index]["img_sfondo"].string ?? "-1"
                        self.MarcasArray.append(marcaTemporal)
                        
                    }
                    print("Wil Dismiss")
                    //self.loadingVC.dismissViewControllerAnimated(false, completion: nil)
                    print("dismissed")
                    self.findMarca()
                    
                    
                }
                
                
            }
        }
        
        
        
        
        
    }
    
    
    func loadPromoCntent(index:Int) {
        
        
        
        if internetConection! {
        let link = promociones[index].marca.img_cfondo
        Alamofire.request(.GET, link)
            .responseImage { response in
                debugPrint(response)
                
                debugPrint(response.result)
                
                if let image = response.result.value {
                    print("image downloaded: \(image)")
                    self.btnMarca.setImage(image, forState: .Normal)
                    self.btnMarca.imageView!.contentMode = .ScaleAspectFill
                    let imageViewSize = self.btnMarca.imageView!.frame.size
                    self.btnMarca.imageView?.layer.cornerRadius = imageViewSize.height * 0.5
                    let imageData = UIImagePNGRepresentation(image)
                    self.promociones[index].img_cfondo_data = imageData
                }
        }
        }
        else {
            if let data = self.promociones[index].img_cfondo_data {
                
                self.btnMarca.setImage(UIImage(data: data), forState: .Normal)
            }
            
            
        }
        self.currentPromoIndex = index
        lblTituloPromo.text = promociones[index].titulo
        lbldescripcionCorta.text = promociones[index].desc_corta
        let dateStr : String = promociones[index].vigencia
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var  date = NSDate()
        date = dateFormatter.dateFromString(dateStr)!
        dateFormatter.dateFormat = "dd MMM"
        lblVigencia.text = dateFormatter.stringFromDate(date)
        if let marcaID = promociones[index].marca_id {
            
            if  misMarcas.contains(marcaID) {
                viewAddCard.hidden = true
            }
            else {
                viewAddCard.hidden = false
                
            }

            
        }
        
        
        
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
    
    
    func findMarca(){
        
        for i in 0..<promociones.count {
            
            for j in 0..<MarcasArray.count {
                
                if promociones[i].marca_id == MarcasArray[j].id {
                    
                    promociones[i].marca = MarcasArray[j]
                    promociones[i].img_cfondo = MarcasArray[j].img_sfondo
                    print("Marca found")
                    break
                }
            }
        }
        ArregloPromociones.promociones = promociones
        let myData = NSKeyedArchiver.archivedDataWithRootObject(ArregloPromociones.promociones)
        NSUserDefaults.standardUserDefaults().setObject(myData, forKey: "promocionesDestacadas")
        NSUserDefaults.standardUserDefaults().synchronize()
        self.pageViewCarrusel!.padre = self
        self.pageViewCarrusel!.promociones = self.promociones
        self.pageViewCarrusel?.iop()


        
    }
    
    func movingForward() {
        
        guard let currentViewController = pageViewCarrusel!.viewControllers?.first else { return }
        
        guard let nextViewController = pageViewCarrusel!.dataSource?.pageViewController( pageViewCarrusel!, viewControllerAfterViewController: currentViewController ) else { return }
        
              // if vc.view.tag
        let index =  nextViewController.view.tag
        loadPromoCntent(index)
        
        pageViewCarrusel!.setViewControllers([nextViewController], direction: .Forward, animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func todasMisTarjetas(sender: AnyObject) {
        
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
    
    func gettingCards() {
    
        let defaults = NSUserDefaults.standardUserDefaults()
        
        
        
        if let notasRaw = defaults.dataForKey("\(user.email!)tarjetas") {
            
            if let favoritas = NSKeyedUnarchiver.unarchiveObjectWithData(notasRaw) as? [CTarjeta] {
                
                ArregloTarjetasFavoritas.tarjetasFavoritas = favoritas
                tarjetas = ArregloTarjetasFavoritas.tarjetasFavoritas

                if tarjetas.count > 0 && logged!{
                    
                    if let obk = defaults.objectForKey("\(user.email!)misMarcasID") {
                        
                        misMarcas = obk as! [Int]
                        
                    }
                    
                    
                    
                    if let tem = defaults.objectForKey("\(user.email!)tarjetasFavID"){
                        
                        self.TarjetasFavID = tem as! [Int]
                        
                        if self.TarjetasFavID.count > 0 {
                            
                           
                            // Adding 4 cards   currentViewController
                            self.VCTarjetasFavoritas = self.storyboard?.instantiateViewControllerWithIdentifier("TarjetasFavoritasViewController") as? TarjetasFavoritasViewController
                            self.VCTarjetasFavoritas!.view.translatesAutoresizingMaskIntoConstraints = false
                            self.addChildViewController(self.VCTarjetasFavoritas!)
                            self.addSubview(self.VCTarjetasFavoritas!.view, toView: self.contenedorMisTarjetas)
                            
                            
                            
                            
                            var trjFav = false
                            for i in 0..<self.tarjetas.count {
                                
                                for j in 0..<self.TarjetasFavID.count {
                                    
                                    if let id = tarjetas[i].id {
                                    if id == self.TarjetasFavID[j]{
                                        self.tarjetas[i].favorita = true
                                        self.tarjetasFavoritas.append(self.tarjetas[i])
                                        trjFav = true
                                        break
                                    }
                                    else { trjFav = false}
                                    }
                                    else {trjFav = false}
                                }
                                
                                if !trjFav {
                                    tarjetasNoFavoritas.append(tarjetas[i])
                                    trjFav = false
                                }

                            }
                            
                        print("Cards Found")
                        
                        
                        for index in 0..<self.tarjetasFavoritas.count{
                            
                            switch index {
                            case 0:
                                
                                if let link = tarjetasFavoritas[index].img_tarjs {
                               
                                    
                                    if internetConection! {
                                Alamofire.request(.GET, link)
                                    .responseImage { response in
                                        debugPrint(response)
                                        
                                        debugPrint(response.result)
                                        
                                        if let image = response.result.value {
                                            print("image downloaded: \(image)")
                                            self.VCTarjetasFavoritas?.btn00.setImage(image, forState: .Normal)
                                            
                                            
                                             self.VCTarjetasFavoritas?.btn00.imageView!.layer.cornerRadius = 10
                                            
                                             self.VCTarjetasFavoritas?.btn00.imageView!.contentMode = .ScaleToFill
                                            
                                             self.VCTarjetasFavoritas?.btn00.addTarget(self, action: #selector(self.CardSelected(_:)), forControlEvents: .TouchDown)

                                            
                                        }
                                }
                                }
                                    else {
                                        
                                        self.VCTarjetasFavoritas?.btn00.setImage(UIImage( data: tarjetasFavoritas[index].img_tarjs_data), forState: .Normal)
                                        
                                        self.VCTarjetasFavoritas?.btn00.imageView!.layer.cornerRadius = 10
                                        
                                        self.VCTarjetasFavoritas?.btn00.imageView!.contentMode = .ScaleToFill
                                        
                                        self.VCTarjetasFavoritas?.btn00.addTarget(self, action: #selector(self.CardSelected(_:)), forControlEvents: .TouchDown)

                                    }
                                }
                                break
                                
                            
                                
                            case 1:
                                if let link = tarjetasFavoritas[index].img_tarjs {
                                
                                    if internetConection! {
                                    Alamofire.request(.GET, link)
                                    .responseImage { response in
                                        debugPrint(response)
                                        
                                        debugPrint(response.result)
                                        
                                        if let image = response.result.value {
                                            print("image downloaded: \(image)")
                                            self.VCTarjetasFavoritas?.btn01.setImage(image, forState: .Normal)
                                            
                                            self.VCTarjetasFavoritas?.btn01.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
                                            
                                            self.VCTarjetasFavoritas?.btn01.imageView!.layer.cornerRadius = 10
                                            self.VCTarjetasFavoritas?.btn01.imageView!.clipsToBounds = true
                                            self.VCTarjetasFavoritas?.btn01.imageView!.contentMode = .ScaleAspectFill
                                            
                                            self.VCTarjetasFavoritas?.btn01.addTarget(self, action: #selector(self.CardSelected(_:)), forControlEvents: .TouchDown)
                                            

                                        }
                                }
                                }
                                    else {
                                        
                                        self.VCTarjetasFavoritas?.btn01.setImage(UIImage( data: tarjetasFavoritas[index].img_tarjs_data), forState: .Normal)
                                        
                                        self.VCTarjetasFavoritas?.btn01.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
                                        
                                        self.VCTarjetasFavoritas?.btn01.imageView!.layer.cornerRadius = 10
                                        self.VCTarjetasFavoritas?.btn01.imageView!.clipsToBounds = true
                                        self.VCTarjetasFavoritas?.btn01.imageView!.contentMode = .ScaleAspectFill
                                        
                                        self.VCTarjetasFavoritas?.btn01.addTarget(self, action: #selector(self.CardSelected(_:)), forControlEvents: .TouchDown)

                                        
                                    }
                                }
                                break
                                
                            case 2:
                                if let link = tarjetasFavoritas[index].img_tarjs {
                                
                                    if internetConection! {
                                    
                                    Alamofire.request(.GET, link)
                                    .responseImage { response in
                                        debugPrint(response)
                                        
                                    debugPrint(response.result)
                                        
                                        if let image = response.result.value {
                                            print("image downloaded: \(image)")
                                            self.VCTarjetasFavoritas?.btn10.setImage(image, forState: .Normal)
                                            self.VCTarjetasFavoritas?.btn10.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
                                            
                                            self.VCTarjetasFavoritas?.btn10.imageView!.layer.cornerRadius = 10
                                            self.VCTarjetasFavoritas?.btn10.imageView!.clipsToBounds = true
                                            self.VCTarjetasFavoritas?.btn10.imageView!.contentMode = .ScaleAspectFill
                                            
                                            self.VCTarjetasFavoritas?.btn10.addTarget(self, action: #selector(self.CardSelected(_:)), forControlEvents: .TouchDown)
                                            

                                        }
                                }
                                }
                                    else {
                                        
                                        self.VCTarjetasFavoritas?.btn10.setImage(UIImage( data: tarjetasFavoritas[index].img_tarjs_data), forState: .Normal)
                                        self.VCTarjetasFavoritas?.btn10.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
                                        
                                        self.VCTarjetasFavoritas?.btn10.imageView!.layer.cornerRadius = 10
                                        self.VCTarjetasFavoritas?.btn10.imageView!.clipsToBounds = true
                                        self.VCTarjetasFavoritas?.btn10.imageView!.contentMode = .ScaleAspectFill
                                        
                                        self.VCTarjetasFavoritas?.btn10.addTarget(self, action: #selector(self.CardSelected(_:)), forControlEvents: .TouchDown)

                                        
                                    }
                                }
                                break
                            case 3:
                                if let link = tarjetasFavoritas[index].img_tarjs {
                                
                                    if internetConection! {
                                    
                                    Alamofire.request(.GET, link)
                                    .responseImage { response in
                                        debugPrint(response)
                                        
                                        debugPrint(response.result)
                                        
                                        if let image = response.result.value {
                                            print("image downloaded: \(image)")
                                            self.VCTarjetasFavoritas?.btn11.setImage(image, forState: .Normal)
                                            self.VCTarjetasFavoritas?.btn11.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
                                            
                                            self.VCTarjetasFavoritas?.btn11.imageView!.layer.cornerRadius = 10
                                            self.VCTarjetasFavoritas?.btn11.imageView!.clipsToBounds = true
                                            self.VCTarjetasFavoritas?.btn11.imageView!.contentMode = .ScaleAspectFill
                                            
                                            self.VCTarjetasFavoritas?.btn11.addTarget(self, action: #selector(self.CardSelected(_:)), forControlEvents: .TouchDown)
                                            

                                        }
                                }
                                }
                                    else {
                                        self.VCTarjetasFavoritas?.btn11.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
                                        self.VCTarjetasFavoritas?.btn11.setImage(UIImage( data: tarjetasFavoritas[index].img_tarjs_data), forState: .Normal)
                                        self.VCTarjetasFavoritas?.btn11.imageView!.layer.cornerRadius = 10
                                        self.VCTarjetasFavoritas?.btn11.imageView!.clipsToBounds = true
                                        self.VCTarjetasFavoritas?.btn11.imageView!.contentMode = .ScaleAspectFill
                                        
                                        self.VCTarjetasFavoritas?.btn11.addTarget(self, action: #selector(self.CardSelected(_:)), forControlEvents: .TouchDown)

                                    }
                                }
                                break
                            default:
                                
                                
                                break
                            }
                            
                            
                        }

                            
                            
                        if tarjetasFavoritas.count == 1 {
                            
                            self.VCTarjetasFavoritas?.btn01.addTarget(self, action: #selector(self.emptyCardSelected(_:)), forControlEvents: .TouchDown)
                            self.VCTarjetasFavoritas?.btn10.addTarget(self, action: #selector(self.emptyCardSelected(_:)), forControlEvents: .TouchDown)
                            self.VCTarjetasFavoritas?.btn11.addTarget(self, action: #selector(self.emptyCardSelected(_:)), forControlEvents: .TouchDown)
                        
                            
                        }
                        else if tarjetasFavoritas.count == 2{
                            
                            self.VCTarjetasFavoritas?.btn10.addTarget(self, action: #selector(self.emptyCardSelected(_:)), forControlEvents: .TouchDown)
                            self.VCTarjetasFavoritas?.btn11.addTarget(self, action: #selector(self.emptyCardSelected(_:)), forControlEvents: .TouchDown)
                        
                        }
                        else if tarjetasFavoritas.count == 3 {
                            
                            self.VCTarjetasFavoritas?.btn11.addTarget(self, action: #selector(self.emptyCardSelected(_:)), forControlEvents: .TouchDown)
                            
                        }
                        else {
                         
                            self.VCTarjetasFavoritas?.btn01.addTarget(self, action: #selector(self.emptyCardSelected(_:)), forControlEvents: .TouchDown)
                            self.VCTarjetasFavoritas?.btn00.addTarget(self, action: #selector(self.emptyCardSelected(_:)), forControlEvents: .TouchDown)
                            self.VCTarjetasFavoritas?.btn10.addTarget(self, action: #selector(self.emptyCardSelected(_:)), forControlEvents: .TouchDown)
                            self.VCTarjetasFavoritas?.btn11.addTarget(self, action: #selector(self.emptyCardSelected(_:)), forControlEvents: .TouchDown)
                            
                            tarjetasNoFavoritas = tarjetas
                            print("No cards Found")
                            
                        }
                            
                            
                            
                        }
                        else {
                            
                            // Adding 4 cards   currentViewController
                            self.VCTarjetasFavoritas = self.storyboard?.instantiateViewControllerWithIdentifier("TarjetasFavoritasViewController") as? TarjetasFavoritasViewController
                            self.VCTarjetasFavoritas!.view.translatesAutoresizingMaskIntoConstraints = false
                            self.addChildViewController(self.VCTarjetasFavoritas!)
                            self.addSubview(self.VCTarjetasFavoritas!.view, toView: self.contenedorMisTarjetas)
                            
                            
                            self.VCTarjetasFavoritas?.btn01.addTarget(self, action: #selector(self.emptyCardSelected(_:)), forControlEvents: .TouchDown)
                            self.VCTarjetasFavoritas?.btn00.addTarget(self, action: #selector(self.emptyCardSelected(_:)), forControlEvents: .TouchDown)
                            self.VCTarjetasFavoritas?.btn10.addTarget(self, action: #selector(self.emptyCardSelected(_:)), forControlEvents: .TouchDown)
                            self.VCTarjetasFavoritas?.btn11.addTarget(self, action: #selector(self.emptyCardSelected(_:)), forControlEvents: .TouchDown)
                            
                            tarjetasNoFavoritas = tarjetas
                            print("No cards Found")
                        }
                        
                        
                        
                    }
                    else {
                        
                        // Adding 4 cards   currentViewController
                        self.VCTarjetasFavoritas = self.storyboard?.instantiateViewControllerWithIdentifier("TarjetasFavoritasViewController") as? TarjetasFavoritasViewController
                        self.VCTarjetasFavoritas!.view.translatesAutoresizingMaskIntoConstraints = false
                        self.addChildViewController(self.VCTarjetasFavoritas!)
                        self.addSubview(self.VCTarjetasFavoritas!.view, toView: self.contenedorMisTarjetas)
                        
                        self.VCTarjetasFavoritas?.btn01.addTarget(self, action: #selector(self.emptyCardSelected(_:)), forControlEvents: .TouchDown)
                        self.VCTarjetasFavoritas?.btn00.addTarget(self, action: #selector(self.emptyCardSelected(_:)), forControlEvents: .TouchDown)
                        self.VCTarjetasFavoritas?.btn10.addTarget(self, action: #selector(self.emptyCardSelected(_:)), forControlEvents: .TouchDown)
                        self.VCTarjetasFavoritas?.btn11.addTarget(self, action: #selector(self.emptyCardSelected(_:)), forControlEvents: .TouchDown)
                        
                        tarjetasNoFavoritas = tarjetas
                        print("No cards Found")


                        
                    }
                 // tercero
                    
                }
                else {
                    
                    self.VCAddFirstView = self.storyboard?.instantiateViewControllerWithIdentifier("AddFirstCardViewController") as? AddFirstCardViewController
                    self.VCAddFirstView?.delegate = self
                    self.VCAddFirstView?.logged = logged!
                    self.VCAddFirstView!.view.translatesAutoresizingMaskIntoConstraints = false
                    self.addChildViewController(self.VCAddFirstView!)
                    self.addSubview(self.VCAddFirstView!.view, toView: self.contenedorMisTarjetas)
                    
                }
                //segundo
            }
            else {
                
                self.VCAddFirstView = self.storyboard?.instantiateViewControllerWithIdentifier("AddFirstCardViewController") as? AddFirstCardViewController
                self.VCAddFirstView?.delegate = self
                self.VCAddFirstView?.logged = logged!
                self.VCAddFirstView!.view.translatesAutoresizingMaskIntoConstraints = false
                self.addChildViewController(self.VCAddFirstView!)
                self.addSubview(self.VCAddFirstView!.view, toView: self.contenedorMisTarjetas)
                
            }
            /*
            self.pageViewCarrusel!.padre = self
            self.pageViewCarrusel!.promociones = self.promociones
            self.pageViewCarrusel?.iop()*/

            //primer
        }
        else {
           
            self.VCAddFirstView = self.storyboard?.instantiateViewControllerWithIdentifier("AddFirstCardViewController") as? AddFirstCardViewController
            self.VCAddFirstView?.delegate = self
            self.VCAddFirstView?.logged = logged!
            self.VCAddFirstView!.view.translatesAutoresizingMaskIntoConstraints = false
            self.addChildViewController(self.VCAddFirstView!)
            self.addSubview(self.VCAddFirstView!.view, toView: self.contenedorMisTarjetas)
        }
        
       
        if internetConection! {
            
            loadingPromocionesDestacadas()
        }
        
    
    }
    
    
    
    
    func  emptyCardSelected(sender : UIButton) {
        
        print("card selected")
        /*
        let vc = storyboard?.instantiateViewControllerWithIdentifier("dashboardTarjetasListViewController") as! dashboardTarjetasListViewController
        vc.tarjetasNoFavoritas = self.tarjetasNoFavoritas as [CTarjeta]
        presentViewController(vc, animated: true, completion: nil)
        */
        
        
        let alertController = UIAlertController(title: "Mis Tarjetas", message: "Selecciona una Tarjeta", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .Cancel) { (action) in
            print(action)
        }
        alertController.addAction(cancelAction)
        
        for i in 0..<tarjetasNoFavoritas.count {
            
            let oneAction = UIAlertAction(title: tarjetasNoFavoritas[i].alias , style: .Default,handler: { action in
                
                
                if let link = self.tarjetasNoFavoritas[i].img_tarjs {
                    Alamofire.request(.GET, link)
                        .responseImage { response in
                            debugPrint(response)
                            
                            debugPrint(response.result)
                            
                            if let image = response.result.value {
                                print("image downloaded: \(image)")
                                sender.setImage(image, forState: .Normal)
                                sender.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
                                
                                sender.imageView?.layer.frame.size.width = self.view.frame.size.width * 0.30
                                sender.layer.frame.size.width = self.view.frame.size.width * 0.30
                                
                                sender.imageView!.layer.cornerRadius = 10
                                sender.imageView!.contentMode = .ScaleAspectFill
                                //hasdkjfasdkfjhaksdfbalsdfg
                                sender.tag = i
                                sender.removeTarget(self, action: #selector(self.emptyCardSelected(_:)), forControlEvents: .TouchDown)
                                sender.addTarget(self, action: #selector(self.CardSelected(_:)), forControlEvents: .TouchDown)
                                self.TarjetasFavID.append(self.tarjetasNoFavoritas[i].id)
                                self.tarjetasFavoritas.append(self.tarjetasNoFavoritas[i])
                                self.tarjetasNoFavoritas.removeAtIndex(i)
                                let defaults = NSUserDefaults.standardUserDefaults()
                                defaults.setObject(self.TarjetasFavID, forKey: "\(self.user.email!)tarjetasFavID")
                                defaults.synchronize()

                                
                            }
                    }
                }
                
            })
            alertController.addAction(oneAction)
        }
       
        self.presentViewController(alertController, animated: true,completion: nil)
        
        
    }
    
    func CardSelected(sender : UIButton) {
        
        
        print(sender.tag)
        
            if tarjetasFavoritas[sender.tag].tipo == "VIRTUAL" {
                
                
                if let sv = self.revealViewController(){
                    let  vc = self.storyboard?.instantiateViewControllerWithIdentifier("detalleTarjtVirtualViewController") as! detalleTarjtVirtualViewController
                    vc.tarjeta = tarjetasFavoritas[sender.tag]
                    vc.senderVC = "SlideOutMenUIViewController"
                    //sv.pushFrontViewController(vc, animated: true)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                
            }
            else if tarjetasFavoritas[sender.tag].tipo == "FISICA" || tarjetasFavoritas[sender.tag].tipo == "AMBAS"{
                
                
                if let sv = self.revealViewController(){
                    let  vc = self.storyboard?.instantiateViewControllerWithIdentifier("DetalleTarjFisicaViewController") as! DetalleTarjFisicaViewController
                    vc.tarjeta = tarjetasFavoritas[sender.tag]
                    vc.senderVC = "SlideOutMenUIViewController"
                    //sv.pushFrontViewController(vc, animated: true)
                     self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        
    
        
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
    
    func marcaNoFavoritaPopUP() {
        
        let vc = storyboard?.instantiateViewControllerWithIdentifier("PopUp1BtnViewController") as! PopUp1BtnViewController
        vc.btnText = "CERRAR"
        vc.btnImage = "desgrane_general_btn_azul"
        vc.imageName = "desgrane_general_icon_alerta"
        vc.labelText = "Necesitas tener la tarjeta de esta marca para guardar la promoción como favorita"
        presentViewController(vc, animated: true, completion: nil)
        
    }
    
    func sendImageData(index : Int, data : NSData){
        
        promociones[index].imagenData = data
        ArregloPromociones.promociones = promociones
        let myData = NSKeyedArchiver.archivedDataWithRootObject(ArregloPromociones.promociones)
        NSUserDefaults.standardUserDefaults().setObject(myData, forKey: "promocionesDestacadas")
        
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



