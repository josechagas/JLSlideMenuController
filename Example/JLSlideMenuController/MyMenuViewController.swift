//
//  MyMenuViewController.swift
//  JLSlideMenuController
//
//  Created by José Lucas Souza das Chagas on 21/03/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import JLSlideMenuController
class MyMenuViewController: JLSlideMenuViewController,UITableViewDelegate,UITableViewDataSource {

    
    
    @IBOutlet weak var optionsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - TableView methods
    
    func configTableView(){
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        optionsTableView.rowHeight = UITableViewAutomaticDimension
        optionsTableView.estimatedRowHeight = 50
        
    }
    
    //MARK: Data Source methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        
        
        cell?.textLabel?.text = "Button \(indexPath.row)"
        
        
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    //MARK: Delegate methods
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 0{
            self.showController("SecondVC", storyboardName: "Main", animated: true)

        }
        else if indexPath.row == 1{
            //self.showController("ThirdVC", storyboardName: "Main", animated: true)
            self.presentControllerModally("ThirdVC", storyboardName: "Main", animated: true)
        }
        else if indexPath.row == 2{
            self.showController("FourthVC", storyboardName: "Main", animated: true)
        }
    }
    

}
