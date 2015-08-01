//
//  MenuTableViewController.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/7/31.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
    
    //MASK: Properties
    
    var menuData:[Int: Dictionary<String, String>] = [
        0: ["text":"切换城市", "icon":"locating"],
        1: ["text":"首页", "icon":"locating"],
        2: ["text":"我的收藏", "icon":"myfav", "segue":StoryBoardIdentifier.ShowFavSegue],
        3: ["text":"消息",  "icon":"locating"],
        4: ["text":"设置",  "icon":"locating"],
        5: ["text":"反馈",  "icon":"locating"],
    ]
    
    //MASK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        //移除底部空Cell
        tableView.tableFooterView = UIView(frame:CGRectZero)
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorColor  = UIColor.whiteColor().colorWithAlphaComponent(0.5)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MASK: Delegate
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //设置下划线无缩进
        cell.separatorInset = UIEdgeInsetsZero
        //设置下划线无边界
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsetsZero
        //无底色
        cell.backgroundColor = UIColor.clearColor()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.tableView!.deselectRowAtIndexPath(indexPath, animated: true)
        
        if let slideCon = self.parentViewController?.parentViewController as? SlideMenuViewController {
            slideCon.dismissMenu()
            if let segue = menuData[indexPath.row]!["segue"] {
                slideCon.masterViewController.performSegueWithIdentifier(segue, sender: nil)
            }
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Tells the data source to return the number of rows in a given section of a table view. (required)
        return menuData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoardIdentifier.MenuCellId, forIndexPath: indexPath) as! UITableViewCell
        
        var text = menuData[indexPath.row]!["text"]!
        var image = UIImage(named: menuData[indexPath.row]!["icon"]!)

        cell.textLabel?.text = text
        cell.imageView?.image = image
        return cell
    }

}
