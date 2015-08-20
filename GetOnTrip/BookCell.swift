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
    
    var bookModel: Book? {
        didSet {
//            let iconURL = NSURL(string: AppIniDev.BaseUri + (bookModel!.image))
//            self.iconView.sd_setImageWithURL(iconURL)
            var imageURL = NSURL(string: AppIniOnline.BaseUri + (bookModel!.image))
            print(imageURL)
            print("\n\n\n")
            self.iconView?.sd_setImageWithURL(imageURL)
            self.content_desc.text = bookModel?.content_desc
            var bookInfo = "作者：" + bookModel!.author + "\n出版社：" + bookModel!.press + "\n页数：" + bookModel!.pages + "\nISBN：" + bookModel!.isbn
            self.bookInfo.text = bookInfo
            self.price_jd.text = bookModel?.price_jd
            self.price_mart.text = bookModel?.price_mart
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
