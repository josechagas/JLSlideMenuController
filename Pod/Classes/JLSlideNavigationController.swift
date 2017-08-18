//
//  JLSlideNavigationController.swift
//  Pods
//
//  Created by José Lucas Souza das Chagas on 24/04/16.
//
//

import UIKit

public enum SlideMenuStyle:Int{
    case inFrontAllViews = 0
    case behindAllViews = 1
}

open class JLSlideNavigationController: UINavigationController,UINavigationControllerDelegate,UIGestureRecognizerDelegate {
    
    
    /**
     menuVCStoryboardID: The Id of your menu View Controller.
     */
    @IBInspectable fileprivate(set) var menuVCStoryboardID:String?
    /**
     the name of the storyboard where your menu View Controller is.
     */
    @IBInspectable fileprivate(set) var storyboardName:String?
    
    /**
     A bolean value that indicates that the slide menu should be behind or not the visible view
     */
    fileprivate(set) var menuStyle:SlideMenuStyle = SlideMenuStyle.inFrontAllViews
    
    /**
     This is to define the style of slide menu
     Choosing true the slide menu will be added behind all views
     Choosing true false slide menu will be added up all views, this is the default style
     
     
     OBS:
     I implemented a enum for this but i discovered that @IBInspectable do not works with enums. :(
     */
    @IBInspectable fileprivate(set) var useBehindAllViewsStyle:Bool = false{
        
        didSet{
            menuStyle = self.useBehindAllViewsStyle ? SlideMenuStyle.behindAllViews : SlideMenuStyle.inFrontAllViews
            
            
        }
        
    }

    /**
     the value of the constraint that determine your menu Width.
     */
    @IBInspectable fileprivate(set)  var slideMenuWidth:CGFloat = 250
    /**
     the value of the constraint that indicates the distance between your menu top and this VC top.
     */
    @IBInspectable fileprivate(set) var distToTop:CGFloat = 0
    /**
     the value of the constraint that indicates the distance between your menu bottom and this VC bottom.
     */
    @IBInspectable fileprivate(set) var distToBottom:CGFloat = 0
    /**
     the bolean value that indicates if your menu will come from left or from right of the window.
     */
    @IBInspectable fileprivate(set) var comeFromLeft:Bool = true
    /**
     A bolean value that indicates to use or not shadow effects
     */
    @IBInspectable fileprivate(set) var useShadowEffects:Bool = false
    
    /**
     The instace of your menu View Controller associated to this View Controller
     */
    fileprivate(set) static var myMenuVC:JLSlideMenuViewController?
    
    /**
     The view of myMenuVC myMenuVC.view
     */
    fileprivate func slideMenuContainerView()->UIView?{
        return JLSlideNavigationController.myMenuVC?.view
    }
    
    //Gestures instances
    fileprivate static var swipeLeft:UISwipeGestureRecognizer?
    
    fileprivate static var swipeRight:UISwipeGestureRecognizer?
    
    fileprivate static var panGes:UIPanGestureRecognizer?
    
    fileprivate static var screenEdgePanGes:UIScreenEdgePanGestureRecognizer?

    /**
     Incicates that the pan gesture that were started is enabled or not
     */
    fileprivate var panEnabled:Bool = false
    fileprivate var lastPanTouch:CGPoint?
    
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        if let pan = JLSlideNavigationController.panGes{
            pan.isEnabled = true
        }
        
        if let pan = JLSlideNavigationController.screenEdgePanGes{
            pan.isEnabled = true
        }

        if let swipeLeft = JLSlideNavigationController.swipeLeft{
            swipeLeft.isEnabled = true
        }
        
