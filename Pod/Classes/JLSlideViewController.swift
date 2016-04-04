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
    /**
     The instace of your menu View Controller associated to this View Controller
     */
    private(set) public var myMenuVC:UIViewController!
    private var comeFromLeft:Bool = true
    
    
    //constraints
    private var sideDist:NSLayoutConstraint!
    private var distToTopC:NSLayoutConstraint!
    private var witdhRatio:NSLayoutConstraint!
    //
    
    private var moveNavigationBar:Bool = false
    
    private var moveTabBar:Bool = false
    
    /**
     Incicates that the pan gesture that were started enabled or not
     */
    private var panEnabled:Bool = false
    private var lastPanTouch:CGPoint?
    override public func viewDidLoad() {
        super.viewDidLoad()
        addPanGesture()
        // Do any additional setup after loading the view.
    }
    public override func viewWillAppear(animated: Bool) {
        checkIfShouldMoveBars(distToTopC.constant, height: menuContainerView.frame.height)
        hideMenu(false)

        super.viewWillAppear(animated)
      
    }
    
    public override func viewDidAppear(animated: Bool) {
        updateConstraints()
        super.viewDidAppear(animated)
    }
    
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    class func loadMenuVC(identifier:String,storyboardName:String)->UIViewController{
        
        let storyboard = UIStoryboard(name: storyboardName, bundle: NSBundle.mainBundle())
        
        //print("\n\n\n AlERT Could NOT LOAD THE VIEW CONTROLLER WITH ID \(identifier) FROM STORYBOARD WITH NAME \(storyboardName). \n\n\n ")
        
        
        return storyboard.instantiateViewControllerWithIdentifier(identifier)
    }
    
    private func addPanGesture(){
        let panGes = UIPanGestureRecognizer(target: self, action: "panAction:")
        
        self.view.addGestureRecognizer(panGes)
    }
    
    
    public func panAction(panGes:UIPanGestureRecognizer){
        let currenLocation = panGes.locationInView(self.view)
        if panGes.state == UIGestureRecognizerState.Began{

            panEnabled = false
            let kFrame = CGRect(x: 0, y: menuContainerView.frame.origin.y, width: menuContainerView.frame.width, height: menuContainerView.frame.height)
            if kFrame.contains(currenLocation){
                panEnabled = true
                lastPanTouch = currenLocation
            }
        }
        else if panGes.state == UIGestureRecognizerState.Ended{//at the end of pan gesture check if the menu is near to show or hide completelly and then finishes the movement
            let menuFrame = menuContainerView.frame
            if menuFrame.origin.x < -menuFrame.size.width/2{
                self.hideMenu(true)
            }
            else if menuFrame.origin.x >= -menuFrame.size.width/2{
                self.showMenu(true)

            }
        }
        if panEnabled{//if the pan started at a right point continue
            menuContainerView.alpha = 1
            let xDeslocamento = currenLocation.x - lastPanTouch!.x
            
            lastPanTouch = currenLocation
            
            if self.sideDist.constant + xDeslocamento >= -self.menuContainerView.frame.width && self.sideDist.constant + xDeslocamento <= 0{
                
                self.sideDist.constant += xDeslocamento
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    UIView.animateWithDuration(0.1, animations: { () -> Void in
                        self.moveBarsBy(xDeslocamento, incrementTabXValue: xDeslocamento)
                        self.view.layoutIfNeeded()
                    })
                })
                
                
            }

        }
        
    }
    
    //MARK: - Slide Menu methods
    
    /**
     This method do what is necessary to add your menu into this ViewController
     - parameter menuVCStoryboardID: The Id of your menu View Controller.
     
     - parameter storyboardName: the name of the storyboard where your menu View Controller is.
     
     - parameter distToTop: the value of the constraint that indicates the distance between your menu top and this VC top.
     
     - parameter width: the value of the constraint that determine your menu Width.
     
     - parameter height: the value of the constraint that determine your menu Height.
     
     - parameter comeFromLeft: the bolean value that indicates if your menu will come from left or from right of the window.
     

     */
    public func addSlideMenu(menuVCStoryboardID:String,storyboardName:String,distToTop:CGFloat,widthAspectRatio:CGFloat,distToBottom:CGFloat,comeFromLeft:Bool){
        
        self.comeFromLeft = comeFromLeft
        
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
        
        //let widthC = NSLayoutConstraint(item: menuContainerView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant:width)
        
        witdhRatio = NSLayoutConstraint(item: menuContainerView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Width, multiplier: widthAspectRatio, constant: 0)
        self.view.addConstraint(witdhRatio)
        
        //let heightC = NSLayoutConstraint(item: menuContainerView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant:height)
        //menuContainerView.addConstraint(heightC)
        
        let distToBottomC = NSLayoutConstraint(item: menuContainerView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -distToBottom)
        self.view.addConstraint(distToBottomC)
        
        if comeFromLeft{
            sideDist = NSLayoutConstraint(item:menuContainerView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant:-self.view.frame.width*widthAspectRatio)
            self.view.addConstraint(sideDist)
            
        }
        else{
            sideDist = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem:menuContainerView, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant:-/*width*/self.view.frame.width*widthAspectRatio)
            self.view.addConstraint(sideDist)
            
        }
        
        //
        self.hideMenu(false)

    }
    
    private func updateConstraints(){
        
        sideDist.constant = -self.view.frame.width*witdhRatio.multiplier//self.view.frame.width
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
            moveNavigationBar = distToTop == 0 ? true : false

        }
        
        if let tabBarController = self.tabBarController{
            moveTabBar = tabBarController.tabBar.frame.origin.y + tabBarController.tabBar.frame.height < distToTop + height ? true : false
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

            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                UIView.animateWithDuration(0.4, delay: 0.2, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                    
                    self.moveBarsTo(self.menuContainerView.frame.width,newTabXValue: self.menuContainerView.frame.width)
                    self.view.layoutIfNeeded()

                    }, completion: nil)

            })
            
        }
        else{
            sideDist.constant = 0
            self.moveBarsTo(menuContainerView.frame.width,newTabXValue: menuContainerView.frame.width)
            self.view.layoutIfNeeded()

        }
    }
    
    /**
     Call this method to hide the menu VC
     - parameter animated: true if you want animated and false if not
     */
    public func hideMenu(animated:Bool){
        if animated{
            sideDist.constant = -menuContainerView.frame.width
            
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                UIView.animateWithDuration(0.4, delay: 0.2, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                    
                    self.moveBarsTo(0,newTabXValue: 0)
                    self.view.layoutIfNeeded()
                    
                    }){ (finished) -> Void in
                        self.menuContainerView.alpha = 0
                }

                
            })
            
        }
        else{
            sideDist.constant = -menuContainerView.frame.width
            self.moveBarsTo(0,newTabXValue: 0)
            self.view.layoutIfNeeded()
            menuContainerView.alpha = 0
        }
    }
    
    /**
     Move the bars by some value to x axis
     */
    private func moveBarsBy(incrementNavXValue:CGFloat,incrementTabXValue:CGFloat){
        
        if moveNavigationBar{
            if let navC = self.navigationController{
                let newNavXValue:CGFloat = self.navigationController!.navigationBar.frame.origin.x + incrementNavXValue

                navC.navigationBar.frame.origin = CGPoint(x: newNavXValue,y: self.navigationController!.navigationBar.frame.origin.y)
            }
            else{
                print("navigation controller nil no metodo moveBars")
            }
        }
        
        if moveTabBar{
            if let tabC = self.tabBarController{
                let newTabXValue:CGFloat = self.tabBarController!.tabBar.frame.origin.x + incrementTabXValue

                tabC.tabBar.frame.origin = CGPoint(x: newTabXValue,y: self.tabBarController!.tabBar.frame.origin.y)
            }
            else{
                print("tabBar controller nil no metodo moveBars")

            }
        }
    }
    
    /**
     Move the bars to the x position choosed
     */
    private func moveBarsTo(newNavXValue:CGFloat,newTabXValue:CGFloat){
        
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
