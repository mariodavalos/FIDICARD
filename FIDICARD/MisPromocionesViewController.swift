//
//  MisPromocionesViewController.swift
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


class MisPromocionesViewController: UIViewController, UITabBarDelegate, UITableViewDataSource, allocCategoriasSelecionDelegate, allocRemoveRowDelegate, allocModifyMarcasArray {
    
    
    var MarcasArray = [CMarca]()
    var storedOffsets = [Int: CGFloat]()
    var MarcasDownloaded = [CMarca]()
    var CategoriaSelection = -1
    var user = Usuario()
    var filter = false
    var misMarcas = [Int]()
    var promosFavoritasID = [Int]()
    var internet : Bool!
    
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var btnCategorias: UIButton!
    @IBOutlet weak var promocionesTableView: UITableView!
    @IBOutlet weak var imgBtnFavoritas: UIImageView!
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
        
        imgHome.userInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
        imgHome.addGestureRecognizer(tapRecognizer)
       
        internet = Reachability.isConnectedToNetwork()
        loadUser()
        /*
        if !marcasDidLoad {
         
        }
        else {
            
            if filter {
                
                imgBtnFavoritas.image = UIImage(named: "desgrane_carrusel_icon_fav_on")
            }
            else {
                imgBtnFavoritas.image = UIImage(named: "desgrane_carrusel_icon_fav_offgray")
                
            }
            
            promocionesTableView.reloadData()
        }*/
         loadingMarcas2()
        
        promocionesTableView.rowHeight = UITableViewAutomaticDimension
        promocionesTableView.estimatedRowHeight = 120
        promocionesTableView.reloadData()
        promocionesTableView.separatorStyle = .None
        
                
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
            NSUserDefaults.standardUserDefaults().setObject(promosFavoritasID, forKey: "\(user.email!)promosFavoritasIDs")
            ArregloMarcas.marcas = self.MarcasArray
            let myData = NSKeyedArchiver.archivedDataWithRootObject(ArregloMarcas.marcas)
            NSUserDefaults.standardUserDefaults().setObject(myData, forKey: "\(self.user.email!)marcas")
            NSUserDefaults.standardUserDefaults().synchronize()
        
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func OpenMenu(sender: AnyObject) {
        
        if let sw = self.revealViewController(){
            sw.revealToggleAnimated(true)
              self.revealViewController().rearViewRevealWidth =  self.view.frame.width * 0.85
        }
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

    }
    
    
    func tableView(tableView: UITableView,numberOfRowsInSection section: Int) -> Int {
        return MarcasArray.count
    }
    
