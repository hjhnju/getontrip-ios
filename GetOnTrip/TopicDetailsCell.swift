//
//  TopicDetailsCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/8/20.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit
import SDWebImage

class TopicDetailsCell: UITableViewCell {

    // 图片
    @IBOutlet weak var iconImage: UIImageView!
    // 标题
    @IBOutlet weak var title: UILabel!
    // 副标题
    @IBOutlet weak var subtitle: UILabel!
    // 描述
    @IBOutlet weak var desc: UILabel!
    // 收集数
    @IBOutlet weak var collect: UIButton!
    // 标签数
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    // 底线
    lazy var baseline: UIView! = {
        var baselineView = UIView()
        baselineView.backgroundColor = UIColor(white: 979797, alpha: 0.3)
        return baselineView
    }()
    
    // 加载数据
    var topicModel: TopicDetails? {
        didSet {
            
            var imageURL = NSURL(string: AppIniOnline.BaseUri + (topicModel!.image))
            self.iconImage?.sd_setImageWithURL(imageURL)
            self.title.text = topicModel!.title
            self.subtitle.text = topicModel!.subtitle
            if topicModel?.subtitle == "" {
                self.desc.numberOfLines = 3
            } else {
                self.desc.numberOfLines = 2
            }
            self.desc.text = topicModel!.desc
            self.collect.setTitle(" " + topicModel!.collect, forState: UIControlState.Normal)
            self.collect.setImage(UIImage(named: "collect"), forState: UIControlState.Normal)
            self.bringSubviewToFront(self.collect)
            self.collect.userInteractionEnabled = false
            self.imageView?.contentMode = UIViewContentMode.ScaleToFill
            
            // TODO:  添加标签（有问题，为什么后面要+那么多的空格，而前面不用加）
            for (var i: NSInteger = 0; i < topicModel?.tags.count; i++ ) {
                var tagsLabel = "" + (topicModel!.tags[i] as! String) as String + "    "
                if (i == 0){
                    label1.hidden = false
                    label1.text = tagsLabel
                    label1.sizeToFit()
                } else if(i == 1){
                    label2.hidden = false
                    label2.text = tagsLabel
                    label2.sizeToFit()
                } else if (i == 2){
                    label3.hidden = false
                    label3.text = tagsLabel
                    label3.sizeToFit()
                } else if(i == 3){
                    label4.hidden = false
                    label4.text = tagsLabel
                    label4.sizeToFit()
                }
                
            }
        }
    }
    
    // cell之间的分隔线
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addSubview(self.baseline)
        var x: CGFloat = 9
        var h: CGFloat = 0.5
        var y: CGFloat = self.bounds.height - h
        var w: CGFloat = UIScreen.mainScreen().bounds.width - x * 2
        baseline.frame = CGRectMake(x, y, w, h)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imageView?.clipsToBounds = true
        collect.setTitleColor(SceneColor.lightGray, forState: UIControlState.Normal)
        self.backgroundColor = UIColor.clearColor()
        
        // 设置圆角
        label1.layer.cornerRadius = 1
        label1.layer.masksToBounds = true
        
        label2.layer.cornerRadius = 1
        label2.layer.masksToBounds = true
        
        label3.layer.cornerRadius = 1
        label3.layer.masksToBounds = true
        
        label4.layer.cornerRadius = 1
        label4.layer.masksToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
