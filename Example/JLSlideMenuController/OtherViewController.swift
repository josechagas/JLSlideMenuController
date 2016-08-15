//
//  OtherViewController.swift
//  JLSlideMenuController
//
//  Created by José Lucas Souza das Chagas on 03/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import JLSlideMenuController

class OtherViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showMenuAction(sender: AnyObject) {
        
        if let slideNVC = self.navigationController as? JLSlideNavigationController{
            !slideNVC.menuIsPresented() ? slideNVC.showMenu(Animated: true) : slideNVC.hideMenu(Animated: true)
        }
        
    }

    @IBAction func dismissButtonAction(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
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
