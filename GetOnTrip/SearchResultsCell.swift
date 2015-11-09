//
//  SearchResultsCell.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/8/7.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

class SearchResultsCell: UITableViewCell {


    lazy var resultImageView: UIImageView = UIImageView(image: UIImage(named: "default-topic"))

    lazy var resultTitleLabel: UILabel = UILabel(color: UIColor.whiteColor(), title: "长安", fontSize: 16, mutiLines: false)
    
    lazy var resultDescLabel: UILabel = UILabel(color: UIColor(hex: 0xFFFFFF, alpha: 0.6), title: "5景点，210个话题", fontSize: 13, mutiLines: true)
    
    lazy var baseLine: UIView = UIView(color: SceneColor.shallowGrey, alphaF: 0.2)
    
    var playImage: UIImageView = UIImageView(image: UIImage(named: "Play_icon"))
    
    var searchCruxCharacter: String = ""
    
    /// 图书背景cell
    var groundView: UIImageView = UIImageView()
    
    var resultImageViewHeight : NSLayoutConstraint?
    
    func searchCruxCharacterAction(title: String, titleColor: UIColor) -> NSAttributedString {
        
        let attr = NSMutableAttributedString(string: title)
        var tempString = title
        var range = (title as NSString).rangeOfString(searchCruxCharacter)
        
        var location = 0
        
        while range.length > 0 {
            
            attr.addAttribute(NSForegroundColorAttributeName, value: titleColor, range: NSMakeRange(location + range.location, range.length))
            location += range.location + range.length
            let temp = NSString(string: tempString).substringWithRange((NSMakeRange(range.location + range.length, (title as NSString).length - location)))
            tempString = temp
            range = NSString(string: temp).rangeOfString(searchCruxCharacter)
        }

        
        return attr
    }
    
    var searchResult: SearchResult? {
        didSet {
            resultImageView.sd_setImageWithURL(NSURL(string: searchResult?.image ?? ""), placeholderImage: PlaceholderImage.defaultSmall)
            resultTitleLabel.attributedText = searchCruxCharacterAction(searchResult?.name ?? "", titleColor: SceneColor.lightYellow)
            resultDescLabel.attributedText = searchCruxCharacterAction(searchResult?.desc ?? "", titleColor: UIColor(hex: 0xF3FD54, alpha: 0.6))
        }
    }
    
    var searchContent: SearchContent? {
        didSet {
            resultTitleLabel.attributedText = searchCruxCharacterAction(searchContent?.title ?? "", titleColor: SceneColor.lightYellow)
            resultDescLabel.attributedText = searchCruxCharacterAction((searchContent?.content)!, titleColor: UIColor(hex: 0xF3FD54, alpha: 0.6))
            
            if searchContent?.search_type == "video" {
                playImage.hidden = false
            } else {
                playImage.hidden = true
            }
            
            
            if searchContent?.search_type == "book" {
                resultImageViewHeight?.constant = 48
                resultImageView.image = UIImage()
                resultImageView.backgroundColor = UIColor.whiteColor()
                groundView.sd_setImageWithURL(NSURL(string: searchResult?.image ?? ""), placeholderImage: PlaceholderImage.defaultSmall)
                groundView.hidden = false
            } else {
                resultImageViewHeight?.constant = 37
                groundView.hidden = true
                resultImageView.sd_setImageWithURL(NSURL(string: searchContent?.image ?? ""), placeholderImage: PlaceholderImage.defaultSmall)
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(resultTitleLabel)
        addSubview(resultDescLabel)
        addSubview(baseLine)
        playImage.hidden = true
        backgroundColor = UIColor.clearColor()
        rewriteProperty()
        addSubview(groundView)
        addSubview(playImage)
        setupAutoLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    ///  让子类来重写，所以只放需要更改的设置
    private func rewriteProperty() {
        addSubview(resultImageView)
        let cons = resultImageView.ff_AlignInner(ff_AlignType.CenterLeft, referView: self, size: CGSizeMake(52, 37), offset: CGPointMake(9, 0))
        resultImageViewHeight = resultImageView.ff_Constraint(cons, attribute: NSLayoutAttribute.Height)
    }
    
    private func setupAutoLayout() {
        
        let w: CGFloat = UIScreen.mainScreen().bounds.width - 18 - 52 - 6
        resultTitleLabel.ff_AlignHorizontal(ff_AlignType.TopRight, referView: resultImageView, size: CGSizeMake(w, 16), offset: CGPointMake(6, 0))
        resultDescLabel.ff_AlignHorizontal(ff_AlignType.BottomRight, referView: resultImageView, size: CGSizeMake(w, 13), offset: CGPointMake(6, 0))
        baseLine.ff_AlignInner(ff_AlignType.TopCenter, referView: self, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 20, 0.5))
        playImage.ff_AlignInner(ff_AlignType.CenterCenter, referView: resultImageView, size: nil)
        groundView.ff_AlignInner(ff_AlignType.CenterCenter, referView: resultImageView, size: CGSizeMake(31, 44), offset: CGPointMake(0, 0))
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        
    }
}

 /// 内容图书cell 
class SearchResultsBookCell: SearchResultsCell {
    
    
    
    private override func rewriteProperty() {
        addSubview(groundView)
        groundView.addSubview(resultImageView)
        groundView.ff_AlignInner(ff_AlignType.CenterLeft, referView: self, size: CGSizeMake(52, 37), offset: CGPointMake(9, 0))
        resultImageView.ff_AlignInner(ff_AlignType.CenterCenter, referView: groundView, size: CGSizeMake(31, 44))
    }
    
    private override func setupAutoLayout() {
        let w: CGFloat = UIScreen.mainScreen().bounds.width - 18 - 52 - 6
        resultTitleLabel.ff_AlignHorizontal(ff_AlignType.TopRight, referView: groundView, size: CGSizeMake(w, 16), offset: CGPointMake(6, 0))
        resultDescLabel.ff_AlignHorizontal(ff_AlignType.BottomRight, referView: groundView, size: CGSizeMake(w, 13), offset: CGPointMake(6, 0))
        baseLine.ff_AlignInner(ff_AlignType.TopCenter, referView: self, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 20, 0.5))
        playImage.ff_AlignInner(ff_AlignType.CenterCenter, referView: groundView, size: nil)
    }
    
}

/// 显示更多的cell
class ShowMoreTableViewCell: UITableViewCell {
    
    let showMore: UIButton = UIButton(title: "显示全部景点", fontSize: 12, radius: 0, titleColor: UIColor(hex: 0xFFFFFF, alpha: 0.8))
    
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
