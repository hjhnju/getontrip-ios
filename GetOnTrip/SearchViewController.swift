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

    let searchResult = SearchResultsViewController()
    
    /// 搜索记录TableView
    let recordTableView = UITableView()
    
    var recordData = [String]()
    
    var searchMuch = [String]()
    
    let searchGroupLab = UILabel(color: UIColor(hex: 0xFFFFFF, alpha: 0.6), title: "  搜索历史", fontSize: 12, mutiLines: true)
    
    /// 搜索组标题
    lazy var groupTitle: UIView = UIView()
    
    lazy var hotWord: UILabel = UILabel(color: UIColor(hex: 0xFFFFFF, alpha: 0.6), title: "  热门搜索", fontSize: 12, mutiLines: true)
    
    /// 清除按钮
    var deleteButton: UIButton = UIButton(title: "清除", fontSize: 10, radius: 0, titleColor: UIColor(hex: 0xFFFFFF, alpha: 0.6))
    
//    
    
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
        
        setupAddProperty()
        loadSearchMuchLabel()
    }
    
    private func setupAddProperty() {
        
        if let userDefault = NSUserDefaults.standardUserDefaults().valueForKey("recordData") as? [String] {
            recordData = userDefault
        }
        addChildViewController(searchResult)
        view.addSubview(searchResult.view)
        view.addSubview(recordTableView)
        hidesNavigationBarDuringPresentation = false
        view.backgroundColor = UIColor(patternImage: UIImage(named: "search-bg0")!)
        searchBar.barStyle = UIBarStyle.Black
        searchBar.tintColor = UIColor.grayColor()
        searchBar.becomeFirstResponder()
        searchBar.keyboardAppearance = UIKeyboardAppearance.Default
        searchBar.delegate = self
        recordTableView.registerClass(SearchRecordTableViewCell.self, forCellReuseIdentifier: "SearchRecordTableView_Cell")
        recordTableView.ff_AlignInner(ff_AlignType.BottomLeft, referView: view, size: CGSizeMake(view.bounds.width, UIScreen.mainScreen().bounds.height - 110), offset: CGPointMake(0, 0))
        recordTableView.backgroundColor = UIColor.clearColor()
        recordTableView.dataSource = self
        recordTableView.delegate = self
        recordTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        groupTitle.addSubview(searchGroupLab)
        groupTitle.addSubview(deleteButton)
        deleteButton.addTarget(self, action: "deleteButtonAction", forControlEvents: UIControlEvents.TouchUpInside)
        searchGroupLab.frame = CGRectMake(0, 50 - 25, 100, 12)
        deleteButton.frame = CGRectMake(view.bounds.width - 30, 50 - 25 , 20, 10)
        recordTableView.registerClass(SearchMuchCell.self, forCellReuseIdentifier: "SearchMuch_Cell")
        
    }
    
    private func loadSearchMuchLabel() {
        SearchMoreRequest.fetchSearchMuchLabel { (data, status) -> Void in
            if status == 0 {
                self.searchMuch = data!
                self.recordTableView.reloadData()
            } else {
                 SVProgressHUD.showInfoWithStatus("您的网络不给力!")
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
        if searchBar.text == "" {
            recordTableView.hidden = false
            recordTableView.reloadData()
        }
    }
    
    ///  取消搜索时调用的方法
    ///
    ///  - parameter searchBar: 搜索栏
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
    }
    
    
    // MARK: - tableview 数据源及代理方法
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return searchMuch.count == 0 ? 1 : 2
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
            return groupTitle
        } else {
            return hotWord
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.section == 0 ? 46 : 100
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

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
        let marginX:CGFloat   = (UIScreen.mainScreen().bounds.size.width - btnWidth * CGFloat(totalCol)) / CGFloat(totalCol + 1)
        let yOffset:CGFloat   = 14
        let marginY:CGFloat   = 26
        
        for (var i = 0; i < searchMuch.count; i++) {
            let btn = UIButton(title: searchMuch[i], fontSize: 14, radius: 0)
            
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
        searchBar.text = btn.titleLabel?.text
        recordTableView.hidden = true
    }
}

/// 搜索历史cell
class SearchRecordTableViewCell : UITableViewCell {
    
    let baseLine: UIView = UIView(color: SceneColor.shallowGrey, alphaF: 0.2)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(baseLine)
        textLabel?.textColor = UIColor.whiteColor()
        textLabel?.font = UIFont.systemFontOfSize(16)
        
        baseLine.ff_AlignInner(ff_AlignType.TopCenter, referView: self, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 18, 0.5))
        backgroundColor = UIColor.clearColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame.origin.x = 9
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        
    }
}

class SearchMuchCell: UITableViewCell {
    
    let baseLine: UIView = UIView(color: SceneColor.shallowGrey, alphaF: 0.2)

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(baseLine)
        baseLine.ff_AlignInner(ff_AlignType.TopCenter, referView: self, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 18, 0.5))

        backgroundColor = UIColor.clearColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        
    }
}
