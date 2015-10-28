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
    
    var searchCruxCharacter: String = ""
    
    func searchCruxCharacterAction(title: String, titleColor: UIColor) -> NSAttributedString {
        
        let attr = NSMutableAttributedString(string: title)
        
        let range = (title as NSString).rangeOfString(searchCruxCharacter)
        attr.addAttribute(NSForegroundColorAttributeName, value: titleColor, range: range)

        return attr
    }
    
    var searchResult: SearchResult? {
        didSet {
            resultTitleLabel.attributedText = searchCruxCharacterAction(searchResult!.name!, titleColor: SceneColor.lightYellow)
            resultDescLabel.attributedText = searchCruxCharacterAction(searchResult!.desc!, titleColor: UIColor(hex: 0xF3FD54, alpha: 0.6))
            resultImageView.sd_setImageWithURL(NSURL(string: searchResult!.image!), placeholderImage: PlaceholderImage.defaultSmall)
        }
    }
    
    var searchContent: SearchContent? {
        didSet {
            resultImageView.sd_setImageWithURL(NSURL(string: searchContent!.image!), placeholderImage: PlaceholderImage.defaultSmall)
            resultTitleLabel.attributedText = searchCruxCharacterAction(searchContent!.title!, titleColor: SceneColor.lightYellow)
            resultDescLabel.attributedText = searchCruxCharacterAction((searchContent?.content)!, titleColor: UIColor(hex: 0xF3FD54, alpha: 0.6))
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupAddProperty()
        setupAutoLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAddProperty() {
        
        addSubview(resultImageView)
        addSubview(resultTitleLabel)
        addSubview(resultDescLabel)
    }
    
    private func setupAutoLayout() {
        
        let w: CGFloat = UIScreen.mainScreen().bounds.width - 18 - 52 - 6
        resultImageView.ff_AlignInner(ff_AlignType.CenterLeft, referView: self, size: CGSizeMake(52, 37), offset: CGPointMake(9, 0))
        resultTitleLabel.ff_AlignHorizontal(ff_AlignType.TopRight, referView: resultImageView, size: CGSizeMake(w, 16), offset: CGPointMake(6, 0))
        resultDescLabel.ff_AlignHorizontal(ff_AlignType.BottomRight, referView: resultImageView, size: CGSizeMake(w, 13), offset: CGPointMake(6, 0))
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
