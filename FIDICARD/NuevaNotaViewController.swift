//
//  NuevaNotaViewController.swift
//  FIDICARD
//
//  Created by Martin Viruete Gonzalez on 13/10/16.
//  Copyright © 2016 oomovil. All rights reserved.
//

import UIKit

class NuevaNotaViewController: UIViewController {

    
    @IBOutlet weak var txtTitulo: UITextField!
    @IBOutlet weak var txtNota: UITextView!
    
    var nota = CNota()
    var editingNote = false
    var index = -1
    var delegate: allocNotasUpdateDeleate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
        //Getting Usrs Info from DB
        
        
        
        //Keaybord will show and hide
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)

        
        if let nota: CNota = nota {
            
            txtNota.text = nota.cuerpo
            txtTitulo.text = nota.titulo
            
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func guardar(sender: AnyObject) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if editingNote {
            
            if let notasRaw = defaults.dataForKey("notas") {
                if let notas = NSKeyedUnarchiver.unarchiveObjectWithData(notasRaw) as? [CNota] {
                    ArregloNotas.notas = notas
                    
                    let note = CNota()
                    note.titulo = txtTitulo.text!
                    note.cuerpo = txtNota.text!
                    let date = NSDate()
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "dd MMM yyyy"
                    note.fecha = dateFormatter.stringFromDate(date)
                    
                    ArregloNotas.notas.removeAtIndex(index)
                    ArregloNotas.notas.insert(note, atIndex: index)
                    let myData = NSKeyedArchiver.archivedDataWithRootObject(ArregloNotas.notas)
                    defaults.setObject(myData, forKey: "notas")
                    defaults.synchronize()
                    editing = false
                    self.delegate.reloadNotas()
                    dismissViewControllerAnimated(true, completion: nil)
                    
                    
                }
            }
            
        
        }
        
        
        else {
        if let notasRaw = defaults.dataForKey("notas") {
            if let notas = NSKeyedUnarchiver.unarchiveObjectWithData(notasRaw) as? [CNota] {
                ArregloNotas.notas = notas
                
                let note = CNota()
                note.titulo = txtTitulo.text!
                note.cuerpo = txtNota.text!
                
                let date = NSDate()
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "dd MMM yyyy"
                note.fecha = dateFormatter.stringFromDate(date)
                /*
                let date = NSDate()
                let calendar = NSCalendar.currentCalendar()
                let components = calendar.components([.Day , .Month , .Year], fromDate: date)
                
                let year =  components.year
                let month = components.month
                let day = components.day
                
                print(year)
                print(month)
                print(day)
                
                note.fecha = String(day) + " " + String(month) + " " + String(year)
                */
                ArregloNotas.notas.append(note)
                let myData = NSKeyedArchiver.archivedDataWithRootObject(ArregloNotas.notas)
                defaults.setObject(myData, forKey: "notas")
                defaults.synchronize()
                self.delegate.reloadNotas()
                dismissViewControllerAnimated(true, completion: nil)
                

            }
            }
        }

    }
    
    
    @IBAction func cancelar(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y == 0{
                self.view.frame.origin.y -= (keyboardSize.height * 0.3)
            }
            else {
                
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y != 0 {
                self.view.frame.origin.y += (keyboardSize.height * 0.3)
            }
            else {
                
            }
        }
        
    }
    @IBAction func primaryAction(sender: AnyObject) {
        
        dismissKeyboard()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    

    
    
}
