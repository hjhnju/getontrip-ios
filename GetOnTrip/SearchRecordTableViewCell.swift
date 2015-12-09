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
    
    /// 选中背景
    lazy var selectBackgroundView = UIView(color: UIColor(hex: 0xAFAFAF, alpha: 0.3))
    
    /// 基线
    let baseLine: UIView = UIView(color: UIColor(hex: 0xBDBDBD, alpha: 0.15))
    
    /// 删除按钮
    lazy var deleteButton = UIButton(image: "delete_search", title: "", fontSize: 0)
    
    /// 父控制器
    var superController: SearchViewController? 
    
    /// 需要删除的索引
    var index: Int = 0
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(selectBackgroundView)
        contentView.addSubview(deleteButton)
        contentView.addSubview(baseLine)
        textLabel?.textColor = UIColor.whiteColor()
        textLabel?.font = UIFont.systemFontOfSize(16)
        deleteButton.addTarget(self, action: "deleteButtonAction", forControlEvents: .TouchUpInside)
        
        selectBackgroundView.hidden = true
        selectBackgroundView.ff_AlignInner(.CenterCenter, referView: contentView, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 18, 43))
        deleteButton.ff_AlignInner(.CenterRight, referView: contentView, size: CGSizeMake(10, 10), offset: CGPointMake(-9, 0))
        baseLine.ff_AlignInner(.BottomCenter, referView: contentView, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 18, 0.5))
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
        selectBackgroundView.hidden = selected == true ? false : true
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        
    }
    
    func deleteButtonAction() {
        UIView.animateWithDuration(0.5, animations: { [weak self] () -> Void in
            self?.contentView.frame.origin.x = -UIScreen.mainScreen().bounds.width
            }) { [weak self] (_) -> Void in
                self?.removeFromSuperview()
                self?.superController?.recordData.removeAtIndex(self?.index ?? 0)
                self?.superController?.recordTableView.reloadData()
        }
    }
}
