
//
//  MessageViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/6.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

class MessageViewController: UITableViewController {

    var lastSuccessRequest: MessageListRequest?
    
    var messageLists: [MessageList]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.backgroundColor = UIColor(patternImage: UIImage(named: "feedBack_background")!)
        loadFeedBackHistory()
    }
    
    
    // MARK: - 加载更新数据
    /// 加载反馈历史消息(都是提问的问题)
    private func loadFeedBackHistory() {
        
        if lastSuccessRequest == nil {
            lastSuccessRequest = MessageListRequest()
        }
        
        lastSuccessRequest?.fetchFeedBackModels {(handler: [MessageList]) -> Void in
            self.messageLists = handler
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messageLists?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Message_Cell", forIndexPath: indexPath) as! MessageTableViewCell
//        var ml = messageLists[indexPath.row]
        cell.message = messageLists![indexPath.row] as MessageList
        
        return cell
    }

}

// MARK: - 回复消息
class MessageTableViewCell: UITableViewCell {
    /// 头像
    lazy var iconView: UIImageView = UIImageView()
    /// 回复人
    lazy var restorePerson: UILabel = UILabel(color: UIColor.whiteColor(), title: "", fontSize: 12, mutiLines: false)
    /// 回复时间
    lazy var restoreTime: UILabel = UILabel(color: UIColor.whiteColor(), title: "", fontSize: 9, mutiLines: false)
    /// 所回复的照片
    lazy var restoreImageView: UIImageView = UIImageView()
    
    /// 设置底线
    lazy var baseline: UIView = UIView(color: UIColor.whiteColor(), alphaF: 0.3)
    
    var message: MessageList? {
        didSet {
            iconView.sd_setImageWithURL(NSURL(string: message!.avatar!), placeholderImage: UIImage(named: "2.jpg"))
            restorePerson.text = message?.content
            restoreTime.text = message?.create_time
            restoreImageView.sd_setImageWithURL(NSURL(string: message!.image!), placeholderImage: UIImage(named: "2.jpg"))
            print(message?.image)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
        restoreImageView.ff_AlignInner(ff_AlignType.CenterRight, referView: self, size: CGSizeMake(77, 58), offset: CGPointMake(9, 0))
        baseline.ff_AlignInner(ff_AlignType.BottomCenter, referView: self, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 18, 0.5), offset: CGPointMake(0, 0))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 系统消息
class SystemTableViewCell: UITableViewCell {
    /// 头像
    lazy var iconView: UIImageView = UIImageView()
    /// 系统回复
    lazy var restorePerson: UILabel = UILabel(color: UIColor.whiteColor(), title: "系统消息", fontSize: 12, mutiLines: false)
    /// 回复时间
    lazy var restoreTime: UILabel = UILabel(color: UIColor.whiteColor(), title: "2天前", fontSize: 9, mutiLines: false)
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
            iconView.sd_setImageWithURL(NSURL(string: message!.avatar!), placeholderImage: UIImage(named: "2.jpg"))
            restorePerson.text = message?.content
            restoreTime.text = message?.create_time
            restoreImageView.sd_setImageWithURL(NSURL(string: message!.image!), placeholderImage: UIImage(named: "2.jpg"))
            
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
        restoreImageView.ff_AlignInner(ff_AlignType.CenterRight, referView: self, size: CGSizeMake(77, 58), offset: CGPointMake(9, 0))
        title.ff_AlignHorizontal(ff_AlignType.TopRight, referView: restorePerson, size: nil, offset: CGPointMake(15, 0))
        subTitle.ff_AlignVertical(ff_AlignType.BottomLeft, referView: title, size: nil, offset: CGPointMake(0, 8))
        baseline.ff_AlignInner(ff_AlignType.BottomCenter, referView: self, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 18, 0.5), offset: CGPointMake(0, 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
