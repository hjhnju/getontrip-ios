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
            if indexPath.row == recordData.count - 1 {
                cell.baseLine.hidden = true
            } else {
                cell.baseLine.hidden = false
            }
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
        let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier("SearchHeaderView") as! SearchHeaderView
        if section == 0 {
            headerView.backgroundView = UIImageView(image: UIImage(named: "search_group_history"))
            headerView.backgroundView?.alpha = 1
            headerView.recordDelButton.addTarget(self, action: "deleteButtonAction", forControlEvents: .TouchUpInside)
            headerView.recordLabel.text = "搜索历史"
            headerView.recordDelButton.hidden = false
        } else {
            headerView.backgroundView?.alpha = 0.0
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
            searchBar.text = recordData[indexPath.row]
            searchBar(searchBar, textDidChange: searchBar.text!)
            tableView.hidden = true
        }
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
        parentViewController?.presentingViewController?.navigationController?.pushViewController(vc, animated: true)
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
    
    // MARK: - 地理定位代理方法
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        /// 只定位一次
        locationManager.stopUpdatingLocation()
        if currentCityId == "" {
            currentCityId = "-1"
        }
        
        // 获取位置信息
        let coordinate = locations.first?.coordinate
        // 反地理编码
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate!.latitude, longitude: coordinate!.longitude)
        
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) -> Void in
            if let locality = placemarks?.first?.locality {
                struct Static {
                    static var onceToken: dispatch_once_t = 0
                }
                dispatch_once(&Static.onceToken, {
                    LocateToCity.locate(locality, handler: { (result, status) -> Void in
                        if status == RetCode.SUCCESS {
                            currentCityId = result as? String ?? "0"
                            if result != nil {
                                let vcity = CityViewController()
                                vcity.cityDataSource = City(id: currentCityId)
                                self?.searchResultViewController.showSearchResultController(vcity)
                            }
                        } else {
                            ProgressHUD.showSuccessHUD(self?.view, text: "网络连接失败，请检查网络")
                        }
                    })
                })
            }
        }
    }
    
    /// 切换当前城市
    func switchCurrentCity(btn: UIButton) {
        // 开始定位
        locationManager.startUpdatingLocation()
        
        if currentCityId != "-1" && currentCityId != "0" && currentCityId != "" {
            let vcity = CityViewController()
            vcity.cityDataSource = City(id: currentCityId)
            self.searchResultViewController.showSearchResultController(vcity)
            return
        }
        
        if currentCityId == "-1" {
            ProgressHUD.showSuccessHUD(self.view, text: "正在定位中")
        } else if currentCityId == "0" {
            ProgressHUD.showSuccessHUD(self.view, text: "当前城市未开通")
        }
    }

}