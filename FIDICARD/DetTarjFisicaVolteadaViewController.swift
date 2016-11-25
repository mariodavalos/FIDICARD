
//
//  DetTarjFisicaVolteadaViewController.swift
//  FIDICARD
//
//  Created by Martin Viruete Gonzalez on 13/10/16.
//  Copyright © 2016 oomovil. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import Haneke

class DetTarjFisicaVolteadaViewController: UIViewController {

    
    @IBOutlet weak var btnRegresar: UIButton!
    @IBOutlet weak var imgBarCode: UIImageView!
    @IBOutlet weak var imgTarjeta: UIImageView!
    @IBOutlet weak var lblNumTajrt: UILabel!
    
    var tarjeta = CTarjeta()

    var padreVC = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateImage(tarjeta.img_tarjs, imageView: imgTarjeta)
        
        imgTarjeta.image = imgTarjeta.image?.imageFlippedForRightToLeftLayoutDirection()
        imgBarCode.image = imgBarCode.image?.imageFlippedForRightToLeftLayoutDirection()
        
        imgTarjeta.contentMode = UIViewContentMode.ScaleAspectFit;
        imgTarjeta.layer.cornerRadius = 20
        imgTarjeta.clipsToBounds = true
        imgTarjeta.contentMode = .ScaleAspectFill
          
        
        let linkBArCode = "http://201.168.207.17:8888/fidicard/kuff-barcode/kuff-barcode.php?code=" + tarjeta.numero
        imgBarCode.hnk_setImageFromURL(NSURL(string: linkBArCode)!)
           }

   
    
    
    
    @IBAction func regresar(sender: AnyObject) {
        
        
        if let sv = self.revealViewController(){
            let  vc = self.storyboard?.instantiateViewControllerWithIdentifier("DetalleTarjFisicaViewController") as! DetalleTarjFisicaViewController
            vc.tarjeta = tarjeta
            vc.senderVC = self.padreVC
            (UIApplication.sharedApplication().delegate as! AppDelegate).landscape = false
            let value = UIInterfaceOrientation.Portrait.rawValue
            UIDevice.currentDevice().setValue(value, forKey: "orientation")
            //sv.pushFrontViewController(vc, animated: true)
            self.navigationController?.popViewControllerAnimated(false)
            
        }
        
        
        
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
    
    

    
    
    
}
