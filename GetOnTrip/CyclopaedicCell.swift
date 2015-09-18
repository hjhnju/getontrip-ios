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
    
    lazy var baseline: UIView! = {
        var baselineView = UIView()
        baselineView.backgroundColor = UIColor(white: 979797, alpha: 0.3)
        return baselineView
    }()
    
    var cyclopaedicModel: Cyclopaedic? {
        didSet {
            self.title.text = cyclopaedicModel!.title
            self.content.text = cyclopaedicModel!.content
            let imageURL = NSURL(string: AppIniOnline.BaseUri + (cyclopaedicModel!.image)!)
            self.iconView?.sd_setImageWithURL(imageURL)
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let x: CGFloat = 9
        let h: CGFloat = 0.5
        let y: CGFloat = self.bounds.height - h
        let w: CGFloat = UIScreen.mainScreen().bounds.width - x * 2
        baseline.frame = CGRectMake(x, y, w, h)
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.addSubview(self.baseline)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
