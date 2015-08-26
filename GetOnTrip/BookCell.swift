//
//  BookCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/8/20.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class BookCell: UITableViewCell {

    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var content_desc: UILabel!
    
    @IBOutlet weak var bookInfo: UILabel!
    
    @IBOutlet weak var price_jd: UILabel!
    
    @IBOutlet weak var price_mart: UILabel!
    
    @IBOutlet weak var price_line: UIView!
    
    @IBOutlet weak var priceJdConstraint: NSLayoutConstraint!
    
    lazy var baseline: UIView! = {
        var baselineView = UIView()
        baselineView.backgroundColor = UIColor(white: 979797, alpha: 0.3)
        return baselineView
        }()
    
    var recordPriceJdConstraint: CGFloat?
    
    var bookModel: Book? {
        didSet {
            var imageURL = NSURL(string: AppIniOnline.BaseUri + (bookModel!.image))
            self.iconView?.sd_setImageWithURL(imageURL)
            
            self.content_desc.text = bookModel?.content_desc
            var bookInfo = "作者：" + bookModel!.author + "\n出版社：" + bookModel!.press + "\n页数：" + bookModel!.pages + "\nISBN：" + bookModel!.isbn
            self.bookInfo.text = bookInfo
            self.price_jd.text = "￥" + bookModel!.price_jd
            
            self.price_mart.hidden = false
            self.price_line.hidden = false
            
            self.priceJdConstraint.constant = recordPriceJdConstraint!
            if bookModel?.price_mart == "" {
                self.price_line.hidden = true
                self.price_mart.hidden = true
                self.priceJdConstraint.constant = CGFloat(-13)
            }
            self.price_mart.text = "￥" + bookModel!.price_mart + " "
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clearColor()
        recordPriceJdConstraint = priceJdConstraint.constant
        self.addSubview(self.baseline)
        var x: CGFloat = 9
        var h: CGFloat = 0.5
        var y: CGFloat = self.bounds.height - h
        var w: CGFloat = UIScreen.mainScreen().bounds.width - x * 2
        baseline.frame = CGRectMake(x, y, w, h)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
