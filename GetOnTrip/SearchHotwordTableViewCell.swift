//
//  Search.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/11/15.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation
import FFAutoLayout

class SearchHotwordTableViewCell: UITableViewCell {
    
    let baseLine: UIView = UIView(color: SceneColor.shallowGrey, alphaF: 0.2)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(baseLine)
        baseLine.ff_AlignInner(ff_AlignType.TopCenter, referView: self, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 18, 0.5))
        
        backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        
    }
}
