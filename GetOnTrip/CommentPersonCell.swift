
//
//  CommentPersonCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/11/26.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class CommentPersonCell: UITableViewCell {
    
    /// 评论人
    lazy var replayButton: ReplayButton = ReplayButton(title: "Clara J:", fontSize: 11, radius: 0, titleColor: SceneColor.fontGray)
    
    var data: Comment? {
        didSet {
            if let data = data {
                replayButton.upId = String(data.id)
                replayButton.to_name = data.to_name
                replayButton.from_name = data.from_name
                replayButton.frameUserId = data.from_user_id
                replayButton.titleLabel?.numberOfLines = 0
                replayButton.setAttributedTitle(schemeAttributedString(data.from_name, toName: data.to_name, content: data.content), forState: .Normal)
                let h = CommentPersonCell.dataWithRowHeight(data)
                replayButton.frame = CGRectMake(12, 7, UIScreen.mainScreen().bounds.width - 75 - 24, h)
            }
        }
    }
    
    // 根据数据返回对应行高
    class func dataWithRowHeight(data: Comment) -> CGFloat {
        let w: CGFloat = UIScreen.mainScreen().bounds.width - 75 - 24
        let size = (" " + data.from_name + " 回复 : " + data.to_name + " " + data.content).sizeofStringWithFount(UIFont.systemFontOfSize(11), maxSize: CGSizeMake(w, CGFloat.max))
        return size.height + 7
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(replayButton)
        
        backgroundColor = UIColor.clearColor()
        replayButton.titleLabel?.preferredMaxLayoutWidth = 100
        replayButton.titleLabel?.numberOfLines = 0
        replayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func schemeAttributedString(fromName: String, toName: String, content: String) -> NSAttributedString {
        
        let attrStr = NSString(string: " " + fromName + " 回复 " + toName + " : " + content)
        let attr    = NSMutableAttributedString(string: attrStr as String)
        let comment = attrStr.rangeOfString(" " + fromName)
        let comMess = attrStr.rangeOfString(" 回复 ")
        let attrN   = attrStr.rangeOfString(toName + " :")
        let content = attrStr.rangeOfString(" " + content)
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 7
        style.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        attr.addAttribute(NSForegroundColorAttributeName, value: SceneColor.fontGray, range: comMess)
        attr.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: comment)
        attr.addAttribute(NSForegroundColorAttributeName, value: SceneColor.fontGray, range: attrN)
        attr.addAttribute(NSForegroundColorAttributeName, value: SceneColor.fontGray, range: content)
        attr.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSMakeRange(0, attr.length))
        attr.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(11), range: NSMakeRange(0, attr.length))
        
        return attr
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        
    }
}
