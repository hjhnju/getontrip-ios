//
//  SearchResultsCell.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/8/7.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class SearchResultsCell: UITableViewCell {


    @IBOutlet weak var resultImageView: UIImageView!

    @IBOutlet weak var resultTitleLabel: UILabel!
    
    @IBOutlet weak var resultDescLabel: UILabel!
    
    var resultImage:UIImage? {
        didSet{
            if resultImage != nil {
                self.resultImageView.image = resultImage
            } else {
                self.resultImageView.image = UIImage(named: "default-topic")
            }
        }
    }
    
    var resultTitle:String? {
        didSet{
            if resultTitle != nil {
                resultTitleLabel.text = resultTitle
            }
        }
    }
    
    var resultDesc:String? {
        didSet{
            if resultDesc != nil {
                resultDescLabel.text = resultDesc
            }
        }
    }
    
    var resultImageUrl:String? {
        didSet {
            if let path = resultImageUrl{
                ImageLoader.sharedLoader.imageForUrl(AppIni.BaseUri + path, completionHandler: {(image: UIImage?, url: String) -> Void in
                    self.resultImage = image
                })
            }else {
                self.resultImage = nil
            }
            
        }
    }
    
    //搜索类型: city, sight, topic, theme //TODO:enum
    var resultType:String?
    
    var resultId:Int?
    
}
