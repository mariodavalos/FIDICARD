//
//  PromoSliderTableViewCell.swift
//  FIDICARD
//
//  Created by Martin Viruete Gonzalez on 11/10/16.
//  Copyright © 2016 oomovil. All rights reserved.
//

import UIKit
import SWRevealViewController

class PromoSliderTableViewCell: UITableViewCell, allocLabelsUpdateDelegate {


    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnMarca: UIButton!
    @IBOutlet weak var btnPromoLike: UIButton!
    @IBOutlet weak var btnPromoLocation: UIButton!
    @IBOutlet weak var lblTituloPromo: UILabel!
    @IBOutlet weak var lblDescripcionPromo: UILabel!
    @IBOutlet weak var lblVigencia: UILabel!
    @IBOutlet weak var imgMorePromos: UIImageView!
    @IBOutlet weak var btnAddCard: UIButton!
    
    var senderVC = ""
    var user = Usuario()
    var i1 = 0
    var i2 = 0
    var marcas = [CMarca]()
    var delegate: allocRemoveRowDelegate!
    var misMarcas = [Int]()
    var isImageLeftSide = true
    var isImageMoving = true
    var timer = NSTimer()
    var contador = 0
    
    var collectionViewOffset: CGFloat {
        get {
            return collectionView.contentOffset.x
        }
        
        set {
            collectionView.contentOffset.x = newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func setCollectionViewDataSourceDelegate
        <D: protocol<UICollectionViewDataSource, UICollectionViewDelegate>>
        (dataSourceDelegate: D, forRow row: Int) {
        
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.reloadData()
    }
    
    func updateLabels(index1: Int, index2: Int, marcas: [CMarca]) {
        
        
        if marcas[index1].promociones2.count > 0 {
            lblTituloPromo.text = marcas[index1].promociones2[index2].titulo
            lblDescripcionPromo.text = marcas[index1].promociones2[index2].desc_corta
            
            let dateStr : String = marcas[index1].promociones2[index2].vigencia
            if dateStr != "Null" && dateStr != "0000-00-00" {

                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                var  date = NSDate()
                date = dateFormatter.dateFromString(dateStr)!
                dateFormatter.dateFormat = "dd MMM"
                lblVigencia.text = dateFormatter.stringFromDate(date)
                
            }
            
            else {
                lblVigencia.text = "NULL"
            }
            
            btnPromoLocation.addTarget(self, action: #selector(self.goTolocation), forControlEvents: .TouchDown)
            if senderVC == "mis"{
                
                btnPromoLike.removeTarget(self, action: #selector(self.promoLiked), forControlEvents: .TouchDown)
                btnPromoLike.addTarget(self, action: #selector(self.deletePromo), forControlEvents: .TouchDown)

            }
            else if senderVC == "todas" {
                btnPromoLike.removeTarget(self, action: #selector(self.deletePromo), forControlEvents: .TouchDown)
                
                btnPromoLike.addTarget(self, action: #selector(self.promoLiked), forControlEvents: .TouchDown)

            }
            
            if let favo = marcas[index1].promociones2[index2].favorita {
                
                if favo {
                    btnPromoLike.setImage(UIImage(named: "desgrane_carrusel_icon_fav_on"), forState: .Normal)
                    
                }
                else {
                    
                    btnPromoLike.setImage(UIImage(named: "desgrane_carrusel_icon_fav_off"), forState: .Normal)
                    
                }
            }
            else{
                
                btnPromoLike.setImage(UIImage(named: "desgrane_carrusel_icon_fav_off"), forState: .Normal)
                marcas[index1].promociones2[index2].favorita = false
                
            }

            
            
            i1 = index1
            i2 = index2
            self.marcas = marcas
            if marcas[index1].promociones2.count > 1 {
            
                imgMorePromos.image = UIImage(named: "ios_icon_swipe")
                timer = NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: #selector(self.moveImage), userInfo: nil, repeats: true)
            
            }
            else {
                
                imgMorePromos.image = nil
                
            }
            
            
        }
    }
    
    func goTolocation(){
    
        delegate.goToSucursal(marcas[i1].promociones2[i2].en_sucurs, marca: marcas[i1] )
        
    }
    
    func promoLiked() {
       
        if misMarcas.contains(marcas[i1].id!){
        
        if let favo = marcas[i1].promociones2[i2].favorita {
            
            if favo {
                btnPromoLike.setImage(UIImage(named: "desgrane_carrusel_icon_fav_off"), forState: .Normal)
                marcas[i1].promociones2[i2].favorita = false
                if let id = marcas[i1].promociones2[i2].id{
                    delegate.promoFavoritaSelected(id, add: false, marcaID: marcas[i1].id!)
                }

            }
            else {
                
                btnPromoLike.setImage(UIImage(named: "desgrane_carrusel_icon_fav_on"), forState: .Normal)
                marcas[i1].promociones2[i2].favorita = true
                if let id = marcas[i1].promociones2[i2].id{
                    if delegate != nil{
                        
                        delegate.promoFavoritaSelected(id, add: true, marcaID: marcas[i1].id!)
                    }
                    else {
                        print("no delegate")
                    }
                    
                }

            }
        }
        else{
            
            btnPromoLike.setImage(UIImage(named: "desgrane_carrusel_icon_fav_on"), forState: .Normal)
            marcas[i1].promociones2[i2].favorita = true
            if let id = marcas[i1].promociones2[i2].id{
                 delegate.promoFavoritaSelected(id, add: true, marcaID: marcas[i1].id!)
            }
           
            
        }
        }
        else {
            delegate.promoFavoritaSelected(-1, add: false, marcaID: -1)
        }

    }
    
    func deletePromo () {
        
                
        if marcas[i1].promociones2.count > 1 {
                
            delegate.removeCollectionItem(i1, i2: i2)
            let indexPath2 = NSIndexPath(forRow: i2, inSection: 0)
            collectionView.deleteItemsAtIndexPaths([indexPath2])
                    
        }
        else {
                   
            self.delegate.removeRow(i1, i2: i2)
                    
        }
            
        
        
    }
    
    
    func moveImage(){
        
        if isImageMoving {
            
            contador += 1
            if isImageLeftSide {
                UIView.animateWithDuration(0.25, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn , animations: {
                    //self.CenterConstraints.constant += 10
                    self.imgMorePromos.frame.origin.x += 10
                    self.layoutIfNeeded()
                    }, completion: nil)
                
            }
            else {
                UIView.animateWithDuration(0.25, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut , animations: {
                    //self.CenterConstraints.constant -= 10
                    self.imgMorePromos.frame.origin.x -= 10
                    self.layoutIfNeeded()
                    }, completion: nil)
                
            }
            isImageLeftSide = !isImageLeftSide
            if contador >= 6 {
                isImageMoving = false
            }
            
        }
        else {
            contador -= 1
            if contador <= 0 {
                isImageMoving = true
            }
        }
        
    }
    
    func restartImageMove(){
        
        if isImageMoving {
            
            
            
        }
        else {
            
        }
        isImageMoving = !isImageMoving
        
    }
    
    
   }
