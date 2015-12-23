//
//  MyCommentViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/12/23.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class MyCommentViewController: MenuViewController, UITableViewDataSource, UITableViewDelegate {

    lazy var tableView = UITableView()
    
    var dataSource: AnyObject? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        initTableView()
    }
    
    private func initView() {
        navBar.titleLabel.text = "我的评论"
        view.backgroundColor = .whiteColor()
        
    }
    
    private func initTableView() {
        view.addSubview(tableView)
        tableView.delegate   = self
        tableView.dataSource = self
    }
    
    // MARK: - tableview delegate and datasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
//        cell.data = dataSource[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
}
