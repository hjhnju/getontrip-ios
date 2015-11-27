//
//  CommentTableViewCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/11/17.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

class CommentTableViewCell : UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    /// 头像
    lazy var iconViewImageView = UIImageView()
    /// 评论人名
    lazy var nameLabel         = UILabel(color: SceneColor.bgBlack, title: "Clara J", fontSize: 14, mutiLines: true)
    /// 评论内容
    lazy var contentLabel      = UILabel(color: SceneColor.fontGray, title: "真的假的，我倒是挺想看看有什么好玩的，真的么，太好咯哈哈哈哈哈哈哈哈真有那么神奇的时期...", fontSize: 12, mutiLines: true)
    /// 评论时间
    lazy var timeLabel         = UILabel(color: UIColor(hex: 0x696969, alpha: 0.5), title: "1年前", fontSize: 8, mutiLines: true)
    /// 回复显示
    lazy var answerLabel       = UILabel(color: UIColor(hex: 0x696969, alpha: 0.5), title: "回复", fontSize: 8, mutiLines: true)
    /// 底线
    lazy var baseLineView = UIView(color: SceneColor.lightGray, alphaF: 0.5)
    /// 他人回复底部
    var commentTableView: UITableView = {
        let tab = UITableView()
        tab.registerClass(CommentPersonCell.self, forCellReuseIdentifier: "CommentPersonCell")
        return tab
    }()
    
    var dataSource: [Comment] = [Comment]()
    
    var comTableCons: NSLayoutConstraint?
    
    var timeXCons: NSLayoutConstraint?
    
    var data: Comment = Comment(id: "") {
        didSet {
            
            if let nsurl = NSURL(string: data.avatar) {
                iconViewImageView.sd_setImageWithURL(nsurl, placeholderImage:PlaceholderImage.defaultSmall)
            }
            nameLabel.text = data.from_name
            contentLabel.attributedText = data.content.getAttributedString(0, lineSpacing: 8, breakMode: NSLineBreakMode.ByTruncatingTail)
            timeLabel.text = data.create_time
            if data.sub_Comment.count == 0 {
                commentTableView.hidden = true
            } else {
                commentTableView.hidden = false
                dataSource = data.sub_Comment
                var comH: CGFloat = 0
                for i in data.sub_Comment {
                    comH += CommentPersonCell.dataWithRowHeight(i)
                }
                comTableCons?.constant = comH + 7
                commentTableView.reloadData()
            }
        }
    }
    
    class func dataWithCellHeight(comment: Comment) -> CGFloat {
        
        let screen = UIScreen.mainScreen().bounds
        var h: CGFloat = 0
        let iconMaxY: CGFloat = 58
        let contentY: CGFloat = 40 + comment.content.sizeofStringWithFount(UIFont.systemFontOfSize(12), maxSize: CGSizeMake(screen.width - 67, CGFloat.max)).height
        h = max(iconMaxY, contentY) + (iconMaxY >= contentY ? 14 : 10)
        
        if comment.sub_Comment.count == 0 {
            return h
        } else {
            var comH: CGFloat = 0
            for i in comment.sub_Comment {
                comH += CommentPersonCell.dataWithRowHeight(i)
            }
            return h + comH + 14
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupAddProperty()
        setAutoLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupAddProperty() {
        addSubview(iconViewImageView)
        addSubview(nameLabel)
        addSubview(contentLabel)
        addSubview(timeLabel)
        addSubview(answerLabel)
        addSubview(baseLineView)
        contentLabel.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 75
        iconViewImageView.contentMode = .ScaleAspectFill
        iconViewImageView.clipsToBounds = true
        
        addSubview(commentTableView)
        commentTableView.separatorStyle = .None
        commentTableView.bounces    = false
        commentTableView.dataSource = self
        commentTableView.delegate   = self
        commentTableView.registerClass(CommentPersonCell.self, forCellReuseIdentifier: "CommentPersonCell")
        commentTableView.backgroundColor = UIColor(hex: 0xA6A6A6, alpha: 0.2)
    }
    
    private func setAutoLayout() {
        iconViewImageView.ff_AlignInner(.TopLeft, referView: self, size: CGSizeMake(44, 44), offset: CGPointMake(11, 14))
        nameLabel.ff_AlignHorizontal(.TopRight, referView: iconViewImageView, size: nil, offset: CGPointMake(10, 0))
        contentLabel.ff_AlignVertical(.BottomLeft, referView: nameLabel, size: nil, offset: CGPointMake(0, 4))
        answerLabel.ff_AlignHorizontal(.BottomRight, referView: nameLabel, size: nil, offset: CGPointMake(6, 0))
        let tcons = timeLabel.ff_AlignHorizontal(.CenterRight, referView: answerLabel, size: nil, offset: CGPointMake(0, 0))
        baseLineView.ff_AlignInner(.BottomCenter, referView: self, size: CGSizeMake(UIScreen.mainScreen().bounds.width, 0.5), offset: CGPointMake(0, 0))
        let cons  = commentTableView.ff_AlignVertical(.BottomLeft, referView: contentLabel, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 75, 0), offset: CGPointMake(0, 4))
        comTableCons = commentTableView.ff_Constraint(cons, attribute: .Height)
        timeXCons = timeLabel.ff_Constraint(tcons, attribute: .Left)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconViewImageView.layer.cornerRadius = min(iconViewImageView.bounds.width, iconViewImageView.bounds.height) * 0.5
        iconViewImageView.clipsToBounds = true
        timeXCons?.constant = UIScreen.mainScreen().bounds.width - CGRectGetMaxX(answerLabel.frame) - timeLabel.bounds.width - 9
    }
    
    // MARK: - tableView delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CommentPersonCell", forIndexPath: indexPath) as! CommentPersonCell
        cell.data = dataSource[indexPath.row]
        cell.replayButton.index = indexPath.row
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var h: CGFloat = CommentPersonCell.dataWithRowHeight(dataSource[indexPath.row])
        if dataSource.count == indexPath.row - 1 && dataSource.count != 0 {
            h += 7
        }
        return h
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let vc = ControllerTools.parentViewController(self, viewController: "CommentViewController") as? CommentViewController
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! CommentPersonCell
        cell.replayButton.addTarget(vc, action: "touchReplyCommentAction:", forControlEvents: .TouchUpInside)
        cell.replayButton.indexPath = indexPath
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {

    }
}


