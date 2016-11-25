//
//  ConfirmTarjtVirtGenViewController.swift
//  FIDICARD
//
//  Created by Miguel Jimenez on 10/12/16.
//  Copyright © 2016 oomovil. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SWRevealViewController


class ConfirmTarjtVirtGenViewController: UIViewController {
    
    
    var Marca = CMarca()
    var user = Usuario()
    var numTarjt = ""
    var pleca = ""
    var titulo = ""
    var aviso = ""
    var fromGenerar = false
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblNumTarjeta: UILabel!
    @IBOutlet weak var tarjetaImage: UIImageView!
    @IBOutlet weak var lblAviso: UILabel!
    @IBOutlet weak var imgPleca: UIImageView!
    @IBOutlet weak var imgTitulo: UIImageView!
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
        
        loadUser()
        imgHome.userInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
        imgHome.addGestureRecognizer(tapRecognizer)
        
        if !fromGenerar {
            
            lblAviso.text = aviso
            imgPleca.image = UIImage(named: pleca)
            imgTitulo.image = UIImage(named: titulo)
        }

        
        lblUserName.text = user.nombre
        generateImage(Marca.img_tarjs,imageView: tarjetaImage)
        lblNumTarjeta.text = numTarjt
        tarjetaImage.contentMode = UIViewContentMode.ScaleAspectFit;
        tarjetaImage.layer.cornerRadius = 20
        tarjetaImage.clipsToBounds = true
        tarjetaImage.contentMode = .ScaleAspectFill

        
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    @IBAction func regresar(sender: AnyObject) {
        
        if let sv = self.revealViewController(){
            
            let  vc = self.storyboard?.instantiateViewControllerWithIdentifier("MarcaViewController") as! MarcaViewController
            
            vc.Marca = self.Marca
            //sv.pushFrontViewController(vc, animated: true)
            self.navigationController?.popViewControllerAnimated(true)
        }

    }
    
    @IBAction func abrirMenu(sender: AnyObject) {
        
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
