//
//  SucursalesLocationViewController.swift
//  FIDICARD
//
//  Created by Martin Viruete Gonzalez on 04/10/16.
//  Copyright © 2016 oomovil. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SWRevealViewController

class SucursalesLocationViewController: UIViewController, MKMapViewDelegate,  CLLocationManagerDelegate {

    var Marca = CMarca()
    var idexPath = 0
    var sucursales = [sucursal]()
    var promocion = CPromocion()
    var MarcasDownloaded = [CMarca]()
    var senderVC = ""
    var senderPadreVC = ""
    var senderAbueloVC = ""
    var senderTataVC = ""
    
    var tarjeta = CTarjeta()
    var allSucursales = false
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var imgHome: UIImageView!
    
    var locationManager:CLLocationManager!
    
    
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
    
    func loadUser() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let user = defaults.dataForKey("user") {
            
            if let user = NSKeyedUnarchiver.unarchiveObjectWithData(user) as? Usuario {
                
                btnBadge.setTitle(String(defaults.integerForKey("\(user.email!)badge")), forState: .Normal)
                
            }
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUser()
        imgHome.userInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
        imgHome.addGestureRecognizer(tapRecognizer)
        locationManager = CLLocationManager()
        locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()

        
        
        if !allSucursales {
        
            
            
        let suc = CustomAnnotation(title: Marca.sucursales[idexPath].nombre, coordinate: CLLocationCoordinate2D(latitude:Marca.sucursales[idexPath].latitud, longitude: Marca.sucursales[idexPath].longitud ),info: Marca.sucursales[idexPath].direccion)
            mapView.addAnnotations([suc])
            
            
            
            let location = CLLocationCoordinate2D(latitude:Marca.sucursales[idexPath].latitud, longitude: Marca.sucursales[idexPath].longitud )
            let center = location
            let region = MKCoordinateRegionMake(center, MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025))
            mapView.setRegion(region, animated: true)
        }
        else {
            
            for index in 0..<sucursales.count {
            let suc = CustomAnnotation(title: Marca.sucursales[index].nombre, coordinate: CLLocationCoordinate2D(latitude:Marca.sucursales[index].latitud, longitude: Marca.sucursales[index].longitud ),info: Marca.sucursales[index].direccion)
                mapView.addAnnotations([suc])
                
            }
            
            let location = CLLocationCoordinate2D(latitude:Marca.sucursales[idexPath].latitud, longitude: Marca.sucursales[idexPath].longitud )
            let center = location
            let region = MKCoordinateRegionMake(center, MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025))
            mapView.setRegion(region, animated: true)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
           }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse && CLLocationManager.locationServicesEnabled(){
            self.mapView.showsUserLocation = true
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.distanceFilter = 200
            self.locationManager.startUpdatingLocation()
        }
    }

    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        /*
        let identifier = "Capital"
        
        // 2
        if annotation is CustomAnnotation {
            // 3

            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
            
            if annotationView == nil {
                //4
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView!.canShowCallout = true
                
                // 5
                let btn = UIButton(type: .DetailDisclosure)
                annotationView!.rightCalloutAccessoryView = btn
            } else {
                // 6
                annotationView!.annotation = annotation
            }
            
            let pinImage = UIImage(named: "iconmap")
            let size = CGSize(width: 30, height: 30)
            UIGraphicsBeginImageContext(size)
            pinImage!.drawInRect(CGRectMake(0, 0, size.width, size.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            annotationView!.image = resizedImage
            //annotationView?.image = UIImage(named: "iconmap")
            return annotationView
        }
                // 7
        return nil
        */

        
        if let annotation = annotation as? CustomAnnotation {
            let identifier = "pin"
            var view: MKAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier){
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
            }
            // Resize image
            let pinImage = UIImage(named: "ios_sucursales_btn_pin")
            let size = CGSize(width: 70, height: 120)
            UIGraphicsBeginImageContext(size)
            pinImage!.drawInRect(CGRectMake(0, 0, size.width, size.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            view.image = resizedImage
            return view
        }
        return nil

    
        
        
        
        
        
        
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let capital = view.annotation as! CustomAnnotation
        let placeName = capital.title
        let placeInfo = capital.info
        
        let alert = UIAlertController(title: placeName, message: placeInfo, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    
    func determineCurrentLocation()
    {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            //locationManager.startUpdatingHeading()
            locationManager.startUpdatingLocation()
        }
    }

    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: true)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = 900
        let coordinateRegion: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,regionRadius * 2.0, regionRadius * 2.0)
        self.mapView.setRegion(coordinateRegion, animated: false)
    }

    
    @IBAction func regresar(sender: AnyObject) {
        
        if let sv = self.revealViewController(){
            
            let  vc = self.storyboard?.instantiateViewControllerWithIdentifier("SucursalesViewController") as! SucursalesViewController
            
            vc.Marca = self.Marca
            vc.sucursales = sucursales
            vc.tarjeta = tarjeta
            vc.promocion = self.promocion
            vc.senderVC = senderVC
            vc.padreSenderVC = senderPadreVC
            vc.tataSenderVC = senderTataVC
            vc.abueloSenderVC = senderAbueloVC
            vc.MarcasDownloaded = self.MarcasDownloaded
            //sv.pushFrontViewController(vc, animated: true)
            self.navigationController?.popViewControllerAnimated(true)
        }

        
    }
    
    
    @IBAction func openMenu(sender: AnyObject) {
        
        if let sw = self.revealViewController(){
            sw.revealToggleAnimated(true)
            self.revealViewController().rearViewRevealWidth =  self.view.frame.width * 0.85

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
