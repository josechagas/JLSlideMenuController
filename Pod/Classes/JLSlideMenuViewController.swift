//
//  JLSlideMenuViewController.swift
//  Pods
//
//  Created by José Lucas Souza das Chagas on 20/03/16.
//
//

import UIKit

open class JLSlideMenuViewController: UIViewController {

    open var attachedNavController:JLSlideNavigationController!
    
    
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
    open var enabled:Bool = true{
        didSet{
            if enabled == false{
                attachedNavController.hideMenu(Animated: false)
            }
        }
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.layoutIfNeeded()
    }

    override open func didMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent)
        //print(parent!.childViewControllers)
    }

    open override var canBecomeFirstResponder : Bool {
        return true
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override open var prefersStatusBarHidden : Bool {
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
    
    open func presentControllerModally(_ VCId:String,storyboardName:String,animated:Bool){
        let destinyVC = JLSlideNavigationController.loadMenuVC(VCId, storyboardName: storyboardName)
        
        destinyVC.view.frame = self.attachedNavController.view.frame
       
        self.attachedNavController.hideMenu(Animated: false)

        let menuSegue = UIStoryboardSegue(identifier: "actualViewToAnother", source: self.attachedNavController,
            destination: destinyVC, performHandler: { () -> Void in
                
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    self.attachedNavController.topViewController!.present(destinyVC, animated: animated, completion: nil)
                    
                })
                

        })
        
        //self.prepareForSegue(menuSegue, sender: nil)
        self.attachedNavController.topViewController!.prepare(for: menuSegue, sender: nil)
        
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
    open func showController(_ VCId:String,storyboardName:String,animated:Bool){
        
        let destinyVC = JLSlideNavigationController.loadMenuVC(VCId, storyboardName: storyboardName)
        
        destinyVC.view.frame = self.attachedNavController.view.frame
        
        self.attachedNavController.hideMenu(Animated: false)

        let menuSegue = UIStoryboardSegue(identifier: "actualViewTo\(storyboardName)", source: self.attachedNavController,
            destination: destinyVC, performHandler: { () -> Void in
                self.attachedNavController.pushViewController(destinyVC, animated: animated)
            })
        
        //self.prepareForSegue(menuSegue, sender: nil)
        self.attachedNavController.prepare(for: menuSegue, sender: nil)

        menuSegue.perform()
        
    }
    
  
}
