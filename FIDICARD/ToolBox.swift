//
//  ToolBox.swift
//  FIDICARD
//
//  Created by Martin Viruete Gonzalez on 24/10/16.
//  Copyright © 2016 oOMovil. All rights reserved.
//

import Foundation
import UIKit
import CoreData



protocol mainCategoriasSelecionDelegate {
    
    
    func setSelecion(_: AnyObject, categoria: String)
    
}

protocol allocCategoriasSelecionDelegate{
    
    func returnCategoria(sender: Int, value : String)
    
}


protocol allocNotasUpdateDeleate {
    func reloadNotas()
}


protocol allocStandardTableDelegate {
    
    func returnOptionSelected(selectionIndex: Int,Selection: String, senderInput: String)
}


protocol allocLabelsUpdateDelegate {
    func updateLabels(index1: Int, index2: Int , marcas :[CMarca])
}

protocol allocRemoveRowDelegate {
    func removeRow(i1: Int , i2: Int)
    func goToSucursal(sucursales: [sucursal], marca : CMarca)
    func promoFavoritaSelected(id: Int, add: Bool, marcaID : Int)
    func removeCollectionItem(i1 : Int, i2: Int)
    
}


protocol allocEditInicoPageView{
    
    func updatePageviewImage(index: Int)
}

protocol allocAddFirstCardDelegate {
    func goToMarcas()
    func userNotLoggedPopUp()
}


protocol allocSaveImageDelegate {
    
    func sendImageData(index : Int, data : NSData)
    
    
}


protocol allocPopUpActionsDelegate {
    
    func action1()
    func action2()
}

protocol allocModifyMarcasArray {
    
    func updatePromosIDArray(add : Bool, id : Int ,i1 : Int, i2: Int)
}



