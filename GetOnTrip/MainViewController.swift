//
//  MainViewController.swift
//  GetOnTrip
//
//  Created by guojinli on 15/7/27.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    // MARK: - Define variable
    var currentBar:String = ""
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBOutlet var containerView: UIView!
    @IBAction func nearClickEvent(sender: UIBarButtonItem) {
        changeContent("NearID")
    }
    @IBAction func findClickEvent(sender: UIBarButtonItem) {
        changeContent("FindID")
    }
    @IBAction func subjectClickEvent(sender: UIBarButtonItem) {
        changeContent("SubjectID")
    }
    
    // MARK: Custom funcitons
    
    func changeContent(storyboardID: String){
        if self.currentBar != storyboardID{
            let count = containerView.subviews.count
            //清空所有的视图
            for i in 0...count{
                containerView.subviews.map{ $0.removeFromSuperview()}
            }
            //获取需要嵌入的视图
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            var storyboardController = UIViewController()
            switch storyboardID{
            case "FindID":
                storyboardController = storyboard.instantiateViewControllerWithIdentifier(storyboardID) as! FindTableViewController
            case "NearID":
                storyboardController = storyboard.instantiateViewControllerWithIdentifier(storyboardID) as! NearbyTableViewController
            case "SubjectID":
                storyboardController = storyboard.instantiateViewControllerWithIdentifier(storyboardID) as! SubjectTableViewController
            default:
                storyboardController = storyboard.instantiateViewControllerWithIdentifier(storyboardID) as! NearbyTableViewController
            }
            self.addChildViewController(storyboardController)
            containerView.addSubview(storyboardController.view)
            self.currentBar = storyboardID
        }
    }
}
