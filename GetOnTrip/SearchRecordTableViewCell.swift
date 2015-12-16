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
    lazy var deleteButton: SearchDeleteButton = SearchDeleteButton(image: "delete_search", title: "", fontSize: 0)
    
    /// 父控制器
    var superController: SearchViewController? 
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        contentView.addSubview(selectBackgroundView)
        contentView.addSubview(deleteButton)
        contentView.addSubview(baseLine)
        textLabel?.textColor = UIColor.whiteColor()
        
        if #available(iOS 9.0, *) {
            textLabel?.font = UIFont(name: Font.PingFangSCLight, size: 16)
        } else {
            textLabel?.font = UIFont(name: Font.ios8Font, size: 16)
        }
        
        deleteButton.addTarget(self, action: "deleteButtonAction", forControlEvents: .TouchUpInside)
        
        selectBackgroundView.hidden = true
        selectBackgroundView.ff_AlignInner(.CenterCenter, referView: contentView, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 18, 50))
        deleteButton.ff_AlignInner(.CenterRight, referView: contentView, size: CGSizeMake(47, 47), offset: CGPointMake(0, 0))
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

    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        selectBackgroundView.hidden = highlighted == true ? false : true
    }
    
    func deleteButtonAction() {
        
        let index = superController?.recordData.indexOf(textLabel?.text ?? "") ?? 0
        self.superController?.recordData.removeAtIndex(index )
        self.superController?.recordTableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Top)
    }
}
