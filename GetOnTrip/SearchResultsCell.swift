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
    static let normalImageHeight: CGFloat = 37
}

class SearchResultsCell: UITableViewCell {

    lazy var resultImageView: UIImageView = UIImageView(image: UIImage(named: "default-topic"))

    lazy var resultTitleLabel: UILabel = UILabel(color: .whiteColor(), title: "长安", fontSize: 16, mutiLines: false, fontName: Font.PingFangSCLight)
    
    lazy var resultDescLabel: UILabel = UILabel(color: .whiteColor(), title: "5景点，210个话题", fontSize: 13, mutiLines: false, fontName: Font.PingFangSCLight)
    
    lazy var baseLine: UIView = UIView(color: SceneColor.shallowGrey, alphaF: 0.15)
    
    var playImage: UIImageView = UIImageView(image: UIImage(named: "search_play"))
    
    var searchCruxCharacter: String = ""
    
    /// 自己是第几组
    var section: Int = 0
    
    /// 图书背景cell
    var groundView: UIImageView = UIImageView()
    
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
                if result.search_type == ContentType.Book {
                    resultImageView.image = UIImage()
                    resultImageView.backgroundColor = UIColor.whiteColor()
                    groundView.sd_setImageWithURL(NSURL(string: result.image), placeholderImage: PlaceholderImage.defaultSmall)
                    groundView.hidden = false
                    playImage.hidden = true
                } else if result.search_type == ContentType.Video {
                    resultImageView.sd_setImageWithURL(NSURL(string: result.image), placeholderImage: PlaceholderImage.defaultSmall)
                    playImage.hidden = false
                    groundView.hidden = true
                } else {
                    playImage.hidden = true
                    groundView.hidden = true
                    resultImageView.sd_setImageWithURL(NSURL(string: result.image), placeholderImage: PlaceholderImage.defaultSmall)
                }
                
                resultTitleLabel.attributedText = searchCruxCharacterAction(result.title, titleColor: SceneColor.lightYellow)
                resultDescLabel.attributedText  = searchCruxCharacterAction(result.content, titleColor: UIColor(hex: 0xF3FD54, alpha: 0.6))
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initView()
        setupAutoLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func initView() {
        contentView.addSubview(resultImageView)
        contentView.addSubview(resultTitleLabel)
        contentView.addSubview(resultDescLabel)
        contentView.addSubview(baseLine)
        playImage.hidden = true
        backgroundColor = UIColor.clearColor()
        contentView.backgroundColor = UIColor(hex: 0xB1B1B1, alpha: 0.25)
        contentView.addSubview(playImage)
        contentView.addSubview(groundView)
    }
    
    private func setupAutoLayout() {
        
        let w: CGFloat = UIScreen.mainScreen().bounds.width - 18 - 52 - 6
        resultImageView.ff_AlignInner(.CenterLeft, referView: contentView, size: CGSizeMake(74, 46), offset: CGPointMake(9, 0))
        resultTitleLabel.ff_AlignHorizontal(.TopRight, referView: resultImageView, size: CGSizeMake(w, 16), offset: CGPointMake(6, 0))
        resultDescLabel.ff_AlignHorizontal(.BottomRight, referView: resultImageView, size: CGSizeMake(w, 13), offset: CGPointMake(6, 0))
        baseLine.ff_AlignInner(.BottomCenter, referView: contentView, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 20, 0.5))
        playImage.ff_AlignInner(.CenterCenter, referView: resultImageView, size: nil)
        groundView.ff_AlignInner(.CenterCenter, referView: resultImageView, size: CGSizeMake(34, 46), offset: CGPointMake(0, 0))
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        
    }
}

