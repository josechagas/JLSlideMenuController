//
//  SecondViewController.swift
//  JLSlideMenuController
//
//  Created by José Lucas Souza das Chagas on 21/03/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import JLSlideMenuController
class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //self.navigationController?.topViewController
        // Do any additional setup after loading the view.
    }
    
        
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showSlideMenu(sender: AnyObject) {
        
        if let navC = self.navigationController as? JLSlideNavigationController{
            if navC.menuIsPresented(){
                navC.hideMenu(true)
            }
            else{
                navC.showMenu(true)
            }
            
        }
    
    }
    
}
