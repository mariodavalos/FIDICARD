//
//  PopUp2BtnViewController.swift
//  FIDICARD
//
//  Created by omar on 13/09/16.
//  Copyright © 2016 oomovil. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PopUp2BtnViewController: UIViewController {

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
     var delegate : allocPopUpActionsDelegate!
    var imageName = ""
    var labelText = ""
    var btnText1 = ""
    var btnImage1 = ""
    var btnText2 = ""
    var btnImage2 = ""
    var returntTo1 = ""
    var returntTo2 = ""
    var emailToErrase = ""
    var borrar = false
  
    @IBOutlet var imagePopUp: UIImageView!
    
    @IBOutlet var lblPopUp: UILabel!
    
    @IBOutlet var btnPopUp1: UIButton!
    
    @IBOutlet var btnPopUp2: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
        imagePopUp.image = UIImage(named: imageName)
        lblPopUp.text = labelText
        btnPopUp1.setTitle(btnText1, forState: .Normal)
        btnPopUp1.setBackgroundImage(UIImage.init(named: btnImage1), forState: .Normal)
        btnPopUp2.setTitle(btnText2, forState: .Normal)
        btnPopUp2.setBackgroundImage(UIImage.init(named: btnImage2), forState: .Normal)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    @IBAction func button1Action(sender: AnyObject) {
        
    
        if delegate != nil {
            delegate.action1()
        }
        else {
            
            if borrar {
                
                
                let todosEndpoint: String = "http://201.168.207.17:8888/fidicard/kuff_api/delUser"
                let newTodo = ["email": emailToErrase , "cancel_token" : "bbb08bb878806e9662015b78060618ad475a995e"]
                Alamofire.request(.POST, todosEndpoint, parameters: newTodo)
                    .responseJSON { response in
                        guard response.result.error == nil else {
                            // got an error in getting the data, need to handle it
                            print("error calling POST on /todos/1")
                            print(response.result.error!)
                            return
                        }
                        
                        if let value = response.result.value {
                            let todo = JSON(value)
                            print("The todo is: " + todo.description)
                            
                            if let data = response.data{
                                
                                let json = JSON(data:data)
                                print("JSON: \(json)")
                                if json["status"].intValue == 200 {
                                    
                                    let destinationController = self.storyboard!.instantiateViewControllerWithIdentifier(self.returntTo1)
                                    
                                    self.presentViewController(destinationController, animated: true, completion: nil)
                                    
                                    
                                }
                                else {
                                    
                                    let destinationController = self.storyboard!.instantiateViewControllerWithIdentifier(self.returntTo1)
                                    
                                    self.presentViewController(destinationController, animated: true, completion: nil)
                                    
                                }
                            }
                        }
                }
                
            }
            else {
                
                
                let destinationController = self.storyboard!.instantiateViewControllerWithIdentifier(self.returntTo1)
                
                self.presentViewController(destinationController, animated: true, completion: nil)
                
            }

            
        }
    
        
        
        
        
    }

    @IBAction func button2Action(sender: AnyObject) {
        
        
        if delegate != nil {
            delegate.action2()
        }
        else {
            
            if returntTo2 == "self" {
                dismissViewControllerAnimated(true, completion: nil)
                
            }
            else {
                let vc = storyboard?.instantiateViewControllerWithIdentifier(returntTo2)
                self.presentViewController(vc!, animated: true, completion: nil)
            }

        }

    }


}
