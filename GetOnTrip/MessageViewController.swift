
//
//  MessageViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/6.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

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

class MessageTableViewCell: UITableViewCell {
    /// 头像
    @IBOutlet weak var iconView: UIImageView!
    /// 回复人
    @IBOutlet weak var restorePerson: UILabel!
    /// 回复时间
    @IBOutlet weak var restoreTime: UILabel!
    /// 所回复的照片
    @IBOutlet weak var restoreImageView: UIImageView!
    
    var message: MessageList? {
        didSet {
            iconView.sd_setImageWithURL(NSURL(string: message!.avatar!), placeholderImage: UIImage(named: "2.jpg"))
            restorePerson.text = message?.content
            restoreTime.text = message?.create_time
            restoreImageView.sd_setImageWithURL(NSURL(string: message!.image!), placeholderImage: UIImage(named: "2.jpg"))
            println(message?.image)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let x: CGFloat = 9
        let h: CGFloat = 0.5
        let y: CGFloat = self.bounds.height - h
        let w: CGFloat = self.bounds.width - x * 2
        baseline.frame = CGRectMake(x, y, w, h)
    }
    
    // 设置底线
    lazy var baseline: UIView! = {
        var baselineView = UIView()
        baselineView.backgroundColor = UIColor(white: 0xFFFFFF, alpha: 0.3)
        return baselineView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addSubview(baseline)
        iconView.layer.cornerRadius = iconView.bounds.width * 0.5
        iconView.clipsToBounds = true
    }
    
}
