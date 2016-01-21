//
//  FoodDetailViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 16/1/19.
//  Copyright © 2016年 Joshua. All rights reserved.
//

import UIKit

class FoodDetailViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    /// 自定义导航
    var navBar: CustomNavigationBar = CustomNavigationBar(title: "", titleColor: SceneColor.frontBlack, titleSize: 17, hasStatusBar: true)
    /// tableview
    lazy var tableView = UITableView()
    /// 头部视图
    lazy var headerView = UIView(frame: CGRectMake(0, 0, Frame.screen.width, 267))
    /// 头部视图高度约束
    var headerHeightConstraint: NSLayoutConstraint?
    lazy var headerImageView: UIImageView = UIImageView()
    /// 网络请求加载数据(添加)
    var lastRequest = FoodRequest()
    /// 美食id
    var foodId = "" {
        didSet {
            lastRequest.foodId = foodId
        }
    }
    
    var data: FoodDetail = FoodDetail() {
        didSet {
            if UserProfiler.instance.isShowImage() { headerImageView.sd_setImageWithURL(NSURL(string: data.image)) }
            recommendShop[0] = data.shopDetails
            recommendTopic[0] = data.topicDetails
            
            
            if let shopDatas = recommendShop[0] {
                shopData = shopDatas
            }
            if let topicDatas = recommendTopic[0] {
                topicData = topicDatas
            }
            
            navBar.titleLabel.text = data.title
            tableView.reloadData()
        }
    }
    /// 店铺数据源
    var shopData: [ShopDetail] = [ShopDetail]()
    /// 话题数据源
    var topicData: [FoodTopicDetail] = [FoodTopicDetail]()
    /// 推荐名店页数数据源
    var recommendShop: [Int : [ShopDetail]] = [Int : [ShopDetail]]()
    /// 推荐名店页数数据源
    var recommendTopic: [Int : [FoodTopicDetail]] = [Int : [FoodTopicDetail]]()
    /// 当前索引
    var shopIndex: Int = 0
    /// 当前话题索引
    var topicIndex: Int = 0
    
    weak var shopUpButton    : UIButton?
    weak var shopBottomButton: UIButton?
    weak var topicUpButton   : UIButton?
    weak var topicBottomButton: UIButton?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        initTableView()
        initHeaderView()
        loadData()
        initNavBar()
    }
    
    ///  初始化属性
    func initView() {
        navBar.setStatusBarHidden(true)
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Fade)
        view.backgroundColor = .whiteColor()
    }
    
    func initNavBar() {
        view.addSubview(navBar)
        view.bringSubviewToFront(navBar)
        if #available(iOS 9.0, *) {
            navBar.titleLabel.font = UIFont(name: Font.defaultFont , size: 17)
        } else {
            navBar.titleLabel.font = UIFont.systemFontOfSize(17)
        }
        navBar.titleLabel.textColor = UIColor(hex: 0x424242, alpha: 1.0)
        navBar.setBackBarButton(UIImage(named: "icon_back"), title: nil, target: self, action: "popViewAction:")
        navBar.setButtonTintColor(SceneColor.frontBlack)
    }
    
    func initHeaderView() {
        view.addSubview(headerView)
        headerView.backgroundColor = SceneColor.whiteGray
        headerView.addSubview(headerImageView)
        headerView.clipsToBounds = true
        headerImageView.contentMode = .ScaleAspectFill
        headerImageView.ff_Fill(headerView)
        headerView.userInteractionEnabled = false
        let cons = headerView.ff_AlignInner(.TopLeft, referView: tableView, size: CGSizeMake(Frame.screen.width, 267))
        headerHeightConstraint = headerView.ff_Constraint(cons, attribute: .Height)
    }
    
    func initTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate   = self
        tableView.separatorStyle = .None
        tableView.registerClass(FoodHeaderContentViewCell.self, forHeaderFooterViewReuseIdentifier: "FoodHeaderContentViewCell")
        tableView.registerClass(FoodHeaderViewCell.self, forHeaderFooterViewReuseIdentifier: "FoodHeaderViewCell")
        tableView.registerClass(FoodTopicTableViewCell.self, forCellReuseIdentifier: "FoodTopicTableViewCell")
        tableView.registerClass(FoodShopTableViewCell.self, forCellReuseIdentifier: "FoodShopTableViewCell")
        tableView.ff_AlignInner(.TopLeft, referView: view, size: Frame.screen.size)
        tableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, Frame.screen.width, 267))
        tableView.sectionHeaderHeight = 40
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = .Default
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }
    
    // MARK: - tableview delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 0 }
        return section == 1 ? shopData.count : topicData.count
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let v = tableView.dequeueReusableHeaderFooterViewWithIdentifier("FoodHeaderContentViewCell") as! FoodHeaderContentViewCell
            v.data = data.content
            return v
        }
        
        let v = tableView.dequeueReusableHeaderFooterViewWithIdentifier("FoodHeaderViewCell") as! FoodHeaderViewCell
        v.upButton.addTarget(self, action: "upPageAction:", forControlEvents: .TouchUpInside)
        v.BottomButton.addTarget(self, action: "BottomPageAction:", forControlEvents: .TouchUpInside)
        v.titleLabel.text = section == 1 ? "推荐名店" : "相关话题"
        v.upButton.tag = section == 1 ? 2 : 3
        v.BottomButton.tag = section == 1 ? 2 : 3
        v.BottomButton.hidden = section == 1 ? false : true
        v.upButton.hidden = section == 1 ? false : true
        
        if section == 1 {
            shopUpButton = v.upButton
            shopUpButton = v.BottomButton
            v.upButton.hidden = Int(data.shopNum) > 4 ? false : true
            v.BottomButton.hidden = Int(data.shopNum) > 4 ? false : true
        } else if section == 2 {
            topicUpButton = v.upButton
            topicBottomButton = v.BottomButton
            v.upButton.hidden = Int(data.topicNum) > 4 ? false : true
            v.BottomButton.hidden = Int(data.topicNum) > 4 ? false : true
        }
        
        return v
    }
    
    /// 每行的行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 112
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? data.headerHeight : 40
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("FoodShopTableViewCell", forIndexPath: indexPath) as! FoodShopTableViewCell
            cell.data = shopData[indexPath.row]
            cell.baseLine.hidden = indexPath.row == shopData.count - 1 ? true : false
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier("FoodTopicTableViewCell", forIndexPath: indexPath) as! FoodTopicTableViewCell
            cell.data = topicData[indexPath.row]
            cell.baseLine.hidden = indexPath.row == topicData.count - 1 ? true : false
            return cell
        }
        return UITableViewCell()
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            let sc = DetailWebViewController()
            let data = shopData[indexPath.row]
            sc.url = data.url
            sc.title = data.title
            navigationController?.pushViewController(sc, animated: true)
        } else if indexPath.section == 2 {
            let vc = TopicViewController()
            let col = topicData[indexPath.row]
            let topic = Topic()
            topic.id       = col.id
            topic.image    = col.image
            topic.title    = col.title
            topic.subtitle = col.desc
            vc.topicDataSource = topic
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var height = (-scrollView.contentOffset.y + 267)
        if height < 44 { height = 44 }
        headerHeightConstraint?.constant = height
    }
    
    private func loadData() {
        lastRequest.fetchModels {[weak self] (result, status) -> Void in
            if status == RetCode.SUCCESS {
                if let data = result {
                    self?.data = data
                }
            }
        }
    }
    
    
    /// 上一页方法
    func upPageAction(sender: UIButton) {
        if sender.tag == 2 { // 推荐名店的上一页
            if let data = recommendShop[shopIndex-1] {
                shopData = data
                tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .None)
                shopIndex--
            }
        } else { // 相关话题的下一页
            if let data = recommendTopic[topicIndex-1] {
                topicData = data
                tableView.reloadSections(NSIndexSet(index: 2), withRowAnimation: .None)
                topicIndex--
            }
        }
    }
    /// 下一页方法
    func BottomPageAction(sender: UIButton) {
        if sender.tag == 2 { // 推荐名店的下一页
            if let data = recommendShop[shopIndex+1] {
                shopData = data
                tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .None)
                shopIndex++
                return
            }
            lastRequest.foodFetchNextPageModels({ (result, status) -> Void in
                print(result)
                if status == RetCode.SUCCESS {
                    if let data = result {
                        print(data.count)
                        if data.count > 0 {
                            self.shopIndex++
                            self.shopData = data
                            self.recommendShop[self.shopIndex] = data
                            self.tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .None)
                        } else {
                            ProgressHUD.showSuccessHUD(nil, text: "已无更多名店")
                            self.lastRequest.shopPage--
                        }
                    }
                }
            })
        } else { // 相关话题的下一页
            if let data = recommendTopic[topicIndex+1] {
                topicData = data
                tableView.reloadSections(NSIndexSet(index: 2), withRowAnimation: .None)
                topicIndex++
                return
            }
            lastRequest.topicFetchNextPageModels({ (result, status) -> Void in
                if status == RetCode.SUCCESS {
                    if let data = result {
                        if data.count > 0 {
                            self.topicIndex++
                            self.topicData = data
                            self.recommendTopic[self.topicIndex] = data
                            self.tableView.reloadSections(NSIndexSet(index: 2), withRowAnimation: .None)
                        } else {
                            ProgressHUD.showSuccessHUD(nil, text: "已无更多话题")
                            self.lastRequest.topicPage--
                        }
                    }
                }
            })
        }
    }
}
