//
//  SearchResultsCell.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/8/7.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

struct SearchResultCellContant {
    static let bookImageHeight: CGFloat   = 48
    static let normalImageHeight: CGFloat = 37
}

class SearchResultsCell: UITableViewCell {

    lazy var resultImageView: UIImageView = UIImageView(image: UIImage(named: "default-topic"))

    lazy var resultTitleLabel: UILabel = UILabel(color: UIColor.whiteColor(), title: "长安", fontSize: 16, mutiLines: false)
    
    lazy var resultDescLabel: UILabel = UILabel(color: UIColor(hex: 0xFFFFFF, alpha: 0.6), title: "5景点，210个话题", fontSize: 13, mutiLines: true)
    
    lazy var baseLine: UIView = UIView(color: SceneColor.shallowGrey, alphaF: 0.2)
    
    var playImage: UIImageView = UIImageView(image: UIImage(named: "search_play"))
    
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
    
    var dataSource: SearchContentResult? {
        didSet {
            if let result = dataSource {
                resultImageView.sd_setImageWithURL(NSURL(string: result.image), placeholderImage: PlaceholderImage.defaultSmall)
                resultTitleLabel.attributedText = searchCruxCharacterAction(result.title, titleColor: SceneColor.lightYellow)
                resultDescLabel.attributedText  = searchCruxCharacterAction(result.content, titleColor: UIColor(hex: 0xF3FD54, alpha: 0.6))
            }
        }
    }
    
//    var searchResult: SearchResult? {
//        didSet {
//            if let result = searchResult {
//                resultImageView.sd_setImageWithURL(NSURL(string: result.image), placeholderImage: PlaceholderImage.defaultSmall)
//                resultTitleLabel.attributedText = searchCruxCharacterAction(result.name, titleColor: SceneColor.lightYellow)
//                resultDescLabel.attributedText  = searchCruxCharacterAction(result.desc, titleColor: UIColor(hex: 0xF3FD54, alpha: 0.6))
//            }
//        }
//    }
//    
//    var searchContent: SearchContentResult? {
//        didSet {
//            if let content = searchContent {
//                resultTitleLabel.attributedText = searchCruxCharacterAction(content.title, titleColor: SceneColor.lightYellow)
//                resultDescLabel.attributedText = searchCruxCharacterAction(content.content, titleColor: UIColor(hex: 0xF3FD54, alpha: 0.6))
//                
//                if content.isVideo() {
//                    playImage.hidden = false
//                } else {
//                    playImage.hidden = true
//                }
//                
//                if content.isBook() {
//                    resultImageViewHeight?.constant = SearchResultCellContant.bookImageHeight
//                    resultImageView.image           = UIImage()
//                    resultImageView.backgroundColor = SceneColor.lightGray
//                    groundView.sd_setImageWithURL(NSURL(string: content.image), placeholderImage: PlaceholderImage.defaultSmall)
//                    groundView.hidden = false
//                } else {
//                    resultImageViewHeight?.constant = SearchResultCellContant.normalImageHeight
//                    groundView.hidden = true
//                    resultImageView.sd_setImageWithURL(NSURL(string: content.image), placeholderImage: PlaceholderImage.defaultSmall)
//                }
//            }
//        }
//    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(resultTitleLabel)
        addSubview(resultDescLabel)
        addSubview(baseLine)
        playImage.hidden = true
        backgroundColor = UIColor(hex: 0xB1B1B1, alpha: 0.25)
        rewriteProperty()
        addSubview(playImage)
        addSubview(groundView)
        setupAutoLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    ///  让子类来重写，所以只放需要更改的设置
    private func rewriteProperty() {
        addSubview(resultImageView)
        let cons = resultImageView.ff_AlignInner(.CenterLeft, referView: self, size: CGSizeMake(52, 37), offset: CGPointMake(9, 0))
        resultImageViewHeight = resultImageView.ff_Constraint(cons, attribute: NSLayoutAttribute.Height)
    }
    
    private func setupAutoLayout() {
        
        let w: CGFloat = UIScreen.mainScreen().bounds.width - 18 - 52 - 6
        resultTitleLabel.ff_AlignHorizontal(.TopRight, referView: resultImageView, size: CGSizeMake(w, 16), offset: CGPointMake(6, 0))
        resultDescLabel.ff_AlignHorizontal(.BottomRight, referView: resultImageView, size: CGSizeMake(w, 13), offset: CGPointMake(6, 0))
        baseLine.ff_AlignInner(.TopCenter, referView: self, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 20, 0.5))
        playImage.ff_AlignInner(.CenterCenter, referView: resultImageView, size: nil)
        groundView.ff_AlignInner(.CenterCenter, referView: resultImageView, size: CGSizeMake(31, SearchResultCellContant.bookImageHeight), offset: CGPointMake(0, 0))
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        
    }
}

