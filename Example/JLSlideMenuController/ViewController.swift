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
        addSlideMenu("MySlideMenu",storyboardName: "Main",distToTop: 0, width: 150, height: 320,comeFromLeft: true)

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        /**
        You can do something like this to make some configurations directly to your menu ViewController
        */
        if let menu = self.myMenuVC as? MyMenuViewController{

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
        
        /*if let appDelegate = UIApplication.sharedApplication().delegate{
            
            let myView = UIView(frame:CGRectMake(0, 200, 30, 100))
            myView.backgroundColor = UIColor.redColor()
            
            let frame = self.view.frame
            
            //change view controller position
            self.view.frame = CGRect(x: 30, y: frame.origin.y, width: frame.size.width, height: frame.size.height)
            

            //change navigation bar position
            self.navigationController?.navigationBar.frame.origin = CGPoint(x: 30, y: (self.navigationController?.navigationBar.frame.origin.y)!)
            
            //add a view on window
            appDelegate.window!!.addSubview(myView)
            //UIApplication.sharedApplication().windows[1].addSubview(myView)
            //UIApplication.sharedApplication().windows[0].backgroundColor = UIColor.clearColor()

        }*/
    }
}