    func tableView(tableView: UITableView,cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("promocionCell",forIndexPath: indexPath) as! PromoSliderTableViewCell
        if filter {
         cell.senderVC = "mis"
        }
        else {
            cell.senderVC = "todas"
        }
        
        cell.user = self.user
        cell.btnMarca.imageView
        cell.btnMarca.imageView!.layer.cornerRadius =  cell.btnMarca.imageView!.frame.width / 2
        cell.misMarcas = self.misMarcas
        cell.btnMarca.imageView!.clipsToBounds = true
        cell.delegate = self
        //cell.btnMarca.frame = CGRect(x: 160, y: 100, width: 50, height: 50)
        cell.btnMarca.layer.cornerRadius = 0.5 * cell.btnMarca.bounds.size.width
        cell.btnMarca.clipsToBounds = true
        cell.btnMarca.imageView?.contentMode = .ScaleAspectFill
        cell.btnMarca.tag = indexPath.row
        cell.btnMarca.addTarget(self, action: #selector(self.goToMarca(_:)), forControlEvents: .TouchDown)
        cell.btnPromoLike.addTarget(self, action: #selector(self.deletePromo(_:)),forControlEvents: .TouchDown)
        cell.marcas = MarcasArray
        //cell.collectionView.reloadData()
        
        if internet! {
        
        Alamofire.request(.GET, MarcasArray[indexPath.row].img_cfondo)
            .responseImage { response in
                debugPrint(response)
                
                print(response.request)
                print(response.response)
                debugPrint(response.result)
                
                if let imageDownloaded = response.result.value {
                    print("image downloaded: \(imageDownloaded)")
                    cell.btnMarca.setImage(imageDownloaded, forState: .Normal)
                    self.MarcasArray[indexPath.row].img_cfondo_data = UIImagePNGRepresentation(imageDownloaded)
                }
                else {
                    cell.btnMarca.setImage(UIImage(named:"ios_general_icn_nofound"), forState: .Normal)
                    
                }
                cell.btnMarca.imageView!.contentMode = .ScaleAspectFill
                let imageViewSize = cell.btnMarca.imageView!.frame.size
                cell.btnMarca.imageView?.layer.cornerRadius = imageViewSize.height * 0.5
                
        }
            
        }
        else {
            
            if let data = MarcasArray[indexPath.row].img_cfondo_data{
            cell.btnMarca.setImage(UIImage(data:data), forState: .Normal)
            cell.btnMarca.imageView!.contentMode = .ScaleAspectFill
            let imageViewSize = cell.btnMarca.imageView!.frame.size
            cell.btnMarca.imageView?.layer.cornerRadius = imageViewSize.height * 0.5
            }
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
    

    
    func removeRow(i1 : Int, i2: Int){
        
        if filter {
            
            print(i1,i2)
            let indexPath = NSIndexPath(forRow: i1, inSection: 0)
            
            print(MarcasArray[i1].promociones2[i2].id!)
            if promosFavoritasID.contains(MarcasArray[i1].promociones2[i2].id!) {
                
                promosFavoritasID.removeAtIndex(promosFavoritasID.indexOf(MarcasArray[i1].promociones2[i2].id!)!)
                MarcasArray.removeAtIndex(i1)
                promocionesTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)

                
            }
            
            
        }
        
       
        
        
    }
    
    func removeCollectionItem(i1 : Int, i2: Int){
        
    promosFavoritasID.removeAtIndex( promosFavoritasID.indexOf(MarcasArray[i1].promociones2[i2].id!)!)
        MarcasArray[i1].promociones2!.removeAtIndex(i2)
        
        
        
    }

    func deletePromo(sender: UIButton){
    
    
    
    }
    
    @IBAction func filterByFavoritas(sender: AnyObject) {
        
        if filter {
            
            imgBtnFavoritas.image = UIImage(named: "desgrane_carrusel_icon_fav_offgray")
            loadingMarcas2()
        }
        else {
         imgBtnFavoritas.image = UIImage(named: "desgrane_carrusel_icon_fav_on")
            loadingMarcas()
        }
        
        filter = !filter
        
        
        
    }
    
    
    
    
    func goToMarca(sender: UIButton){
        
        if internet! {
        
        if let sw = self.revealViewController() {
            
            let vc = storyboard?.instantiateViewControllerWithIdentifier("MarcaViewController") as! MarcaViewController
            vc.Marca = MarcasArray[sender.tag]
            
           // sw.pushFrontViewController(vc, animated: true)
             self.navigationController?.pushViewController(vc, animated: true)
            
        }
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
    

    
    
    
    func loadingMarcas() {
        
      //  let loadVC = self.storyboard?.instantiateViewControllerWithIdentifier("ActivityIndicatorViewController") as! ActivityIndicatorViewController
       // presentViewController(loadVC, animated: false, completion: nil)
        
        if internet! {
        
        Alamofire.request(.GET,"http://201.168.207.17:8888/fidicard/kuff_api/getAllDataForMarcas/" ).responseJSON {
            (response) in
            if let data = response.data{
                
                let json = JSON(data:data)
                print("JSON: \(json)")
                if json["status"].intValue == 200 {
                    
                    let response = json["response"]
                    
                    self.MarcasArray.removeAll()
                    self.MarcasDownloaded.removeAll()
                    for index in 0..<response.count {
                        
                        
                        // self.estadosArray.append(response[index]["nombre"].string ?? "Null")
                        let marcaTemporal = CMarca()
                        marcaTemporal.id = Int(response[index]["id"].string ?? "-1")
                    if self.misMarcas.contains(marcaTemporal.id!) {
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
                        
                        /////
                        
                        marcaTemporal.promociones2 = [CPromocion]()
                        let promos = response[index]["promociones"]
                        
                        for indexProm in 0..<promos.count {
                            
                            let promocionTemporal = CPromocion()
                            
                            promocionTemporal.id = Int(promos[indexProm]["id"].string ?? "-1")
                            
                            if self.promosFavoritasID.contains(promocionTemporal.id){
                                
                                promocionTemporal.cuerpo = promos[indexProm]["cuerpo"].string ?? "Null"
                                promocionTemporal.categoria_id = Int(promos[indexProm]["categoria_id"].string ?? "-1")
                                promocionTemporal.desc_corta = promos[indexProm]["desc_corta"].string ?? "Null"
                                promocionTemporal.img_cfondo = promos[indexProm]["img_cfondo"].string ?? "Null"
                                promocionTemporal.titulo = promos[indexProm]["titulo"].string ?? "Null"
                                promocionTemporal.en_sucurs = [sucursal]()
                                promocionTemporal.favorita = true
                                
                                
                                for jdex in 0..<response[index]["sucursales"].count {
                                    
                                    let sucursalTemporal = sucursal()
                                    
                                    sucursalTemporal.latitud = Double(response[index]["sucursales"][jdex]["latitud"].string ?? "-1")
                                    sucursalTemporal.longitud = Double(response[index]["sucursales"][jdex]["longitud"].string ?? "-1")
                                    sucursalTemporal.id = Int(response[index]["sucursales"][jdex]["sucursal_id"].string ?? "-1")
                                    sucursalTemporal.nombre = response[index]["sucursales"][jdex]["nombre"].string ?? "Null"
                                    sucursalTemporal.direccion = response[index]["sucursales"][jdex]["direccion"].string ?? "Null"
                                    sucursalTemporal.tels = [String]()
                                    sucursalTemporal.tels.append(response[index]["sucursales"][jdex]["tels"].string ?? "Null")
                                    
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
                            
                            
                        }
                        
                        
                        
                        
                        if marcaTemporal.promociones2.count > 0 {
                            
                            marcaTemporal.nombre =  response[index]["nombre"].string ?? "-1"
                            marcaTemporal.img_sfondo =  response[index]["img_sfondo"].string ?? "-1"
                            self.MarcasArray.append(marcaTemporal)
                            
                            

                        }
                        
                        
                    }
                    }
                    self.promocionesTableView.reloadData()
                    //self.marcasCollectionView.reloadData()
                    self.MarcasDownloaded = self.MarcasArray
                    //self.marcasDidLoad = true
                    /*if self.CategoriaSelection >= 0 {
                     
                     self.FilterArray()
                     }*/
                    
                    ArregloMarcas.marcas = self.MarcasArray
                    let myData = NSKeyedArchiver.archivedDataWithRootObject(ArregloMarcas.marcas)
                    NSUserDefaults.standardUserDefaults().setObject(myData, forKey: "\(self.user.email!)marcas")
                    NSUserDefaults.standardUserDefaults().synchronize()

                    
                    //self.dismissViewControllerAnimated(false, completion: nil)
                    
                }
                
                
            }
        }
        
        }
        
        else {
            
            loadingMarcasOffLine()

            
        }
        
        
    }
    
    func loadingMarcasOffLine(){
        
        
        let alert = UIAlertController(title: "Error de Conexion", message: "Puede que varias funciones no esten activas", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        loadUser()
        let defaults = NSUserDefaults.standardUserDefaults()
        if let notasRaw = defaults.dataForKey("\(self.user.email!)marcas") {
            
            if let favoritas = NSKeyedUnarchiver.unarchiveObjectWithData(notasRaw) as? [CMarca] {
                
                ArregloMarcas.marcas = favoritas
                self.MarcasArray = ArregloMarcas.marcas
                self.MarcasDownloaded = self.MarcasArray
                //self.marcasDidLoad = true
                self.promocionesTableView.reloadData()
            }
        }
        
        
 
        
    }
    
    func loadingMarcas2() {
        
        if internet! {
        
            Alamofire.request(.GET,"http://201.168.207.17:8888/fidicard/kuff_api/getAllDataForMarcas/" ).responseJSON {
                (response) in
                if let data = response.data{
                    
                    let json = JSON(data:data)
                    print("JSON: \(json)")
                    if json["status"].intValue == 200 {
                        
                        let response = json["response"]
                        self.MarcasArray.removeAll()
                        self.MarcasDownloaded.removeAll()
                        for index in 0..<response.count {
                            
                            
                            // self.estadosArray.append(response[index]["nombre"].string ?? "Null")
                        
                            let marcaTemporal = CMarca()
                            
                            
                            marcaTemporal.id = Int(response[index]["id"].string ?? "-1")
                            
                            if self.misMarcas.contains(marcaTemporal.id!) {
                                
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
                                
                                /////
                                
                                marcaTemporal.promociones2 = [CPromocion]()
                                let promos = response[index]["promociones"]
                                
                                for indexProm in 0..<promos.count {
                                    
                                    let promocionTemporal = CPromocion()
                                    
                                    promocionTemporal.id = Int(promos[indexProm]["id"].string ?? "-1")
                                    

                                    if self.promosFavoritasID.contains(promocionTemporal.id!) {
                                        
                                        promocionTemporal.favorita = true
                                        
                                    }
                                    
                                    
                                        promocionTemporal.cuerpo = promos[indexProm]["cuerpo"].string ?? "Null"
                                        promocionTemporal.categoria_id = Int(promos[indexProm]["categoria_id"].string ?? "-1")
                                        promocionTemporal.desc_corta = promos[indexProm]["desc_corta"].string ?? "Null"
                                        promocionTemporal.img_cfondo = promos[indexProm]["img_cfondo"].string ?? "Null"
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

                                ///Find Del IF
                                
                                if marcaTemporal.promociones2.count > 0 {
                                    
                                    marcaTemporal.nombre =  response[index]["nombre"].string ?? "-1"
                                    marcaTemporal.img_sfondo =  response[index]["img_sfondo"].string ?? "-1"
                                    self.MarcasArray.append(marcaTemporal)
                                    
                                }
                                
                            }

                            
                        }
                        self.promocionesTableView.reloadData()
                        //self.marcasCollectionView.reloadData()
                        self.MarcasDownloaded = self.MarcasArray
                        //self.marcasDidLoad = true
                        /*if self.CategoriaSelection >= 0 {
                         
                         self.FilterArray()
                         }*/
                        
                        //self.dismissViewControllerAnimated(false, completion: nil)
                        
                    }
                    
                    
                }
            }
            
        }
        else{
            loadingMarcasOffLine()
        }
        
        
     }
    
  }





extension MisPromocionesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
        
        
        if internet! {
        
        Alamofire.request(.GET, MarcasArray[collectionView.tag].promociones2[indexPath.item].imagen)
            .responseImage { response in
                print(response.response)
                if let imageDownloaded = response.result.value {
                    print("image downloaded: \(imageDownloaded)")
                    cell.imgPromo.image = imageDownloaded
                    self.MarcasArray[collectionView.tag].promociones2[indexPath.item].imagenData = UIImagePNGRepresentation(imageDownloaded)
                }
                else {
                    
                    cell.imgPromo.image = UIImage(named: "ios_general_icn_nofound" )!
                    
                }
                
        }
        
        }
        else {
            
            if let datos = MarcasArray[collectionView.tag].promociones2[indexPath.item].imagenData {
                 cell.imgPromo.image = UIImage(data: datos)
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
            let vc = storyboard?.instantiateViewControllerWithIdentifier("MisPromosDetalleViewController") as! MisPromosDetalleViewController
            vc.senderVC = "MisPromocionesViewController"
            vc.MarcasDownloaded = self.MarcasDownloaded
            vc.promocion = self.MarcasArray[collectionView.tag].promociones2[indexPath.item]
            vc.i1 = collectionView.tag
            vc.i2 = indexPath.row
            vc.filter = filter
            vc.delegate = self
            //vc.marcasDidLoad = self.marcasDidLoad
            //sv.pushFrontViewController(vc, animated: true)
             self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
            let indexPathForCell = NSIndexPath(forRow: collectionView.tag, inSection: 0)
            print("\(indexPathForCell.row) , \(indexPath.row)")
            let celda = cell as! PromocionCollectionViewCell
            //celda.delegate = promocionesTableView.cellForRowAtIndexPath(indexPathForCell) as! PromoSliderTableViewCell
            if celda.delegate != nil {
                
                celda.delegate.updateLabels(indexPathForCell.row, index2: indexPath.row, marcas: MarcasArray)
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
                if nombreMArca.lowercaseString.rangeOfString(txtSearch.text!) != nil {
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
    
    
    func returnCategoria(sender: Int  , value: String){
        
        print (sender)
        btnCategorias.setTitle(value, forState: .Normal)
        CategoriaSelection = sender
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
                btnBadge.setTitle(String(defaults.integerForKey("\(user.email!)badge")), forState: .Normal)
            }
            
        }
        
        if let obj = defaults.objectForKey("\(user.email!)misMarcasID") {
            
            misMarcas = obj as! [Int]
        }
        print(user.email)
        if let objeto = defaults.objectForKey("\(user.email!)promosFavoritasIDs") {
            
            promosFavoritasID = objeto as! [Int]
            print(promosFavoritasID)
        }
            
            
            
            

        
    }
    
    
    func goToSucursal(sucursales : [sucursal], marca : CMarca){
        
        if internet! {
            if let sv = self.revealViewController(){
                
                print(sucursales.count)
                
                let  vc = self.storyboard?.instantiateViewControllerWithIdentifier("SucursalesViewController") as! SucursalesViewController
                vc.sucursales = sucursales
                vc.Marca = marca
                vc.filter = filter
                vc.MarcasDownloaded = self.MarcasDownloaded
               // vc.marcasDidLoad = self.marcasDidLoad
                vc.senderVC = "MisPromocionesViewController"
                //sv.pushFrontViewController(vc, animated: true)
                 self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        else{
            
        }
        
    }

    
    
    func promoFavoritaSelected(id: Int, add: Bool, marcaID : Int){
        
        if !filter {
            
            if !promosFavoritasID.contains(id) && add {
                
                promosFavoritasID.append(id)
                //NSUserDefaults.standardUserDefaults().setObject(promosFavoritasID, forKey: "\(user.email!)promosFavoritasIDs")
                
            }
            else if promosFavoritasID.contains(id) && !add {
                
                promosFavoritasID.removeAtIndex(promosFavoritasID.indexOf(id)!)
               // NSUserDefaults.standardUserDefaults().setObject(promosFavoritasID, forKey: "\(user.email!)promosFavoritasIDs")
            }

        }

            
        
    }
    


    
    func updatePromosIDArray(add : Bool, id : Int ,i1 : Int, i2: Int){
        
        if add  && !promosFavoritasID.contains(id){
            
            promosFavoritasID.append(id)
            
        }
        else if !add && promosFavoritasID.contains(id){
            
            promosFavoritasID.removeAtIndex(promosFavoritasID.indexOf(id)!)
        }
        
        self.promocionesTableView.reloadData()
        
        
    }
    
    
}


