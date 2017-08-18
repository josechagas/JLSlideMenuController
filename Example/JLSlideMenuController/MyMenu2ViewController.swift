//
//  MyMenu2ViewController.swift
//  JLSlideMenuController
//
//  Created by José Lucas Souza das Chagas on 02/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import JLSlideMenuController

class MyMenu2ViewController: JLSlideMenuViewController,UITableViewDelegate,UITableViewDataSource {

    
    
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        cell?.textLabel?.text = "Button \(indexPath.row)"
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    //MARK: Delegate methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0{
            self.showController("FifthVC", storyboardName: "Main", animated: true)
            
        }
        else if indexPath.row == 1{
            self.presentControllerModally("ThirdVC", storyboardName: "Main", animated: true)
        }
        else if indexPath.row == 2{
            self.showController("FourthVC", storyboardName: "Main", animated: true)
        }
    }
}
