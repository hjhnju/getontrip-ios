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
import SVProgressHUD

class MessageViewController: MenuViewController, UITableViewDataSource, UITableViewDelegate{
    
    static let name = "消息"

    var lastRequest: MessageListRequest = MessageListRequest()
    
    var messageLists: [MessageList] = [MessageList]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    lazy var tableView: UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initProperty()
        initRefresh()
    }
    
    private func initProperty() {
        
        title = "消息"
        navBar.setTitle(MessageViewController.name)
        
        view.backgroundColor = SceneColor.bgBlack
        view.addSubview(tableView)
        
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.ff_AlignInner(ff_AlignType.TopLeft, referView: view, size: CGSizeMake(view.bounds.width, view.bounds.height - 64), offset: CGPointMake(0, 64))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.registerClass(MessageTableViewCell.self, forCellReuseIdentifier: "Message_Cell")
//        loadFeedBackHistory()
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
    
    // MARK: - 加载更新数据
    /// 加载反馈历史消息(都是提问的问题)
//    private func loadFeedBackHistory() {
//        
//        
//        lastRequest.fetchFeedBackModels {(handler: [MessageList]) -> Void in
//            self.messageLists = handler
//            self.tableView.reloadData()
//        }
//    }

    // MARK: - Table view data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messageLists.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Message_Cell", forIndexPath: indexPath) as! MessageTableViewCell
        cell.message = messageLists[indexPath.row] as MessageList
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let data = messageLists[indexPath.row] as MessageList
        
        let vc = TopicViewController()
        let topic = Topic(id: data.topicId)
        vc.topicDataSource = topic
        navigationController?.pushViewController(vc, animated: true)
        vc.doComment(vc.commentBtn)
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
                SVProgressHUD.showInfoWithStatus("您的网络不给力!")
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
    lazy var baseline: UIView = UIView(color: UIColor.whiteColor(), alphaF: 0.3)
    
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
        iconView.ff_AlignInner(ff_AlignType.CenterLeft, referView: self, size: CGSizeMake(35, 35), offset: CGPointMake(9, 0))
        restorePerson.ff_AlignHorizontal(ff_AlignType.TopRight, referView: iconView, size: nil, offset: CGPointMake(7, 0))
        restoreTime.ff_AlignHorizontal(ff_AlignType.BottomRight, referView: iconView, size: nil, offset: CGPointMake(7, 0))
        restoreImageView.ff_AlignInner(ff_AlignType.CenterRight, referView: self, size: CGSizeMake(77, 57), offset: CGPointMake(-9, 0))
        baseline.ff_AlignInner(ff_AlignType.BottomCenter, referView: self, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 18, 0.5), offset: CGPointMake(0, 0))
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
    lazy var iconView: UIImageView = UIImageView()
    /// 系统回复
    lazy var restorePerson: UILabel = UILabel(color: UIColor.whiteColor(), title: "系统消息", fontSize: 12, mutiLines: false)
    /// 回复时间
    lazy var restoreTime: UILabel = UILabel(color: UIColor(hex: 0x7F7F7F, alpha: 1.0), title: "2天前", fontSize: 9, mutiLines: false)
    /// 标题
    lazy var title: UILabel = UILabel(color: UIColor.whiteColor(), title: "周天赞自己，升级正能量！", fontSize: 12, mutiLines: false)
    /// 副标题
    lazy var subTitle: UILabel = UILabel(color: UIColor.whiteColor(), title: "给负能量除以二，让好心情翻一番。来途知查看你的爱心话题，推荐有趣的话题，传递周一正能量能量！查看你的爱心话题，推荐有趣的话题，传递周一正能量能量能量能能量", fontSize: 12, mutiLines: false)
    /// 图片
    lazy var restoreImageView: UIImageView = UIImageView()
    
    /// 设置底线
    lazy var baseline: UIView = UIView(color: UIColor.whiteColor(), alphaF: 0.3)
    
    var message: MessageList? {
        didSet {
            iconView.sd_setImageWithURL(NSURL(string: message!.avatar), placeholderImage: PlaceholderImage.defaultSmall)
            restorePerson.text = message?.content
            restoreTime.text = message?.create_time
            restoreImageView.sd_setImageWithURL(NSURL(string: message!.image), placeholderImage: PlaceholderImage.defaultSmall)
            
            let getWidth = CGRectGetMaxX(restorePerson.frame) + 8
            if message?.image == "" {
                
                title.preferredMaxLayoutWidth = bounds.width - (getWidth + 10)
                subTitle.preferredMaxLayoutWidth = title.preferredMaxLayoutWidth
            } else {
                title.preferredMaxLayoutWidth = bounds.width - (getWidth + iconView.bounds.width + 10 + 18)
                subTitle.preferredMaxLayoutWidth = title.preferredMaxLayoutWidth
            }
        }
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
        
        iconView.clipsToBounds = true
        iconView.layer.cornerRadius = iconView.bounds.width * 0.5
        
        iconView.ff_AlignInner(ff_AlignType.CenterLeft, referView: self, size: CGSizeMake(35, 35), offset: CGPointMake(9, 0))
        restorePerson.ff_AlignHorizontal(ff_AlignType.TopRight, referView: iconView, size: nil, offset: CGPointMake(7, 0))
        restoreTime.ff_AlignHorizontal(ff_AlignType.BottomRight, referView: iconView, size: nil, offset: CGPointMake(7, 0))
        restoreImageView.ff_AlignInner(ff_AlignType.CenterRight, referView: self, size: CGSizeMake(77, 58), offset: CGPointMake(-9, 0))
        title.ff_AlignHorizontal(ff_AlignType.TopRight, referView: restorePerson, size: nil, offset: CGPointMake(15, 0))
        subTitle.ff_AlignVertical(ff_AlignType.BottomLeft, referView: title, size: nil, offset: CGPointMake(0, 8))
        baseline.ff_AlignInner(ff_AlignType.BottomCenter, referView: self, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 18, 0.5), offset: CGPointMake(0, 0))
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
