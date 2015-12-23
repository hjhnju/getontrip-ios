//
//  MyCommentTableViewCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/12/23.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class MyCommentTableViewCell: UITableViewCell {

    /// 回复图标
    lazy var iconImageView = UIImageView(image: UIImage(named: "mycomment_icon"))
    
    /// 评论内容
    lazy var contentLabel = UILabel(color: SceneColor.frontBlack, title: "", fontSize: 15, mutiLines: true, fontName: Font.PingFangSCLight)
    
    /// 评论来源文章
    lazy var fromLabel = UILabel(color: SceneColor.thinGrey, title: "", fontSize: 10, mutiLines: true, fontName: Font.PingFangSCLight)
    
    /// 评论时间
    lazy var timeLabel = UILabel(color: SceneColor.whiteGrey, title: "", fontSize: 9, mutiLines: true, fontName: Font.PingFangSCLight)
    
    var dataSource: MyComment? {
        didSet {
            if let data = dataSource {
                contentLabel.text = data.title
                fromLabel.text = data.from
                timeLabel.text = data.time
            }
        }
    }
    
    class func heightWithMyComment(data: MyComment) -> CGFloat {
        let maxWidth = UIScreen.mainScreen().bounds.width - 119
        let titleFont = UIFont(name: Font.PingFangSCLight, size: 15) ?? UIFont(name: Font.ios8Font, size: 15)!
        let fromFont  = UIFont(name: Font.PingFangSCLight, size: 10) ?? UIFont(name: Font.ios8Font, size: 10)!
        return data.title.sizeofStringWithFount1(titleFont, maxSize: CGSizeMake(maxWidth, CGFloat.max)).height +
               data.from.sizeofStringWithFount1(fromFont, maxSize: CGSizeMake(maxWidth, CGFloat.max)).height + 35
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(fromLabel)
        contentView.addSubview(timeLabel)
        contentLabel.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 119
        fromLabel.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 119
        
        iconImageView.ff_AlignInner(.TopLeft, referView: contentView, size: CGSizeMake(28, 29), offset: CGPointMake(9, 19))
        contentLabel.ff_AlignHorizontal(.TopRight, referView: iconImageView, size: nil, offset: CGPointMake(14, 0))
        fromLabel.ff_AlignVertical(.BottomLeft, referView: contentLabel, size: nil, offset: CGPointMake(0, 2))
        timeLabel.ff_AlignInner(.TopRight, referView: contentView, size: nil, offset: CGPointMake(-9, 28))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        
    }
}
