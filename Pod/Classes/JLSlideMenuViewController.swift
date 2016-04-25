//
//  JLSlideMenuViewController.swift
//  Pods
//
//  Created by José Lucas Souza das Chagas on 20/03/16.
//
//

import UIKit

public class JLSlideMenuViewController: UIViewController {

    public var attachedNavController:JLSlideNavigationController!
    
    
    //constraints
    var sideDist:NSLayoutConstraint!
    var distToTopC:NSLayoutConstraint!
    var distToBottomC:NSLayoutConstraint!
    var widthC:NSLayoutConstraint!
    //
    
    /**
     TRUE to enable the menu FALSE to disable
     
     The value of this enable or disable the animations and gestures to show and hide the menu
     */
    public var enabled:Bool = true{
        didSet{
            if enabled == false{
                attachedNavController.hideMenu(false)
            }
        }
    }
    
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
    
    func removeConstraints(){
        self.view.window!.removeConstraint(sideDist)
        self.view.window!.removeConstraint(distToTopC)
        self.view.window!.removeConstraint(distToBottomC)
        self.view.removeConstraint(widthC)
        
    }
    
    /**
     Call this method to present modally the correct view controller accordingly to some interaction
     with the menu view controller
     
     - parameter VCId: The Id of the view controller to show
     - parameter storyboardName: the name of the storyboard where the view controller is
     - parameter animated: true to transition with some animation or not
     */
    
    public func presentControllerModally(VCId:String,storyboardName:String,animated:Bool){
        let destinyVC = JLSlideNavigationController.loadMenuVC(VCId, storyboardName: storyboardName)
        
        destinyVC.view.frame = self.attachedNavController.view.frame
       
        self.attachedNavController.hideMenu(false)

        let menuSegue = UIStoryboardSegue(identifier: "actualViewToAnother", source: self.attachedNavController,
            destination: destinyVC, performHandler: { () -> Void in
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.attachedNavController.topViewController!.presentViewController(destinyVC, animated: animated, completion: nil)
                    
                })
                

        })
        
        //self.prepareForSegue(menuSegue, sender: nil)
        self.attachedNavController.topViewController!.prepareForSegue(menuSegue, sender: nil)
        
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
        
        let destinyVC = JLSlideNavigationController.loadMenuVC(VCId, storyboardName: storyboardName)
        
        destinyVC.view.frame = self.attachedNavController.view.frame
        
        self.attachedNavController.hideMenu(false)

        let menuSegue = UIStoryboardSegue(identifier: "actualViewToAnother", source: self.attachedNavController,
            destination: destinyVC, performHandler: { () -> Void in
                self.attachedNavController.pushViewController(destinyVC, animated: animated)
            })
        
        //self.prepareForSegue(menuSegue, sender: nil)
        self.attachedNavController.prepareForSegue(menuSegue, sender: nil)

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
