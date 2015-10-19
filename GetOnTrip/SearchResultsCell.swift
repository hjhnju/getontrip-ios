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
    
    var searchCity: SearchCity? {
        didSet {
            resultImageView.sd_setImageWithURL(NSURL(string: searchCity!.image!))
            resultTitleLabel.text = searchCity?.name
            resultDescLabel.text = searchCity?.desc
        }
    }
    
    var searchSight: SearchSight? {
        didSet {
            resultImageView.sd_setImageWithURL(NSURL(string: searchSight!.image!))
            resultTitleLabel.text = searchSight?.name
            resultDescLabel.text = searchSight?.desc
        }
    }
    
    var searchContentTopic: SearchContentTopic? {
        didSet {
            resultImageView.sd_setImageWithURL(NSURL(string: searchContentTopic!.image!))
            resultTitleLabel.text = searchContentTopic?.title
            resultDescLabel.text = searchContentTopic?.subtitle
        }
    }
    
    var searchContentBook: SearchContentBook? {
        didSet {
            resultImageView.sd_setImageWithURL(NSURL(string: searchContentBook!.image!))
            resultTitleLabel.text = searchContentBook?.title
            resultDescLabel.text = searchContentBook?.desc
        }
    }
    
    var searchContentVideo: SearchContentVideo? {
        didSet {
            resultImageView.sd_setImageWithURL(NSURL(string: searchContentVideo!.image!))
            resultTitleLabel.text = searchContentVideo?.title
            resultDescLabel.text = searchContentVideo?.from
        }
    }
    
    var searchContentWiki: SearchContentWiki? {
        didSet {
            resultImageView.sd_setImageWithURL(NSURL(string: searchContentWiki!.image!))
            resultTitleLabel.text = searchContentWiki?.name
            resultDescLabel.text = searchContentWiki?.desc
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
        
        resultImageView.ff_AlignInner(ff_AlignType.CenterLeft, referView: self, size: CGSizeMake(52, 37), offset: CGPointMake(9, 0))
        resultTitleLabel.ff_AlignHorizontal(ff_AlignType.TopRight, referView: resultImageView, size: nil, offset: CGPointMake(6, 0))
        resultDescLabel.ff_AlignHorizontal(ff_AlignType.BottomRight, referView: resultImageView, size: nil, offset: CGPointMake(6, 0))
    }
}
