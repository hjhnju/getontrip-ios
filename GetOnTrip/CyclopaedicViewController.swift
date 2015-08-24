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
    
    // 网络请求，加载数据
    var lastSuccessRequest: CyclopaedicRequest?
    
    var sightId: Int?
    
    var nearCyclopaedic = [Cyclopaedic]()
    
    var cellIdentifier: String?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        view.backgroundColor = UIColor(patternImage: UIImage(named: "cyclopaedicBottom")!)
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
        
        cellIdentifier = cellIdentifier == nil ? "CyclopaedicRightCell" : "CyclopaedicLeftCell"

        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier!, forIndexPath: indexPath) as! CyclopaedicCell
        cell.cyclopaedicModel = nearCyclopaedic[indexPath.row]
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        print("选中了\n")

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
                print("==========\(handler)============")
                self.tableView.reloadData()
            }
        }
        
    }
    
}
