//
//  CyclopaedicViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/8/18.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit
import Foundation

class CyclopaedicViewController: UITableViewController {
    
    /// 网络请求，加载数据
    var lastSuccessRequest: CyclopaedicRequest?
    
    var sightId: Int?
    
    var nearCyclopaedic = [Cyclopaedic]()
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.backgroundColor = UIColor.clearColor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        refresh()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearCyclopaedic.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CyclopaedicLeftCell", forIndexPath: indexPath) as! CyclopaedicCell
        
        if indexPath.row == 0 {
            cell.removeFromSuperview()
            cell = tableView.dequeueReusableCellWithIdentifier("CyclopaedicRightCell") as! CyclopaedicCell
        }
        cell.cyclopaedicModel = nearCyclopaedic[indexPath.row]
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let cycloVC = CyclopaedicDetailController()
        cycloVC.requestURL = nearCyclopaedic[indexPath.row].url
        navigationController?.pushViewController(cycloVC, animated: true)
    }
    
    private func refresh() {
        NSLog("notice:refreshing nearby data.")
        
        //获取数据更新tableview
        if lastSuccessRequest == nil {
            lastSuccessRequest = CyclopaedicRequest(sightId: sightId!)
        }
        
        lastSuccessRequest?.fetchCyclopaedicPageModels { (handler: [Cyclopaedic]) -> Void in
            if handler.count > 0 {
                self.nearCyclopaedic = handler
                self.tableView.reloadData()
            }
        }
        
    }
    
}
