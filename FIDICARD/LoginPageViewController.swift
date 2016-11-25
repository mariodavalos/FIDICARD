//
//  LoginPageViewController.swift
//  FIDICARD
//
//  Created by omar on 07/09/16.
//  Copyright © 2016 oomovil. All rights reserved.
//

import UIKit

class LoginPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pages = ["Slider1","Slider2","Slider3"]
    var padre = InicioViewController()
    var MyDelegate : allocEditInicoPageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self

        
        self.view.layer.cornerRadius = 20
        
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier(self.pages[0]) as! MainPageViewModeloViewController
        vc.view.tag = 0
        
        
        
        setViewControllers([vc], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        guard let vc = pageViewController.viewControllers?.first else{
            return nil
        }
        
        let index = vc.view.tag - 1
        
        if index == -1{
            return nil
        }
        
        
        
        let beforeVC = self.storyboard?.instantiateViewControllerWithIdentifier(self.pages[index])as! MainPageViewModeloViewController
        
        beforeVC.view.tag = index
        
        

        

        return beforeVC
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard let vc = pageViewController.viewControllers?.first else{
            return nil
        }
        
        let index =  vc.view.tag + 1
        
        if index > 2 {
            return nil
        }
        
        let afterVC = self.storyboard?.instantiateViewControllerWithIdentifier(self.pages[index])as! MainPageViewModeloViewController
            afterVC.view.tag = index
        
        return afterVC
    }
    
    
    
}







