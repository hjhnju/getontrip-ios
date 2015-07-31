//
//  MenuTableViewController.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/7/31.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
    
    //MASK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        //移除底部空Cell
        tableView.tableFooterView = UIView(frame:CGRectZero)
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorColor  = UIColor.whiteColor()
        tableView.sectionHeaderHeight = 0.0
        tableView.sectionFooterHeight = 0.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //设置下划线补全
        cell.separatorInset = UIEdgeInsetsZero
        //设置下划线无边界
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsetsZero
    }

}
