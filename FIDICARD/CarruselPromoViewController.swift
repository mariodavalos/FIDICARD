//
//  CarruselPromoViewController.swift
//  FIDICARD
//
//  Created by omar on 16/09/16.
//  Copyright © 2016 oomovil. All rights reserved.
//

import UIKit

class CarruselPromoViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate,allocSaveImageDelegate {

    var promociones = [CPromocion]()
    var padre = SlideOutMenUIViewController()
        
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        
        
      
    }
    
    func iop(){
        
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("PromoCarruselModeloViewController") as! PromoCarruselModeloViewController
        if promociones.count > 0 {
            
            vc.index = 0
            vc.padre  = padre
            vc.delegate = self
            if let data = promociones[0].imagenData {
                vc.imageData = data
            }
            if let img = promociones[0].imagen {
                
                vc.img = img
                padre.loadPromoCntent(0)
            }

            vc.view.tag = 0
            setViewControllers([vc], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
            
        }

        
    }
        
        func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
            
            guard let vc = pageViewController.viewControllers?.first else{
                return nil
            }
            
            var index = vc.view.tag - 1
            /*
            if index == -1{
                return nil
            }*/
            var limit = promociones.count
            limit -= 1

            
            if index == -1 {
                index = limit
            }
            
            let beforeVC = self.storyboard?.instantiateViewControllerWithIdentifier("PromoCarruselModeloViewController") as! PromoCarruselModeloViewController
            beforeVC.index = index
            beforeVC.delegate = self
            beforeVC.padre = padre
            beforeVC.img = promociones[index].imagen
            if let data = promociones[index].imagenData {
                beforeVC.imageData = data
            }
            //padre.loadPromoCntent(index)

            beforeVC.view.tag = index
            return beforeVC
        }
        
        func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
            guard let vc = pageViewController.viewControllers?.first else{
                return nil
            }
            
            var index =  vc.view.tag + 1
            var limit = promociones.count
            limit -= 1
            /*
            if index > (limit) {
                return nil
            }*/
            
            if index > (limit) {
                index = 0
            }
            
            let afterVC = self.storyboard?.instantiateViewControllerWithIdentifier("PromoCarruselModeloViewController") as! PromoCarruselModeloViewController
            
            afterVC.index = index
            afterVC.padre = padre
            afterVC.delegate = self
            afterVC.img = promociones[index].imagen
            if let data = promociones[index].imagenData {
                afterVC.imageData = data
            }
            //padre.loadPromoCntent(index)


            afterVC.view.tag = index
            
            return afterVC
        }
    
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let vc = pageViewController.viewControllers?.first else{
            return
        }
        
        let index =  vc.view.tag
        padre.loadPromoCntent(index)

        
    }
    
    func sendImageData(index : Int, data : NSData){
        
        padre.sendImageData(index, data: data)
        
        
    }
    
    

}


