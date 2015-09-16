//
//  SendCommentCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/8/31.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class SendCommentCell: UITableViewCell {

    // 头像
    @IBOutlet weak var iconView: UIImageView!
    // 姓名
    @IBOutlet weak var name: UILabel!
    // 内容
    @IBOutlet weak var content: UILabel!
    // 发布时间
    @IBOutlet weak var create_tiem: UILabel!
    // 对话内容
    @IBOutlet weak var dialogContent: UILabel!
    
    // 设置底线
    lazy var baseline: UIView! = {
        var baselineView = UIView()
        baselineView.backgroundColor = UIColor(hex: 0x9C9C9C, alpha: 0.5)
        return baselineView
    }()
    
    var rowHeight: CGFloat?
    var sendCommentModel: SendComment? {
        didSet {
            
            iconView.sd_setImageWithURL(NSURL(string: sendCommentModel!.avatar!))
            name.text = sendCommentModel?.from_name
            content.text = sendCommentModel?.content
            create_tiem.text = sendCommentModel?.create_time
            
            for subComment in sendCommentModel!.subComment {
                
            }
            
            var text: String = ""
            for subComment in sendCommentModel!.subComment {
                text += (subComment.from_name! + ":" + subComment.content! + "\n" + subComment.to_name! + "回复")
            }
            dialogContent.text = text
            
            if text != "" {
                rowHeight = CGRectGetMaxY(dialogContent.frame) + CGFloat(23)
            } else {
                rowHeight = max(CGRectGetMaxY(iconView.frame), CGRectGetMaxY(content.frame)) + CGFloat(15)
            }
            
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var x: CGFloat = 0
        var h: CGFloat = 0.5
        var y: CGFloat = self.bounds.height - 0.5
        var w: CGFloat = self.bounds.width
        baseline.frame = CGRectMake(x, y, w, h)

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.addSubview(baseline)
        iconView.layer.masksToBounds = true
        iconView.layer.cornerRadius = iconView.bounds.width * 0.5
        dialogContent.preferredMaxLayoutWidth = 300
    }
}
