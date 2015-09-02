//
//  MenuTableViewController.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/7/31.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
    
    // MARK: - Properties
    var menuData:[Int: Dictionary<String, String>] = [
        0: ["text":"切换城市", "icon":"menu-locate"],
        1: ["text":"我的收藏", "icon":"menu-favorite", "segue":StoryBoardIdentifier.ShowFavSegue],
        2: ["text":"消息",  "icon":"menu-msg"],
        3: ["text":"设置",  "icon":"menu-setting"],
        4: ["text":"反馈",  "icon":"menu-feedback"],
    ]
    
    lazy var baseline: UIView! = {
        var baselineView = UIView()
        baselineView.backgroundColor = UIColor(white: 0xFFFFFF, alpha: 0.3)
        return baselineView
    }()
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //移除底部空Cell
        tableView.tableFooterView = UIView(frame:CGRectZero)
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorColor  = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.addSubview(baseline)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - tableView Delegate
    var cellx: CGFloat = 0
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //设置下划线无缩进
        cell.separatorInset = UIEdgeInsetsZero
        //设置下划线无边界
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsetsZero
        //无底色
        cell.backgroundColor = UIColor.clearColor()
        
        cellx += 300
        cell.transform = CGAffineTransformMakeTranslation(cellx, 0)
        UIView.animateWithDuration(0.8, delay: 0.0, usingSpringWithDamping: 3, initialSpringVelocity: 3, options: UIViewAnimationOptions.AllowAnimatedContent, animations: { () -> Void in
            cell.transform = CGAffineTransformIdentity
        }, completion: nil)
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.tableView!.deselectRowAtIndexPath(indexPath, animated: true)
        
        if let slideCon = self.parentViewController?.parentViewController as? SlideMenuViewController {
            slideCon.dismissMenu()
            if let segue = menuData[indexPath.row]!["segue"] {
                slideCon.masterViewController.performSegueWithIdentifier(segue, sender: nil)
                
            }
            
            var vc = UIViewController()
            vc.view.backgroundColor = UIColor.orangeColor()
            slideCon.masterViewController.view.addSubview(vc.view)
            slideCon.masterViewController.addChildViewController(vc)
            slideCon.masterViewController.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - tableView  dataSource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return menuData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoardIdentifier.MenuCellID, forIndexPath: indexPath) as! MenuTableViewCell
        
        // 添加tableview顶上的线
        if indexPath.row == 0 {
            cell.addSubview(baseline)
            baseline.frame = CGRectMake(0, 0, tableView.bounds.width, 0.5)
        }
        
        var text = menuData[indexPath.row]!["text"]!
        cell.titleLabel.text = text
        
        return cell
    }
}

// MARK: -  MenuTableViewCell
class MenuTableViewCell: UITableViewCell {
    
    // 设置文字
    @IBOutlet weak var titleLabel: UILabel!
    
    // 设置底线
    lazy var baseline: UIView! = {
        var baselineView = UIView()
        baselineView.backgroundColor = UIColor(white: 0xFFFFFF, alpha: 0.3)
        return baselineView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var x: CGFloat = 0
        var h: CGFloat = 0.5
        var y: CGFloat = self.bounds.height - h
        var w: CGFloat = self.bounds.width
        baseline.frame = CGRectMake(x, y, w, h)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addSubview(baseline)
    }
}
