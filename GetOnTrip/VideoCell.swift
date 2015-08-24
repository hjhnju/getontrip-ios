//
//  VideoCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/8/21.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class VideoCell: UITableViewCell {

    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var smallIconView: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    // 合集
    @IBOutlet weak var id: UILabel!
    
    @IBOutlet weak var watchBtn: UIButton!
    
    lazy var baseline: UIView! = {
        var baselineView = UIView()
        baselineView.backgroundColor = UIColor(white: 979797, alpha: 0.3)
        return baselineView
    }()
    
    var videoModel: Video? {
        didSet {
            var imageURL = NSURL(string: AppIniOnline.BaseUri + (videoModel!.image))
            self.iconView?.sd_setImageWithURL(imageURL)
            self.title.text = videoModel!.title
            self.id.text = "合集: 共\(videoModel!.id)集"
        }
    }

    
    // TODO: 点击观看
    func touchUpInsideWatch(sender: AnyObject) {
        print("正在跳转请稍候")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        watchBtn.layer.masksToBounds = true
        watchBtn.layer.cornerRadius = 12.0
        watchBtn.layer.borderWidth = 1.0
        watchBtn.layer.borderColor = UIColor.yellowColor().CGColor
        watchBtn.addTarget(self, action: "touchUpInsideWatch:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.addSubview(self.baseline)
        var x: CGFloat = 9
        var h: CGFloat = 0.5
        var y: CGFloat = CGRectGetMaxY(self.frame) + CGFloat(h)
        var w: CGFloat = UIScreen.mainScreen().bounds.width - x * 2
        baseline.frame = CGRectMake(x, y, w, h)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    

}
