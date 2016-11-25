//
//  MisMarcasViewController.swift
//  FIDICARD
//
//  Created by omar on 16/09/16.
//  Copyright © 2016 oomovil. All rights reserved.
//

import UIKit
import SWRevealViewController
import Alamofire
import AlamofireImage
import SwiftyJSON

class MisMarcasViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, allocCategoriasSelecionDelegate {
    
    var CategoriaSelection : Int = -1
    var MarcasArray = [CMarca]()
    var MarcasDownloaded = [CMarca]()
    var ShouldReload : Bool = false
    var ShouldFilter: Bool = false
    var internetConection : Bool!
    
    
    @IBOutlet weak var categoriasBtn: UIButton!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var marcasCollectionView: UICollectionView!
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
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadUser()
        imgHome.userInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
        imgHome.addGestureRecognizer(tapRecognizer)

        internetConection = Reachability.isConnectedToNetwork()
        
        if ShouldReload {
            txtSearch.becomeFirstResponder()
            marcasCollectionView.reloadData()
        }
        if ShouldFilter {
            
            FilterArray()
            
        }
        
        else {
         loadingMarcas()
        }
        
        
        
        
    

        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    @IBAction func openMenu(sender: AnyObject) {
        
        if let sw = self.revealViewController(){
            sw.revealToggleAnimated(true)
        }
        
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return MarcasArray.count
    }

    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionCell", forIndexPath: indexPath) as! ImageCollectionViewCell
        
        let image = cell.image
        
        let url = MarcasArray[indexPath.row].img_cfondo
        
        
        Alamofire.request(.GET, url)
            .responseImage { response in
                debugPrint(response)
                
                print(response.request)
                print(response.response)
                debugPrint(response.result)
                
                if let imageDownloaded = response.result.value {
                    print("image downloaded: \(imageDownloaded)")
                    image.image = imageDownloaded
                    
                }
                else {
                    image.image = UIImage(named: "ios_general_icn_nofound" )
                    
                }
                
                image.contentMode = UIViewContentMode.ScaleAspectFit;
                image.layer.cornerRadius = image.frame.width / 2
                image.clipsToBounds = true
                image.contentMode = .ScaleAspectFill
                


        }

      
        return cell
        
    }
    
    
    func collectionView(collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let kWhateverHeightYouWant = collectionView.frame.size.height / 4
        let width = collectionView.frame.size.width / 4
        return CGSizeMake(width, CGFloat(kWhateverHeightYouWant))
    }
    
    
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if NSUserDefaults.standardUserDefaults().boolForKey("userLogged"){
            
            print("Marca Elejida")
            if let sv = self.revealViewController(){
                
                
                let vc = storyboard!.instantiateViewControllerWithIdentifier("MarcaViewController") as! MarcaViewController
                
                vc.Marca = MarcasArray[indexPath.row]
                
                //sv.pushFrontViewController(vc, animated: true)
                 self.navigationController?.pushViewController(vc, animated: true)
            
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
    
    
    func loadingMarcas() {
        
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ActivityIndicatorViewController") as! ActivityIndicatorViewController
        
        presentViewController(vc, animated: false, completion: nil)
        
        if internetConection! {
        
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
                    self.marcasCollectionView.reloadData()
                    self.MarcasDownloaded = self.MarcasArray
                    self.dismissViewControllerAnimated(false, completion: nil)
                    if self.CategoriaSelection >= 0 {
                        
                        self.FilterArray()
                    }

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
    
    
    func FilterArray() {
        
        var temporalMarcasArray = [CMarca]()
        
        if CategoriaSelection != 0 {
            
            for index in  0..<MarcasDownloaded.count {
                
                if MarcasDownloaded[index].categorias_id == CategoriaSelection {
                    
                    
                    temporalMarcasArray.append(MarcasDownloaded[index])
                }
                
                
            }
            MarcasArray = temporalMarcasArray
            marcasCollectionView.reloadData()
            print (temporalMarcasArray)

            
        }
        
        if CategoriaSelection == 0 {
            
            MarcasArray = MarcasDownloaded
            marcasCollectionView.reloadData()
        }
        
        
    }
    
   func  filteArray2() {
    
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
        marcasCollectionView.reloadData()
        print (temporalMarcasArray)
        
    }
    
    else {
        
        MarcasArray = MarcasDownloaded
        marcasCollectionView.reloadData()
    }
    
    }

    
    @IBAction func Searching(sender: AnyObject) {
        
        filteArray2()
        
    }
    
    @IBAction func searchingEnded(sender: AnyObject) {
        
        if MarcasArray.count == 0 {
            
            if let sv = self.revealViewController(){
               let vc = storyboard!.instantiateViewControllerWithIdentifier("MarcaNotFoundViewController") as! MarcaNotFoundViewController
                vc.MarcasDownloaded = self.MarcasDownloaded
                vc.MarcasArray = self.MarcasArray
               // sv.pushFrontViewController(vc, animated: true)
                 self.navigationController?.pushViewController(vc, animated: false)
            }

            
        }

        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    
    @IBAction func searchPrimaryAction(sender: AnyObject) {
        
        dismissKeyboard()
    }
    
    
    func returnCategoria(sender: Int , value : String){
        
        print (sender)
        categoriasBtn.setTitle(value, forState: .Normal)
        CategoriaSelection = sender
        FilterArray()
        
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




