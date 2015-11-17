//
//  Search.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/11/15.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation
import FFAutoLayout

/// 搜索历史cell
class SearchRecordTableViewCell : UITableViewCell {
    
    let baseLine: UIView = UIView(color: SceneColor.shallowGrey, alphaF: 0.2)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(baseLine)
        textLabel?.textColor = UIColor.whiteColor()
        textLabel?.font = UIFont.systemFontOfSize(16)
        
        baseLine.ff_AlignInner(ff_AlignType.TopCenter, referView: self, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 18, 0.5))
        backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame.origin.x = 9
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        
    }
}
