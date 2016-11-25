//
//  PopUp1BtnViewController.swift
//  FIDICARD
//
//  Created by omar on 13/09/16.
//  Copyright © 2016 oomovil. All rights reserved.
//

import UIKit
import Foundation

class PopUp1BtnViewController: UIViewController {
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    var imageName = ""
    var labelText = ""
    var btnText = ""
    var btnImage = ""
   
    @IBOutlet var image: UIImageView!
    
    @IBOutlet var lblText: UILabel!
    
    @IBOutlet var btnPopUp: UIButton!
    
   
    @IBAction func ButonAction(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        image.image = UIImage.init(named: imageName)
        lblText.text = labelText
        btnPopUp.setTitle(btnText, forState: .Normal)
        btnPopUp.setBackgroundImage(UIImage.init(named: btnImage), forState: .Normal)
    

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
