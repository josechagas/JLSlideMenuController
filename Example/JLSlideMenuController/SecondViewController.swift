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

        addSlideMenu(0, width: 150, height: 320,comeFromLeft: true)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func showMenu(sender: AnyObject) {
        
        if menuIsPresented(){
            hideMenu()
        }
        else{
            showMenu()
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
