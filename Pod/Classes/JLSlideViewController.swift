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
    
    private var menuContainerView: UIView!
    private var sideDist:NSLayoutConstraint!
    private var comeFromLeft:Bool = true
    private var distToTopC:NSLayoutConstraint!

    
    private var moveNavigationBar:Bool = false
    
    private var moveTabBar:Bool = false
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    public override func viewWillAppear(animated: Bool) {
        checkIfShouldMoveBars(distToTopC.constant, height: menuContainerView.frame.height)
        hideMenu(false)

        super.viewWillAppear(animated)
      
    }
    
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    static func loadMenuVC(identifier:String,storyboardName:String)->UIViewController{
        
        let storyboard = UIStoryboard(name: storyboardName, bundle: NSBundle.mainBundle())
        
        //print("\n\n\n AlERT Could NOT LOAD THE VIEW CONTROLLER WITH ID \(identifier) FROM STORYBOARD WITH NAME \(storyboardName). \n\n\n ")
        
        
        return storyboard.instantiateViewControllerWithIdentifier(identifier)
    }
    
    
    /**
     This method do what is necessary to add your menu into this ViewController
     - parameter menuVCStoryboardID: The Id of your menu View Controller.
     
     - parameter storyboardName: the name of the storyboard where your menu View Controller is.
     
     - parameter distToTop: the value of the constraint that indicates the distance between your menu top and this VC top.
     
     - parameter width: the value of the constraint that determine your menu Width.
     
     - parameter height: the value of the constraint that determine your menu Height.
     
     - parameter comeFromLeft: the bolean value that indicates if your menu will come from left or from right of the window.
     

     */
    public func addSlideMenu(menuVCStoryboardID:String,storyboardName:String,distToTop:CGFloat,width:CGFloat,height:CGFloat,comeFromLeft:Bool){
        
        self.comeFromLeft = comeFromLeft
        var myMenuVC:UIViewController!
        
        myMenuVC = JLSlideViewController.loadMenuVC(menuVCStoryboardID,storyboardName: storyboardName)
        
        menuContainerView = myMenuVC.view
        menuContainerView.translatesAutoresizingMaskIntoConstraints = false
        menuContainerView.clipsToBounds = true
        
        myMenuVC.didMoveToParentViewController(self)
        self.addChildViewController(myMenuVC)
        
        self.view.addSubview(menuContainerView)
        
        self.view.bringSubviewToFront(menuContainerView)
        
        applyShadowEffects()
        
        // Constraints
        
        distToTopC = NSLayoutConstraint(item: menuContainerView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: distToTop)
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
        self.hideMenu(false)

    }
    
    private func applyShadowEffects(){
        menuContainerView.layer.shadowColor = UIColor.blackColor().CGColor
        menuContainerView.layer.shadowOffset = CGSize(width: -3, height: 10)
        menuContainerView.layer.shadowOpacity = 0.3
        menuContainerView.layer.shadowRadius = 9
        menuContainerView.layer.masksToBounds = false
    }
    
    
    private func checkIfShouldMoveBars(distToTop:CGFloat,height:CGFloat){
        
        if let _ = self.navigationController{
            //moveNavigationBar = navigationController.navigationBar.frame.size.height > distToTop ? true : false
            moveNavigationBar = distToTop == 0 ? true : false

        }
        
        if let tabBarController = self.tabBarController{
            moveTabBar = tabBarController.tabBar.frame.origin.y < distToTop + height ? true : false
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
     - parameter animated: true if you want animated and false if not
     */
    public func showMenu(animated:Bool){
        menuContainerView.alpha = 1
        if animated{
            sideDist.constant = 0

            UIView.animateWithDuration(0.4, delay: 0.2, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.moveBars(ShowingSlideView: true)

                }, completion: nil)
            
           
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                self.view.layoutIfNeeded()
                
                
                }) { (finished) -> Void in
            }

        }
        else{
            sideDist.constant = 0
            self.moveBars(ShowingSlideView: true)
            self.view.layoutIfNeeded()

        }
    }
    
    /**
     Call this method to hide the menu VC
     - parameter animated: true if you want animated and false if not
     */
    public func hideMenu(animated:Bool){
        if animated{
            sideDist.constant = -menuContainerView.frame.height
            
            UIView.animateWithDuration(0.2) { () -> Void in
                self.moveBars(ShowingSlideView: false)
            }
            
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                self.view.layoutIfNeeded()
                }) { (finished) -> Void in
                    self.menuContainerView.alpha = 0
            }

        }
        else{
            sideDist.constant = -menuContainerView.frame.height
            self.moveBars(ShowingSlideView: false)
            self.view.layoutIfNeeded()
            menuContainerView.alpha = 0
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
            if let navC = self.navigationController{
                navC.navigationBar.frame.origin = CGPoint(x: newNavXValue,y: self.navigationController!.navigationBar.frame.origin.y)
            }
            else{
                print("navigation controller nil no metodo moveBars")
            }
        }
        
        if moveTabBar{
            if let tabC = self.tabBarController{
                tabC.tabBar.frame.origin = CGPoint(x: newTabXValue,y: self.tabBarController!.tabBar.frame.origin.y)
            }
            else{
                print("tabBar controller nil no metodo moveBars")

            }
        }
    }
    

}
