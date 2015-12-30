//
//  SearchBar.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/12/30.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class SearchBar: UIView {

    weak var superController: SearchViewController?
    
    var tempUpdateFrame: CGFloat = 0
    
    func updateWidthFrame(w: CGFloat) {
        imageViewW?.constant = w - 9
        textfiledW?.constant = w - 9
        layoutIfNeeded()
    }
    
    func updateCancelButtonShow(isShow: Bool) {
        imageViewW?.constant = isShow ? imageViewW!.constant - 46 : imageViewW!.constant + 46
        textfiledW?.constant = isShow ? imageViewW!.constant - 46 : imageViewW!.constant + 46
        UIView.animateWithDuration(0.5) { [weak self] () -> Void in
            self?.layoutIfNeeded()
        }
    }
    
    /// 图片
    lazy var imageView = UIImageView(image: UIImage(named: "search_box"))
    /// 文本框
    lazy var textFile = UITextField(alignment: .Left, sizeFout: 16, color: .whiteColor())
    /// 删除按钮
    lazy var deleteButton = UIButton(image: "delete_searchBar", title: "", fontSize: 0)
    /// 顶部提示
    lazy var defaultPromptButton: UIButton = UIButton(image: "search_icon", title: "  搜索城市、景点等内容", fontSize: 14, titleColor: UIColor(hex: 0xFFFFFF, alpha: 0.3), fontName: Font.defaultFont)
    /// 取消按钮
    lazy var clearTextButton: UIButton = UIButton(title: "取消", fontSize: 16, radius: 0, titleColor: UIColor(hex: 0xFFFFFF, alpha: 0.7), fontName: Font.PingFangSCLight)

    var imageViewW: NSLayoutConstraint?
    var textfiledW: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 底图
        addSubview(imageView)
        
        // 提示框
        addSubview(defaultPromptButton)
        defaultPromptButton.enabled = false
        defaultPromptButton.setImage(UIImage(named: "search_icon"), forState: .Disabled)
        
        // 取消按钮
        addSubview(clearTextButton)
        clearTextButton.hidden = true
        clearTextButton.addTarget(self, action: "clearTextButtonAction", forControlEvents: UIControlEvents.TouchUpInside)
        
        // 删除按钮
        deleteButton.setImage(UIImage(named: "delete_clear_hei"), forState: .Highlighted)
        textFile.rightView = deleteButton
        textFile.rightViewMode = .WhileEditing
        
        // 文本框
        addSubview(textFile)
        textFile.borderStyle   = .None
        textFile.leftView      = UIView(frame: CGRectMake(0, 0, 27, 35))
        textFile.leftViewMode  = .Always
        textFile.rightView     = deleteButton
        textFile.rightViewMode = .Always
        textFile.returnKeyType = .Search
        textFile.addTarget(self, action: "textEditingDidBegin:", forControlEvents: UIControlEvents.EditingDidBegin)
        textFile.addTarget(self, action: "textValueChanged", forControlEvents: UIControlEvents.ValueChanged)
        
        let ivcons = imageView.ff_AlignInner(.CenterLeft, referView: self, size: CGSizeMake(bounds.width, 35), offset: CGPointMake(9, 0))
        imageViewW = imageView.ff_Constraint(ivcons, attribute: .Width)
        defaultPromptButton.ff_AlignInner(.CenterLeft, referView: self, size: nil, offset: CGPointMake(20, 0))
        clearTextButton.ff_AlignInner(.CenterRight, referView: self, size: nil, offset: CGPointMake(-11, 0))
        let tfcons = textFile.ff_AlignInner(.CenterLeft, referView: self, size: CGSizeMake(bounds.width, 35), offset: CGPointMake(9, 0))
        textfiledW = textFile.ff_Constraint(tfcons, attribute: .Width)
        
        clipsToBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func textEditingDidBegin(textfiled: UITextField) {
        clearTextButton.hidden = false
        updateCancelButtonShow(true)
    }
    
    /// 值改变
    func textValueChanged(textfiled: UITextField) {
        defaultPromptButton.titleLabel?.hidden = textfiled.text == "" ? false : true
    }
    
    func clearTextButtonAction() {
        UIView.animateWithDuration(0.5, animations: { [weak self] () -> Void in
            self?.superController?.view.alpha = 0
            self?.textFile.resignFirstResponder()
            self?.superController?.modificationSearchBarFrame()
            self?.updateWidthFrame(self?.tempUpdateFrame ?? 0)
            }) { [weak self] (_) -> Void in
                self?.updateCancelButtonShow(false)
                self?.clearTextButton.hidden = true
        }
    }
}
