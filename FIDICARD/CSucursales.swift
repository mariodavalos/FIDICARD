//
//  CSucursales.swift
//  FIDICARD
//
//  Created by Martin Viruete Gonzalez on 04/10/16.
//  Copyright © 2016 oomovil. All rights reserved.
//

import Foundation


class sucursal: NSObject, NSCoding {
    
    var nombre: String!
    var direccion: String!
    var id : Int!
    var latitud: Double!
    var longitud: Double!
    var marca_id: Int!
    var tels: [String]!
    var promociones: [CPromocion]!
    
    
    
    override init() {
        
        
    }
    
    required init(coder aDecoder: NSCoder) {
        if let transDescriptionDecoded = aDecoder.decodeObjectForKey("nombre") as? String {
            self.nombre = transDescriptionDecoded
        }
        if let amountEncoded = aDecoder.decodeObjectForKey("direccion") as? String {
            self.direccion = amountEncoded
        }

        if let amountEncoded = aDecoder.decodeObjectForKey("id") as? Int {
            self.id = amountEncoded
        }
        if let amountEncoded = aDecoder.decodeObjectForKey("latitud") as? Double {
            self.latitud = amountEncoded
        }
        
        if let amountEncoded = aDecoder.decodeObjectForKey("longitud") as? Double {
            self.longitud = amountEncoded
        }
        
        if let amountEncoded = aDecoder.decodeObjectForKey("marca_id") as? Int {
            self.marca_id = amountEncoded
        }
        
        if let amountEncoded = aDecoder.decodeObjectForKey("tels") as? [String] {
            self.tels = amountEncoded
        }

    }
    
    
    
    func encodeWithCoder(aCoder: NSCoder) {
        if let transDescriptionEncoded = self.nombre {
            aCoder.encodeObject(transDescriptionEncoded, forKey: "nombre")
        }
        if let amountEncoded = self.direccion {
            aCoder.encodeObject(amountEncoded, forKey: "direccion")
        }
        
        if let amountEncoded = self.latitud
        {
            aCoder.encodeObject(amountEncoded, forKey: "latitud")
        }
        
        if let amountEncoded = self.id {
            aCoder.encodeObject(amountEncoded, forKey: "id")
        }
        
        if let amountEncoded = self.longitud {
            aCoder.encodeObject(amountEncoded, forKey: "longitud")
        }
        
        if let amountEncoded = self.marca_id {
            aCoder.encodeObject(amountEncoded, forKey: "marca_id")
        }
        if let amountEncoded = self.tels {
            aCoder.encodeObject(amountEncoded, forKey: "tels")
        }
        
        if let amountEncoded = self.marca_id {
            aCoder.encodeObject(amountEncoded, forKey: "marca_id")
        }
        

        
    }
    
    
    
    
    
}