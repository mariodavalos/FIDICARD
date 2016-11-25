//
//  RestriccionesPromocionViewController.swift
//  FIDICARD
//
//  Created by Martin Viruete Gonzalez on 11/10/16.
//  Copyright © 2016 oomovil. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

var MyObservationContext = 0

class RestriccionesPromocionViewController: UIViewController, UIWebViewDelegate {

   
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var marcaImg: UIImageView!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var webviewHeightConstraint: NSLayoutConstraint!
    var marcaLink = ""
    var marcaImgData : NSData! = nil
    var restriccion = ""
    var senderVC = ""
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.scrollEnabled = false
        let cuerpo = "<font face='calibri' size='3px' color='#555555'>" + restriccion + "</font>"
        webView.loadHTMLString(cuerpo, baseURL: nil)
        webView.scrollView.indicatorStyle = .White
        webView.backgroundColor = UIColor.whiteColor()
        webView.opaque = false
        webView.delegate = self
        print(marcaLink)
        if marcaImgData != nil{
            
            marcaImg.image = UIImage(data: marcaImgData)
            self.marcaImg.contentMode = .ScaleAspectFill
        }
        else {
            
            Alamofire.request(.GET, marcaLink)
                .responseImage { response in
                    debugPrint(response)
                    
                    debugPrint(response.result)
                    
                    if let image = response.result.value {
                        print("image downloaded: \(image)")
                        self.marcaImg.image = image
                        self.marcaImg.contentMode = .ScaleToFill
                    }
                    else {
                        self.marcaImg.image = UIImage(named: "ios_general_icn_nofound")
                        self.marcaImg.contentMode = .ScaleAspectFill
                    }
            }
        }

        
        
    }

    func webViewDidFinishLoad(webView: UIWebView) {
        webView.frame.size.height = 1
        webView.frame.size = webView.sizeThatFits(CGSizeZero)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cerrar(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
   
}
