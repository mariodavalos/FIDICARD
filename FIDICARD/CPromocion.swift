//
//  CPromocion.swift
//  FIDICARD
//
//  Created by Martin Viruete Gonzalez on 04/11/16.
//  Copyright © 2016 oOMovil. All rights reserved.
//

import UIKit

class CPromocion: NSObject , NSCoding {

    
    var id: Int!
    var titulo: String!
    var cuerpo: String!
    var categoria_id: Int!
    var desc_corta : String!
    var en_sucurs : [sucursal]!
    var vigencia: String!
    var link_promo: String!
    var destacada: String!
    var imagen: String!
    var imagenData : NSData!
    var restriccciones: String!
    var marca_id : Int!
    var img_cfondo: String!
    var img_cfondo_data: NSData!
    var marca : CMarca!
    var favorita: Bool!
    
    override init(){
        
    }
    
    required init(coder aDecoder: NSCoder) {
        if let transDescriptionDecoded = aDecoder.decodeObjectForKey("titulo") as? String {
            self.titulo = transDescriptionDecoded
        }
        if let amountEncoded = aDecoder.decodeObjectForKey("favorita") as? Bool {
            self.favorita = amountEncoded
        }
        
        if let amountEncoded = aDecoder.decodeObjectForKey("cuerpo") as? String {
            self.cuerpo = amountEncoded
        }
        if let amountEncoded = aDecoder.decodeObjectForKey("id") as? Int {
            self.id = amountEncoded
        }
        if let amountEncoded = aDecoder.decodeObjectForKey("link_promo") as? String {
            self.link_promo = amountEncoded
        }
        
        if let amountEncoded = aDecoder.decodeObjectForKey("imagen") as? String {
            self.imagen = amountEncoded
        }
        
        if let amountEncoded = aDecoder.decodeObjectForKey("restriccciones") as? String {
            self.restriccciones = amountEncoded
        }
        
        if let amountEncoded = aDecoder.decodeObjectForKey("desc_corta") as? String {
            self.desc_corta = amountEncoded
        }
        if let amountEncoded = aDecoder.decodeObjectForKey("img_cfondo") as? String {
            self.img_cfondo = amountEncoded
        }
        
        if let amountEncoded = aDecoder.decodeObjectForKey("vigencia") as? String {
            self.vigencia = amountEncoded
        }
        
        if let amountEncoded = aDecoder.decodeObjectForKey("imagenData") as? NSData {
            self.imagenData = amountEncoded
        }
        
        
        if let amountEncoded = aDecoder.decodeObjectForKey("img_cfondo_data") as? NSData {
            self.img_cfondo_data = amountEncoded
        }
        
        
         if let amountEncoded = aDecoder.decodeObjectForKey("marca") as? CMarca {
         self.marca = amountEncoded
         }
        
        if let amountEncoded = aDecoder.decodeObjectForKey("marca_id") as? Int {
            self.marca_id = amountEncoded
        }

        
        
    }
    
    
    
    func encodeWithCoder(aCoder: NSCoder) {
        if let transDescriptionEncoded = self.titulo {
            aCoder.encodeObject(transDescriptionEncoded, forKey: "titulo")
        }
        if let amountEncoded = self.favorita {
            aCoder.encodeObject(amountEncoded, forKey: "favorita")
        }
        
        if let amountEncoded = self.cuerpo
        {
            aCoder.encodeObject(amountEncoded, forKey: "cuerpo")
        }
        
        if let amountEncoded = self.id {
            aCoder.encodeObject(amountEncoded, forKey: "id")
        }
        
        if let amountEncoded = self.link_promo {
            aCoder.encodeObject(amountEncoded, forKey: "link_promo")
        }
        
        if let amountEncoded = self.imagen {
            aCoder.encodeObject(amountEncoded, forKey: "imagen")
        }
        if let amountEncoded = self.restriccciones {
            aCoder.encodeObject(amountEncoded, forKey: "restriccciones")
        }
        
        if let amountEncoded = self.marca_id {
            aCoder.encodeObject(amountEncoded, forKey: "marca_id")
        }
        
        if let amountEncoded = self.desc_corta {
            aCoder.encodeObject(amountEncoded, forKey: "desc_corta")
        }
        if let amountEncoded = self.img_cfondo {
            aCoder.encodeObject(amountEncoded, forKey: "img_cfondo")
        }
        
        if let amountEncoded = self.vigencia {
            aCoder.encodeObject(amountEncoded, forKey: "vigencia")
        }
        
        if let amountEncoded = self.imagenData {
            aCoder.encodeObject(amountEncoded, forKey: "imagenData")
        }
        
        
        if let amountEncoded = self.img_cfondo_data {
            aCoder.encodeObject(amountEncoded, forKey: "img_cfondo_data")
        }
        
        
         if let amountEncoded = self.marca {
         aCoder.encodeObject(amountEncoded, forKey: "marca")
         }
        
        if let amountEncoded = self.marca_id {
            aCoder.encodeObject(amountEncoded, forKey: "marca_id")
        }
        
        
    }
    
    
    
}
