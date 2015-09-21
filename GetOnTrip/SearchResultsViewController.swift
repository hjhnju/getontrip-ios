//
//  SearchBaseViewController.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/8/5.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit



class SearchResultsViewController: UITableViewController, UISearchResultsUpdating {
    
    // MARK: Properties
    
    var resultData = [[Dictionary<String, AnyObject>]]()
    
    var sectionTitle = [String]()
    
    var titleMap = ["sight":"景点", "city":"城市", "topic":"话题", "theme":"主题"]
    
    var sectionTypes = ["sight", "city", "topic", "theme"]
    
    var scrollLock:Bool = false
    
    var filterString: String? {
        didSet {
            if let query = filterString {
                if query.isEmpty {
                    return
                }
                self.resultData.removeAll(keepCapacity: true)
                self.sectionTitle.removeAll(keepCapacity: true)
                HttpRequest.ajax(AppIni.BaseUri, path: "/api/search", post: ["query":query], handler: {(respData: AnyObject) -> Void in
                    
                    for section in self.sectionTypes {
                        
                        let secRows = respData[section] // as! NSDictionary
                        if secRows!!.count > 0 {
                            var rows = [Dictionary<String, AnyObject>]()
                            for row in secRows as! NSArray {
                                rows.append(row as! Dictionary)
                            }
                            self.resultData.append(rows)
                            let title = self.titleMap[section] ?? section
                            self.sectionTitle.append(title)
                        }
                    }
                    
                    self.tableView.reloadData()
                })
                
            }
        }
    }
    
    //MARK: View Life Circle
    
    override func viewDidLoad() {
        tableView.tableFooterView = UIView(frame:CGRectZero)
        tableView.separatorColor  = UIColor.grayColor()
        tableView.rowHeight = 60
        tableView.backgroundView = UIImageView(image: UIImage(named: "search-bg0")!)
    }
    
    // MARK: UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return resultData.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.clearColor()
        let frame = CGRectMake(0, view.frame.size.height-1, view.frame.width, 0.5)
        let line  = UIView(frame: frame)
        line.backgroundColor = UIColor.grayColor()
        view.addSubview(line)
        
        let headerView = view as! UITableViewHeaderFooterView
        headerView.textLabel!.textColor = UIColor.lightGrayColor()
        headerView.textLabel!.font = UIFont(name: "Helvetica Neue", size: 11)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultData[section].count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoardIdentifier.SearchResultsCell, forIndexPath: indexPath) as! SearchResultsCell

        cell.resultImageUrl = resultData[indexPath.section][indexPath.row]["image"]?.stringValue
        cell.resultTitle = resultData[indexPath.section][indexPath.row]["name"]?.stringValue
        cell.resultDesc  = resultData[indexPath.section][indexPath.row]["desc"]?.stringValue
        cell.resultType  = self.sectionTypes[indexPath.section]
        cell.resultId  = Int(resultData[indexPath.section][indexPath.row]["id"] as! String)!
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let searchResultsCell = cell as! SearchResultsCell
        //Apperance of cell
        searchResultsCell.separatorInset = UIEdgeInsetsZero
        searchResultsCell.preservesSuperviewLayoutMargins = false
        searchResultsCell.layoutMargins = UIEdgeInsetsZero
        searchResultsCell.backgroundColor = UIColor.clearColor()
        
        searchResultsCell.resultTitleLabel.textColor = UIColor.whiteColor()
        searchResultsCell.resultDescLabel.textColor = UIColor.lightGrayColor()
    }
    
    // MARK: UISearchResultsUpdating
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        // updateSearchResultsForSearchController(_:) is called when the controller is being dismissed to allow those who are using the controller they are search as the results controller a chance to reset their state. No need to update anything if we're being dismissed.
        if !searchController.active {
            return
        }
        
        filterString = searchController.searchBar.text
    }
}
