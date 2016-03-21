//
//  JLSlideMenuViewController.swift
//  Pods
//
//  Created by José Lucas Souza das Chagas on 20/03/16.
//
//

import UIKit

public class JLSlideMenuViewController: UIViewController {

    
    override public func viewDidLoad() {
        super.viewDidLoad()
        //applyShadowEffects()
        // Do any additional setup after loading the view.
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override public func prefersStatusBarHidden() -> Bool {
        return true
    }

    private func applyShadowEffects(){
        self.view.layer.shadowColor = UIColor.blackColor().CGColor
        self.view.layer.shadowOffset = CGSize(width: -3, height: 10)
        self.view.layer.shadowOpacity = 0.1
        self.view.layer.shadowRadius = 9
        self.view.layer.masksToBounds = false
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
