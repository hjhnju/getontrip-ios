//
//  SearchListPageController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/22.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

class SearchListPageController: BaseHomeController, UITableViewDataSource, UITableViewDelegate {
    
    /// 底部的tableView
    lazy var tableView = UITableView()
    
    var dataSource: NSDictionary?
    
    /// 网络请求加载数据(添加)
    var lastSuccessAddRequest: HomeSearchCityRequest?

    // MARK: - 初始化
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSearchData()
        
        view.addSubview(tableView)
        tableView.ff_AlignInner(ff_AlignType.TopLeft, referView: view, size: view.bounds.size, offset: CGPointMake(0, 0))
        
    }
    
    
    /// 发送反馈消息
    private func loadSearchData() {
        
        if lastSuccessAddRequest == nil {
            lastSuccessAddRequest = HomeSearchCityRequest()
            
        }
        
        lastSuccessAddRequest?.fetchFeedBackModels {[unowned self] (handler: NSDictionary) -> Void in
            self.dataSource = handler
            self.tableView.reloadData()
        }
    }
    
    // MARK: - tableView 数据源及代理方法
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dataSource?.objectForKey("datas")?.count)! + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}
