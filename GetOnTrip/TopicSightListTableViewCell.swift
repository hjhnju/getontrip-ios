//
//  TopicSightListTableViewCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/11/30.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class TopicSightListTableViewCell: UITableViewCell {

    /// 景点名称
    lazy var sightName = UILabel(color: SceneColor.darkYellows, title: "", fontSize: 20, mutiLines: false)
    
    var data: [String : String]? {
        didSet {
            sightName.text = data?["name"] ?? ""
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clearColor()
        addSubview(sightName)
        sightName.ff_AlignInner(.CenterCenter, referView: self, size: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(selected: Bool, animated: Bool) {

    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        
    }
}
