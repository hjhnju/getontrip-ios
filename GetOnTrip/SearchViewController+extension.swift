//
//  SearchViewController+extension.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/12/8.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import CoreLocation

extension SearchViewController {
    
    // MARK: - tableview 数据源及代理方法
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return hotwordData.count == 0 ? 1 : 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? recordData.count : 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(SearchViewContant.recordCellId, forIndexPath: indexPath) as! SearchRecordTableViewCell
            cell.superController = self
            cell.textLabel?.text = recordData[indexPath.row]
            cell.deleteButton.tag = indexPath.row
            cell.baseLine.hidden = indexPath.row == recordData.count - 1 ? true : false
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(SearchViewContant.hotwordCellId, forIndexPath: indexPath) as! SearchHotwordTableViewCell
            cell.superController = self
            cell.dataSource = hotwordData
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return getSearchHeaderView(section)
    }
    
    func getSearchHeaderView(section: Int) -> SearchHeaderView {
        let headerView = recordTableView.dequeueReusableHeaderFooterViewWithIdentifier("SearchHeaderView") as! SearchHeaderView
        headerView.baseLine.hidden = false
        headerView.backgroundView?.alpha = 0
        if section == 0 {
            headerView.recordDelButton.addTarget(self, action: "deleteButtonAction", forControlEvents: .TouchUpInside)
            headerView.recordLabel.text = "搜索历史"
            headerView.recordDelButton.setTitle("清除历史", forState: .Normal)
            headerView.recordDelButton.hidden = false
        } else {
            headerView.recordLabel.text = "热门搜索"
            headerView.recordDelButton.hidden = true
        }
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.section == 0 ? 47 : 300
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // TODO: 晓羽说让用户等一下看下效果
        NSThread.sleepForTimeInterval(0.2)
        view.endEditing(true)
        if indexPath.section != 1 {
            tableView.hidden = true
        }
        
        searchBar.textFile.text = recordData[indexPath.row]
        textfileValueChangedAction(searchBar.textFile)
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    // MARK: - 删除历史记录方法
    func deleteButtonAction() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey("recordData")
        recordData.removeAll()
        recordTableView.reloadData()
    }
    
    func showSearchResultController(vc: UIViewController) {
        //采用push可手势返回
//        parentViewController?.presentingViewController?.navigationController?.pushViewController(vc, animated: true)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /**
     设置无搜索结果
     - parameter isNoResult:
     */
    func showNoResult(show: Bool = true) {
        noSearchResultLabel.hidden = !show
    }
    
    /**
     保存搜索历史纪录
     - parameter filterString: query
     */
    func saveRecord(filterString: String) {
        if filterString == "" {
            return
        }
        
        if let index = recordData.indexOf(filterString) {
            recordData.removeAtIndex(index)
        }
        
        recordData.insert(filterString, atIndex: 0)
        if recordData.count > SearchViewContant.recordLimit {
            recordData.removeLast()
        }
    }
    
    /// 切换当前城市
    func switchCurrentCity(btn: UIButton) {
        
        if currentCityId == "" {
            /// 开始获取定位权限
        }
        
        if currentCityId == "0" {
            ProgressHUD.showSuccessHUD(view, text: "正在定位中")
            return
        }
        
        if currentCityId == "-2" {
            ProgressHUD.showSuccessHUD(view, text: "当前城市未开通")
        }
        
        if currentCityId != "-1" {
            let vcity = CityViewController()
            vcity.cityDataSource = City(id: currentCityId)
            searchResultViewController.showSearchResultController(vcity)
            return
        }
    }
    


}