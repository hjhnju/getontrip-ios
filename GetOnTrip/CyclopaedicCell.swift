//
//  CyclopaedicCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/8/20.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class CyclopaedicCell: UITableViewCell {

    
    @IBOutlet weak var title: UILabel!
    
    
    @IBOutlet weak var content: UILabel!
    
    @IBOutlet weak var iconView: UIImageView!
    
    var cyclopaedicModel: Cyclopaedic? {
        didSet {
            self.title.text = cyclopaedicModel!.title
            self.content.text = cyclopaedicModel!.content
            var imageURL = NSURL(string: AppIniOnline.BaseUri + (cyclopaedicModel!.image))
            self.iconView?.sd_setImageWithURL(imageURL)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
