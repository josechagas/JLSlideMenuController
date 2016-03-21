//
//  JLSlideViewController.swift
//  Pods
//
//  Created by José Lucas Souza das Chagas on 20/03/16.
//
//

import UIKit

/**
The ViewController that contains the slide menu
*/
public class JLSlideViewController: UIViewController {

    private static var slideMenuController:UIViewController?
    
    private var menuContainerView: UIView!
    private var sideDist:NSLayoutConstraint!
    private var comeFromLeft:Bool = true
    
    
    private var moveNavigationBar:Bool = false
    
    private var moveTabBar:Bool = false
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        self.hideMenu()
    }

    private func loadMenuVC(identifier:String)->UIViewController{
        
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        
        return storyboard.instantiateViewControllerWithIdentifier(identifier)

        

    }
    
    
    /**
     This method do what is necessary to add your menu into this ViewController
     
     - parameter distToTop: the value of the constraint the indicate the distance between youw menu top and this VC top.
     
     - parameter width: the value of the constraint that determine your menu Width.
     
     - parameter height: the value of the constraint that determine your menu Height.
     
     - parameter comeFromLeft: the bolean value that indicates if your menu will come from left or from right of the window.
     */
    public func addSlideMenu(distToTop:CGFloat,width:CGFloat,height:CGFloat,comeFromLeft:Bool){
        self.comeFromLeft = comeFromLeft
        
        var myMenuVC:UIViewController!

        if let menuVC = JLSlideViewController.slideMenuController{
            myMenuVC = menuVC
        }
        else{
            myMenuVC = loadMenuVC("MySlideMenu")
            JLSlideViewController.slideMenuController = myMenuVC
        }
        
        menuContainerView = myMenuVC.view
        menuContainerView.translatesAutoresizingMaskIntoConstraints = false
        menuContainerView.clipsToBounds = true
        menuContainerView.alpha = 0
        
        self.addChildViewController(myMenuVC)
        myMenuVC.didMoveToParentViewController(self)

        self.view.addSubview(menuContainerView)
        
        self.view.bringSubviewToFront(menuContainerView)
        
        applyShadowEffects()
        
        checkIfShouldMoveBars(distToTop, height: height)
        

        // Constraints
        
        let distToTopC = NSLayoutConstraint(item: menuContainerView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: distToTop)
        self.view.addConstraint(distToTopC)
        
        let widthC = NSLayoutConstraint(item: menuContainerView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant:width)
        menuContainerView.addConstraint(widthC)
        
        let heightC = NSLayoutConstraint(item: menuContainerView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant:height)
        menuContainerView.addConstraint(heightC)

        if comeFromLeft{
            sideDist = NSLayoutConstraint(item:menuContainerView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant:-width)
            self.view.addConstraint(sideDist)

        }
        else{
            sideDist = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem:menuContainerView, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant:-width)
            self.view.addConstraint(sideDist)

        }
        
        //
     

    }
    
       
    
    private func applyShadowEffects(){
        menuContainerView.layer.shadowColor = UIColor.blackColor().CGColor
        menuContainerView.layer.shadowOffset = CGSize(width: -3, height: 10)
        menuContainerView.layer.shadowOpacity = 0.1
        menuContainerView.layer.shadowRadius = 9
        menuContainerView.layer.masksToBounds = false
    }
    
    
    private func checkIfShouldMoveBars(distToTop:CGFloat,height:CGFloat){
        
        if let navigationController = self.navigationController{
            moveNavigationBar = navigationController.navigationBar.frame.height > distToTop ? true : false
        }
        
        if let tabBarController = self.tabBarController{
            moveNavigationBar = tabBarController.tabBar.frame.origin.y > distToTop + height ? true : false
        }
        
        
    }
    
    
    /**
     This method indicates if the menu VC is presented of not
     */
    public func menuIsPresented()->Bool{
        return sideDist.constant == 0
    }
    
    /**
     Call this method for present the menu VC
     */
    public func showMenu(){
        sideDist.constant = 0
        
        UIView.animateWithDuration(0.8) { () -> Void in
            self.moveBars(ShowingSlideView: true)
        }
        menuContainerView.alpha = 1
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.view.layoutIfNeeded()
            /**
            move the rest of the window
            */
            //self.menuContainerView.alpha = 1

            }) { (finished) -> Void in
                //self.menuContainerView.alpha = 1
        }
    }
    
    /**
     Call this method to hide the menu VC
     */
    public func hideMenu(){
        sideDist.constant = -menuContainerView.frame.height
        
        UIView.animateWithDuration(0.2) { () -> Void in
            self.moveBars(ShowingSlideView: false)
        }
        
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.view.layoutIfNeeded()
            //self.menuContainerView.alpha = 0
            }) { (finished) -> Void in
                self.menuContainerView.alpha = 0
        }
    }
    
    
    private func moveBars(ShowingSlideView showingSlideView:Bool){
        var newNavXValue:CGFloat = 0
        var newTabXValue:CGFloat = 0

        if showingSlideView{
            if comeFromLeft{
                
                newNavXValue = menuContainerView.frame.width
                newTabXValue = menuContainerView.frame.width
            }
            else{
                newNavXValue = -menuContainerView.frame.width
                newTabXValue = -menuContainerView.frame.width
            }
        }
        
        
        if moveNavigationBar{
            self.navigationController!.navigationBar.frame.origin = CGPoint(x: newNavXValue,y: self.navigationController!.navigationBar.frame.origin.y)
        }
        
        if moveTabBar{
            self.tabBarController!.tabBar.frame.origin = CGPoint(x: newTabXValue,y: self.tabBarController!.tabBar.frame.origin.y)
        }
    }
    

}
