//
//  ViewController.swift
//  FIDICARD
//
//  Created by omar on 07/09/16.
//  Copyright © 2016 oomovil. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import FacebookCore
import FacebookLogin
import FacebookShare


class InicioViewController: UIViewController, FBSDKLoginButtonDelegate, allocEditInicoPageView {
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    @IBOutlet var btnIniciarConFaceBook: FBSDKLoginButton!
    
    @IBOutlet var contenedor: UIView!
    
    @IBOutlet weak var pageControl: UIImageView!
    
    var pageViewCarrusel: LoginPageViewController?
    var count = 0
    
    func updatePageviewImage(index: Int){
        
        switch index {
            
        case 0 :
            
            pageControl.image = UIImage(named: "ios_inicio_dot1")
            
            break
        case 1:
            pageControl.image = UIImage(named: "ios_inicio_dot2")
            break
            
        case 2:
            pageControl.image = UIImage(named: "ios_inicio_dot3")
            break
            
        default:
            break
            
        }

        
        
    }
    
    
    
    @IBAction func LoginWithFacebook(sender: AnyObject) {
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func Registrarse(sender: AnyObject) {
       
        let destinationController = storyboard!.instantiateViewControllerWithIdentifier("RegistroViewController")
        
        presentViewController(destinationController, animated: true, completion: nil)
        
        
    }
    
    @IBAction func iniciarSinRegistrar(sender: AnyObject) {
        
        let destinationController = storyboard!.instantiateViewControllerWithIdentifier("HomeView")
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setBool(false, forKey:"userLogged")
        
        presentViewController(destinationController, animated: true, completion: nil)
        
        
    }
      
    
    
    
    @IBAction func iniciarSesion(sender: AnyObject) {
        
        let destinationController = storyboard!.instantiateViewControllerWithIdentifier("LoginViewController") 
        
        presentViewController(destinationController, animated: true, completion: nil)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnIniciarConFaceBook.setTitle("INICIAR SESION\n CON FACEBOOK", forState: .Normal)
        
        
        btnIniciarConFaceBook.readPermissions = ["public_profile", "email", "user_friends"];
        btnIniciarConFaceBook.delegate = self
        
        btnIniciarConFaceBook.setTitle("INICIAR SESION\n CON FACEBOOK", forState: .Normal)
        
        btnIniciarConFaceBook.backgroundColor = UIColor(red: 4/255, green: 128/255, blue: 224/255, alpha: 1)
        btnIniciarConFaceBook.setBackgroundImage(nil, forState: .Normal)

        // Do any additional setup after loading the view, typically from a nib.
        
        
        pageViewCarrusel!.padre = self
        
        
    }
    
    @objc func loginButtonClicked() {
        let loginManager = LoginManager()
        loginManager.logIn([ .PublicProfile ], viewController: self) { loginResult in
            switch loginResult {
            case .Failed(let error):
                print(error)
            case .Cancelled:
                print("User cancelled login.")
            case .Success(let grantedPermissions, let declinedPermissions, let _):
                print("Logged in!")
                
                break
                
            }
        }
    }
    
    
    @IBAction func rightArrow(sender: AnyObject) {
      
        
        guard let currentViewController = pageViewCarrusel!.viewControllers?.first else { return }
        
        guard let nextViewController = pageViewCarrusel!.dataSource?.pageViewController( pageViewCarrusel!, viewControllerAfterViewController: currentViewController ) else { return }
        
        pageViewCarrusel!.setViewControllers([nextViewController], direction: .Forward, animated: true, completion: nil)
        count = count+1
        updatePageviewImage(count)
        
    }
    
    
    @IBAction func leftArrow(sender: AnyObject) {
        
        guard let currentViewController = pageViewCarrusel!.viewControllers?.first else { return }
        
        guard let previousViewController = pageViewCarrusel!.dataSource?.pageViewController( pageViewCarrusel!, viewControllerBeforeViewController: currentViewController ) else { return }
        
        pageViewCarrusel!.setViewControllers([previousViewController], direction: .Reverse, animated: true, completion: nil)
        
        count = count-1
        updatePageviewImage(count)


    }
    
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
        
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        
      
        FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"first_name, last_name, picture.type(large),email"]).startWithCompletionHandler { (connection, result, error) -> Void in
            
            if let resultado = result {
                
                let strFirstName = (resultado.objectForKey("first_name"))
                let strLastName: String = (result.objectForKey("last_name") as? String)!
                let strPictureURL: String = (result.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String)!
                let srtEmail: String = (result.objectForKey("email") as? String)!
                
                
                print("Welcome, \(strFirstName) \(strLastName)")
                
                
                
                let image = UIImage(data: NSData(contentsOfURL: NSURL(string: strPictureURL)!)!)
                
                let temporalUser = Usuario()
                temporalUser.nombre = strFirstName as? String
                temporalUser.apellido = strLastName
                temporalUser.email = srtEmail
                
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(temporalUser), forKey: "user")
                
                let imageData = UIImagePNGRepresentation(image!)
                
                defaults.setObject(imageData, forKey: "profileImage")
                defaults.setObject(true, forKey: "wasImageSet")
                
                
                defaults.synchronize()
                
                let loginManager: FBSDKLoginManager = FBSDKLoginManager()
                loginManager.logOut()
                
                dispatch_async(dispatch_get_main_queue(), {
                    let destinationController = self.storyboard!.instantiateViewControllerWithIdentifier("LoginFacebookViewController")
                    self.presentViewController(destinationController, animated: true, completion: nil)
                })

                
                
            }
            
            
            
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        let segueName = segue.identifier
        if segueName == "PageViewSegue" {
            pageViewCarrusel = segue.destinationViewController as? LoginPageViewController
            pageViewCarrusel?.MyDelegate = self
            pageViewCarrusel?.delegate = self
        }
   
    }
    
    


}


extension InicioViewController: UIPageViewControllerDelegate{
    
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let vc = pageViewController.viewControllers?.first else{
            return
        }
        
        let index =  vc.view.tag
        self.updatePageviewImage(index)
        self.count = index
        
    }
    
    
    
    
}

