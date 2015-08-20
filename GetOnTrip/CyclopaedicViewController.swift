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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor(patternImage: UIImage(named: "cyclopaedicBottom")!)
        
        refresh()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearCyclopaedic.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("CyclopaedicRightCell", forIndexPath: indexPath) as! CyclopaedicCell
        cell.cyclopaedicModel = nearCyclopaedic[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    private func refresh() {
        NSLog("notice:refreshing nearby data.")
        
        //获取数据更新tableview
        if lastSuccessRequest == nil {
            lastSuccessRequest = CyclopaedicRequest(sightId: sightId!)
        }
        
        lastSuccessRequest?.fetchCyclopaedicPageModels { (handler: [Cyclopaedic]) -> Void in
        print("=====\(handler)======")
            if handler.count > 0 {
                self.nearCyclopaedic = handler
                
                self.tableView.reloadData()
                print("\n\n")
                print(self.nearCyclopaedic)
                print("\n\n")
            }
            
            
            
        }
        
    }
    
}
