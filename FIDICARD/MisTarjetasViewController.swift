//
//  MisTarjetasViewController.swift
//  FIDICARD
//
//  Created by omar on 16/09/16.
//  Copyright © 2016 oomovil. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
import SwiftyJSON
import SWRevealViewController


class MisTarjetasViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,allocCategoriasSelecionDelegate {
    
    var categorias = ["Todas","Deporte","Restaurante","Entretenimiento",
                      "Oscio","Moda","Médico","Hogar","Gourmet",
                      "Tienda departamental",
                      "Bancaria","Finanzas","Bebés","Infantil"]

    var tarjetas = [CTarjeta]()
    var TarjetasFavID = [Int]()
    var tarjetasDownloaded = [CTarjeta]()
    var contador = 0
    var CategoriaSelection = -1
    var user = Usuario()
    var misMarcas = [Int]()
    var internetConection : Bool!
  
    @IBOutlet weak var tarjetasTableView: UITableView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var BtnCategorias: UIButton!
    @IBOutlet weak var imgHome: UIImageView!
    
    @IBOutlet weak var btnBadge: UIButton!
    
    func imageTapped(img: AnyObject)
    {
        if let sv = self.revealViewController(){
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("Home")
            sv.pushFrontViewController(vc, animated: true)
        }
        
    }
    
    
    @IBAction func goToNotificaciones(sender: AnyObject) {
        
        if let sv = self.revealViewController() {
            
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("NotificacionesViewController") as! NotificacionesViewController
            sv.pushFrontViewController(vc, animated: true)
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    
    override func shouldAutorotate() -> Bool {
        
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgHome.userInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
        imgHome.addGestureRecognizer(tapRecognizer)
        
        self.tarjetasTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        internetConection =  Reachability.isConnectedToNetwork()
        loadUser()
        loadTarjetas()
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

        //Keaybord will show and hide
      NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
       NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)


    }
    
    override func viewWillAppear(animated: Bool) {
        
       
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        
        let loadVC = self.storyboard?.instantiateViewControllerWithIdentifier("ActivityIndicatorViewController") as! ActivityIndicatorViewController
        presentViewController(loadVC, animated: false, completion: nil)
        let defaults = NSUserDefaults.standardUserDefaults()
        
        ArregloTarjetasFavoritas.tarjetasFavoritas = tarjetasDownloaded
        let myData = NSKeyedArchiver.archivedDataWithRootObject(ArregloTarjetasFavoritas.tarjetasFavoritas)
        defaults.setObject(myData, forKey: "\(user.email!)tarjetas")
        defaults.synchronize()
        //TarjetasFavID = [Int]()
        defaults.setObject(TarjetasFavID, forKey: "\(user.email!)tarjetasFavID")
        defaults.synchronize()
        loadVC.dismissViewControllerAnimated(false, completion: nil)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y == 0{
                self.view.frame.origin.y -= (keyboardSize.height * 0.4)
            }
            else {
                
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y != 0 {
                self.view.frame.origin.y += (keyboardSize.height * 0.4)
            }
            else {
                
            }
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
    

    
    @IBAction func OpenMenu(sender: AnyObject) {
        
        if let sw = self.revealViewController(){
            sw.revealToggleAnimated(true)
            self.revealViewController().rearViewRevealWidth =  self.view.frame.width * 0.85
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return tarjetas.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if tarjetas[indexPath.row].tipo == "VIRTUAL" {
            
            
            if let sv = self.revealViewController(){
                let  vc = self.storyboard?.instantiateViewControllerWithIdentifier("detalleTarjtVirtualViewController") as! detalleTarjtVirtualViewController
                vc.tarjeta = tarjetas[indexPath.row]
                vc.senderVC = "MisTarjetasViewController"
                //sv.pushFrontViewController(vc, animated: true)
                self.navigationController?.pushViewController(vc, animated: true)
            }

            
        }
        else if tarjetas[indexPath.row].tipo == "FISICA"{
            
            
            if let sv = self.revealViewController(){
                let  vc = self.storyboard?.instantiateViewControllerWithIdentifier("DetalleTarjFisicaViewController") as! DetalleTarjFisicaViewController
                vc.tarjeta = tarjetas[indexPath.row]
                vc.senderVC = "MisTarjetasViewController"
                //sv.pushFrontViewController(vc, animated: true)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("tarjetaCell", forIndexPath: indexPath) as! MisTarjetasTableViewCell
        if internetConection! {
          
            Alamofire.request(.GET, tarjetas[indexPath.row].img_tarjs)
                .responseImage { response in
                    debugPrint(response)
                    
                    print(response.request)
                    print(response.response)
                    debugPrint(response.result)
                    
                    if let imageDownloaded = response.result.value {
                        print("image downloaded: \(imageDownloaded)")
                        cell.imgTarjeta.image = imageDownloaded
                        let imageData = UIImagePNGRepresentation(imageDownloaded)
                        self.tarjetas[indexPath.row].img_tarjs_data = imageData

                    }
                    else {
                        
                        cell.imgTarjeta.image = UIImage(named: "ios_general_icn_nofound" )!
                        let imageData = UIImagePNGRepresentation(UIImage(named: "ios_general_icn_nofound" )!)
                        self.tarjetas[indexPath.row].img_tarjs_data = imageData
                    }
                    
                    
                    
            }

        
        }
        else {
        
             cell.imgTarjeta.image = UIImage(data: self.tarjetas[indexPath.row].img_tarjs_data)
        }
        
        print(tarjetas[indexPath.row].img_tarjs)
        cell.lblMarca.text = String(tarjetas[indexPath.row].nombreMarca)
            cell.lblMonedero.text = tarjetas[indexPath.row].alias
            cell.lblCategoria.text = categorias[tarjetas[indexPath.row].categoria_id]
        if let favo = tarjetas[indexPath.row].favorita{
            if favo{
                
                cell.btnFavorita.setImage(UIImage(named: "ios_mistarjetas_icn_star_on"), forState: .Normal)
                cell.favorita = true
            }
            else {
                
                 cell.btnFavorita.setImage(UIImage(named: "ios_mistarjetas_icn_star_off"), forState: .Normal)
                cell.favorita = false
            }
        }
        else {
             cell.btnFavorita.setImage(UIImage(named: "ios_mistarjetas_icn_star_off"), forState: .Normal)
            cell.favorita = false

        }


        
        cell.imgTarjeta.contentMode = UIViewContentMode.ScaleAspectFit;
        cell.imgTarjeta.layer.cornerRadius = 10
        cell.imgTarjeta.clipsToBounds = true
        cell.imgTarjeta.contentMode = .ScaleAspectFill
        
        cell.btnFavorita.tag = indexPath.row
        cell.btnFavorita.addTarget(self, action: #selector(self.favoritaSelected(_:)), forControlEvents: .TouchDown)
        
        
        
        return cell
        
    }
    

    func favoritaSelected(sender: UIButton?) {
        
        if let tag = sender?.tag{
           
            if contador <= 3 {
            
                
                if !tarjetas[tag].favorita! {
                    
                    contador += 1
                    
                    tarjetas[tag].favorita = !tarjetas[tag].favorita!
                    print( "\(tag)   \(tarjetas[tag].favorita!)")
                     sender!.setImage(UIImage(named: "ios_mistarjetas_icn_star_on"), forState: .Normal)
                    TarjetasFavID.append(tarjetas[tag].id)
                    
                }
                else {
                    contador -= 1
                    tarjetas[tag].favorita = !tarjetas[tag].favorita!
                    print( "\(tag)   \(tarjetas[tag].favorita!)")
                     sender!.setImage(UIImage(named: "ios_mistarjetas_icn_star_off"), forState: .Normal)
                    for k in 0..<TarjetasFavID.count {
                        
                        if TarjetasFavID[k] == tarjetas[tag].id {
                            
                            TarjetasFavID.removeAtIndex(k)
                            return
                        }
                        
                    }
                    
                }
                
            }
            else {
                
                if tarjetas[tag].favorita!{
                    
                    contador -= 1
                    tarjetas[tag].favorita = !tarjetas[tag].favorita!
                     sender!.setImage(UIImage(named: "ios_mistarjetas_icn_star_off"), forState: .Normal)
                    for k in 0..<TarjetasFavID.count {
                        
                        if TarjetasFavID[k] == tarjetas[tag].id {
                            
                            TarjetasFavID.removeAtIndex(k)
                            return
                        }
                        
                    }
                }
                else {
                    
                    print("Solo puedes seleccionar 4 tarjetas como favoritas")
                    
                    let alert = UIAlertController(title: "Solo puedes seleccionar 4 tarjetas como favoritas", message: "si deseas seleccionar esta tarjeta como favorita puedes deseleccionar otra", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)

                    
                }
                
            }
        }
       
        
        
 
    }
    
    func loadTarjetas() {
        
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ActivityIndicatorViewController") as! ActivityIndicatorViewController
        
        presentViewController(vc, animated: false, completion: nil)
        
        if internetConection! {
        
        let todosEndpoint: String = "http://201.168.207.17:8888/fidicard/kuff_api/getTarjetasFromUser"
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        
        if let user = defaults.dataForKey("user") {
            
            if let user = NSKeyedUnarchiver.unarchiveObjectWithData(user) as? Usuario {
  
        let newTodo = ["email": String(user.email!)]
        Alamofire.request(.POST, todosEndpoint, parameters: newTodo)
            .responseJSON { response in

                 guard response.result.isSuccess else {
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
                            
                            let response = json["perfil"]

                            for index in 0..<response.count {
                            
                                let tarjetaTemporal = CTarjeta()
                                tarjetaTemporal.numero = response[index]["numero"].string ?? "null"
                                tarjetaTemporal.alias = response[index]["alias"].string ?? "null"
                                tarjetaTemporal.caduca = response[index]["caduca"].string ?? "null"
                                tarjetaTemporal.id = Int(response[index]["id"].string ?? "-1")
                                tarjetaTemporal.categoria_id = Int(response[index]["categoria_id"].string ?? "-1")
                                tarjetaTemporal.marca_id = Int(response[index]["marca_id"].string ?? "-1")
                                tarjetaTemporal.usuario_id = Int(response[index]["usuario_id"].string ?? "-1")
                                tarjetaTemporal.tipo = response[index]["tipo"].string ?? "null"
                                tarjetaTemporal.img_tarjs = response[index]["img_tarjs"].string ?? "null"
                                tarjetaTemporal.fecha_alta = response[index]["fecha_alta"].string ?? "null"
                                tarjetaTemporal.nombreMarca = response[index]["nombre"].string ?? "null"
                                
                                
                                self.tarjetas.append(tarjetaTemporal)
                                print(tarjetaTemporal.img_tarjs)
                                print(tarjetaTemporal.id)
                                print("Tarjeta pemporal")
                            
                            }
                            self.tarjetasDownloaded = self.tarjetas
                            self.tarjetasTableView.rowHeight = UITableViewAutomaticDimension
                            self.tarjetasTableView.estimatedRowHeight = 80
                            
                            for k in 0..<self.tarjetas.count {
                                
                                self.misMarcas.append(self.tarjetas[k].marca_id)
                            }
                            
                            defaults.setObject(self.misMarcas, forKey: "\(user.email!)misMarcasID")
                            
                            if let tem = defaults.objectForKey("\(user.email!)tarjetasFavID"){
                            
                                self.TarjetasFavID = tem as! [Int]
                                for i in 0..<self.tarjetas.count {
                                    
                                    for j in 0..<self.TarjetasFavID.count {
                                        
                                        if self.tarjetas[i].id == self.TarjetasFavID[j]{
                                            self.contador += 1
                                            self.tarjetas[i].favorita = true
                                            break
                                        }
                                    }
                                   
                                    
                                }
                                
                                
                                
                            }
                            
                            self.tarjetasTableView.reloadData()
                            self.dismissViewControllerAnimated(false, completion: nil)
                        }
                        else {
                            
                           // No tinene tarjetas
                            self.dismissViewControllerAnimated(false, completion: nil)
                        }
                        
                    }

                  }
                }

              }
           }
            
        
        }
        else {
            
            
            if let notasRaw = NSUserDefaults.standardUserDefaults().dataForKey("\(user.email!)tarjetas") {
                
                if let favoritas = NSKeyedUnarchiver.unarchiveObjectWithData(notasRaw) as? [CTarjeta] {
                    
                    ArregloTarjetasFavoritas.tarjetasFavoritas = favoritas
                    tarjetas = ArregloTarjetasFavoritas.tarjetasFavoritas
                    tarjetasDownloaded = tarjetas
                }
            }
            self.tarjetasTableView.rowHeight = UITableViewAutomaticDimension
            self.tarjetasTableView.estimatedRowHeight = 80
            if let tem = NSUserDefaults.standardUserDefaults().objectForKey("\(user.email!)tarjetasFavID"){
                
                self.TarjetasFavID = tem as! [Int]
                for i in 0..<self.tarjetas.count {
                    
                    for j in 0..<self.TarjetasFavID.count {
                        
                        if self.tarjetas[i].id == self.TarjetasFavID[j]{
                            self.contador += 1
                            self.tarjetas[i].favorita = true
                            break
                        }
                    }
                    
                    
                }
                
                
                
            }
            
            self.tarjetasTableView.reloadData()
            self.dismissViewControllerAnimated(false, completion: nil)
            let alert = UIAlertController(title: "Error de Conexion", message: "Puede que varias funciones no esten activas", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.Default, handler: nil))
            //presentViewControllefr(alert, animated: true, completion: nil)
            self.presentViewController(alert, animated: true, completion: nil)

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

    
    @IBAction func openCategorias(sender: AnyObject) {
        
        if let sw = self.revealViewController(){ //self.revealViewController(){
            
            let vc = storyboard!.instantiateViewControllerWithIdentifier("CategoriasViewController") as! CategoriasViewController
            vc.delegate = self
            sw.setRightViewController(vc, animated: true)
            sw.rightRevealToggleAnimated(true)
            self.revealViewController().rightViewRevealWidth  =  self.view.frame.width * 0.80
            
            
        }
    }
    
    
    
    func  filteArray2() {
        
        var temporalTarjetasArray = [CTarjeta]()
        
        if txtSearch.text! != "" {
            
            for index in  0..<tarjetasDownloaded.count {
                
                let nombreMArca = tarjetasDownloaded[index].nombreMarca!
                if nombreMArca.lowercaseString.hasPrefix(txtSearch.text!){
                    print("exists, Appended")
                    temporalTarjetasArray.append(tarjetasDownloaded[index])
                }
                
            }
            
            tarjetas = temporalTarjetasArray
            tarjetasTableView.reloadData()
            print (temporalTarjetasArray)
            
        }
            
        else {
            
            tarjetas = tarjetasDownloaded
            tarjetasTableView.reloadData()
        }
        
    }
    
    
    @IBAction func Searching(sender: AnyObject) {
        
        filteArray2()
        
    }
    
    @IBAction func searchingEnded(sender: AnyObject) {
        
       
              
    }
    
    @IBAction func searchPrimaryAction(sender: AnyObject) {
        
        dismissKeyboard()
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    func returnCategoria(sender: Int , value : String){
        
        print (sender)
        BtnCategorias.setTitle(value, forState: .Normal)
        CategoriaSelection = sender
        FilterArray()
        
    }
    func FilterArray() {
        
        var temporalTarjetasArray = [CTarjeta]()
        
        if CategoriaSelection != 0 {
            
            for index in  0..<tarjetasDownloaded.count {
                
                if tarjetasDownloaded[index].categoria_id == CategoriaSelection {
                    
                    
                    temporalTarjetasArray.append(tarjetasDownloaded[index])
                }
                
                
            }
            tarjetas = temporalTarjetasArray
            tarjetasTableView.reloadData()
            print (temporalTarjetasArray)
            
            
        }
        
        if CategoriaSelection == 0 {
            
            tarjetas = tarjetasDownloaded
            tarjetasTableView.reloadData()
        }
        
        
    }
    
    
    
  
    
    @IBAction func goToMarcas(sender: AnyObject) {
        
        if let sv = self.revealViewController(){
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("MisMarcas")
            sv.pushFrontViewController(vc, animated: true)
            
            
        }
        
    }
    




    

    
}
