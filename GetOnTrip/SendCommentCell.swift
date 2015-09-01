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
    
    var sendCommentModel: SendComment? {
        didSet {
            
            iconView.sd_setImageWithURL(NSURL(string: sendCommentModel!.avatar!))
            name.text = sendCommentModel?.from_name
            content.text = sendCommentModel?.content
            create_tiem.text = sendCommentModel?.create_time
            
            let array = sendCommentModel?.subComment!
            var text: String = ""
            for it in array! {
                var sendSub = it as! SendComment_SubComment
                text.append(sendSub.from_name? + ":" + sendSub.content? + "\n" + sendSub.to_name? + "回复") as! String
            }
            dialogContent.text = text
        }
    }
    
    func rowHeight(text: String) -> CGFloat {
        dialogContent.text = text
//        layoutIfNeeded()
        dialogContent.text = "aladksjnaljkdn;alksj"
        return CGRectGetMaxY(dialogContent.frame) + CGFloat(23)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        iconView.layer.masksToBounds = true
        iconView.layer.cornerRadius = iconView.bounds.width * 0.5
        dialogContent.preferredMaxLayoutWidth = 300
    }
    
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
