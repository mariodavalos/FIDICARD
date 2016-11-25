//
//  CompletarTuPerfil2ViewController.swift
//  FIDICARD
//
//  Created by omar on 09/09/16.
//  Copyright © 2016 oomovil. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CompletarTuPerfil2ViewController: UIViewController, allocPopUpActionsDelegate{
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBOutlet weak var btnDeporte: UIButton!
    @IBOutlet weak var btnRestaurante: UIButton!
    @IBOutlet weak var btnEntretenimiento: UIButton!
    @IBOutlet weak var btnOcio: UIButton!
    @IBOutlet weak var btnModa: UIButton!
    @IBOutlet weak var btnMedico: UIButton!
    @IBOutlet weak var btnHogar: UIButton!
    @IBOutlet weak var btnGourmet: UIButton!
    @IBOutlet weak var btnTIenda: UIButton!
    @IBOutlet weak var btnBancaria: UIButton!
    @IBOutlet weak var btnFinanzas: UIButton!
    @IBOutlet weak var btnBebess: UIButton!
    @IBOutlet weak var btnInfantil: UIButton!
    
    @IBOutlet weak var imageDeportes: UIImageView!
    @IBOutlet weak var imageRestaurante: UIImageView!
    @IBOutlet weak var imageEntretenimiento: UIImageView!
    @IBOutlet weak var imageOcio: UIImageView!
    @IBOutlet weak var imageModa: UIImageView!
    @IBOutlet weak var imageMedico: UIImageView!
    @IBOutlet weak var imageHogar: UIImageView!
    @IBOutlet weak var imageGourmet: UIImageView!
    @IBOutlet weak var imageTienda: UIImageView!
    @IBOutlet weak var imageBAncaria: UIImageView!
    @IBOutlet weak var imageFianazas: UIImageView!
    @IBOutlet weak var imageBebes: UIImageView!
    @IBOutlet weak var imageInfantil: UIImageView!
    
    
    
    
    var CheckStatus = [false,false,false,false,false,false,false,false,false,false,false,false,false,false]
    var index = [Int]()
    var btnNames = [String]()
    @IBOutlet weak var lblUserName: UILabel!
    
    var user = Usuario()
    
    
    @IBOutlet weak var profileImage: UIImageView!
    
    
    func createPreferencesJSON(arreglo: [Bool]) -> NSString{
        
        //  [{"int_id": 1}, {"int_id": 5}]
        
        var array = [[String:String]]()
        
        for index in 0..<arreglo.count  {
            
          
            if arreglo[index] == true {
            
            array.append( ["int_id" : String(index + 1)])
            
            }

            
        }
       
        
        
        
        
        let json = try! NSJSONSerialization.dataWithJSONObject(array, options: .PrettyPrinted)
        
        let datastring = NSString(data: json, encoding: NSUTF8StringEncoding)
        
    
        print(datastring)
        
        return datastring!
    }
    
    
    
   
   
    
    
    @IBAction func siguiente(sender: AnyObject) {
        
        
        
        let image = profileImage.image
       
        let multipartFormData =  MultipartFormData()
        if  let imageData = UIImageJPEGRepresentation(image!, 0.6) {
            multipartFormData.appendBodyPart(data: imageData, name: "imagen", fileName: "file.jpg", mimeType: "image/jpg")
        }
        
        
        
       
        let JSONPREFERENCES = createPreferencesJSON(CheckStatus)
        
        
        let todosEndpoint: String = "http://201.168.207.17:8888/fidicard/kuff_api/updatePerfil"
        
        var newTodo = [String : AnyObject]()
            
          newTodo = ["email": user.email!,"fecha_nac": user.fechaDeNacimiento, "pais_id": user.pais, "estado_id": user.estado, "ciudad" : user.ciudad,"estciv_id": user.estadoCivil, "ocup_id" : user.ocupacionArray, "otra_ocup": user.ocupacion, "intereses": JSONPREFERENCES]
        print (newTodo)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let wasImageSet = defaults.boolForKey("wasImageSet")
        if (!wasImageSet) {
        
        Alamofire.request(.POST, todosEndpoint, parameters: newTodo )
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
                            
                           
                            defaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(self.user), forKey: "user")
                            defaults.setObject(self.user.email!, forKey: "userEmail")
                            defaults.setObject(self.user.password!, forKey: "password")
                            defaults.setBool(true, forKey: "userLogged")
                            let destinationController = self.storyboard!.instantiateViewControllerWithIdentifier("HomeView")
                            
                            self.presentViewController(destinationController, animated: true, completion: nil)
                            
                        }
                                                
                        
                    }
                    
                }

        
        
        }
        }
        
        else {
            
            
        let image2 = ResizeImage(image!, targetSize: CGSizeMake(1000.0, 500.0))
        let imageData = UIImagePNGRepresentation(image2)
        

        Alamofire.upload(
            .POST,
            todosEndpoint,
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(data: imageData!, name: "imagen", fileName: "file.png", mimeType: "image/png")
                multipartFormData.appendBodyPart(data: self.user.email!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"email")
                multipartFormData.appendBodyPart(data: self.user.fechaDeNacimiento .dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"fecha_nac")
                multipartFormData.appendBodyPart(data: String(self.user.pais).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"pais_id")
                multipartFormData.appendBodyPart(data:String(self.user.estado).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"estado_id")
                multipartFormData.appendBodyPart(data: String(self.user.ciudad).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"ciudad")
                multipartFormData.appendBodyPart(data: String(self.user.estadoCivil).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"estciv_id")
                
                multipartFormData.appendBodyPart(data: String(self.user.ocupacionArray).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"ocup_id")
                
                multipartFormData.appendBodyPart(data: String(self.user.ocupacion).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"otra_ocup")
                
                multipartFormData.appendBodyPart(data: JSONPREFERENCES.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"intereses")
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                    }
                    defaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(self.user), forKey: "user")
                    defaults.setBool(true, forKey: "userLogged")
                    let destinationController = self.storyboard!.instantiateViewControllerWithIdentifier("HomeView")
                    
                    self.presentViewController(destinationController, animated: true, completion: nil)
                break
                case .Failure(let encodingError):
                    print(encodingError)
                }
            }
        )

        
        }
        
    }
    

    
    
    func ResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
        } else {
            newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    
    
    func resizeImage(image: UIImage, newWidth: CGFloat , newHeight: CGFloat) -> UIImage {
        
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }

    
    @IBAction func Cancelar(sender: AnyObject) {
    
        
        
        let destinationController = storyboard!.instantiateViewControllerWithIdentifier("PopUp2BtnViewController") as! PopUp2BtnViewController
        destinationController.delegate = self
        destinationController.imageName = "desgrane_general_icon_alerta"
        destinationController.labelText = "¿Seguro que deseas salir de completar tu registro"
        destinationController.btnText1 = "SI, LO HARÉ DESPUÉS"
        destinationController.btnText2 = "NO, VOLVER AL REGISTRO"
        destinationController.btnImage1 = "desgrane_general_btn_rosa"
        destinationController.btnImage2 = "desgrane_general_btn_azul"
        
        destinationController.returntTo1 = "HomeView"
        destinationController.returntTo2 = "self"
        
        presentViewController(destinationController, animated: false, completion: nil)

        
    }
    
    func action1() {
        
        //LogOut
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(Usuario()), forKey: "user")
        defaults.setBool(false, forKey: "userLogged")
        defaults.setObject(false, forKey: "wasImageSet")
        defaults.setObject("", forKey: "userEmail")
        defaults.setObject("", forKey: "password")
        
        defaults.synchronize()
        
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("InicioViewController") as! InicioViewController
        presentViewController(vc, animated: true, completion: nil)
        
        
        
    }
    func action2() {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        lblUserName.text = user.nombre
        
      
        
        //Setting Profile Image
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        
        if defaults.boolForKey("wasImageSet")  == true
        {
        let imageData = defaults.dataForKey("profileImage")
        
        profileImage.image = UIImage(data: imageData!)
        }
        self.profileImage!.contentMode = .ScaleAspectFill
        self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
        self.profileImage.clipsToBounds = true
        self.profileImage.contentMode = .ScaleAspectFill

        
               
    }
    
 
    override func viewWillAppear(animated: Bool) {
        // Roundin Profile Image
        self.profileImage!.contentMode = .ScaleAspectFill
        self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
        self.profileImage.clipsToBounds = true
        self.profileImage.contentMode = .ScaleAspectFill


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func Deportes(sender: UIButton) {
        
   
        if (sender.currentTitle! == "Deportes" && CheckStatus[0] == true) {
            
            CheckStatus[0] = false
            imageDeportes.image = nil
            
        }
        
        else if (sender.currentTitle! == "Deportes" && CheckStatus[0] == false) {
            
            CheckStatus[0] = true
             imageDeportes.image = UIImage(named: "desgrane_icon_select")
        }
        
        
        if (sender.currentTitle! == "Restaurante" && CheckStatus[1] == true) {
            
            CheckStatus[1] = false
            imageRestaurante.image = nil
            
        }
            
        else if (sender.currentTitle! == "Restaurante" && CheckStatus[1] == false) {
            
            CheckStatus[1] = true
            imageRestaurante.image = UIImage(named: "desgrane_icon_select")
        }
        
        
        
        if (sender.currentTitle! == "Entretenimiento" && CheckStatus[2] == true) {
            
            CheckStatus[2] = false
            imageEntretenimiento.image = nil
            
        }
            
        else if (sender.currentTitle! == "Entretenimiento" && CheckStatus[2] == false) {
            
            CheckStatus[2] = true
            imageEntretenimiento.image = UIImage(named: "desgrane_icon_select")
        }
        
        
        if (sender.currentTitle! == "Oscio" && CheckStatus[3] == true) {
            
            CheckStatus[3] = false
            imageOcio.image = nil
            
        }
            
        else if (sender.currentTitle! == "Oscio" && CheckStatus[3] == false) {
            
            CheckStatus[3] = true
            imageOcio.image = UIImage(named: "desgrane_icon_select")
        }

        
        
        if (sender.currentTitle! == "Moda" && CheckStatus[4] == true) {
            
            CheckStatus[4] = false
            imageModa.image = nil
            
        }
            
        else if (sender.currentTitle! == "Moda" && CheckStatus[4] == false) {
            
            CheckStatus[4] = true
            imageModa.image = UIImage(named: "desgrane_icon_select")
        }
        
        
        if (sender.currentTitle! == "Médico" && CheckStatus[5] == true) {
            
            CheckStatus[5] = false
            imageMedico.image = nil
            
        }
            
        else if (sender.currentTitle! == "Médico" && CheckStatus[5] == false) {
            
            CheckStatus[5] = true
            imageMedico.image = UIImage(named: "desgrane_icon_select")
        }


        if (sender.currentTitle! == "Hogar" && CheckStatus[6] == true) {
            
            CheckStatus[6] = false
            imageHogar.image = nil
            
        }
            
        else if (sender.currentTitle! == "Hogar" && CheckStatus[6] == false) {
            
            CheckStatus[6] = true
            imageHogar.image = UIImage(named: "desgrane_icon_select")
        }
        
        
        
        if (sender.currentTitle! == "Gourmet" && CheckStatus[7] == true) {
            
            CheckStatus[7] = false
            imageGourmet.image = nil
            
        }
            
        else if (sender.currentTitle! == "Gourmet" && CheckStatus[7] == false) {
            
            CheckStatus[7] = true
            imageGourmet.image = UIImage(named: "desgrane_icon_select")
        }
        
        
        if (sender.currentTitle! == "Tienda departamental" && CheckStatus[8] == true) {
            
            CheckStatus[8] = false
            imageTienda.image = nil
            
        }
            
        else if (sender.currentTitle! == "Tienda departamental" && CheckStatus[8] == false) {
            
            CheckStatus[8] = true
            imageTienda.image = UIImage(named: "desgrane_icon_select")
        }


        
        
        if (sender.currentTitle! == "Bancaria" && CheckStatus[9] == true) {
            
            CheckStatus[9] = false
            imageBAncaria.image = nil
            
        }
            
        else if (sender.currentTitle! == "Bancaria" && CheckStatus[9] == false) {
            
            CheckStatus[9] = true
            imageBAncaria.image = UIImage(named: "desgrane_icon_select")
        }
        
        
        if (sender.currentTitle! == "Finanzas" && CheckStatus[10] == true) {
            
            CheckStatus[10] = false
            imageFianazas.image = nil
            
        }
            
        else if (sender.currentTitle! == "Finanzas" && CheckStatus[10] == false) {
            
            CheckStatus[10] = true
            imageFianazas.image = UIImage(named: "desgrane_icon_select")
        }


        
        if (sender.currentTitle! == "Bebés" && CheckStatus[11] == true) {
            
            CheckStatus[11] = false
            imageBebes.image = nil
            
        }
            
        else if (sender.currentTitle! == "Bebés" && CheckStatus[11] == false) {
            
            CheckStatus[11] = true
            imageBebes.image = UIImage(named: "desgrane_icon_select")
        }
        
        
        if (sender.currentTitle! == "Infantil" && CheckStatus[12] == true) {
            
            CheckStatus[12] = false
            imageInfantil.image = nil
            
        }
            
        else if (sender.currentTitle! == "Infantil" && CheckStatus[12] == false) {
            
            CheckStatus[12] = true
            imageInfantil.image = UIImage(named: "desgrane_icon_select")
        }
        
        
    }
    
    @IBAction func changedState(sender: AnyObject) {
        
        
        
    }
    



}