        if let swipeRight = JLSlideNavigationController.swipeRight{
            swipeRight.isEnabled = true
        }
        // Do any additional setup after loading the view.
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let _ = self.view.window{
            
            checkIfShouldAddOrUpdateMenu()
        }
        //print(self.view.window!.gestureRecognizers!.count)
    }
    
   
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //self.hideMenu(Animated: false)
        
        if let pan = JLSlideNavigationController.panGes{
            pan.isEnabled = false
        }
        
        if let pan = JLSlideNavigationController.screenEdgePanGes{
            pan.isEnabled = false
        }
        
        if let swipeLeft = JLSlideNavigationController.swipeLeft{
            swipeLeft.isEnabled = false
        }
        
        if let swipeRight = JLSlideNavigationController.swipeRight{
            swipeRight.isEnabled = false
        }
        
    }
    
    
    
    class func loadMenuVC(_ identifier:String,storyboardName:String)->UIViewController{
        
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }
    
    
    //MARK: - NavigationController delegate methods
    
    open func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if let menuView = slideMenuContainerView() , let window = self.view.window{
            window.bringSubview(toFront: menuView)
        }
        let subViews = viewController.view.subviews
        if let screenEdgeGes = JLSlideNavigationController.screenEdgePanGes{
            for subView in subViews{
                if let gestures = subView.gestureRecognizers{
                    for gesture in gestures{
                        gesture.require(toFail: screenEdgeGes)
                    }
                }
            }
        }
        
       
    }
    
    //MARK: - Gestures methods
    fileprivate func addGestures(){
        
        if let window = self.view.window , let pan = JLSlideNavigationController.panGes{
            window.removeGestureRecognizer(pan)
        }
        
        JLSlideNavigationController.panGes = UIPanGestureRecognizer(target: self, action: #selector(JLSlideNavigationController.panAction(_:)))
        JLSlideNavigationController.panGes?.delegate = self
        self.view.window?.addGestureRecognizer(JLSlideNavigationController.panGes!)

        //Screen Edge pan
        addScreenEdgeGesture()
        
        addSwipeLeftGesture()
        addSwipeRightGesture()
        
    }
    
    fileprivate func addSwipeLeftGesture(){
        if let window = self.view.window , let swipeLeft = JLSlideNavigationController.swipeLeft{
            window.removeGestureRecognizer(swipeLeft)
        }
        
        JLSlideNavigationController.swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(JLSlideNavigationController.swipesAction(_:)))
        
        JLSlideNavigationController.swipeLeft?.delegate = self
        
        JLSlideNavigationController.swipeLeft!.direction = UISwipeGestureRecognizerDirection.left
        
        self.view.window?.addGestureRecognizer(JLSlideNavigationController.swipeLeft!)
        
        JLSlideNavigationController.swipeLeft!.require(
            toFail: comeFromLeft ? JLSlideNavigationController.panGes! : JLSlideNavigationController.screenEdgePanGes!)
    }
    
    fileprivate func addSwipeRightGesture(){
        if let window = self.view.window , let swipeRight = JLSlideNavigationController.swipeRight{
            window.removeGestureRecognizer(swipeRight)
        }
        
        JLSlideNavigationController.swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(JLSlideNavigationController.swipesAction(_:)))
        
        JLSlideNavigationController.swipeRight?.delegate = self
        
        JLSlideNavigationController.swipeRight!.direction = UISwipeGestureRecognizerDirection.right
        
        self.view.window?.addGestureRecognizer(JLSlideNavigationController.swipeRight!)
        
        JLSlideNavigationController.swipeRight!.require(
            toFail: comeFromLeft ? JLSlideNavigationController.screenEdgePanGes! : JLSlideNavigationController.panGes!)
    }

    
    fileprivate func addScreenEdgeGesture(){
        if let window = self.view.window , let pan = JLSlideNavigationController.screenEdgePanGes{
            window.removeGestureRecognizer(pan)
        }
        
        JLSlideNavigationController.screenEdgePanGes = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(JLSlideNavigationController.screenEdgePanAction(_:)))
        
        JLSlideNavigationController.screenEdgePanGes?.delegate = self
        
        JLSlideNavigationController.screenEdgePanGes!.edges = comeFromLeft ? UIRectEdge.left : UIRectEdge.right
        
        self.view.window?.addGestureRecognizer(JLSlideNavigationController.screenEdgePanGes!)
        
        
        JLSlideNavigationController.panGes!.require(toFail: JLSlideNavigationController.screenEdgePanGes!)
        
        
        if let screenEdgeGes = JLSlideNavigationController.screenEdgePanGes, let topViewC = topViewController{
            let subViews = topViewC.view.subviews
            
            for subView in subViews{
                if let gestures = subView.gestureRecognizers{
                    for gesture in gestures{
                        gesture.require(toFail: screenEdgeGes)
                    }
                }
            }
        }

    }
    
    //MARK: Gesture Actions
    
    func swipesAction(_ swipeGes:UISwipeGestureRecognizer){
        let locationInView = swipeGes.location(in: self.view)
        if swipeGes.direction == UISwipeGestureRecognizerDirection.left{
            //print("swipe Left")
            if comeFromLeft{
                self.hideMenu(Animated: true)
            }
            else{
                if locationInView.x >= self.view.frame.width - 30{
                    self.showMenu(Animated: true)
                }
            }
            //comeFromLeft ? self.hideMenu(Animated: true) : self.showMenu(Animated: true)

        }
        else{
            //print("swipe Right")
            if comeFromLeft{
                if locationInView.x <= 30{
                    self.showMenu(Animated: true)
                }
            }
            else{
                self.hideMenu(Animated: true)
            }
            //comeFromLeft ? self.showMenu(Animated: true) : self.hideMenu(Animated: true)
        }
    }
    
    
    open func screenEdgePanAction(_ edgePan:UIScreenEdgePanGestureRecognizer){
        let currenLocation = edgePan.location(in: self.view)
        
        if let menuView = slideMenuContainerView(),  JLSlideNavigationController.myMenuVC!.enabled{
            if edgePan.state == UIGestureRecognizerState.began{
                panEnabled = false
                if !menuIsPresented(){
                    panEnabled = true
                    lastPanTouch = currenLocation
                }
                
            }
            else if edgePan.state == UIGestureRecognizerState.ended{//at the end of pan gesture check if the menu is near to show or hide completelly and then finishes the movement
                endedPan(edgePan, OnMenuView: menuView)
                
            }
            
            
            
            if panEnabled{//if the pan started at a right point continue
                executingPan(edgePan, OnMenuView: menuView, CurrentLocationOnView: currenLocation)
            }
        }
    }
    
    
    
    open func panAction(_ panGes:UIPanGestureRecognizer){
        
        
        /**
         This current location myght cause some problems when you have to move self.view to present the slide menu, specially because you choosed to use behindAllViewStyle
         */
        let currentLocation = panGes.location(in: self.view)
        
        if let menuView = slideMenuContainerView(), JLSlideNavigationController.myMenuVC!.enabled{
            
            if panGes.state == UIGestureRecognizerState.began{
                panEnabled = false
                /**because this method should only when the menu is totally presented
                 when its hidden you have the option to use the edge pan or some action on some button
                 */
                if menuIsPresented(){
                    if menuView.frame.contains(currentLocation){
                        panEnabled = true
                        lastPanTouch = currentLocation
                    }
                }
                
            }
            else if panGes.state == UIGestureRecognizerState.ended{//at the end of pan gesture check if the menu is near to show or hide completelly and then finishes the movement
                endedPan(panGes, OnMenuView: menuView)
                lastPanTouch = CGPoint.zero
            }
            
            
            if panEnabled{//if the pan started at a right point continue
                //print("current location: \(currentLocation)")
                executingPan(panGes, OnMenuView: menuView, CurrentLocationOnView: currentLocation)
            }

        }
    }
    
    /**
     This method executes all animations necessary on menuView at the end o pan gesture
     - parameter panGes: The pan gesture that ended
     - parameter OnMenuView: the instance of JLSlideMenuViewController view
     */
    fileprivate func endedPan(_ panGes:UIPanGestureRecognizer,OnMenuView menuView:UIView!){
        panEnabled = false
        let menuFrame = menuView.frame
        
        let velocity = panGes.velocity(in: self.view)
        
        if abs(Int32(velocity.x/self.view.frame.width)) > 4{//its on speed of a swipe
            if velocity.x/self.view.frame.width > 0{//move in
                comeFromLeft ? self.showMenu(Animated: true) : self.hideMenu(Animated: true)
            }
            else{//move out
                comeFromLeft ? self.hideMenu(Animated: true) : self.showMenu(Animated: true)
            }
        }
        else{

            if comeFromLeft{
                if menuFrame.origin.x <= -menuFrame.size.width/2{
                    self.hideMenu(Animated: true)
                }
                else if menuFrame.origin.x > -menuFrame.size.width/2{
                    self.showMenu(Animated: true)
                }
            }
            else{
                if menuFrame.origin.x >= self.view.frame.width - menuFrame.size.width/2{
                    self.hideMenu(Animated: true)
                }
                else if menuFrame.origin.x < self.view.frame.width - menuFrame.size.width/2{
                    self.showMenu(Animated: true)
                }
            }
        }
    }
    
    /**
     This method executes all necessary animations while pan gesture is being executing
     - parameter panGes: The instance of pan gesture that is being executed
     - parameter OnMenuView: the instance of view o JLSlideMenuViewController
     - parameter CurrentLocationOnView: The current position of touch on view(`self.view`)
     */
    fileprivate func executingPan(_ panGes:UIPanGestureRecognizer,OnMenuView menuView:UIView!,CurrentLocationOnView currentLocation:CGPoint!){
        let xDeslocamento = currentLocation.x - lastPanTouch!.x
        
        lastPanTouch = currentLocation
        /*
        if comeFromLeft{
            if menuView.frame.origin.x + xDeslocamento >= -menuView.frame.width && menuView.frame.origin.x + xDeslocamento <= 0{
                JLSlideNavigationController.myMenuVC!.sideDist.constant += xDeslocamento
                //menuView.frame.origin = CGPoint(x:menuView.frame.origin.x + xDeslocamento ,y:menuView.frame.origin.y)
            }
            
        }
        else{
            if menuView.frame.origin.x + xDeslocamento >= self.view.frame.width - menuView.frame.width  && menuView.frame.origin.x + xDeslocamento <= self.view.frame.width{
                
                JLSlideNavigationController.myMenuVC!.sideDist.constant -= xDeslocamento

                //menuView.frame.origin = CGPoint(x:menuView.frame.origin.x + xDeslocamento ,y: menuView.frame.origin.y)
            }
        }*/
        let view:UIView!
        if let tabVC =  self.tabBarController, let tabView = tabVC.view{
            view = tabView
        }
        else{
            view = self.view
        }
        self.menuStyle == SlideMenuStyle.behindAllViews ? moveTopView(view, ByValue: xDeslocamento) : moveSlideMenuView(menuView, ByValue: xDeslocamento)
        
    }
    
    /**
     Move slide menu view by some value, this method is called when behindTopVC is false and while pan gesture is running
     - parameter menuView: The instance of slide menu view
     - parameter ByValue: The value you want it to move on x axis.
     */
    fileprivate func moveSlideMenuView(_ menuView:UIView!,ByValue xDeslocamento:CGFloat!){
        
        menuView.alpha = 1
        if comeFromLeft{
            if menuView.frame.origin.x + xDeslocamento >= -slideMenuWidth && menuView.frame.origin.x + xDeslocamento <= 0{
                JLSlideNavigationController.myMenuVC!.sideDist.constant += xDeslocamento
            }
            
        }
        else{
            if menuView.frame.origin.x + xDeslocamento >= self.view.frame.width - slideMenuWidth  && menuView.frame.origin.x + xDeslocamento <= self.view.frame.width{
                
                JLSlideNavigationController.myMenuVC!.sideDist.constant -= xDeslocamento
                
            }
        }
    }
    
    /**
     Move current top view by some value, this method is called when behindTopVC is true and while pan gesture is running
     - parameter menuView: The instance of top view
     - parameter ByValue: The value you want it to move on x axis.
     */
    fileprivate func moveTopView(_ topView:UIView!,ByValue xDeslocamento:CGFloat!){
        let currentXPosition = topView.frame.origin.x
        
        //correcting the last pan position because of motion on all self.view, where pan is detected
        lastPanTouch = CGPoint(x: self.lastPanTouch!.x - xDeslocamento,y: self.lastPanTouch!.y)
        
        if comeFromLeft{
            if currentXPosition + xDeslocamento <= slideMenuWidth && currentXPosition + xDeslocamento >= 0{
                
                topView.frame.origin = CGPoint(x: currentXPosition + xDeslocamento, y: topView.frame.origin.y)

            }
            
        }
        else{
            if currentXPosition + xDeslocamento >= -slideMenuWidth  && currentXPosition + xDeslocamento <= 0{
                
                topView.frame.origin = CGPoint(x: currentXPosition + xDeslocamento, y: topView.frame.origin.y)
            }
        }
    }
    
    
    //MARK: Gesture Recognizer delegate methods
    
    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isEqual(JLSlideNavigationController.panGes!){
            let velocity = JLSlideNavigationController.panGes!.velocity(in: self.view)
            if abs(Int32(velocity.x/self.view.frame.width)) > 4{//its on speed of a swipe
                return false
            }
        }
        else if gestureRecognizer.isEqual(JLSlideNavigationController.screenEdgePanGes!){
            let velocity = JLSlideNavigationController.screenEdgePanGes!.velocity(in: self.view)
            if abs(Int32(velocity.x/self.view.frame.width)) > 4{//its on speed of a swipe
                return false
            }
        }
        return true
    }
    
    //MARK: - Slide Menu methods
    
    
    fileprivate func checkIfShouldAddOrUpdateMenu(){
        if let menuVC = JLSlideNavigationController.myMenuVC{//update or remove
            if let myMenuVCID = self.menuVCStoryboardID ,let _ = self.storyboardName {
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
            if let _ = self.menuVCStoryboardID ,let _ = self.storyboardName {
                addSlideMenu()
            }
        }
    }
    
    fileprivate func updateSlideMenu(){
        addGestures()

        JLSlideNavigationController.myMenuVC!.attachedNavController = self
        JLSlideNavigationController.myMenuVC!.removeConstraints()
        slideMenuContainerView()!.translatesAutoresizingMaskIntoConstraints = false
        slideMenuContainerView()!.clipsToBounds = true
        slideMenuContainerView()!.tag = 101
        
        applyShadowEffects()
        
        addConstraintsToMenuView()
        
        self.hideMenu(Animated: false)
        
    }
    
    /**
     This method do what is necessary to add your menu into this NavigationController
     */
    fileprivate func addSlideMenu(){
        
        if let _ = slideMenuContainerView(){
            JLSlideNavigationController.myMenuVC?.view.removeFromSuperview()
        }
        else if let view = self.view.window?.viewWithTag(101){
            view.removeFromSuperview()
        }
        
        addGestures()

        JLSlideNavigationController.myMenuVC = JLSlideNavigationController.loadMenuVC(menuVCStoryboardID!,storyboardName: storyboardName!) as? JLSlideMenuViewController
        
        JLSlideNavigationController.myMenuVC!.attachedNavController = self
        slideMenuContainerView()!.translatesAutoresizingMaskIntoConstraints = false
        slideMenuContainerView()!.clipsToBounds = true
        slideMenuContainerView()!.tag = 101

        self.view.window!.addSubview(slideMenuContainerView()!)
        
        if menuStyle == SlideMenuStyle.behindAllViews{
            slideMenuContainerView()?.layer.zPosition = self.view.layer.zPosition - 1
        }
        else{
            self.view.window!.bringSubview(toFront: slideMenuContainerView()!)
        }
        
        applyShadowEffects()

        
        addConstraintsToMenuView()
        
        self.hideMenu(Animated: false)
        
    }
    
    fileprivate func addConstraintsToMenuView(){
        // Constraints
        JLSlideNavigationController.myMenuVC!.distToTopC = NSLayoutConstraint(item: slideMenuContainerView()!, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view.window!, attribute: NSLayoutAttribute.top, multiplier: 1, constant: distToTop)
        self.view.window!.addConstraint(JLSlideNavigationController.myMenuVC!.distToTopC)
        
        JLSlideNavigationController.myMenuVC!.widthC = NSLayoutConstraint(item: slideMenuContainerView()!, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: slideMenuWidth)
        slideMenuContainerView()!.addConstraint(JLSlideNavigationController.myMenuVC!.widthC)
        
        JLSlideNavigationController.myMenuVC!.distToBottomC = NSLayoutConstraint(item: slideMenuContainerView()!, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.view.window!, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: -distToBottom)
        self.view.window!.addConstraint(JLSlideNavigationController.myMenuVC!.distToBottomC)
        
        if comeFromLeft{
            let constant = menuStyle == SlideMenuStyle.behindAllViews ? 0 : -slideMenuWidth/*-self.view.frame.width*widthAspectRatio*/
            
            JLSlideNavigationController.myMenuVC!.sideDist = NSLayoutConstraint(item:slideMenuContainerView()!, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.view.window!, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: constant)
            self.view.window!.addConstraint(JLSlideNavigationController.myMenuVC!.sideDist)
            
        }
        else{
            let constant = menuStyle == SlideMenuStyle.behindAllViews  ?  0 : -slideMenuWidth
            
            JLSlideNavigationController.myMenuVC!.sideDist = NSLayoutConstraint(item: self.view.window!, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem:slideMenuContainerView(), attribute: NSLayoutAttribute.trailing, multiplier: 1, constant:constant)
            self.view.window!.addConstraint(JLSlideNavigationController.myMenuVC!.sideDist)
        }

    }

    fileprivate func applyShadowEffects(){
        let viewToApply:UIView!

        if menuStyle == SlideMenuStyle.behindAllViews{
            if let tabVC =  self.tabBarController, let tabView = tabVC.view{
                viewToApply = tabView
            }
            else{
                viewToApply = self.view
            }
        }
        else{
            viewToApply = slideMenuContainerView()! // the slide menu
            
        }
        
        if useShadowEffects{
            viewToApply.layer.shadowColor = UIColor.black.cgColor
            viewToApply.layer.shadowOffset = CGSize(width: comeFromLeft ? -4 : 4, height: 10)
            viewToApply.layer.shadowOpacity = 0.4
            viewToApply.layer.shadowRadius = 9
            viewToApply.layer.masksToBounds = false

        }
        else{
            viewToApply.layer.shadowColor = UIColor.clear.cgColor
            viewToApply.layer.shadowOffset = CGSize.zero
            viewToApply.layer.shadowOpacity = 0
            viewToApply.layer.shadowRadius = 0
            viewToApply.layer.masksToBounds = true

        }

    }
    
    
    /**
     This method indicates if the menu VC is presented of not
     */
    open func menuIsPresented()->Bool{
        if menuStyle == SlideMenuStyle.behindAllViews{
            if let tabVC =  self.tabBarController, let tabView = tabVC.view{
                return tabView.frame.origin.x == slideMenuWidth || tabView.frame.origin.x == -slideMenuWidth
            }
            else{
                return self.view.frame.origin.x == slideMenuWidth || self.view.frame.origin.x == -slideMenuWidth
            }

        }
        else{
            if let mennuView = slideMenuContainerView() {
                return mennuView.frame.origin.x == 0 || (mennuView.frame.origin.x == self.view.frame.width - mennuView.frame.width)
            }
        }
        
        
        return false
    }
    
    /**
     Call this method for present the menu VC
     - parameter animated: true if you want animated and false if not
     */
    open func showMenu(Animated animated:Bool){
        
        if let menuView = slideMenuContainerView(), JLSlideNavigationController.myMenuVC!.enabled{
            
            JLSlideNavigationController.panGes?.isEnabled = true
            JLSlideNavigationController.screenEdgePanGes?.isEnabled = false

            
            if let vc = JLSlideNavigationController.myMenuVC!.attachedNavController.topViewController{
                vc.view.isUserInteractionEnabled = false
            }
            
            
            if animated{
                
                DispatchQueue.main.async(execute: { () -> Void in
                    if self.menuStyle == SlideMenuStyle.behindAllViews{
                    
                        menuView.isUserInteractionEnabled = true
                        UIView.animateKeyframes(withDuration: 0.1, delay: 0, options: UIViewKeyframeAnimationOptions(), animations: {
                            
                            let changeXTo = self.comeFromLeft ? self.slideMenuWidth : -self.slideMenuWidth
                            
                            if let tabVC =  self.tabBarController, let tabView = tabVC.view{
                                tabView.frame.origin = CGPoint(x: changeXTo, y: self.view.frame.origin.y)
                            }
                            else{
                                self.view.frame.origin = CGPoint(x: changeXTo, y: self.view.frame.origin.y)
                            }
                            
                            }, completion: { (finished) in
                                
                        })
                    }
                    else{
                        menuView.alpha = 1
                        JLSlideNavigationController.myMenuVC!.sideDist.constant = 0
                        UIView.animate(withDuration: 0.1, animations: {
                            self.view.window?.layoutIfNeeded()
                        })
                    }
                })
                
            }
            else{
                
                if self.menuStyle == SlideMenuStyle.behindAllViews{
                    let changeXTo = self.comeFromLeft ? self.slideMenuWidth : -self.slideMenuWidth
                    menuView.isUserInteractionEnabled = true
                    if let tabVC =  self.tabBarController, let tabView = tabVC.view{
                        tabView.frame.origin = CGPoint(x: changeXTo, y: self.view.frame.origin.y)
                    }
                    else{
                        self.view.frame.origin = CGPoint(x: changeXTo, y: self.view.frame.origin.y)
                    }
                }
                else{
                    menuView.alpha = 1
                    JLSlideNavigationController.myMenuVC!.sideDist.constant = 0
                    self.view.window?.layoutIfNeeded()
                }

            }

        }
        
    }
    
    /**
     Call this method to hide the menu VC
     - parameter animated: true if you want animated and false if not
     */
    open func hideMenu(Animated animated:Bool){
        if let menuView = slideMenuContainerView(), JLSlideNavigationController.myMenuVC!.enabled{
            
            JLSlideNavigationController.panGes?.isEnabled = false
            JLSlideNavigationController.screenEdgePanGes?.isEnabled = true

            
            if let vc = JLSlideNavigationController.myMenuVC!.attachedNavController.topViewController{
                vc.view.isUserInteractionEnabled = true
            }
            
            if animated{
                DispatchQueue.main.async(execute: { () -> Void in
                    if self.menuStyle == SlideMenuStyle.behindAllViews{
                        menuView.isUserInteractionEnabled = false
                        UIView.animateKeyframes(withDuration: 0.1, delay: 0, options: UIViewKeyframeAnimationOptions(), animations: {
                            if let tabVC =  self.tabBarController, let tabView = tabVC.view{
                                tabView.frame.origin = CGPoint(x: 0, y: self.view.frame.origin.y)
                            }
                            else{
                                self.view.frame.origin = CGPoint(x: 0, y: self.view.frame.origin.y)
                            }
                            }, completion: { (finished) in
                                
                        })
                    }
                    else{
                        JLSlideNavigationController.myMenuVC!.sideDist.constant = -menuView.frame.width
                        UIView.animate(withDuration: 0.1, animations: {
                            self.view.window?.layoutIfNeeded()
                            }, completion: { (finished) in
                                if finished && !self.menuIsPresented(){
                                    menuView.alpha = 0
                                }
                        })
                    }
                    
                })
                
            }
            else{
                if self.menuStyle == SlideMenuStyle.behindAllViews{
                    menuView.isUserInteractionEnabled = false
                    if let tabVC =  self.tabBarController, let tabView = tabVC.view{
                        tabView.frame.origin = CGPoint(x: 0, y: self.view.frame.origin.y)
                    }
                    else{
                        self.view.frame.origin = CGPoint(x: 0, y: self.view.frame.origin.y)
                    }
                }
                else{
                    JLSlideNavigationController.myMenuVC!.sideDist.constant = -menuView.frame.width
                    self.view.window?.layoutIfNeeded()
                    menuView.alpha = 0
                }
            }

        }
    }
}
