//
//  SearchViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/10/25.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout
import SVProgressHUD

class SearchViewController: UISearchController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    let searchResult =  SearchResultsViewController()
    
    /// 搜索记录TableView
    let recordTableView = UITableView()
    
    /// 搜索组标题
    var recordTitleView: UIView = UIView()
    
    let recordLabel = UILabel(color: UIColor(hex: 0xFFFFFF, alpha: 0.6), title: "  搜索历史", fontSize: 12, mutiLines: true)
    
    /// 搜索记录
    var recordData = [String]()
    
    /// 清除按钮
    var recordDelButton: UIButton = UIButton(title: "清除", fontSize: 10, radius: 0, titleColor: UIColor(hex: 0xFFFFFF, alpha: 0.6))
    
    /// 热门搜索词
    var hotwordData = [String]()
    
    var hotWordLabel: UILabel = UILabel(color: UIColor(hex: 0xFFFFFF, alpha: 0.6), title: "  热门搜索", fontSize: 12, mutiLines: true)
    
    /// 搜索提示
    var searchResultLabel: UILabel = UILabel(color: UIColor(hex: 0xFFFFFF, alpha: 0.6), title: "当前搜索无内容", fontSize: 14, mutiLines: true)
    
    /// 定位城市
    var locationButton: UIButton = UIButton(image: "location_Yellow", title: " 即刻定位当前城市", fontSize: 12, titleColor: UIColor(hex: 0xF3FD54, alpha: 1.0))
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init() {
        super.init(searchResultsController: searchResult)
        searchResultsUpdater = searchResult

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageV = UIImageView(image: UIImage(named: "search-bg")!)
        view.addSubview(imageV)
        view.addSubview(searchResult.view)
        imageV.frame = UIScreen.mainScreen().bounds
        setupAddProperty()
        loadSearchMuchLabel()
    }
    
    
    func switchCurrentCity(btn: UIButton) {
        
        if isLocationCompetence == nil {
            SVProgressHUD.showErrorWithStatus("未能获取权限定位失败!")
            locationButton.hidden = true
            return
        }
        
        if currentCityId == nil {
            SVProgressHUD.showInfoWithStatus("正在定位中", maskType: SVProgressHUDMaskType.Black)
            return
        } else if currentCityId == "" {
            SVProgressHUD.showErrorWithStatus("当前城市未开通")
        } else {
            let vcity = CityViewController()
            vcity.cityDataSource = City(id: currentCityId!)
            searchResult.showSearchResultController(vcity)
        }
    }
    
    var textfile: UITextField? {
        didSet {
            textfile?.textColor = UIColor.whiteColor()
            let leftView = UIImageView(image: UIImage(named: "search_icon"))
            textfile?.leftViewMode = UITextFieldViewMode.Always
            textfile?.leftView = leftView
            textfile?.rightView?.backgroundColor = UIColor.whiteColor()
            textfile?.attributedPlaceholder = NSAttributedString(string: "搜索", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        }
    }
    
    private func setupAddProperty() {
        
        if let userDefault = NSUserDefaults.standardUserDefaults().valueForKey("recordData") as? [String] {
            recordData = userDefault
        }
        addChildViewController(searchResult)
        view.addSubview(recordTableView)
        view.addSubview(locationButton)
        view.addSubview(searchResultLabel)
        
        hidesNavigationBarDuringPresentation = false
        searchBar.barStyle = UIBarStyle.Black
        searchBar.keyboardAppearance = UIKeyboardAppearance.Default
        searchBar.delegate = self
        
        recordTableView.registerClass(SearchRecordTableViewCell.self, forCellReuseIdentifier: "SearchRecordTableView_Cell")
        recordTableView.ff_AlignInner(ff_AlignType.BottomLeft, referView: view, size: CGSizeMake(view.bounds.width, UIScreen.mainScreen().bounds.height - 110), offset: CGPointMake(0, 0))
        locationButton.ff_AlignInner(ff_AlignType.TopCenter, referView: view, size: nil, offset: CGPointMake(0, 92))
        searchResultLabel.ff_AlignVertical(ff_AlignType.BottomCenter, referView: locationButton, size: nil, offset: CGPointMake(0, 81))
        recordTableView.backgroundColor = UIColor.clearColor()
        recordTableView.dataSource = self
        recordTableView.delegate = self
        recordTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        recordTitleView.addSubview(recordLabel)
        recordTitleView.addSubview(recordDelButton)
        recordDelButton.addTarget(self, action: "deleteButtonAction", forControlEvents: UIControlEvents.TouchUpInside)
        recordLabel.frame = CGRectMake(0, 50 - 25, 100, 12)
        recordDelButton.frame = CGRectMake(view.bounds.width - 30, 50 - 25 , 20, 10)
        recordTableView.registerClass(SearchMuchCell.self, forCellReuseIdentifier: "SearchMuch_Cell")
        
        locationButton.addTarget(self, action: "switchCurrentCity:", forControlEvents: UIControlEvents.TouchUpInside)
        searchResultLabel.hidden = true
        
        searchBar.setSearchFieldBackgroundImage(UIImage(named: "search_box"), forState: UIControlState.Normal)
        searchBar.tintColor = UIColor(hex: 0xFFFFFF, alpha: 0.5)
        searchBar.translucent = true
        
        for item in searchBar.subviews {
            for it in item.subviews {
                if it.isKindOfClass(NSClassFromString("UISearchBarBackground")!) {
                    it.removeFromSuperview()
                }
                if it.isKindOfClass(NSClassFromString("UISearchBarTextField")!) {
                    textfile = it as? UITextField
                }
            }
        }
    }
    
    private func loadSearchMuchLabel() {
        SearchMoreRequest.fetchHotWords { (result, status) -> Void in
            if status == RetCode.SUCCESS {
                if let data = result {
                    self.hotwordData = data
                    self.recordTableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - searchbar 代理方法
    ///  搜索栏文本开始编辑
    ///
    ///  - parameter searchBar: 搜索栏
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        
    }
    
    ///  搜索栏结束编辑
    ///
    ///  - parameter searchBar: 搜索栏
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        
        NSUserDefaults.standardUserDefaults().setObject(recordData, forKey: "recordData")
    }
    
    ///  搜索栏文字改变时调用的方法
    ///
    ///  - parameter searchBar:  搜索栏
    ///  - parameter searchText: 搜索栏文本
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        recordTableView.hidden = true
        
        if searchBar.text == "" { // 48 × 51
            recordTableView.hidden = false
            recordTableView.reloadData()
        } else {
            locationButton.hidden = true
        }
    }
    
    ///  取消搜索时调用的方法
    ///
    ///  - parameter searchBar: 搜索栏
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
    }
    
    
    // MARK: - tableview 数据源及代理方法
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return hotwordData.count == 0 ? 1 : 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? recordData.count : 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("SearchRecordTableView_Cell", forIndexPath: indexPath) as! SearchRecordTableViewCell
            cell.textLabel?.text = recordData[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("SearchMuch_Cell", forIndexPath: indexPath) as! SearchMuchCell
            addSearchMuchButtonAction(cell)
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return recordTitleView
        } else {
            return hotWordLabel
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.section == 0 ? 46 : 100
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        view.endEditing(true)
        if indexPath.section != 1 {
            searchBar.text = recordData[indexPath.row]
            
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
    
    func addSearchMuchButtonAction(cell: UITableViewCell) {
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
            
            btn.addTarget(self, action: "searchMuchButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
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
    
    func searchMuchButtonAction(btn: UIButton) {
        view.endEditing(true)
        searchBar.text = btn.titleLabel?.text
        recordTableView.hidden = true
    }
    
    func showSearchResultController(vc: UIViewController) {
        //采用push可手势返回
        parentViewController?.presentingViewController?.navigationController?.pushViewController(vc, animated: true)
    }
}