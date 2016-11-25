//
//  CNota.swift
//  FIDICARD
//
//  Created by Martin Viruete Gonzalez on 13/10/16.
//  Copyright © 2016 oomovil. All rights reserved.
//

import Foundation


class CNota: NSObject, NSCoding {
    
    var titulo: String!
    var cuerpo: String!
    var de: String!
    var marca_id: String!
    var fecha: String!
    
    
    override init() {
        
        
    }
    
    
    required init(coder aDecoder: NSCoder) {
        if let transDescriptionDecoded = aDecoder.decodeObjectForKey("titulo") as? String {
            self.titulo = transDescriptionDecoded
        }
        if let amountEncoded = aDecoder.decodeObjectForKey("cuerpo") as? String {
            self.cuerpo = amountEncoded
        }
        
        if let amountEncoded = aDecoder.decodeObjectForKey("de") as? String {
            self.de = amountEncoded
        }
        
        if let amountEncoded = aDecoder.decodeObjectForKey("marca_id") as? String {
            self.marca_id = amountEncoded
        }
        if let amountEncoded = aDecoder.decodeObjectForKey("fecha") as? String {
            self.fecha = amountEncoded
        }
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        if let transDescriptionEncoded = self.titulo {
            aCoder.encodeObject(transDescriptionEncoded, forKey: "titulo")
        }
        if let amountEncoded = self.cuerpo {
            aCoder.encodeObject(amountEncoded, forKey: "cuerpo")
        }
        
        if let amountEncoded = self.de {
            aCoder.encodeObject(amountEncoded, forKey: "de")
        }
        
        if let amountEncoded = self.marca_id {
            aCoder.encodeObject(amountEncoded, forKey: "marca_id")
            
        }
        
        if let amountEncoded = self.fecha {
            aCoder.encodeObject(amountEncoded, forKey: "fecha")
            
        }
                
        
        
    }

    
    
}