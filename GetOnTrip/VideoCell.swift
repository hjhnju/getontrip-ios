//
//  VideoCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/8/21.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

struct VideoCellContant {
    static let CellHeight:CGFloat = 200
}

class VideoCell: UITableViewCell {

    lazy var iconView: UIImageView = UIImageView()
    
    //故宫至宝
    lazy var titleLabel: UILabel = UILabel(color: UIColor.whiteColor(), title: "", fontSize: 18, mutiLines: true)
    
    //时长：2小时
    lazy var timeLabel: UILabel = UILabel(color: UIColor(hex: 0xFFFFFF, alpha: 0.5), title: "", fontSize: 12, mutiLines: true)
    
    lazy var watchBtn: UIButton = UIButton(title: "点击观看", fontSize: 12, radius: 12, titleColor: UIColor.yellowColor())
    
    lazy var bottomLine: UIView = UIView(color: UIColor.whiteColor())
    
    var video: Video? {
        didSet {
            if let video = video {
                //TODO: 2g/3g情况不加载网络图片
                iconView.backgroundColor = video.bgColor
                iconView.sd_setImageWithURL(NSURL(string: video.image))
                if video.isAlbum() {
                    iconView.contentMode = UIViewContentMode.ScaleAspectFit
                } else {
                    iconView.contentMode = UIViewContentMode.ScaleAspectFill
                }
                titleLabel.text = video.title
                timeLabel.text = video.len
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.blackColor()
        initView()
        setupAutoLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        
        addSubview(iconView)
        addSubview(titleLabel)
        addSubview(timeLabel)
        addSubview(watchBtn)
        addSubview(bottomLine)

        titleLabel.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 80
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = NSTextAlignment.Center
        
        watchBtn.layer.borderWidth = 1.0
        watchBtn.layer.borderColor = UIColor.yellowColor().CGColor
        iconView.contentMode       = UIViewContentMode.ScaleToFill
        iconView.clipsToBounds     = true
    }
    
    private func setupAutoLayout() {
        
        iconView.ff_AlignInner(.TopLeft, referView: self, size: CGSizeMake(UIScreen.mainScreen().bounds.width, VideoCellContant.CellHeight - 1))
        timeLabel.ff_AlignInner(.TopLeft, referView: self, size: nil, offset: CGPointMake(19, 9))
        titleLabel.ff_AlignInner(.CenterCenter, referView: self, size: nil, offset: CGPointMake(0, 0))
        watchBtn.ff_AlignVertical(.BottomCenter, referView: titleLabel, size: CGSizeMake(83, 28), offset: CGPointMake(0, 7))
        bottomLine.ff_AlignInner(.BottomLeft, referView: self, size: CGSizeMake(UIScreen.mainScreen().bounds.width, 1))
        
        //添加一个灰色蒙板
        let maskView = UIView(color: SceneColor.bgBlack, alphaF: 0.55)
        iconView.addSubview(maskView)
        maskView.ff_Fill(iconView)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        
    }
}
