//
//  JLSlideNavigationController.swift
//  Pods
//
//  Created by José Lucas Souza das Chagas on 24/04/16.
//
//

import UIKit

public class JLSlideNavigationController: UINavigationController,UINavigationControllerDelegate {

    
    /**
     menuVCStoryboardID: The Id of your menu View Controller.
     */
    @IBInspectable private(set) var menuVCStoryboardID:String?
    /**
     the name of the storyboard where your menu View Controller is.
     */
    @IBInspectable private(set) var storyboardName:String?
    /**
     the value of the constraint that indicates the distance between your menu top and this VC top.
     */
    @IBInspectable private(set) var distToTop:CGFloat = 0
    /**
     the value of the constraint that determine your menu Width.
     */
    @IBInspectable private(set)  var width:CGFloat = 250
    /**
     the value of the constraint that indicates the distance between your menu bottom and this VC bottom.
     */
    @IBInspectable private(set) var distToBottom:CGFloat = 0
    /**
     the bolean value that indicates if your menu will come from left or from right of the window.
     */
    @IBInspectable private(set) var comeFromLeft:Bool = true
    /**
     A bolean value that indicates to use or not shadow effects
     */
    @IBInspectable private(set) var useShadowEffects:Bool = false
    
    private var menuContainerView: UIView?
    /**
     The instace of your menu View Controller associated to this View Controller
     */
    private(set) static var myMenuVC:JLSlideMenuViewController?
    
    private static var panGes:UIPanGestureRecognizer?
    
    private static var screeEdgePanGes:UIScreenEdgePanGestureRecognizer?

    /**
     Incicates that the pan gesture that were started enabled or not
     */
    
    private var panEnabled:Bool = false
    private var lastPanTouch:CGPoint?
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        if let pan = JLSlideNavigationController.panGes{
            pan.enabled = true
        }
        
        if let pan = JLSlideNavigationController.screeEdgePanGes{
            pan.enabled = true
        }

