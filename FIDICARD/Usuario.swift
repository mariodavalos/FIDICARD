//
//  Usuario.swift
//  FIDICARD
//
//  Created by Martin Viruete Gonzalez on 21/09/16.
//  Copyright © 2016 oomovil. All rights reserved.
//

import UIKit




class Usuario: NSObject, NSCoding {
    
    
    var id: Int = -1
    var nombre : String?
    var apellido : String?
    var email : String?
    var password :String?
    
    var fechaDeNacimiento : String = ""
    var pais :Int = -1
    var ciudad: String!
    var estado: Int = -1
    var estadoNombre :String?
    var estadoCivil = -1
    var ocupacionArray = -1
    var ocupacion = ""
    var fb_reg = false
    var domicilio = ""
    var telefono = ""
    var imageLink :String?
    
    
    var interesesArray = [Int]()
    
    
    override init() {
        
        
        
    }
    
    required init(coder aDecoder: NSCoder) {
        if let transDescriptionDecoded = aDecoder.decodeObjectForKey("nombre") as? String {
            self.nombre = transDescriptionDecoded
        }
        if let amountEncoded = aDecoder.decodeObjectForKey("apellido") as? String {
            self.apellido = amountEncoded
        }
        
        if let amountEncoded = aDecoder.decodeObjectForKey("email") as? String {
            self.email = amountEncoded
        }
        
        if let amountEncoded = aDecoder.decodeObjectForKey("password") as? String {
            self.password = amountEncoded
        }
        if let amountEncoded = aDecoder.decodeObjectForKey("imageLink") as? String {
            self.imageLink = amountEncoded
        }
        
        if let amountEncoded = aDecoder.decodeObjectForKey("estadoNombre") as? String {
            self.estadoNombre = amountEncoded
            
        }
        
        if let amountEncoded = aDecoder.decodeObjectForKey("ciudad") as? String {
            self.ciudad = amountEncoded
        }
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        if let transDescriptionEncoded = self.nombre {
            aCoder.encodeObject(transDescriptionEncoded, forKey: "nombre")
        }
        if let amountEncoded = self.apellido {
            aCoder.encodeObject(amountEncoded, forKey: "apellido")
        }
        
        if let amountEncoded = self.email {
            aCoder.encodeObject(amountEncoded, forKey: "email")
        }
        
        if let amountEncoded = self.password {
            aCoder.encodeObject(amountEncoded, forKey: "password")
            
        }
        if let amountEncoded = self.imageLink {
            aCoder.encodeObject(amountEncoded, forKey: "imageLink")
            
        }
        if let amountEncoded = self.estadoNombre{
            aCoder.encodeObject(amountEncoded, forKey: "estadoNombre")
            
        }

        if let amountEncoded = self.ciudad{
            aCoder.encodeObject(amountEncoded, forKey: "ciudad")
            
        }

    }

    
    
    
    
    
}
