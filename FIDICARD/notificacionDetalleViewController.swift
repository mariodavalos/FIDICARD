//
//  notificacionDetalleViewController.swift
//  FIDICARD
//
//  Created by Martin Viruete Gonzalez on 27/10/16.
//  Copyright © 2016 oOMovil. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire


class notificacionDetalleViewController: UIViewController,UIWebViewDelegate {

    var notificaion = CPromocion()
    
    @IBOutlet weak var imgPromo: UIImageView!
    @IBOutlet weak var lblTituloPromo: UILabel!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var btnPromoLike: UIButton!
    @IBOutlet weak var imgHome: UIImageView!
    @IBOutlet weak var btnBadge: UIButton!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    loadUser()
    lblTituloPromo.text = notificaion.titulo!
    webView.delegate = self
    let cuerpo = "<font face='calibri' size='3px' color='#555555'>" + notificaion.cuerpo! + "</font>"
        
    webView.loadHTMLString(cuerpo, baseURL: nil)
    webView.scrollView.indicatorStyle = .White
    webView.backgroundColor = UIColor.clearColor()
    webView.opaque = false

    
        Alamofire.request(.GET, self.notificaion.imagen)
            .responseImage { response in
                debugPrint(response)
                
                debugPrint(response.result)
                
                if let image = response.result.value {
                    print("image downloaded: \(image)")
                    self.imgPromo.image = image
                }
        }

        
    
    
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        // webView.frame.size.height = 1
        // webView.frame.size = webView.sizeThatFits(CGSizeZero)
        webView.scrollView.scrollEnabled = false
        heightConstraint.constant = webView.scrollView.contentSize.height - self.view.frame.size.height * 0.16
        webView.backgroundColor = UIColor.whiteColor()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func goToSucursal(sender: AnyObject) {
    }

    

    @IBAction func regresar(sender: AnyObject) {
    }

    @IBAction func goToMArcas(sender: AnyObject) {
        
        if let sv = self.revealViewController(){
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("MisMarcasViewController")
            sv.pushFrontViewController(vc, animated: true)
        }

        
    }
    



    @IBAction func openMenu(sender: AnyObject) {
        
        if let sw = self.revealViewController(){
            sw.revealToggleAnimated(true)
            self.revealViewController().rearViewRevealWidth =  self.view.frame.width * 0.85
            //self.revealViewController().frontViewShadowRadius = 50
            //sw.frontViewShadowOffset.width = self.view.frame.width * 0.15
        }

    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
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
