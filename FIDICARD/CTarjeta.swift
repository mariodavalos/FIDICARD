//
//  CTarjeta.swift
//  FIDICARD
//
//  Created by Martin Viruete Gonzalez on 13/10/16.
//  Copyright © 2016 oomovil. All rights reserved.
//

import Foundation


class CTarjeta: NSObject, NSCoding {
    
    var numero: String!
    var alias: String!
    var caduca: String!
    var id: Int!
    var marca_id : Int!
    var usuario_id: Int!
    var tipo: String!
    var img_tarjs: String!
    var img_tarjs_data: NSData!
    var fecha_alta : String!
    var marca : CMarca!
    var favorita: Bool? = false
    var nombreMarca: String!
    var categoria_id: Int!
   
    override init() {
        
        
        
    }
    
    required init(coder aDecoder: NSCoder) {
        if let transDescriptionDecoded = aDecoder.decodeObjectForKey("numero") as? String {
            self.numero = transDescriptionDecoded
        }
        if let amountEncoded = aDecoder.decodeObjectForKey("favorita") as? Bool {
            self.favorita = amountEncoded
        }
        
        if let amountEncoded = aDecoder.decodeObjectForKey("alias") as? String {
            self.alias = amountEncoded
        }
        if let amountEncoded = aDecoder.decodeObjectForKey("id") as? Int {
            self.id = amountEncoded
        }
        if let amountEncoded = aDecoder.decodeObjectForKey("img_tarjs") as? String {
            self.img_tarjs = amountEncoded
        }
        
        if let amountEncoded = aDecoder.decodeObjectForKey("tipo") as? String {
            self.tipo = amountEncoded
        }
        
        if let amountEncoded = aDecoder.decodeObjectForKey("marca_id") as? Int {
            self.marca_id = amountEncoded
        }
        
        if let amountEncoded = aDecoder.decodeObjectForKey("caduca") as? String {
            self.caduca = amountEncoded
        }
        
        if let amountEncoded = aDecoder.decodeObjectForKey("nombreMarca") as? String {
            self.nombreMarca = amountEncoded
        }
        if let amountEncoded = aDecoder.decodeObjectForKey("categoria_id") as? Int {
            self.categoria_id = amountEncoded
        }
        
        if let amountEncoded = aDecoder.decodeObjectForKey("img_tarjs_data") as? NSData {
            self.img_tarjs_data = amountEncoded
        }
        
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        if let transDescriptionEncoded = self.numero {
            aCoder.encodeObject(transDescriptionEncoded, forKey: "numero")
        }
        if let amountEncoded = self.favorita {
            aCoder.encodeObject(amountEncoded, forKey: "favorita")
        }
        
        if let amountEncoded = self.alias {
            aCoder.encodeObject(amountEncoded, forKey: "alias")
        }
        
        if let amountEncoded = self.id {
            aCoder.encodeObject(amountEncoded, forKey: "id")
        }
        
        if let amountEncoded = self.img_tarjs {
            aCoder.encodeObject(amountEncoded, forKey: "img_tarjs")
        }
        if let amountEncoded = self.tipo {
            aCoder.encodeObject(amountEncoded, forKey: "tipo")
        }
        
        if let amountEncoded = self.marca_id {
            aCoder.encodeObject(amountEncoded, forKey: "marca_id")
        }
        
        if let amountEncoded = self.caduca {
            aCoder.encodeObject(amountEncoded, forKey: "caduca")
        }
        
        if let amountEncoded = self.nombreMarca {
            aCoder.encodeObject(amountEncoded, forKey: "nombreMarca")
        }
        if let amountEncoded = self.categoria_id {
            aCoder.encodeObject(amountEncoded, forKey: "categoria_id")
        }
        if let amountEncoded = self.img_tarjs_data {
            aCoder.encodeObject(amountEncoded, forKey: "img_tarjs_data")
        }
        
        
        
    }

    
    
    
}