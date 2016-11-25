//
//  TodasLasPromocionesViewController.swift
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



class TodasLasPromocionesViewController: UIViewController, UITabBarDelegate, UITableViewDataSource, allocCategoriasSelecionDelegate, allocRemoveRowDelegate, allocModifyMarcasArray {
    
    
    @IBOutlet weak var promocionesTableView: UITableView!
    
    var MarcasArray = [CMarca]()
    var storedOffsets = [Int: CGFloat]()
    var MarcasDownloaded = [CMarca]()
    var CategoriaSelection = -1
    var marcasDidLoad = false
    var misMarcas = [Int]()
    var internet : Bool!
    var user = Usuario()
    var logged :Bool!

    
    @IBOutlet weak var btnCategorias: UIButton!
    var promosFavoritasIDs = [Int]()
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var imgHome: UIImageView!
    @IBOutlet weak var btnBadge: UIButton?
    
    
    @IBAction func goToNotificaciones(sender: AnyObject) {
        
        if let sv = self.revealViewController() {
            
          let vc = self.storyboard?.instantiateViewControllerWithIdentifier("NotificacionesViewController") as! NotificacionesViewController
            sv.pushFrontViewController(vc, animated: true)
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
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
        //self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        imgHome.userInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
        imgHome.addGestureRecognizer(tapRecognizer)
        
        internet = Reachability.isConnectedToNetwork()
        
        loadUser()
        if !marcasDidLoad {
            loadingMarcas()
            
        }
        
        
        promocionesTableView.rowHeight = UITableViewAutomaticDimension
        promocionesTableView.estimatedRowHeight = 120
        promocionesTableView.reloadData()
        promocionesTableView.separatorStyle = .None

        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func openMenu(sender: AnyObject) {
        
        if let sw = self.revealViewController(){
            sw.revealToggleAnimated(true)
              self.revealViewController().rearViewRevealWidth =  self.view.frame.width * 0.85
        }
        
        
    }
    
    func tableView(tableView: UITableView,numberOfRowsInSection section: Int) -> Int {
        return MarcasArray.count
    }

    
    
    
    func tableView(tableView: UITableView,cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("promocionCell",forIndexPath: indexPath) as! PromoSliderTableViewCell
        
        cell.senderVC = "todas"
        cell.delegate = self
        cell.btnMarca.imageView!.contentMode = .ScaleAspectFill
        let imageViewSize = cell.btnMarca.imageView!.frame.size
        cell.btnMarca.imageView?.layer.cornerRadius = imageViewSize.height * 0.5
        cell.misMarcas = misMarcas
        cell.btnMarca.tag = indexPath.row
        cell.btnAddCard.tag = indexPath.row
        
        cell.btnMarca.addTarget(self, action: #selector(self.goToMarca(_:)), forControlEvents: .TouchDown)
        
        cell.btnAddCard.addTarget(self, action: #selector(self.goToAddCard(_:)), forControlEvents: .TouchDown)
        
    
        
    
            
            if let favorita = MarcasArray[indexPath.row].promociones2[0].favorita {
                
                if favorita {
                    
                    cell.btnPromoLike.setImage(UIImage(named: "desgrane_carrusel_icon_fav_on"), forState: .Normal)
                }
                else {
                    cell.btnPromoLike.setImage(UIImage(named: "desgrane_carrusel_icon_fav_off"), forState: .Normal)
                }
                
            }
            else{
                
                cell.btnPromoLike.setImage(UIImage(named: "desgrane_carrusel_icon_fav_off"), forState: .Normal)
                MarcasArray[indexPath.row].promociones2[0].favorita = false
                
            }
            
            


        
        //cell.collectionView.reloadData()

        Alamofire.request(.GET, MarcasArray[indexPath.row].img_cfondo)
            .responseImage { response in
                debugPrint(response)
                
                print(response.request)
                print(response.response)
                debugPrint(response.result)
                
                if let imageDownloaded = response.result.value {
                    print("image downloaded: \(imageDownloaded)")
                    cell.btnMarca.setImage(imageDownloaded, forState: .Normal)
                    
                }
                else {
                cell.btnMarca.setImage(UIImage(named:"ios_general_icn_nofound"), forState: .Normal)
                    
                }
                cell.btnMarca.imageView!.contentMode = .ScaleAspectFill
                let imageViewSize = cell.btnMarca.imageView!.frame.size
                cell.btnMarca.imageView?.layer.cornerRadius = imageViewSize.height * 0.5

                
        }
        
        


        
        return cell
    }
       func tableView(tableView: UITableView,willDisplayCell cell: UITableViewCell,
                                   forRowAtIndexPath indexPath: NSIndexPath) {
        
       guard let tableViewCell = cell as? PromoSliderTableViewCell else { return }
        
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
        
    }
    
    func tableView(tableView: UITableView,didEndDisplayingCell cell: UITableViewCell,forRowAtIndexPath indexPath: NSIndexPath) {
        
        guard let tableViewCell = cell as? PromoSliderTableViewCell else { return }
        
        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
        tableViewCell.timer.invalidate()
    }
    
    
    
    func goToAddCard(sender: UIButton) {
        
        
        if logged! {
            
            
            
            let Marca =  MarcasArray[sender.tag]
            
            print(sender.tag)
            print(Marca.nombre)
            
            if Marca.tipo_tarjs == "FISICA" || Marca.tipo_tarjs == "AMBAS" {
                
                if let sv = self.revealViewController(){
                    
                    let  vc = self.storyboard?.instantiateViewControllerWithIdentifier("SolicitarTarjetaViewController") as! SolicitarTarjetaViewController
                    vc.marcaID = Marca.id
                    vc.Marca = Marca
                    //sv.pushFrontViewController(vc, animated: true)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
                
            else if Marca.tipo_tarjs == "VIRTUAL" {
                
                if let sv = self.revealViewController(){
                    let  vc = self.storyboard?.instantiateViewControllerWithIdentifier("GenerarTarjetaViewController") as! GenerarTarjetaViewController
                    vc.Marca = Marca
                    //sv.pushFrontViewController(vc, animated: true)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
            
        }
        else {
            userNotLoggedPopUp()
        }

        
        
    }
    
    
    
    
    func goToMarca(sender: UIButton){
        
        if let sw = self.revealViewController() {
            
            let vc = storyboard?.instantiateViewControllerWithIdentifier("MarcaViewController") as! MarcaViewController
            vc.Marca = MarcasArray[sender.tag]
            
            //sw.pushFrontViewController(vc, animated: true)
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        
    }
    
    func goToGenerarTarjeta(sender: UIButton){
        
        
        
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
    
    
    
    func loadingMarcas() {
        
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ActivityIndicatorViewController") as! ActivityIndicatorViewController
        presentViewController(vc, animated: false, completion: nil)
        if internet! {
        
        
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
                        marcaTemporal.img_sfondo =  response[index]["img_sfondo"].string ?? "-1"
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
                        
                        /////
                        
                        marcaTemporal.promociones2 = [CPromocion]()
                        let promos = response[index]["promociones"]
                        
                        for indexProm in 0..<promos.count {
                            
                            let promocionTemporal = CPromocion()
                            
                            promocionTemporal.id = Int(promos[indexProm]["id"].string ?? "-1")
                            promocionTemporal.cuerpo = promos[indexProm]["cuerpo"].string ?? "Null"
                            promocionTemporal.categoria_id = Int(promos[indexProm]["categoria_id"].string ?? "-1")
                            promocionTemporal.desc_corta = promos[indexProm]["desc_corta"].string ?? "Null"
                            promocionTemporal.img_cfondo = marcaTemporal.img_sfondo
                            promocionTemporal.titulo = promos[indexProm]["titulo"].string ?? "Null"
                            promocionTemporal.en_sucurs = [sucursal]()
                            
                            
                            for jdex in 0..<response[index]["promociones"][indexProm]["sucarsales"].count {
                                
                                let sucursalTemporal = sucursal()
                                
                                sucursalTemporal.latitud = Double(response[index]["promociones"][indexProm]["sucarsales"][jdex]["latitud"].string ?? "-1")
                                sucursalTemporal.longitud = Double(response[index]["promociones"][indexProm]["sucarsales"][jdex]["longitud"].string ?? "-1")
                                sucursalTemporal.id = Int(response[index]["promociones"][indexProm]["sucarsales"][jdex]["sucursal_id"].string ?? "-1")
                                sucursalTemporal.nombre = response[index]["promociones"][indexProm]["sucarsales"][jdex]["nombre"].string ?? "Null"
                                sucursalTemporal.direccion = response[index]["promociones"][indexProm]["sucarsales"][jdex]["direccion"].string ?? "Null"
                                sucursalTemporal.tels = [String]()
                                sucursalTemporal.tels.append(response[index]["promociones"][indexProm]["sucarsales"][jdex]["tels"].string ?? "Null")
                                
                                promocionTemporal.en_sucurs.append(sucursalTemporal)
                                
                            }

                            promocionTemporal.imagen = promos[indexProm]["imagen"].string ?? "Null"
                            promocionTemporal.destacada = promos[indexProm]["destacada"].string ?? "Null"
                            promocionTemporal.marca_id = Int(promos[indexProm]["marca_id"].string ?? "Null")
                            promocionTemporal.restriccciones = promos[indexProm]["restricciones"].string ?? "Null"
                            promocionTemporal.link_promo = promos[indexProm]["link_promo"].string ?? "Null"
                            promocionTemporal.vigencia = promos[indexProm]["vigencia"].string ?? "Null"
                            marcaTemporal.promociones2.append(promocionTemporal)
                            
                        }

                        let defaults = NSUserDefaults.standardUserDefaults()
                        
                        if let objeto = defaults.objectForKey("\(self.user.email!)promosFavoritasIDs") {
                            
                            self.promosFavoritasIDs = objeto as! [Int]
                            
                            var ban = false
                            
                            for i in 0..<marcaTemporal.promociones2.count {
                                
                                
                                for j in 0..<self.promosFavoritasIDs.count{
                                    
                                    if marcaTemporal.promociones2[i].id == self.promosFavoritasIDs[j] {
                                        
                                        marcaTemporal.promociones2[i].favorita = true
                                        ban = true
                                    }
                                    
                                }
                                if !ban {
                                    marcaTemporal.promociones2[i].favorita = false
                                }
                                
                            }
                            
                        }
                        
                        
                        
                        ///
                        
                        marcaTemporal.nombre =  response[index]["nombre"].string ?? "-1"
                        
                        self.MarcasArray.append(marcaTemporal)
                        
                        
                    }
                    self.promocionesTableView.reloadData()
                    //self.marcasCollectionView.reloadData()
                    self.MarcasDownloaded = self.MarcasArray
                    self.marcasDidLoad = true
                    

                    
                    self.dismissViewControllerAnimated(false, completion: nil)
                    /*if self.CategoriaSelection >= 0 {
                        
                        self.FilterArray()
                    }*/
                    
                }
                else {
                    
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
    
   
}


extension TodasLasPromocionesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        //return model[collectionView.tag].count
        return MarcasArray[collectionView.tag].promociones2.count
        
    }
    
    
    
    
    
    func collectionView(collectionView: UICollectionView,cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("promoCollectionCell",forIndexPath: indexPath) as! PromocionCollectionViewCell
        let indexPathForCell = NSIndexPath(forRow: collectionView.tag, inSection: 0)
        if let celda = promocionesTableView.cellForRowAtIndexPath(indexPathForCell) {
            
            cell.delegate = celda as! PromoSliderTableViewCell
        }
        
        
        
        
        Alamofire.request(.GET, MarcasArray[collectionView.tag].promociones2[indexPath.item].imagen)
            .responseImage { response in
                print(response.response)
                if let imageDownloaded = response.result.value {
                    print("image downloaded: \(imageDownloaded)")
                    cell.imgPromo.image = imageDownloaded
                }
                else {
                    
                    cell.imgPromo.image = UIImage(named: "ios_general_icn_nofound" )!
                    
                }
                
        }
       
        
        
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let kWhateverHeightYouWant = collectionView.frame.size.height
        return CGSizeMake(collectionView.bounds.size.width, CGFloat(kWhateverHeightYouWant))
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if let sv = self.revealViewController(){
            let vc = storyboard?.instantiateViewControllerWithIdentifier("TodasLasPromosDetalleViewController") as! TodasLasPromosDetalleViewController
            vc.senderVC = "TodasLasPromocionesViewController"
            vc.MarcasDownloaded = self.MarcasDownloaded
            vc.promocion = self.MarcasArray[collectionView.tag].promociones2[indexPath.item]
            vc.marcasDidLoad = self.marcasDidLoad
            vc.user = self.user
            vc.delegate = self
            if misMarcas.contains(self.MarcasArray[collectionView.tag].id!) {
                
                vc.canAdd = true
            }
            else {
                vc.canAdd = false
            }
            
            
            //sv.pushFrontViewController(vc, animated: true)
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }
    

    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
       
        if self.marcasDidLoad {
            
        let indexPathForCell = NSIndexPath(forRow: collectionView.tag, inSection: 0)
        
            
            
        print("\(indexPathForCell.row) , \(indexPath.row)")
            let celda = cell as! PromocionCollectionViewCell
            //celda.delegate = promocionesTableView.cellForRowAtIndexPath(indexPathForCell) as! PromoSliderTableViewCell
            if celda.delegate != nil {
                
                celda.delegate.updateLabels(indexPathForCell.row, index2: indexPath.row, marcas: MarcasArray)
            }
            
       
        }
        
        
        print("Cell aparecio")
        
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
        
        var temporalTarjetasArray = [CMarca]()
        
        if txtSearch.text! != "" {
            
            for index in  0..<MarcasDownloaded.count {
                
                let nombreMArca = MarcasDownloaded[index].nombre
                if nombreMArca.lowercaseString.hasPrefix(txtSearch.text!) {
                    print("exists, Appended")
                    temporalTarjetasArray.append(MarcasDownloaded[index])
                }
                
            }
            
            MarcasArray = temporalTarjetasArray
            promocionesTableView.reloadData()
            print (temporalTarjetasArray)
            
        }
            
        else {
            
            MarcasArray = MarcasDownloaded
            promocionesTableView.reloadData()
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
    
    
    func returnCategoria(sender: Int , value: String){
        
        print (sender)
        CategoriaSelection = sender
        btnCategorias.setTitle(value, forState: .Normal)
        FilterArray()
        
    }
    func FilterArray() {
        
        var temporalTarjetasArray = [CMarca]()
        
        if CategoriaSelection != 0 {
            
            for index in  0..<MarcasDownloaded.count {
                
                if MarcasDownloaded[index].categorias_id == CategoriaSelection {
                    
                    
                    temporalTarjetasArray.append(MarcasDownloaded[index])
                }
                
                
            }
            MarcasArray = temporalTarjetasArray
            promocionesTableView.reloadData()
            print (temporalTarjetasArray)
            
            
        }
        
        if CategoriaSelection == 0 {
            
            MarcasArray = MarcasDownloaded
            promocionesTableView.reloadData()
        }
        
        
    }
    
    
    
   
    
    @IBAction func goToMarcas(sender: AnyObject) {
        
        if let sv = self.revealViewController(){
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("MisMarcas")
            sv.pushFrontViewController(vc, animated: true)
           
            
        }
        
    }
    
    
    


    func loadUser() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let user = defaults.dataForKey("user") {
            
            if let user = NSKeyedUnarchiver.unarchiveObjectWithData(user) as? Usuario {
                self.user = user
                btnBadge!.setTitle(String(defaults.integerForKey("\(user.email!)badge")), forState: .Normal)
                
            }
            
        }
        logged = defaults.boolForKey("userLogged")
        if let obk = defaults.objectForKey("\(user.email!)misMarcasID") {
            misMarcas = obk as! [Int]
        }

    }
    
    func removeRow (i1: Int , i2: Int){
        
        
    }
    func goToSucursal(sucursales : [sucursal], marca : CMarca){
        
        if logged! {
            
            if let sv = self.revealViewController(){
                
                let  vc = self.storyboard?.instantiateViewControllerWithIdentifier("SucursalesViewController") as! SucursalesViewController
                vc.sucursales = sucursales
                vc.Marca = marca
                vc.MarcasDownloaded = self.MarcasDownloaded
                vc.marcasDidLoad = self.marcasDidLoad
                vc.senderVC = "TodasLasPromocionesViewController"
                //sv.pushFrontViewController(vc, animated: true)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        else {
            
            userNotLoggedPopUp()
        }
        
    }
    
    func userNotLoggedPopUp() {
        
        
        let destinationController = storyboard!.instantiateViewControllerWithIdentifier("PopUp2BtnViewController") as! PopUp2BtnViewController
        
        destinationController.imageName = "desgrane_general_icon_alerta"
        destinationController.labelText = "Para tener una mejor experiencia inicia sesion o crea una cuenta"
        destinationController.btnText1 = "Ir al Inicio"
        destinationController.btnText2 = "Registrarme"
        destinationController.btnImage1 = "desgrane_general_btn_rosa"
        destinationController.btnImage2 = "desgrane_general_btn_azul"
        
        destinationController.returntTo1 = "InicioViewController"
        destinationController.returntTo2 = "RegistroViewController"
        
        presentViewController(destinationController, animated: false, completion: nil)
        
        
    }
    
    func promoFavoritaSelected(id: Int, add: Bool, marcaID: Int){
        
        if misMarcas.contains(marcaID) {
        
        if !promosFavoritasIDs.contains(id) && add {
            
            promosFavoritasIDs.append(id)
            NSUserDefaults.standardUserDefaults().setObject(promosFavoritasIDs, forKey: "\(user.email!)promosFavoritasIDs")
            
        }
        else if promosFavoritasIDs.contains(id) && !add {
            
            promosFavoritasIDs.removeAtIndex(promosFavoritasIDs.indexOf(id)!)
            NSUserDefaults.standardUserDefaults().setObject(promosFavoritasIDs, forKey: "\(user.email!)promosFavoritasIDs")
        }
        
        }
        else {
            marcaNoFavoritaPopUP()
        }
        
        
    }
    
    func removeCollectionItem(i1 : Int, i2: Int){
        
        
        
    }
    
    func marcaNoFavoritaPopUP() {
        
        let vc = storyboard?.instantiateViewControllerWithIdentifier("PopUp1BtnViewController") as! PopUp1BtnViewController
        vc.btnText = "CERRAR"
        vc.btnImage = "desgrane_general_btn_azul"
        vc.imageName = "desgrane_general_icon_alerta"
        vc.labelText = "Para seleccionar esta promocion como favorita necesitas agregar su tarjeta"
        presentViewController(vc, animated: true, completion: nil)
        
    }
    
    func updatePromosIDArray(add : Bool, id : Int ,i1 : Int, i2: Int){
        
        if add  && !promosFavoritasIDs.contains(id){
            
            promosFavoritasIDs.append(id)
            
        }
        else if !add && promosFavoritasIDs.contains(id){
            
            promosFavoritasIDs.removeAtIndex(promosFavoritasIDs.indexOf(id)!)
        }
        
        self.promocionesTableView.reloadData()
        
    }
    

    
}









    


