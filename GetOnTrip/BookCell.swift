//
//  BookCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/8/20.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

class BookCell: UITableViewCell {

    lazy var iconView: UIImageView = UIImageView(image: UIImage())
    
    lazy var titleLabel: UILabel = UILabel(color: UIColor.blackColor(), title: "带本书去颐和园：长廊画和故事", fontSize: 18, mutiLines: true)
    
    lazy var subtitleLabel: UILabel = UILabel(color: UIColor(hex: 0x1C1C1C, alpha: 0.8), title: "童年记忆中我...", fontSize: 12, mutiLines: false)
    
    lazy var author: UILabel = UILabel(color: UIColor(hex: 0x2A2D2E, alpha: 0.7), title: "作者：张加冕", fontSize: 12, mutiLines: true)
    
    lazy var baseLine: UIView = UIView(color: UIColor(hex: 0x979797, alpha: 0.3))
    
    var subtitleHeight: NSLayoutConstraint?

    var book: Book? {
        didSet {
            if let book = book {
                iconView.image = nil
                iconView.sd_setImageWithURL(NSURL(string: book.image), placeholderImage: PlaceholderImage.defaultSmall)
                titleLabel.text = book.title
                subtitleLabel.attributedText = book.content_desc.getAttributedString(0, lineSpacing: 7, breakMode: NSLineBreakMode.ByTruncatingTail)
                subtitleHeight?.constant = book.title.sizeofStringWithFount(UIFont.systemFontOfSize(18), maxSize: CGSize(width: UIScreen.mainScreen().bounds.width - 115 - 18 - 7, height: CGFloat.max)).height > 10 ? 60 : 80
                author.text = book.author
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupProperty()
        setupAutoLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupProperty() {
        
        addSubview(iconView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(author)
        addSubview(baseLine)
        
        let w: CGFloat = UIScreen.mainScreen().bounds.width - 115 - 18 - 7
        titleLabel.preferredMaxLayoutWidth    = w
        subtitleLabel.preferredMaxLayoutWidth = w
        titleLabel.numberOfLines              = 2
        subtitleLabel.numberOfLines           = 0
        iconView.contentMode                  = UIViewContentMode.ScaleAspectFill
        iconView.clipsToBounds                = true
    }
    
    private func setupAutoLayout() {
        
        iconView.ff_AlignInner(ff_AlignType.CenterLeft, referView: self, size: CGSizeMake(115, 145), offset: CGPointMake(9, 0))
        titleLabel.ff_AlignHorizontal(ff_AlignType.TopRight, referView: iconView, size: nil, offset: CGPointMake(7, 0))
        let cons = subtitleLabel.ff_AlignVertical(ff_AlignType.BottomLeft, referView: titleLabel, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 115 - 18 - 7, 80), offset: CGPointMake(0, 12))
        subtitleHeight = subtitleLabel.ff_Constraint(cons, attribute: NSLayoutAttribute.Height)
        author.ff_AlignHorizontal(ff_AlignType.BottomRight, referView: iconView, size: nil, offset: CGPointMake(7, 0))
        baseLine.ff_AlignInner(ff_AlignType.BottomCenter, referView: self, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 18, 0.5))
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        
    }
}
