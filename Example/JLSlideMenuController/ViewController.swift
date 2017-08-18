//
//  ViewController.swift
//  JLSlideMenuController
//
//  Created by José Lucas on 03/20/2016.
//  Copyright (c) 2016 José Lucas. All rights reserved.
//

import UIKit
import JLSlideMenuController



class ViewController: UIViewController {
    
    
    @IBOutlet weak var blueView: UIView!

    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

        
    @IBAction func showSlideMenu(_ sender: AnyObject) {
        
        if let nav = self.navigationController as? JLSlideNavigationController{
            
            if nav.menuIsPresented(){
                nav.hideMenu(Animated: true)
            }
            else{
                nav.showMenu(Animated: true)
            }
        }
        
        
    }
    
    
    
}

