
//
//  CommentTableViewCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/11/17.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

class CommentTableViewCell : UITableViewCell {
    
    lazy var iconView: UIImageView = UIImageView()
    
    lazy var titleName: UILabel = UILabel(color: SceneColor.bgBlack, title: "Clara J", fontSize: 14, mutiLines: true)
    
    lazy var content: UILabel = UILabel(color: SceneColor.fontGray, title: "真的假的，我倒是挺想看看有什么好玩的，真的么，太好咯哈哈哈哈哈哈哈哈真有那么神奇的时期...", fontSize: 12, mutiLines: true)
    
    lazy var time: UILabel = UILabel(color: UIColor(hex: 0x696969, alpha: 0.5), title: "1年前", fontSize: 8, mutiLines: true)
    
    lazy var answerLabel: UILabel = UILabel(color: UIColor(hex: 0x696969, alpha: 0.5), title: "回复", fontSize: 8, mutiLines: true)
    
    /// 其他人评论底部view
    lazy var commentAnswersView: UIView = UIView(color: UIColor(hex: 0x696969, alpha: 0.2))
    
    lazy var baseLine = UIView(color: SceneColor.lightGray, alphaF: 0.5)
    
    var answerCommentViewHeight: NSLayoutConstraint?
    
    var data: CommentList? {
        didSet {
            iconView.sd_setImageWithURL(NSURL(string: data!.avatar)!, placeholderImage:PlaceholderImage.defaultSmall)
            titleName.text = data!.from_name
            content.text = data!.content
            time.text = data!.create_time
            
            if data?.to_name == "" {
                answerLabel.hidden = true
            } else {
                answerLabel.hidden = false
            }
            var y: CGFloat = 8
            let w: CGFloat = UIScreen.mainScreen().bounds.width - 75 - 24
            var index: Int = 0
            for item in data!.sub_Comment {
                let commentPerson = commentPersonButton()
                commentAnswersView.addSubview(commentPerson)
                commentPerson.upId = String(data!.id)
                commentPerson.to_name = item.to_name
                commentPerson.from_name = item.from_name
                commentPerson.frameUserId = item.from_user_id
                commentPerson.titleLabel.numberOfLines = 0
                commentPerson.index = index
//                commentPerson.titleLabel.lineBreakMode = NSLineBreakMode.ByCharWrapping
                commentPerson.titleLabel.text = (" " + item.from_name + " 回复 :" + item.to_name + " " + item.content)
                let size = (" " + item.from_name + " 回复 :" + item.to_name + " " + item.content).sizeofStringWithFount(UIFont.systemFontOfSize(11), maxSize: CGSizeMake(w, CGFloat.max))
                
//                commentPerson.setAttributedTitle(schemeAttributedString(item.from_name, toName: item.to_name, content: item.content), forState: UIControlState.Normal)
//                commentPerson.titleLabel.attributedText = schemeAttributedString(item.from_name, toName: item.to_name, content: item.content)
                commentPerson.frame = CGRectMake(12, y, size.width, size.height)
                y += size.height
                index++
            }
            
            var str = ""
            for i in data!.sub_Comment {
                str = str + i.from_name + "   回复 :" + i.to_name + i.content + "\n"
            }
            answerCommentViewHeight!.constant = str.sizeofStringWithFount(UIFont.systemFontOfSize(11), maxSize: CGSizeMake(UIScreen.mainScreen().bounds.width - 75 - 24, CGFloat.max)).height + 16 + CGFloat(2 * (data!.sub_Comment.count - 1))
            if data?.sub_Comment.count == 0 {
                commentAnswersView.hidden = true
            }
        }
    }
    
    func schemeAttributedString(fromName: String, toName: String, content: String) -> NSAttributedString {
        
        let attrStr = NSString(string: " " + fromName + " 回复 " + toName + " :" + content)
        let attr    = NSMutableAttributedString(string: attrStr as String)
        let comment = attrStr.rangeOfString(" " + fromName)
        let comMess = attrStr.rangeOfString(" 回复 ")
        let attrN   = attrStr.rangeOfString(toName + " :")
        let content = attrStr.rangeOfString(" " + content)
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 8
        style.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        attr.addAttribute(NSForegroundColorAttributeName, value: SceneColor.fontGray, range: comMess)
        attr.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: comment)
        attr.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: attrN)
        attr.addAttribute(NSForegroundColorAttributeName, value: SceneColor.fontGray, range: content)
        attr.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSMakeRange(0, attr.length))
        attr.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(11), range: NSMakeRange(0, attr.length))
        
        return attr
    }
    
    func dataWithCellHeight(comment: CommentList) -> CGFloat {
        
        var str = ""
        for i in comment.sub_Comment {
            str = str + i.from_name + "   回复 :" + i.to_name + i.content + "\n"
        }
        
        var height =  40 + 16 + 9 + comment.content.sizeofStringWithFount(UIFont.systemFontOfSize(11), maxSize: CGSizeMake(UIScreen.mainScreen().bounds.width - 75, CGFloat.max)).height + str.sizeofStringWithFount(UIFont.systemFontOfSize(11), maxSize: CGSizeMake(UIScreen.mainScreen().bounds.width - 75 - 24, CGFloat.max)).height + 16 + CGFloat(2 * (comment.sub_Comment.count - 1))
        if comment.sub_Comment.count == 0 {
            height = height - 16
        }
        
        return height
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
        addSubview(iconView)
        addSubview(titleName)
        addSubview(content)
        addSubview(time)
        addSubview(answerLabel)
        addSubview(commentAnswersView)
        addSubview(baseLine)
        content.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 75
        iconView.contentMode = UIViewContentMode.ScaleAspectFill
        iconView.clipsToBounds = true
    }
    
    private func setAutoLayout() {
        iconView.ff_AlignInner(ff_AlignType.TopLeft, referView: self, size: CGSizeMake(44, 44), offset: CGPointMake(11, 14))
        titleName.ff_AlignHorizontal(ff_AlignType.TopRight, referView: iconView, size: nil, offset: CGPointMake(10, 0))
        content.ff_AlignVertical(ff_AlignType.BottomLeft, referView: titleName, size: nil, offset: CGPointMake(0, 4))
        time.ff_AlignInner(ff_AlignType.TopRight, referView: self, size: nil, offset: CGPointMake(-9, 23))
        answerLabel.ff_AlignHorizontal(ff_AlignType.CenterRight, referView: titleName, size: nil, offset: CGPointMake(6, 0))
        let cons = commentAnswersView.ff_AlignVertical(ff_AlignType.BottomLeft, referView: content, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 75, 0), offset: CGPointMake(0, 7))
        answerCommentViewHeight = commentAnswersView.ff_Constraint(cons, attribute: NSLayoutAttribute.Height)
        baseLine.ff_AlignInner(ff_AlignType.BottomCenter, referView: self, size: CGSizeMake(UIScreen.mainScreen().bounds.width, 0.5), offset: CGPointMake(0, 0))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconView.layer.cornerRadius = min(iconView.bounds.width, iconView.bounds.height) * 0.5
        iconView.clipsToBounds = true
    }
}


