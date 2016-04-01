//
//  SecondViewController.swift
//  JLSlideMenuController
//
//  Created by José Lucas Souza das Chagas on 21/03/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import JLSlideMenuController
class SecondViewController: JLSlideViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        addSlideMenu("MySlideMenu",storyboardName: "Main",distToTop: 0, width: 150, height: 320,comeFromLeft: true)
        // Do any additional setup after loading the view.
    }
    
        
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showSlideMenu(sender: AnyObject) {
        
        if menuIsPresented(){
            hideMenu(true)
        }
        else{
            showMenu(true)
        }
        
    }
    
}
