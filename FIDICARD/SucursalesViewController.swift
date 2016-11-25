//
//  SucursalesViewController.swift
//  FIDICARD
//
//  Created by Martin Viruete Gonzalez on 04/10/16.
//  Copyright © 2016 oomovil. All rights reserved.
//

import UIKit

class SucursalesViewController: UIViewController, UITabBarDelegate, UITableViewDataSource {
    
    var Marca = CMarca()
    var sucursales = [sucursal]()
    var senderVC = ""
    var tarjeta = CTarjeta()
    var padreSenderVC = ""
    var abueloSenderVC = ""
    var tataSenderVC = ""
    var MarcasDownloaded = [CMarca]()
    var marcasDidLoad = false
    var promocion = CPromocion()
    var filter = false
    var i1 = 0
    var i2 = 0
    var internet : Bool!
    
    @IBOutlet weak var sucursalesTable: UITableView!
    @IBOutlet weak var imgHome: UIImageView!
    
    
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
        internet = Reachability.isConnectedToNetwork()
        loadUser()
        imgHome.userInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
        imgHome.addGestureRecognizer(tapRecognizer)

        sucursalesTable.separatorStyle = UITableViewCellSeparatorStyle.None
        sucursalesTable.rowHeight = UITableViewAutomaticDimension
        sucursalesTable.estimatedRowHeight = 80
        sucursalesTable.reloadData()
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

    }
    
    func loadUser() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let user = defaults.dataForKey("user") {
            
            if let user = NSKeyedUnarchiver.unarchiveObjectWithData(user) as? Usuario {
                btnBadge.setTitle(String(defaults.integerForKey("\(user.email!)badge")), forState: .Normal)
                
            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sucursales.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("sucursalCell", forIndexPath: indexPath) as! SucursalTableViewCell
        
         cell.nombre.text =  sucursales[indexPath.row].nombre
         cell.direccion.text = sucursales[indexPath.row].direccion
         cell.telefono.text = sucursales[indexPath.row].tels[0]
        
        return cell
        
    }
    
    
    
 
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
        if internet!{
            
        
        if let sv = self.revealViewController(){
            
            let vc = storyboard!.instantiateViewControllerWithIdentifier("SucursalesLocationViewController") as! SucursalesLocationViewController
            vc.idexPath = indexPath.row
            vc.Marca = Marca
    
            if (self.senderVC == "Promos1ViewController") {
                Marca.sucursales = self.sucursales
            }
    
            vc.sucursales = self.sucursales
            vc.tarjeta = tarjeta
            vc.Marca = self.Marca
            vc.promocion = self.promocion
            vc.senderVC = senderVC
            vc.MarcasDownloaded = self.MarcasDownloaded
            vc.senderPadreVC = self.padreSenderVC
            vc.senderAbueloVC = self.abueloSenderVC
            vc.senderTataVC = self.tataSenderVC
            //sv.pushFrontViewController(vc, animated: true)
            self.navigationController?.pushViewController(vc, animated: true)
        }

        }
        else{
            
            let alert = UIAlertController(title: "Error de Conexion", message: "Puede que varias funciones no esten activas", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    
    @IBAction func regresar(sender: AnyObject) {
        
        
        self.navigationController?.popViewControllerAnimated(true)
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
            
        case "SlideOutMenUIViewController":
            
            if let sv = self.revealViewController(){
                let  vc = self.storyboard?.instantiateViewControllerWithIdentifier("SlideOutMenUIViewController")
                //sv.pushFrontViewController(vc, animated: true)
                self.navigationController?.popViewControllerAnimated(true)
            }
            

            
            break
            
        case "TodasLasPromocionesViewController":
            if let sv = self.revealViewController(){
                let vc = self.storyboard!.instantiateViewControllerWithIdentifier("TodasLasPromocionesViewController") as! TodasLasPromocionesViewController
                vc.marcasDidLoad = true
                vc.MarcasDownloaded = MarcasDownloaded
                vc.MarcasArray = MarcasDownloaded

                sv.pushFrontViewController(vc, animated: true)
            }
            
            
            break
            
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
            
        case  "TodasLasPromosDetalleViewController":
            
            if let sv = self.revealViewController(){
                let vc = storyboard?.instantiateViewControllerWithIdentifier("TodasLasPromosDetalleViewController") as! TodasLasPromosDetalleViewController
                vc.senderVC = padreSenderVC
                vc.padreSenderVC = abueloSenderVC
                vc.abueloSenderVC = self.tataSenderVC
                vc.MarcasDownloaded = self.MarcasDownloaded
                vc.promocion = self.promocion
                vc.marcasDidLoad = self.marcasDidLoad
                vc.Marca = self.Marca
                vc.tarjeta = self.tarjeta
                sv.pushFrontViewController(vc, animated: true)
            }

            
        break
            
            
        case "MisPromosDetalleViewController":
            
            if let sv = self.revealViewController(){
                let vc = storyboard?.instantiateViewControllerWithIdentifier("MisPromosDetalleViewController") as! MisPromosDetalleViewController
                vc.senderVC = "MisPromocionesViewController"
                vc.MarcasDownloaded = self.MarcasDownloaded
                vc.promocion = self.promocion
                vc.i1 = i1
                vc.i2 = i2
                vc.marcasDidLoad = self.marcasDidLoad
                sv.pushFrontViewController(vc, animated: true)
            }

            

            break
            
        case "Promos1ViewController":
            
            if let sv = self.revealViewController(){
                let  vc = self.storyboard?.instantiateViewControllerWithIdentifier("Promos1ViewController") as! Promos1ViewController
                vc.senderID = padreSenderVC
                vc.tarjeta = self.tarjeta
                vc.padreSenderID = abueloSenderVC
                sv.pushFrontViewController(vc, animated: true)
            }

            
            
            break
            
        default:
            break
        }
        
        */
      
    }
    
    
    @IBAction func OpenMenu(sender: AnyObject) {
        
        if let sw = self.revealViewController(){
            sw.revealToggleAnimated(true)
            self.revealViewController().rearViewRevealWidth =  self.view.frame.width * 0.85
        }
    }
    
    @IBAction func sucursalesCerca(sender: AnyObject) {
        
        if internet!{
        if let sv = self.revealViewController(){
            
            let vc = storyboard!.instantiateViewControllerWithIdentifier("SucursalesLocationViewController") as! SucursalesLocationViewController
            vc.allSucursales = true
            vc.tarjeta = tarjeta
            vc.Marca = Marca
            vc.sucursales = self.sucursales
            vc.senderVC = "SucursalesViewController"
            vc.senderPadreVC = self.senderVC
            vc.senderAbueloVC = self.padreSenderVC
            vc.senderTataVC = self.tataSenderVC
             self.navigationController?.pushViewController(vc, animated: true)
            //sv.pushFrontViewController(vc, animated: true)

        }

        }
        else {
            let alert = UIAlertController(title: "Error de Conexion", message: "Puede que varias funciones no esten activas", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            

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
