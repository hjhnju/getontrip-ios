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
    
    var videoModel: Video? {
        didSet {
            var imageURL = NSURL(string: AppIniOnline.BaseUri + (videoModel!.image))
            self.iconView?.sd_setImageWithURL(imageURL)
            self.title.text = videoModel!.title
            self.id.text = "合集: 共\(self.id)集"
        }
    }
    
    // TODO: 点击观看
    @IBAction func touchUpInsideWatch(sender: AnyObject) {
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
