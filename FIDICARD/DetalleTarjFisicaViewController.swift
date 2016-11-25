//
//  DetalleTarjFisicaViewController.swift
//  FIDICARD
//
//  Created by Martin Viruete Gonzalez on 13/10/16.
//  Copyright © 2016 oomovil. All rights reserved.
//

import UIKit
import SWRevealViewController
import AlamofireImage
import Alamofire
import SwiftyJSON
import Haneke

class DetalleTarjFisicaViewController: UIViewController {

    var tarjeta = CTarjeta()
    @IBOutlet weak var imgTarjeta: UIImageView!
    @IBOutlet weak var lblAlias: UILabel!
    @IBOutlet weak var imgBarCode: UIImageView!
    @IBOutlet weak var notSwitch: UISwitch!
    
    var user = Usuario()
    var MarcasArray = [CMarca]()
    var MarcasDownloaded = [CMarca]()
    var senderVC = ""
    var internet : Bool!
    
    
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
                self.user = user
                btnBadge.setTitle(String(defaults.integerForKey("\(user.email!)badge")), forState: .Normal)
                
            }
            
        }
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        loadUser()
        internet = Reachability.isConnectedToNetwork()
        lblAlias.text = tarjeta.alias
        generateImage(tarjeta.img_tarjs, imageView: imgTarjeta)
        imgTarjeta.contentMode = UIViewContentMode.ScaleAspectFit;
        imgTarjeta.layer.cornerRadius = 20
        imgTarjeta.clipsToBounds = true
        imgTarjeta.contentMode = .ScaleAspectFill
        let linkBArCode = "http://201.168.207.17:8888/fidicard/kuff-barcode/kuff-barcode.php?code=" + tarjeta.numero
        //generateImage(linkBArCode, imageView: imgBarCode)
        imgBarCode.hnk_setImageFromURL(NSURL(string: linkBArCode)!)
        if tarjeta.marca != nil {
            
            
        }
        else {
            let vc = storyboard?.instantiateViewControllerWithIdentifier("ActivityIndicatorViewController") as! ActivityIndicatorViewController
            presentViewController(vc, animated: false, completion: nil)
            loadingMarcas()
        }

        
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
       
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func editarTarjeta(sender: AnyObject) {
        
        if let sv = self.revealViewController(){
            let  vc = self.storyboard?.instantiateViewControllerWithIdentifier("EditarTarjetaViewController") as! EditarTarjetaViewController
            vc.tarjeta = tarjeta
            
            self.navigationController?.pushViewController(vc, animated: true)
            //sv.pushFrontViewController(vc, animated: true)
        }
        
        
    }
    
    
    @IBAction func abrirMenu(sender: AnyObject) {
        
        if let sw = self.revealViewController(){
            sw.revealToggleAnimated(true)
             self.revealViewController().rearViewRevealWidth =  self.view.frame.width * 0.85
        }
        
    }
    
    
    @IBAction func regresar(sender: AnyObject) {
        
      
        /*
        switch senderVC {
            
        case "MisTarjetasViewController":
            
            if let sv = self.revealViewController(){
                let  vc = self.storyboard?.instantiateViewControllerWithIdentifier("MisTarjetasViewController") as! MisTarjetasViewController
                
                sv.pushFrontViewController(vc, animated: true)
            }
            
            break
            
        case "SlideOutMenUIViewController":
            
            if let sv = self.revealViewController(){
                let  vc = self.storyboard?.instantiateViewControllerWithIdentifier("SlideOutMenUIViewController") as! SlideOutMenUIViewController
                
                sv.pushFrontViewController(vc, animated: true)
            }
            
            
            
            break
            
        default:
            break
        }*/
        self.navigationController?.popViewControllerAnimated(true)
        
        
    }
    
    
    func generateImage(url: String, imageView: UIImageView) {
        
        
        Alamofire.request(.GET, url)
            .responseImage { response in
                debugPrint(response)
                
                print(response.request)
                print(response.response)
                debugPrint(response.result)
                
                if let imageDownloaded = response.result.value {
                    print("image downloaded: \(imageDownloaded)")
                    imageView.image = imageDownloaded
                }
                else {
                    
                    imageView.image = UIImage(named: "ios_general_icn_nofound" )!
                    
                }
                
        }
        
        
    }
    
    
    @IBAction func girar90(sender: AnyObject) {
        
        //AppDelegate.shouldRotate = true
        
                
        if let sv = self.revealViewController(){
            let  vc = self.storyboard?.instantiateViewControllerWithIdentifier("DetTarjFisicaVolteadaViewController") as! DetTarjFisicaVolteadaViewController
            vc.tarjeta = tarjeta
            vc.padreVC = senderVC
            
            (UIApplication.sharedApplication().delegate as! AppDelegate).landscape = true
            let value = UIInterfaceOrientation.LandscapeRight.rawValue
            UIDevice.currentDevice().setValue(value, forKey: "orientation")
            self.navigationController?.pushViewController(vc, animated: false)
            //sv.pushFrontViewController(vc, animated: true)
        }

        
    }
    
    
    
    
    @IBAction func goToNotas(sender: AnyObject) {
        
        if let sv = self.revealViewController(){
            let  vc = self.storyboard?.instantiateViewControllerWithIdentifier("NotasViewController") as! NotasViewController
            vc.tarjeta = tarjeta
            //sv.pushFrontViewController(vc, animated: true)
            self.navigationController?.pushViewController(vc, animated: true)
        }

        
        
    }
    
    
    @IBAction func goToPromos(sender: AnyObject) {
        
        if internet! {
        
        if let sv = self.revealViewController(){
            let  vc = self.storyboard?.instantiateViewControllerWithIdentifier("Promos1ViewController") as! Promos1ViewController
            vc.senderID = "DetalleTarjFisicaViewController"
            vc.tarjeta = self.tarjeta
            vc.padreSenderID = self.senderVC
            //sv.pushFrontViewController(vc, animated: true)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        }else {
            let alert = UIAlertController(title: "Error de Conexion", message: "Puedes acceder aesta seccion sin una conexion a Internet", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
                
    }
    
    @IBAction func goToSucursales(sender: AnyObject) {
        
        if internet! {
        if let sv = self.revealViewController(){
            
            let  vc = self.storyboard?.instantiateViewControllerWithIdentifier("SucursalesViewController") as! SucursalesViewController
            vc.sucursales = tarjeta.marca.sucursales
            vc.Marca = self.tarjeta.marca
            vc.tarjeta = self.tarjeta
            vc.senderVC = "DetalleTarjFisicaViewController"
            vc.padreSenderVC = senderVC
            //sv.pushFrontViewController(vc, animated: true)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        }
    else {
    let alert = UIAlertController(title: "Error de Conexion", message: "Puedes acceder aesta seccion sin una conexion a Internet", preferredStyle: UIAlertControllerStyle.Alert)
    alert.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.Default, handler: nil))
    self.presentViewController(alert, animated: true, completion: nil)
    }

    
    
    
    }
    
    
    @IBAction func GoToInfo(sender: AnyObject) {
        
        
        if internet! {
        
        if let sv = self.revealViewController(){
            
            let  vc = self.storyboard?.instantiateViewControllerWithIdentifier("InformacionMarcaViewController") as! InformacionMarcaViewController
            vc.padreSenderVC = senderVC
            vc.nombre = tarjeta.marca.nombre
            vc.ubicacion = tarjeta.marca.ubicacion
            vc.telefonos = tarjeta.marca.tels[0]
            vc.web = tarjeta.marca.web
            vc.info = tarjeta.marca.info
            vc.Marca = self.tarjeta.marca
            vc.tarjeta = self.tarjeta
            vc.senderVC = "DetalleTarjFisicaViewController"
            //sv.pushFrontViewController(vc, animated: true)
            self.navigationController?.pushViewController(vc, animated: true)
        }
            
        }else {
            let alert = UIAlertController(title: "Error de Conexion", message: "Puedes acceder aesta seccion sin una conexion a Internet", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }

        
        
    }
    
    func getCodigoBarras() {
        
        
        
    }
    
    
    func loadingMarcas() {
        
        if internet! {
        
        
        
        
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
                        marcaTemporal.tipo_tarjs = response[index]["tipo_tarjs"].string ?? "-1"
                        marcaTemporal.sucursales = [sucursal]()
                        let sucursales = response[index]["sucursales"]
                        let sucursalTemporal = sucursal()
                        for indexSuc in 0..<sucursales.count {
                            
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
                    self.findMarca()
                    self.MarcasDownloaded = self.MarcasArray
                    
                    
                }
            }
        }
            
        }
        
        else {
            self.dismissViewControllerAnimated(false, completion: nil)
            let alert = UIAlertController(title: "Error de Conexion", message: "Puede que varias funciones no esten activas", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)

        }
    }
    
    
    func findMarca(){
        
        for j in 0..<MarcasArray.count {
                
                if tarjeta.marca_id == MarcasArray[j].id {
                    
                    tarjeta.marca = MarcasArray[j]
                    print("Marca found")
                    break
                }
            }
        self.dismissViewControllerAnimated(false, completion: nil)
        
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
    
    @IBAction func goToInicio(sender: AnyObject) {
        
        if let sv = self.revealViewController(){
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("Home")
            sv.pushFrontViewController(vc, animated: true)
        }
        
    }

    
    @IBAction func changeNotification(sender: AnyObject) {
        
        if notSwitch.on {
            
            let todosEndpoint: String = "http://201.168.207.17:8888/fidicard/kuff_api/toggleNotifMarca"
            let newTodo = ["email": String(user.email!),"marca_id" : String(self.tarjeta.marca_id) , "activa" : 1]

            print(newTodo)
            Alamofire.request(.POST, todosEndpoint, parameters: newTodo as! [String : AnyObject])
                .responseJSON { response in
                
                    guard response.result.error == nil else {
                        
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
                                        
                                        print("toggled")
                                    }
                                
                            }
                    }
            }
        }
        else {
            
            let todosEndpoint: String = "http://201.168.207.17:8888/fidicard/kuff_api/toggleNotifMarca"
            let newTodo = ["email": String(user.email!),"marca_id" : String(self.tarjeta.marca_id) , "activa" : 0]
            print(newTodo)
            Alamofire.request(.POST, todosEndpoint, parameters: newTodo as! [String : AnyObject])
                .responseJSON { response in
                    
                    guard response.result.error == nil else {
                        
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
                                
                                print("toggled")
                            }
                            
                        }
                    }
            }

            
        }
        
    }


}
