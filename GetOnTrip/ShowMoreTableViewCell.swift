//
//  SearchMore.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/11/15.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation
import FFAutoLayout

/// "显示全部XX"的cell
class ShowMoreTableViewCell: UITableViewCell {
    
    //搜索类型
    var type: Int = SearchType.Content
    
    var showMore: UIButton = UIButton(title: "显示全部景点", fontSize: 12, radius: 0, titleColor: UIColor(hex: 0xFFFFFF, alpha: 0.8))
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clearColor()
        addSubview(showMore)
        
        showMore.ff_AlignInner(ff_AlignType.CenterCenter, referView: self, size: nil, offset: CGPointMake(0, 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        
    }
}
