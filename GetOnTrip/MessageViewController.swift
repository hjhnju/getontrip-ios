//
//  MessageViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/6.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout
import MJRefresh

class MessageViewController: MenuViewController, UITableViewDataSource, UITableViewDelegate{
    
    static let name = "消息"

    var lastRequest: MessageListRequest = MessageListRequest()
    
    lazy var tableView: UITableView = UITableView()
    
    let collectPrompt = UILabel(color: UIColor(hex: 0x2A2D2E, alpha: 0.3), title: "您暂时还未收到任何消息\n(∩_∩)", fontSize: 13, mutiLines: true)
    
    var messageLists: [MessageList] = [MessageList]() {
        didSet {
            if messageLists.count == 0 {
                collectPrompt.hidden = true
            } else {
                collectPrompt.hidden = false
            }
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initProperty()
        if globalUser != nil {
            initRefresh()
        }
    }
    
    private func initProperty() {
        
        title = "消息"
        navBar.setTitle(MessageViewController.name)
        
        view.backgroundColor = SceneColor.bgBlack
        view.addSubview(tableView)
        view.addSubview(collectPrompt)
    
        tableView.addSubview(collectPrompt)
        collectPrompt.ff_AlignInner(.TopCenter, referView: tableView, size: nil, offset: CGPointMake(0, 135))
        collectPrompt.textAlignment = NSTextAlignment.Center
        collectPrompt.hidden = true
        
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.ff_AlignInner(.TopLeft, referView: view, size: CGSizeMake(view.bounds.width, view.bounds.height - 44), offset: CGPointMake(0, 44))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.registerClass(MessageTableViewCell.self, forCellReuseIdentifier: "Message_Cell")
        tableView.registerClass(SystemTableViewCell.self, forCellReuseIdentifier: "SystemTableView_Cell")
    }
    
    private func initRefresh() {
        //上拉刷新
        let tbHeaderView = MJRefreshNormalHeader(refreshingBlock: loadData)
        tbHeaderView.automaticallyChangeAlpha = true
        tbHeaderView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        tbHeaderView.stateLabel?.font = UIFont.systemFontOfSize(12)
        tbHeaderView.lastUpdatedTimeLabel?.font = UIFont.systemFontOfSize(11)
        tbHeaderView.stateLabel?.textColor = SceneColor.lightGray
        tbHeaderView.lastUpdatedTimeLabel?.textColor = SceneColor.lightGray
        tbHeaderView.lastUpdatedTimeLabel?.hidden = true
        tbHeaderView.stateLabel?.hidden = true
        tbHeaderView.arrowView?.image = UIImage()
        
        //下拉刷新
        let tbFooterView = MJRefreshAutoNormalFooter(refreshingBlock: loadMore)
        tbFooterView.automaticallyRefresh = true
        tbFooterView.automaticallyChangeAlpha = true
        tbFooterView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        tbFooterView.stateLabel?.font = UIFont.systemFontOfSize(12)
        tbFooterView.stateLabel?.textColor = SceneColor.lightGray
        
        
        self.tableView.mj_header = tbHeaderView
        self.tableView.mj_footer = tbFooterView
        
        if !tableView.mj_header.isRefreshing() {
            tableView.mj_header.beginRefreshing()
        }
    }

    // MARK: - Table view data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if messageLists.count == 0 { collectPrompt.hidden = false } else { collectPrompt.hidden = true }
        return messageLists.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let mes = messageLists[indexPath.row] as MessageList
        
        if mes.type == "1" {
            let cell = tableView.dequeueReusableCellWithIdentifier("SystemTableView_Cell", forIndexPath: indexPath) as! SystemTableViewCell
            cell.message = mes
            if messageLists.count - 1 == indexPath.row {
                cell.baseline.removeFromSuperview()
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("Message_Cell", forIndexPath: indexPath) as! MessageTableViewCell
            cell.message = mes
            
            if messageLists.count - 1 == indexPath.row {
                cell.baseline.removeFromSuperview()
            }
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let mes = messageLists[indexPath.row] as MessageList
        if mes.type == "1" {
            return SystemTableViewCell.messageWithHeight(mes)
        }
        return 75
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        
        let data = messageLists[indexPath.row] as MessageList
        
        if data.type != "1" {
            let vc = TopicViewController()
            let topic = Topic(id: data.topicId)
            vc.topicDataSource = topic
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // 删除方法
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle != UITableViewCellEditingStyle.Delete { return }
        
        let msg = messageLists[indexPath.row]
        MessageListRequest.deleteMessage(msg.mid) { (result, status) -> Void in
            if status == RetCode.SUCCESS {
                print(result)
                self.messageLists.removeAtIndex(indexPath.row)
                tableView.reloadData()
                ProgressHUD.showErrorHUD(self.view, text: "删除成功")

            } else {
                ProgressHUD.showErrorHUD(self.view, text: "删除失败，请重新删除")
            }
        }
        
    }
    
    
    /// 是否正在加载中
    var isLoading:Bool = false
    
    /// 注意：不能在loadData中进行beginRefreshing, beginRefreshing会自动调用loadData
    private func loadData() {
        if self.isLoading {
            return
        }
        
        self.isLoading = true
        
        //清空footer的“加载完成”
        self.tableView.mj_footer.resetNoMoreData()
        
        lastRequest.fetchFirstPageModels {[weak self] (data, status) -> Void in
            //处理异常状态
            if RetCode.SUCCESS != status {
                ProgressHUD.showErrorHUD(self?.view, text: "您的网络不给力！")
                self?.tableView.mj_header.endRefreshing()
                self?.isLoading = false
                return
            }
            
            if let dataSource = data {
                self?.tableView.mj_header.endRefreshing()
                self?.messageLists = dataSource
            }
            self?.isLoading = false
        }
    }
    
    /// 底部加载更多
    func loadMore(){
        if self.isLoading {
            return
        }
        self.isLoading = true
        //请求下一页
        self.lastRequest.fetchNextPageModels { [weak self] (data, status) -> Void in
            
            if let dataSource = data {
                if dataSource.count > 0 {
                    if let cells = self?.messageLists {
                        self?.messageLists = cells + dataSource
                    }
                    self?.tableView.mj_footer.endRefreshing()
                } else {
                    self?.tableView.mj_footer.endRefreshingWithNoMoreData()
                }
            }
            self?.isLoading = false
        }
    }
    
    
}

// MARK: - 回复消息
class MessageTableViewCell: UITableViewCell {
    /// 头像
    lazy var iconView: UIImageView = UIImageView()
    /// 回复人
    lazy var restorePerson: UILabel = UILabel(color: UIColor.blackColor(), title: "", fontSize: 12, mutiLines: false)
    /// 回复时间
    lazy var restoreTime: UILabel = UILabel(color: UIColor.blackColor(), title: "", fontSize: 9, mutiLines: false)
    /// 所回复的照片
    lazy var restoreImageView: UIImageView = UIImageView()
    
    /// 设置底线
    lazy var baseline: UIView = UIView(color: SceneColor.shallowGrey, alphaF: 0.3)
    
    var message: MessageList? {
        didSet {
            iconView.sd_setImageWithURL(NSURL(string: message!.avatar), placeholderImage: PlaceholderImage.defaultSmall)
            restorePerson.text = message?.content
            restoreTime.text = message?.create_time
            restoreImageView.sd_setImageWithURL(NSURL(string: message!.image), placeholderImage: PlaceholderImage.defaultSmall)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(baseline)
        addSubview(iconView)
        addSubview(restoreTime)
        addSubview(restorePerson)
        addSubview(restoreImageView)
        
        iconView.layer.borderWidth = 1.0
        iconView.layer.borderColor = SceneColor.shallowGrey.CGColor
        
        iconView.clipsToBounds = true
        iconView.layer.cornerRadius = iconView.bounds.width * 0.5
        iconView.ff_AlignInner(.CenterLeft, referView: self, size: CGSizeMake(35, 35), offset: CGPointMake(9, 0))
        restorePerson.ff_AlignHorizontal(.TopRight, referView: iconView, size: nil, offset: CGPointMake(7, 0))
        restoreTime.ff_AlignHorizontal(.BottomRight, referView: iconView, size: nil, offset: CGPointMake(7, 0))
        restoreImageView.ff_AlignInner(.CenterRight, referView: self, size: CGSizeMake(77, 57), offset: CGPointMake(-9, 0))
        baseline.ff_AlignInner(.BottomCenter, referView: self, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 18, 0.5), offset: CGPointMake(0, 0))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconView.layer.cornerRadius = max(iconView.bounds.width, iconView.bounds.height) * 0.5
        iconView.clipsToBounds = true
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        
    }
}

// MARK: - 系统消息
class SystemTableViewCell: UITableViewCell {
    /// 头像
    lazy var iconView: UIImageView = UIImageView(image: UIImage(named: "icon_app"))
    /// 系统回复
    lazy var restorePerson: UILabel = UILabel(color: SceneColor.frontBlack, title: "系统消息", fontSize: 12, mutiLines: false)
    /// 回复时间
    lazy var restoreTime: UILabel = UILabel(color: SceneColor.frontBlack, title: "2天前", fontSize: 9, mutiLines: false)
    /// 标题
    lazy var title: UILabel = UILabel(color: SceneColor.frontBlack, title: "周天赞自己，升级正能量！", fontSize: 12, mutiLines: false)
    /// 副标题
    lazy var subTitle: UILabel = UILabel(color: SceneColor.frontBlack, title: "给负能量除以二，让好心情翻一番。来途知查看你的爱心话题，推荐有趣的话题，传递周一正能量能量！查看你的爱心话题，推荐有趣的话题，传递周一正能量能量能量能能量", fontSize: 12, mutiLines: false)
    /// 图片
    lazy var restoreImageView: UIImageView = UIImageView()
    
    /// 设置底线
    lazy var baseline: UIView = UIView(color: SceneColor.shallowGrey, alphaF: 0.3)
    
    var message: MessageList? {
        didSet {
            restoreTime.text = message?.create_time
            restoreImageView.sd_setImageWithURL(NSURL(string: message!.image), placeholderImage: PlaceholderImage.defaultSmall)
            
            let getWidth = CGRectGetMaxX(restorePerson.frame) + 8
            title.text = message?.title
            subTitle.text = message?.content
            if message!.systemMesIsIcon {
                restoreImageView.removeFromSuperview()
                title.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - (getWidth + 10)
                subTitle.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - (getWidth + 10)
            } else {
                title.preferredMaxLayoutWidth = bounds.width - (getWidth + iconView.bounds.width + 10 + 18)
                subTitle.preferredMaxLayoutWidth = bounds.width - (getWidth + iconView.bounds.width + 10 + 18)
            }
        }
    }
    
    class func messageWithHeight(mes: MessageList) -> CGFloat {
        var w: CGFloat = 114
        var h: CGFloat = 24
        if mes.systemMesIsIcon {
            w = UIScreen.mainScreen().bounds.width - CGFloat(114) - CGFloat(105)
        } else {
            w = UIScreen.mainScreen().bounds.width - CGFloat(114) - CGFloat(9)
        }
        h = h + mes.title.sizeofStringWithFount1(UIFont.systemFontOfSize(12), maxSize: CGSizeMake(w, CGFloat.max)).height +
                mes.content.sizeofStringWithFount1(UIFont.systemFontOfSize(12), maxSize: CGSizeMake(w, CGFloat.max)).height
        return max(h, 72)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(title)
        addSubview(subTitle)
        addSubview(baseline)
        addSubview(iconView)
        addSubview(restoreTime)
        addSubview(restorePerson)
        addSubview(restoreImageView)
        
        title.numberOfLines = 0
        subTitle.numberOfLines = 0
        
        iconView.clipsToBounds = true
        iconView.layer.cornerRadius = iconView.bounds.width * 0.5
        
        iconView.ff_AlignInner(.TopLeft, referView: self, size: CGSizeMake(35, 35), offset: CGPointMake(10, 19))
        restorePerson.ff_AlignHorizontal(.TopRight, referView: iconView, size: nil, offset: CGPointMake(7, 0))
        restoreTime.ff_AlignHorizontal(.BottomRight, referView: iconView, size: nil, offset: CGPointMake(7, 0))
        restoreImageView.ff_AlignInner(.CenterRight, referView: self, size: CGSizeMake(77, 58), offset: CGPointMake(-9, 0))
        title.ff_AlignHorizontal(.TopRight, referView: restorePerson, size: nil, offset: CGPointMake(15, 0))
        subTitle.ff_AlignVertical(.BottomLeft, referView: title, size: nil, offset: CGPointMake(0, 8))
        baseline.ff_AlignInner(.BottomCenter, referView: self, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 18, 0.5), offset: CGPointMake(0, 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconView.layer.cornerRadius = max(iconView.bounds.width, iconView.bounds.height) * 0.5
        iconView.clipsToBounds = true
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        
    }
}
