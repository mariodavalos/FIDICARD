//
//  MarcaNotFoundViewController.swift
//  FIDICARD
//
//  Created by Martin Viruete Gonzalez on 04/10/16.
//  Copyright © 2016 oomovil. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class MarcaNotFoundViewController: UIViewController,allocCategoriasSelecionDelegate {

    @IBOutlet weak var txtSugerencia: UITextField!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var btnCategorias: UIButton!
    @IBOutlet weak var imgHome: UIImageView!
   
    var MarcasArray = [CMarca]()
    var MarcasDownloaded = [CMarca]()
    
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
        
        imgHome.userInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
        imgHome.addGestureRecognizer(tapRecognizer)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)

        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func enviarSugerencia(sender: AnyObject) {
        
        let todosEndpoint: String = "http://201.168.207.17:8888/fidicard/kuff_api/sugerirMarca"
        let newTodo = ["marca": String(txtSugerencia.text!)]
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
                        let destinationController = self.storyboard!.instantiateViewControllerWithIdentifier("PopUp1BtnViewController") as! PopUp1BtnViewController
                        
                        
                        let json = JSON(data:data)
                        print("JSON: \(json)")
                        if json["status"].intValue == 200 {
                            
                            
                            destinationController.imageName = "desgrane_general_icon_succes"
                            destinationController.labelText = "La sugerencia se ha enviado correctamente. Gracias por tu aportacion "
                            destinationController.btnText = "CERRAR"
                            destinationController.btnImage = "desgrane_general_btn_azul"
                        }
                        else {
                            
                            destinationController.imageName = "desgrane_general_icon_alerta"
                            destinationController.labelText = "Tubimos problemas enviando tu sugerencia. Por favor intentalo mas tarde"
                            destinationController.btnText = "CERRAR"
                            destinationController.btnImage = "desgrane_general_btn_azul"
                        }
                        
                        self.presentViewController(destinationController, animated: false, completion: nil)
                    }
                }
            }
        }
   
    @IBAction func SearcheditChanged(sender: AnyObject) {
      
        
        var temporalMarcasArray = [CMarca]()
        
        if txtSearch.text! != "" {
            
            for index in  0..<MarcasDownloaded.count {
                
                
                if MarcasDownloaded[index].nombre
                    .lowercaseString.hasPrefix(txtSearch.text!)  {
                    print("exists, Appended")
                    temporalMarcasArray.append(MarcasDownloaded[index])
                }
                
            }
            
            MarcasArray = temporalMarcasArray
            if temporalMarcasArray.count > 0 {
               
                if let sv = self.revealViewController(){
                    let vc = storyboard!.instantiateViewControllerWithIdentifier("MisMarcasViewController") as! MisMarcasViewController
                    vc.MarcasDownloaded = self.MarcasDownloaded
                    vc.MarcasArray = self.MarcasArray
                    vc.ShouldReload = true
                    sv.pushFrontViewController(vc, animated: true)
                }

            }
            //marcasCollectionView.reloadData()
            print (temporalMarcasArray)
            
        }
            
        else {
            
            if let sv = self.revealViewController(){
                let vc = storyboard!.instantiateViewControllerWithIdentifier("MisMarcasViewController") as! MisMarcasViewController
                vc.MarcasDownloaded = self.MarcasDownloaded
                vc.MarcasArray = self.MarcasArray
                vc.ShouldReload = true
                sv.pushFrontViewController(vc, animated: true)
            }

            
        }
        
        
    }
    
    @IBAction func openCategorias(sender: AnyObject) {
        
        if let sw = self.revealViewController(){ //self.revealViewController(){
            
            let vc = storyboard!.instantiateViewControllerWithIdentifier("CategoriasViewController") as! CategoriasViewController
            vc.delegate = self
            sw.setRightViewController(vc, animated: true)
            sw.rightRevealToggleAnimated(true)
            self.revealViewController().rightViewRevealWidth  =  self.view.frame.width * 0.80
            
            
        }
        
        
    }
    
    
    
    
    
    @IBAction func searchingEnded(sender: AnyObject) {
        
        if MarcasArray.count != 0 {
            
            
            
            if let sv = self.revealViewController(){
                let vc = storyboard!.instantiateViewControllerWithIdentifier("MisMarcasViewController") as! MisMarcasViewController
                vc.MarcasDownloaded = self.MarcasDownloaded
                vc.MarcasArray = self.MarcasArray
                vc.ShouldReload = true
                self.navigationController?.popToRootViewControllerAnimated(true)
                //sv.pushFrontViewController(vc, animated: true)
                self.navigationController?.popViewControllerAnimated(true)
            }
            

            
        }

        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    

    @IBAction func PrimaryActionSugerencia(sender: AnyObject) {
        
        dismissKeyboard()
    }
    
    @IBAction func openMenu(sender: AnyObject) {
        
         if let sw = self.revealViewController(){
            sw.revealToggleAnimated(true)
            self.revealViewController().rearViewRevealWidth =  self.view.frame.width * 0.85
        }

    }
    
    
    func returnCategoria(sender: Int , value : String){
        
        print (sender)
        btnCategorias.setTitle(value, forState: .Normal)
        if let sv = self.revealViewController(){
            let vc = storyboard!.instantiateViewControllerWithIdentifier("MisMarcasViewController") as! MisMarcasViewController
            vc.MarcasDownloaded = self.MarcasDownloaded
            vc.ShouldFilter = true
            vc.CategoriaSelection = sender
            self.navigationController?.popViewControllerAnimated(false)
            //sv.pushFrontViewController(vc, animated: true)
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
