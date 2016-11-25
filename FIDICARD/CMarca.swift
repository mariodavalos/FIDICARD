//
//  CMarca.swift
//  FIDICARD
//
//  Created by Martin Viruete Gonzalez on 04/10/16.
//  Copyright © 2016 oomovil. All rights reserved.
//

import Foundation


class CMarca: NSObject, NSCoding  {
    
    var id: Int!
    var img_tarjs: String!
    var img_cfondo: String!
    var img_cfondo_data : NSData!
    var img_sfondo: String!
    var longitud: Double!
    var latitud: Double!
    var categorias_id: Int!
    var promociones: [String]!
    var promociones2: [CPromocion]!
    var tels: [String]!
    var fecha_reg: String!
    var admin_id: Int!
    var priv_marca_id: Int!
    var web: String!
    var info: String!
    var ubicacion: String!
    var aviso_priv: String!
    var sucursales: [sucursal]!
    var nombre: String!
    var tipo_tarjs: String!
    
    
   override init() {
        
    }
    
    
    
    required init(coder aDecoder: NSCoder) {
        if let transDescriptionDecoded = aDecoder.decodeObjectForKey("img_tarjs") as? String {
            self.img_tarjs = transDescriptionDecoded
        }
        if let amountEncoded = aDecoder.decodeObjectForKey("img_cfondo") as? String {
            self.img_cfondo = amountEncoded
        }
        
        if let amountEncoded = aDecoder.decodeObjectForKey("img_sfondo") as? String {
            self.img_sfondo = amountEncoded
        }
        if let amountEncoded = aDecoder.decodeObjectForKey("id") as? Int {
            self.id = amountEncoded
        }
        if let amountEncoded = aDecoder.decodeObjectForKey("promociones2") as? [CPromocion] {
            self.promociones2 = amountEncoded
        }
        
        if let amountEncoded = aDecoder.decodeObjectForKey("tels") as? [String] {
            self.tels = amountEncoded
        }
        
        if let amountEncoded = aDecoder.decodeObjectForKey("aviso_priv") as? String {
            self.aviso_priv = amountEncoded
        }
        
        if let amountEncoded = aDecoder.decodeObjectForKey("nombre") as? String {
            self.nombre = amountEncoded
        }
        
        if let amountEncoded = aDecoder.decodeObjectForKey("tipo_tarjs") as? String {
            self.tipo_tarjs = amountEncoded
        }
        if let amountEncoded = aDecoder.decodeObjectForKey("sucursales") as? [sucursal] {
            self.sucursales = amountEncoded
        }
        
        
        if let amountEncoded = aDecoder.decodeObjectForKey("img_cfondo_data") as? NSData{
            self.img_cfondo_data = amountEncoded
        }

        
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        if let transDescriptionEncoded = self.img_tarjs {
            aCoder.encodeObject(transDescriptionEncoded, forKey: "img_tarjs")
        }
        if let amountEncoded = self.img_cfondo {
            aCoder.encodeObject(amountEncoded, forKey: "img_cfondo")
        }
        
        if let amountEncoded = self.img_sfondo {
            aCoder.encodeObject(amountEncoded, forKey: "img_sfondo")
        }
        
        if let amountEncoded = self.id {
            aCoder.encodeObject(amountEncoded, forKey: "id")
        }
        
        if let amountEncoded = self.sucursales {
            aCoder.encodeObject(amountEncoded, forKey: "sucursales")
        }
        if let amountEncoded = self.promociones2 {
            aCoder.encodeObject(amountEncoded, forKey: "promociones2")
        }
        
        if let amountEncoded = self.tels {
            aCoder.encodeObject(amountEncoded, forKey: "tels")
        }
        
        if let amountEncoded = self.aviso_priv {
            aCoder.encodeObject(amountEncoded, forKey: "aviso_priv")
        }
        
        if let amountEncoded = self.nombre {
            aCoder.encodeObject(amountEncoded, forKey: "nombre")
        }
        if let amountEncoded = self.tipo_tarjs {
            aCoder.encodeObject(amountEncoded, forKey: "tipo_tarjs")
        }
        
        if let amountEncoded = self.img_cfondo_data {
            aCoder.encodeObject(amountEncoded, forKey: "img_cfondo_data")
        }
        
        
    }

    
    
    
}