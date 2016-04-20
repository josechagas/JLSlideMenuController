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
        // Do any additional setup after loading the view.
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.view.layoutIfNeeded()
    }

    override public func didMoveToParentViewController(parent: UIViewController?) {
        super.didMoveToParentViewController(parent)
        //print(parent!.childViewControllers)
    }

    public override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override public func prefersStatusBarHidden() -> Bool {
        return true
    }
    /**
     Call this method to present modally the correct view controller accordingly to some interaction
     with the menu view controller
     
     - parameter VCId: The Id of the view controller to show
     - parameter storyboardName: the name of the storyboard where the view controller is
     - parameter animated: true to transition with some animation or not
     */
    
    public func presentControllerModally(VCId:String,storyboardName:String,animated:Bool){
        let destinyVC = JLSlideViewController.loadMenuVC(VCId, storyboardName: storyboardName)
        
        destinyVC.view.frame = self.parentViewController!.view.frame
        
        let menuSegue = UIStoryboardSegue(identifier: "actualViewToAnother", source: self.parentViewController!,
            destination: destinyVC, performHandler: { () -> Void in
                
                self.parentViewController?.presentViewController(destinyVC, animated: animated, completion: nil)
                
        })
        
        self.prepareForSegue(menuSegue, sender: nil)
        
        menuSegue.perform()
    }
    
    /**
     Call this method to show the correct view controller accordingly to some interaction
     with the menu view controller
     
     Use this one if the view controller where the menu is right now have some navigation controller
     
     - parameter VCId: The Id of the view controller to show
     - parameter storyboardName: the name of the storyboard where the view controller is
     - parameter animated: true to transition with some animation or not
     */
    public func showController(VCId:String,storyboardName:String,animated:Bool){
        
        let destinyVC = JLSlideViewController.loadMenuVC(VCId, storyboardName: storyboardName)
        
        destinyVC.view.frame = self.parentViewController!.view.frame
        
        let menuSegue = UIStoryboardSegue(identifier: "actualViewToAnother", source: self.parentViewController!,
            destination: destinyVC, performHandler: { () -> Void in
                
               
                if let navC = self.parentViewController!.navigationController{
                    navC.pushViewController(destinyVC, animated: animated)
                }
                else{
                    print("navigation controller nil no metodo showController")
                }
                
        })
        
        self.prepareForSegue(menuSegue, sender: nil)
        
        menuSegue.perform()
        
     
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
