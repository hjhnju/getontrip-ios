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
    
    /// 临时保存进入搜索之前的frame
    var tempUpdateFrame: CGFloat = 0
    
    func updateWidthFrame(w: CGFloat) {
        imageViewW?.constant = w
        textfiledW?.constant = w
        layoutIfNeeded()
    }
    
    func updateCancelButtonShow(isShow: Bool) {
        imageViewW?.constant = isShow ? imageViewW!.constant - 46 : imageViewW!.constant + 46
        textfiledW?.constant = isShow ? textfiledW!.constant - 46 : textfiledW!.constant + 46
//        UIView.animateWithDuration(0.5) { [weak self] () -> Void in
        layoutIfNeeded()
//        }
    }
    
    /// 图片
    lazy var imageView = UIImageView(image: UIImage(named: "search_box"))
    /// 文本框
    lazy var textFile = UITextField(alignment: .Left, sizeFout: 16, color: .whiteColor())
    /// 删除按钮
    lazy var deleteButton = UIButton(image: "delete_clear_hei", title: "", fontSize: 0)
    /// 顶部提示
    lazy var defaultPromptButton: UIButton = UIButton(image: "search_icon", title: " 搜索您想去的景点或城市", fontSize: 12, titleColor: UIColor(hex: 0xFFFFFF, alpha: 0.8), fontName: Font.defaultFont)
    /// 取消按钮
    lazy var clearTextButton: UIButton = UIButton(title: "取消", fontSize: 16, radius: 0, titleColor: UIColor(hex: 0xFFFFFF, alpha: 0.7), fontName: Font.PingFangSCLight)

    var imageViewW: NSLayoutConstraint?
    var textfiledW: NSLayoutConstraint?
    
    var leftView = UIView(frame: CGRectMake(0, 0, 30, 35))
    
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
        clearTextButton.addTarget(self, action: "clearTextButtonAction", forControlEvents: .TouchUpInside)
        
        // 删除按钮
        deleteButton.setImage(UIImage(named: "delete_clear_hei"), forState: .Highlighted)
        textFile.rightView = deleteButton
        textFile.rightViewMode = .WhileEditing
        deleteButton.bounds = CGRectMake(0, 0, 28, 20)
        deleteButton.hidden = true
        deleteButton.addTarget(self, action: "deleteTextFiledTextAction", forControlEvents: .TouchUpInside)
        
        // 文本框
        addSubview(textFile)
        textFile.borderStyle   = .None
        textFile.leftView      = leftView
        textFile.leftViewMode  = .Always
        textFile.rightView     = deleteButton
        textFile.rightViewMode = .Always
        textFile.returnKeyType = .Search
        textFile.autocorrectionType = .Default
        textFile.textColor     = .whiteColor()
        textFile.clearButtonMode = .Always
        
        let ivcons = imageView.ff_AlignInner(.CenterLeft, referView: self, size: CGSizeMake(bounds.width, 35), offset: CGPointMake(9, 0))
        imageViewW = imageView.ff_Constraint(ivcons, attribute: .Width)
        defaultPromptButton.ff_AlignInner(.CenterLeft, referView: self, size: nil, offset: CGPointMake(19, 0))
        clearTextButton.ff_AlignInner(.CenterRight, referView: self, size: nil, offset: CGPointMake(-11, 0))
        let tfcons = textFile.ff_AlignInner(.CenterLeft, referView: self, size: CGSizeMake(bounds.width, 35), offset: CGPointMake(9, 0))
        textfiledW = textFile.ff_Constraint(tfcons, attribute: .Width)
        
        clipsToBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func deleteTextFiledTextAction() {
        textFile.text = ""
        superController?.textfileValueChangedAction(textFile)
    }
    
    /// 点击取消之后调用的方法
    func clearTextButtonAction() {
        clearTextButton.hidden = true
        deleteButton.hidden = true
        textFile.text = ""
//        textfileValueChangedAction()
        
        superController?.textfileValueChangedAction(textFile)
        superController?.isRefreshSearchBar = true
        let vc = superController?.parentViewController as? RecommendViewController
        vc?.isRefreshNavBar = true
        vc?.isSlideMenu = true
        vc?.slideNavButton.hidden = false
        superController?.isEnterSearchController = false
        defaultPromptButton.titleLabel?.alpha = (superController?.parentViewController as? RecommendViewController)?.searchBarTW < 60 ? 0 : 1
        UIView.animateWithDuration(0.5, animations: { [weak self] () -> Void in
            self?.superController?.view.alpha = 0
            self?.textFile.resignFirstResponder()
            self?.superController?.modificationSearchBarFrame()
            self?.updateWidthFrame(((self?.superController?.parentViewController as? RecommendViewController)?.searchBarTW ?? 0) - 60)
            self?.imageViewW?.constant += 46
            self?.textfiledW?.constant += 46
            })
    }

}
