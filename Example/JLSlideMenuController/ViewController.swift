//
//  ViewController.swift
//  JLSlideMenuController
//
//  Created by José Lucas on 03/20/2016.
//  Copyright (c) 2016 José Lucas. All rights reserved.
//

import UIKit
import JLSlideMenuController



class ViewController: JLSlideViewController {

    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addSlideMenu("MySlideMenu",storyboardName: "Main",distToTop: 0, width: 200, distToBottom: 0,comeFromLeft: true)

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        /**
        You can do something like this to make some configurations directly to your menu ViewController
        for example block some button on menu because you are on the view of that button.
        */
        if let menu = self.myMenuVC as? MyMenuViewController{
            // do any configuration here
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func showSlideMenu(sender: AnyObject) {
        
        
        if menuIsPresented(){
            self.hideMenu(true)
        }
        else{
            self.showMenu(true)

        }
    }
}

