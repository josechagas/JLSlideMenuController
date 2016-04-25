//
//  FithViewController.swift
//  JLSlideMenuController
//
//  Created by José Lucas Souza das Chagas on 24/04/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import JLSlideMenuController


class FithViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
