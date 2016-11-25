//
//  MarcaPromocionPageViewController.swift
//  FIDICARD
//
//  Created by Miguel Jimenez on 10/12/16.
//  Copyright © 2016 oomovil. All rights reserved.
//

import UIKit

class MarcaPromocionPageViewController: UIPageViewController ,UIPageViewControllerDataSource, UIPageViewControllerDelegate{
    
    
    var promociones = [CPromocion]()
    var padre = MarcaViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        self.dataSource = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func iop(){
        
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("PromoCarruselModeloViewController") as! PromoCarruselModeloViewController
        vc.index = 0
        vc.padre2  = padre
        vc.img =  promociones[0].imagen
        padre.loadPromoContent(0)
        
        vc.view.tag = 0
        setViewControllers([vc], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        
    }
    

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        guard let vc = pageViewController.viewControllers?.first else{
            return nil
        }
        
        let index = vc.view.tag - 1
        /*
         if index == -1{
         return nil
         }*/
        var limit = promociones.count
        limit -= 1
        
        
        if index == -1 {
            return nil
        }
        
        let beforeVC = self.storyboard?.instantiateViewControllerWithIdentifier("PromoCarruselModeloViewController") as! PromoCarruselModeloViewController
        beforeVC.index = index
        beforeVC.padre2 = padre
        beforeVC.img = promociones[index].imagen
       
        
        beforeVC.view.tag = index
        return beforeVC
    }
    


    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard let vc = pageViewController.viewControllers?.first else{
            return nil
        }
        
        let index =  vc.view.tag + 1
        var limit = promociones.count
        limit -= 1
        /*
         if index > (limit) {
         return nil
         }*/
        
        if index > (limit) {
            return nil
        }
        
        let afterVC = self.storyboard?.instantiateViewControllerWithIdentifier("PromoCarruselModeloViewController") as! PromoCarruselModeloViewController
        
        afterVC.index = index
        afterVC.padre2 = padre
        afterVC.img = promociones[index].imagen
        
        
        
        afterVC.view.tag = index
        
        return afterVC
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let vc = pageViewController.viewControllers?.first else{
            return
        }
        
        let index =  vc.view.tag
        padre.loadPromoContent(index)

       
        
        
    }

    
    
}
