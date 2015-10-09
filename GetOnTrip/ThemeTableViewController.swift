//
//  ThemeTableViewController.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/8/31.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit
import MJRefresh

class ThemeTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var themes = [Theme]()
    
    var lastRequest: ThemeRequest?

    var isLoadingMore = false
    
    // MARK: View Life Circle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = SceneColor.gray
        tableView.rowHeight = 409
        tableView.separatorColor = UIColor.clearColor()
        
        //下拉刷新
        let headerView = MJRefreshNormalHeader(refreshingBlock: refresh)
        headerView.stateLabel.font                = UIFont(name: SceneFont.heiti, size: 12)
        headerView.lastUpdatedTimeLabel.font      = UIFont(name: SceneFont.heiti, size: 11)
        headerView.stateLabel.textColor           = SceneColor.lightGray
        headerView.lastUpdatedTimeLabel.textColor = SceneColor.lightGray
        headerView.activityIndicatorViewStyle     = UIActivityIndicatorViewStyle.White
        
        self.tableView.header = headerView
        
        //上拉刷新
        let footerView = MJRefreshAutoNormalFooter(refreshingBlock: loadMore)
        footerView.automaticallyRefresh                = true
        footerView.appearencePercentTriggerAutoRefresh = -3
        footerView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        footerView.stateLabel.font            = UIFont(name: SceneFont.heiti, size: 12)
        footerView.stateLabel.textColor       = SceneColor.lightGray
        
        self.tableView.footer = footerView
        
        refresh()
    }
    
    func refresh() {
        
        if self.lastRequest == nil {
            self.lastRequest = ThemeRequest()
        }
        lastRequest?.fetchFirstPageModels {
            (themes:[Theme]) -> Void in
            if themes.count > 0 {
                self.themes = themes
                self.tableView.reloadData()
            }
            self.tableView.header.endRefreshing()
            self.tableView.footer.resetNoMoreData()
        }
    }
    
    func loadMore(){
        if self.isLoadingMore {
            return
        }
        self.isLoadingMore = true
        //请求下一页
        self.lastRequest?.fetchNextPageModels { (themes:[Theme]) -> Void in
            if themes.count > 0 {
                self.themes = self.themes + themes
                self.tableView.reloadData()
                self.tableView.footer.endRefreshing()
            } else {
                self.tableView.footer.noticeNoMoreData()
            }
            self.isLoadingMore = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return themes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoardIdentifier.ThemeTabelViewCellID, forIndexPath: indexPath) as! ThemeTableViewCell

        cell.updateCell(themes[indexPath.row])

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.tableView!.deselectRowAtIndexPath(indexPath, animated: true)
        
        let theme = themes[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoardIdentifier.ThemeTabelViewCellID, forIndexPath: indexPath) as! ThemeTableViewCell
        theme.image = cell.themeImageView.image
        
        performSegueWithIdentifier(StoryBoardIdentifier.ShowThemeSegue, sender: theme)
    }
    
    
    // MARK: Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var destination = segue.destinationViewController as? UIViewController
        if let navCon = destination as? UINavigationController {
            destination = navCon.visibleViewController
        }
        if let identifier = segue.identifier {
            switch identifier{
            case StoryBoardIdentifier.ShowThemeSegue:
                if let targetVC = destination as? ThemeDetailViewController {
                    targetVC.theme = sender as? Theme
                }
            default:break
            }
        }
    }
    
    
}