        // Do any additional setup after loading the view.
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let _ = self.view.window{
            
            checkIfShouldAddOrUpdateMenu()
        }
        print(self.view.window!.gestureRecognizers!.count)
    }
    
   
    
    public override func viewDidDisappear(animated: Bool) {
        super.viewDidAppear(animated)
        if let pan = JLSlideNavigationController.panGes{
            pan.enabled = false
        }
        
        if let pan = JLSlideNavigationController.screeEdgePanGes{
            pan.enabled = false
        }
    
    }
    
    
    
    class func loadMenuVC(identifier:String,storyboardName:String)->UIViewController{
        
        let storyboard = UIStoryboard(name: storyboardName, bundle: NSBundle.mainBundle())
        
        return storyboard.instantiateViewControllerWithIdentifier(identifier)
    }
    
    
    //MARK: - NavigationController delegate methods
    
    public func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        if let menuView = menuContainerView , window = self.view.window{
            window.bringSubviewToFront(menuView)
        }
        let subViews = viewController.view.subviews
        if let screenEdgeGes = JLSlideNavigationController.screeEdgePanGes{
            for subView in subViews{
                if let gestures = subView.gestureRecognizers{
                    for gesture in gestures{
                        gesture.requireGestureRecognizerToFail(screenEdgeGes)
                    }
                }
            }
        }
        
       
    }
    
    //MARK: - Gestures methods
    private func addGestures(){
        //Pan

        if let window = self.view.window , pan = JLSlideNavigationController.panGes{
            window.removeGestureRecognizer(pan)
        }
        
        JLSlideNavigationController.panGes = UIPanGestureRecognizer(target: self, action: #selector(JLSlideNavigationController.panAction(_:)))
        
        self.view.window?.addGestureRecognizer(JLSlideNavigationController.panGes!)

        //Screen Edge pan
        if let window = self.view.window , pan = JLSlideNavigationController.screeEdgePanGes{
            window.removeGestureRecognizer(pan)
        }
        
        JLSlideNavigationController.screeEdgePanGes = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(JLSlideNavigationController.screenEdgePanAction(_:)))
        
        
        
        if comeFromLeft{
            
            JLSlideNavigationController.screeEdgePanGes!.edges = UIRectEdge.Left

        }
        else{
            JLSlideNavigationController.screeEdgePanGes!.edges = UIRectEdge.Right

        }

        self.view.window?.addGestureRecognizer(JLSlideNavigationController.screeEdgePanGes!)
        
        
        JLSlideNavigationController.panGes!.requireGestureRecognizerToFail(JLSlideNavigationController.screeEdgePanGes!)
        
        
        if let screenEdgeGes = JLSlideNavigationController.screeEdgePanGes, topViewC = topViewController{
            let subViews = topViewC.view.subviews

            for subView in subViews{
                if let gestures = subView.gestureRecognizers{
                    for gesture in gestures{
                        gesture.requireGestureRecognizerToFail(screenEdgeGes)
                    }
                }
            }
        }

    }
    
    public func screenEdgePanAction(edgePan:UIScreenEdgePanGestureRecognizer){
        let currenLocation = edgePan.locationInView(self.view)
        
        if let menuView = menuContainerView where  JLSlideNavigationController.myMenuVC!.enabled{
            if edgePan.state == UIGestureRecognizerState.Began{
                panEnabled = false
                if !menuIsPresented(){
                    panEnabled = true
                    lastPanTouch = currenLocation
                }
                
            }
            else if edgePan.state == UIGestureRecognizerState.Ended{//at the end of pan gesture check if the menu is near to show or hide completelly and then finishes the movement
                panEnabled = false
                let menuFrame = menuView.frame
                if comeFromLeft{
                    if menuFrame.origin.x <= -menuFrame.size.width/2{
                        self.hideMenu(true)
                    }
                    else if menuFrame.origin.x > -menuFrame.size.width/2{
                        self.showMenu(true)
                    }
                }
                else{
                    if menuFrame.origin.x >= self.view.frame.width - menuFrame.size.width/2{
                        self.hideMenu(true)
                    }
                    else if menuFrame.origin.x < self.view.frame.width - menuFrame.size.width/2{
                        self.showMenu(true)
                    }
                }
                
                
            }
            
            
            
            if panEnabled{//if the pan started at a right point continue
                menuView.alpha = 1
                let xDeslocamento = currenLocation.x - lastPanTouch!.x
                
                lastPanTouch = currenLocation
                
                if comeFromLeft{
                    if menuView.frame.origin.x + xDeslocamento >= -menuView.frame.width && menuView.frame.origin.x + xDeslocamento <= 0{
                        
                        menuView.frame.origin = CGPoint(x:menuView.frame.origin.x + xDeslocamento ,y:menuView.frame.origin.y)
                        
                        
                    }
                }
                else{
                    if menuView.frame.origin.x + xDeslocamento >= self.view.frame.width - menuView.frame.width  && menuView.frame.origin.x + xDeslocamento <= self.view.frame.width{
                        
                        menuView.frame.origin = CGPoint(x:menuView.frame.origin.x + xDeslocamento ,y: menuView.frame.origin.y)
                    }
                }
                
                
            }
            
        }
    }
    
    
    
    public func panAction(panGes:UIPanGestureRecognizer){
        let currenLocation = panGes.locationInView(self.view)
        
        if let menuView = menuContainerView where  JLSlideNavigationController.myMenuVC!.enabled{
            if panGes.state == UIGestureRecognizerState.Began{
                panEnabled = false
                if menuIsPresented(){
                    if menuView.frame.contains(currenLocation){
                        panEnabled = true
                        lastPanTouch = currenLocation
                    }
                }
                
            }
            else if panGes.state == UIGestureRecognizerState.Ended{//at the end of pan gesture check if the menu is near to show or hide completelly and then finishes the movement
                panEnabled = false
                let menuFrame = menuView.frame
                if comeFromLeft{
                    if menuFrame.origin.x <= -menuFrame.size.width/2{
                        self.hideMenu(true)
                    }
                    else if menuFrame.origin.x > -menuFrame.size.width/2{
                        self.showMenu(true)
                    }
                }
                else{
                    if menuFrame.origin.x >= self.view.frame.width - menuFrame.size.width/2{
                        self.hideMenu(true)
                    }
                    else if menuFrame.origin.x < self.view.frame.width - menuFrame.size.width/2{
                        self.showMenu(true)
                    }
                }
                
                
            }
            
            
            
            if panEnabled{//if the pan started at a right point continue
                menuView.alpha = 1
                let xDeslocamento = currenLocation.x - lastPanTouch!.x
                
                lastPanTouch = currenLocation
                
                if comeFromLeft{
                    if menuView.frame.origin.x + xDeslocamento >= -menuView.frame.width && menuView.frame.origin.x + xDeslocamento <= 0{
                        
                        menuView.frame.origin = CGPoint(x:menuView.frame.origin.x + xDeslocamento ,y:menuView.frame.origin.y)
                        
                        
                    }
                }
                else{
                    if menuView.frame.origin.x + xDeslocamento >= self.view.frame.width - menuView.frame.width  && menuView.frame.origin.x + xDeslocamento <= self.view.frame.width{
                        
                        menuView.frame.origin = CGPoint(x:menuView.frame.origin.x + xDeslocamento ,y: menuView.frame.origin.y)
                    }
                }
                
                
            }

        }
    }
    
    
    //MARK: - Slide Menu methods
    
    
    private func checkIfShouldAddOrUpdateMenu(){
        if let menuVC = JLSlideNavigationController.myMenuVC{//update or remove
            if let myMenuVCID = self.menuVCStoryboardID ,_ = self.storyboardName {
                if myMenuVCID == menuVC.restorationIdentifier{//the same one
                    updateSlideMenu()
                }
                else{
                    addSlideMenu()
                }
            }
            else{
                menuVC.enabled = false
            }
        }
        else{
            if let _ = self.menuVCStoryboardID ,_ = self.storyboardName {
                addSlideMenu()
            }
        }
    }
    
    private func updateSlideMenu(){
        addGestures()

        JLSlideNavigationController.myMenuVC!.attachedNavController = self
        JLSlideNavigationController.myMenuVC!.removeConstraints()
        menuContainerView = JLSlideNavigationController.myMenuVC!.view
        menuContainerView!.translatesAutoresizingMaskIntoConstraints = false
        menuContainerView!.clipsToBounds = true
        menuContainerView!.tag = 101
        
        applyShadowEffects()
        
        addConstraintsToMenuView()
        
        self.hideMenu(false)
        
    }
    
    /**
     This method do what is necessary to add your menu into this NavigationController
     */
    private func addSlideMenu(){
        
        if let _ = menuContainerView{
            self.menuContainerView!.removeFromSuperview()
        }
        else if let view = self.view.window?.viewWithTag(101){
            view.removeFromSuperview()
        }
        
        addGestures()

        JLSlideNavigationController.myMenuVC = JLSlideNavigationController.loadMenuVC(menuVCStoryboardID!,storyboardName: storyboardName!) as?JLSlideMenuViewController
        
        JLSlideNavigationController.myMenuVC!.attachedNavController = self
        menuContainerView = JLSlideNavigationController.myMenuVC!.view
        menuContainerView!.translatesAutoresizingMaskIntoConstraints = false
        menuContainerView!.clipsToBounds = true
        menuContainerView!.tag = 101

        self.view.window!.addSubview(menuContainerView!)
        
        self.view.window!.bringSubviewToFront(menuContainerView!)
        
        applyShadowEffects()

        
        addConstraintsToMenuView()
        
        self.hideMenu(false)
        
    }
    
    private func addConstraintsToMenuView(){
        // Constraints
        
        JLSlideNavigationController.myMenuVC!.distToTopC = NSLayoutConstraint(item: menuContainerView!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view.window!, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: distToTop)
        self.view.window!.addConstraint(JLSlideNavigationController.myMenuVC!.distToTopC)
        
        JLSlideNavigationController.myMenuVC!.widthC = NSLayoutConstraint(item: menuContainerView!, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: width)
        menuContainerView!.addConstraint(JLSlideNavigationController.myMenuVC!.widthC)
        
        JLSlideNavigationController.myMenuVC!.distToBottomC = NSLayoutConstraint(item: menuContainerView!, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view.window!, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -distToBottom)
        self.view.window!.addConstraint(JLSlideNavigationController.myMenuVC!.distToBottomC)
        
        if comeFromLeft{
            JLSlideNavigationController.myMenuVC!.sideDist = NSLayoutConstraint(item:menuContainerView!, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.view.window!, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: -width/*-self.view.frame.width*widthAspectRatio*/)
            self.view.window!.addConstraint(JLSlideNavigationController.myMenuVC!.sideDist)
            
        }
        else{
            JLSlideNavigationController.myMenuVC!.sideDist = NSLayoutConstraint(item: self.view.window!, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem:menuContainerView, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant:-width)
            self.view.window!.addConstraint(JLSlideNavigationController.myMenuVC!.sideDist)
        }

    }

    private func applyShadowEffects(){
        
        if useShadowEffects{
            menuContainerView!.layer.shadowColor = UIColor.blackColor().CGColor
            menuContainerView!.layer.shadowOffset = CGSize(width: comeFromLeft ? 4 : -4, height: 10)
            menuContainerView!.layer.shadowOpacity = 0.4
            menuContainerView!.layer.shadowRadius = 9
            menuContainerView!.layer.masksToBounds = false

        }
        else{
            menuContainerView!.layer.shadowColor = UIColor.clearColor().CGColor
            menuContainerView!.layer.shadowOffset = CGSize.zero
            menuContainerView!.layer.shadowOpacity = 0
            menuContainerView!.layer.shadowRadius = 0
            menuContainerView!.layer.masksToBounds = true

        }
        
    }
    
    
    /**
     This method indicates if the menu VC is presented of not
     */
    public func menuIsPresented()->Bool{
        
        if let mennuView = menuContainerView {
            return mennuView.frame.origin.x == 0 || (mennuView.frame.origin.x == self.view.frame.width - mennuView.frame.width)

        }
        return false
    }
    
    /**
     Call this method for present the menu VC
     - parameter animated: true if you want animated and false if not
     */
    public func showMenu(animated:Bool){
        
        if let menuView = menuContainerView where JLSlideNavigationController.myMenuVC!.enabled{
            if let vc = JLSlideNavigationController.myMenuVC!.attachedNavController.topViewController{
                vc.view.userInteractionEnabled = false
            }

            menuView.alpha = 1
            if animated{
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    UIView.animateKeyframesWithDuration(0.3, delay: 0, options: UIViewKeyframeAnimationOptions.BeginFromCurrentState, animations: {
                        
                        
                        if self.comeFromLeft{
                            menuView.frame.origin = CGPoint(x: 0,y: menuView.frame.origin.y)
                            
                        }
                        else{
                            menuView.frame.origin = CGPoint(x: self.view.frame.width - menuView.frame.width,y: menuView.frame.origin.y)
                            
                        }
                        
                        }, completion: { (finished) in
                            if finished && self.menuIsPresented(){
                                JLSlideNavigationController.myMenuVC!.sideDist.constant = 0
                                self.view.layoutIfNeeded()

                            }
                    })
                    
                })
                
            }
            else{
               
                JLSlideNavigationController.myMenuVC!.sideDist.constant = 0
                
                self.view.layoutIfNeeded()
                
            }

        }
        
    }
    
    /**
     Call this method to hide the menu VC
     - parameter animated: true if you want animated and false if not
     */
    public func hideMenu(animated:Bool){
        if let menuView = menuContainerView where JLSlideNavigationController.myMenuVC!.enabled{
            
            
            
            if let vc = JLSlideNavigationController.myMenuVC!.attachedNavController.topViewController{
                vc.view.userInteractionEnabled = true
            }

            if animated{
                
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    UIView.animateKeyframesWithDuration(0.3, delay: 0, options: UIViewKeyframeAnimationOptions.BeginFromCurrentState, animations: {
                        
                        if self.comeFromLeft{
                            menuView.frame.origin = CGPoint(x: -menuView.frame.width,y:menuView.frame.origin.y)
                        }
                        else{
                            menuView.frame.origin = CGPoint(x: self.view.frame.width,y: menuView.frame.origin.y)
                        }
                        
                        }, completion: { (finished) in
                            if finished && !self.menuIsPresented(){
                                menuView.alpha = 0
                                JLSlideNavigationController.myMenuVC!.sideDist.constant = -menuView.frame.width
                                self.view.layoutIfNeeded()
                            }
                    })
                })
                
            }
            else{
                JLSlideNavigationController.myMenuVC!.sideDist.constant = -menuView.frame.width
                self.view.layoutIfNeeded()
                menuView.alpha = 0
                
            }

        }
    }
}
