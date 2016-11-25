//
//  PromoCarruselModeloViewController.swift
//  FIDICARD
//
//  Created by omar on 16/09/16.
//  Copyright © 2016 oomovil. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class PromoCarruselModeloViewController: UIViewController {
    
    
    
    @IBOutlet var imagen: UIImageView!
    var img: String!
    var index:Int!
    var padre = SlideOutMenUIViewController?()
    var padre2 = MarcaViewController?()
    var internet: Bool!
    var padre3 = Promos1ViewController?()
    var delegate: allocSaveImageDelegate!
    var imageData :NSData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.imagen.image = UIImage(named: img)
    
        internet = Reachability.isConnectedToNetwork()
        
        
        if internet! {
            Alamofire.request(.GET, img)
                .responseImage { response in
                    debugPrint(response)
                    
                    debugPrint(response.result)
                    
                    if let image = response.result.value {
                        print("image downloaded: \(image)")
                        self.imagen.image = image
                        self.imagen.contentMode = .ScaleToFill
                        self.imageData = UIImagePNGRepresentation(image)
                        if self.padre2 == nil && self.padre3 == nil && self.padre != nil{
                            self.delegate.sendImageData(self.index, data: self.imageData)
                        }
           
                    }
            }

            
        }
        else {
            
            if let datos = imageData {
                imagen.image = UIImage(data: datos)
            }
            
        }
        
    }
    
    
    
    @IBAction func btnImage(sender: AnyObject) {
        
        print ("Promo Selected")
        
        if padre != nil {
            
            padre!.goToPromocion(index)

        }
        
        if padre2 != nil {
            padre2!.goToPromocion(index)

        }
        
        if padre3 != nil {
            padre3!.goToPromocion(index)
        }
        
        
        
    }
    
    
    
    

}
