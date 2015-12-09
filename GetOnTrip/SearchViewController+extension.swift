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
            cell.index = indexPath.row
            cell.textLabel?.text = recordData[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(SearchViewContant.hotwordCellId, forIndexPath: indexPath) as! SearchHotwordTableViewCell
            cell.superController = self
            cell.dataSource = hotwordData
//            addSearchHotwordButtonAction(cell)
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return section == 0 ? recordTitleView : hotWordLabel
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.section == 0 ? 43 : 500
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
    
    func addSearchHotwordButtonAction(cell: UITableViewCell) {
        let btnWidth:CGFloat  = UIScreen.mainScreen().bounds.width / 5
        let btnHeight:CGFloat = 20
        let totalCol:Int      = 5
        let totalRow:Int      = 5
        let marginX:CGFloat   = (UIScreen.mainScreen().bounds.size.width - btnWidth * CGFloat(totalCol)) / CGFloat(totalCol + 1) + 9
        let yOffset:CGFloat   = 14
        let marginY:CGFloat   = 26
        
        for (var i = 0; i < hotwordData.count; i++) {
            let btn = UIButton(title: hotwordData[i], fontSize: 16, radius: 0)
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
            cell.addSubview(btn)
            
            btn.addTarget(self, action: "searchHotwordButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
            btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            
            let row:Int = i / totalCol
            let col:Int = i % totalCol
            
            if row >= totalRow {
                break
            }
            
            let btnX:CGFloat = marginX + (marginX + btnWidth) * CGFloat(col)
            let btnY:CGFloat = yOffset + (marginY + btnHeight) * CGFloat(row)
            btn.frame = CGRectMake(btnX, btnY, btnWidth, btnHeight)
        }
        
    }
    
    func searchHotwordButtonAction(btn: UIButton) {
        view.endEditing(true)
        searchBar.text = btn.titleLabel?.text ?? ""
        searchBar(searchBar, textDidChange: searchBar.text ?? "")
        recordTableView.hidden = true
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