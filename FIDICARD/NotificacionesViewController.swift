//
//  NotificacionesViewController.swift
//  FIDICARD
//
//  Created by omar on 16/09/16.
//  Copyright © 2016 oomovil. All rights reserved.
//

import UIKit
import SWRevealViewController
import Alamofire
import AlamofireImage

class NotificacionesViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    var notificaciones = [CPromocion]()
    static let RefreshNewsFeedNotification = "RefreshNewsFeedNotification"
    
    @IBOutlet weak var notificacionesTableView: UITableView!
    @IBOutlet weak var imgHome: UIImageView!
    @IBOutlet weak var btnBadge: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        loadUser()
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.receivedRefreshNewsFeedNotification(_:)), name: NotificacionesViewController.RefreshNewsFeedNotification, object: nil)
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let obj = defaults.dataForKey("user") where defaults.boolForKey("userLogged") {
            
            if let user = NSKeyedUnarchiver.unarchiveObjectWithData(obj) as? Usuario {
                
                if let objeto = defaults.dataForKey("\(user.email!)notificaciones") {
                    
                    if let Notificaciones = NSKeyedUnarchiver.unarchiveObjectWithData(objeto) as? [CPromocion] {
                        
                        ArregloPromociones.promociones = Notificaciones
                        self.notificaciones = ArregloPromociones.promociones
                        
                        for i in 0..<self.notificaciones.count {
                            
                            notificaciones[i].vigencia = "2016-10-10"
                            notificaciones[i].img_cfondo = "nil"
                        }
                        
                        notificacionesTableView.reloadData()
                    }
                }
                
            }
            
        }

        
        let notificacion = CPromocion()
        notificacion.desc_corta = "Nuevo NOtificcion"
        notificacion.vigencia = "2016-05-29"
        notificacion.img_cfondo = ""
        notificacion.imagen = ""
        notificacion.titulo = "Nuevo Notificacion"
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    @IBAction func OpenMenu(sender: AnyObject) {
        
        if let sw = self.revealViewController(){
            sw.revealToggleAnimated(true)
            self.revealViewController().rearViewRevealWidth =  self.view.frame.width * 0.85
            //self.revealViewController().frontViewShadowRadius = 50
            //sw.frontViewShadowOffset.width = self.view.frame.width * 0.15
        }

    }
    @IBAction func goToMArcas(sender: AnyObject) {
        
        if let sv = self.revealViewController(){
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("MisMarcas")
            sv.pushFrontViewController(vc, animated: true)
        }

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificaciones.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        
        
        
        if let sv = self.revealViewController(){
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("notificacionDetalleViewController") as! notificacionDetalleViewController
            vc.notificaion = notificaciones[indexPath.row]
            sv.pushFrontViewController(vc, animated: true)
        }
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("notificacionCell", forIndexPath: indexPath) as! notificationTableViewCell
        cell.lblDescripcion.text = self.notificaciones[indexPath.row].desc_corta
        
        Alamofire.request(.GET, self.notificaciones[indexPath.row].img_cfondo)
            .responseImage { response in
                debugPrint(response)
                
                debugPrint(response.result)
                
                if let image = response.result.value {
                    print("image downloaded: \(image)")
                    cell.imgMarca.image = image
                }
        }
        
        let dateStr : String = self.notificaciones[indexPath.row].vigencia
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var  date = NSDate()
        date = dateFormatter.dateFromString(dateStr)!
        dateFormatter.dateFormat = "dd MMM"
        cell.lblVigencia.text = dateFormatter.stringFromDate(date)
        cell.lblVigencia.text = self.notificaciones[indexPath.row].vigencia
        
        return cell
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    func receivedRefreshNewsFeedNotification(notification: NSNotification) {
        dispatch_async(dispatch_get_main_queue()) {
            self.notificacionesTableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
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
    

   
}
