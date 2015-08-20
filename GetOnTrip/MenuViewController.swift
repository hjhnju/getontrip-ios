//
//  SideViewController.swift
//  GetOnTrip
//
//  Created by guojinli on 15/7/27.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

protocol UserDataSource {
    
}

class MenuViewController: UIViewController {
    
    //MASK: Properties
    
    var slideDelegate: SlideMenuViewControllerDelegate?
    
    var logined: Bool = true
    
    var headImage: UIImage? {
        didSet {
            headButton.setBackgroundImage(headImage, forState: UIControlState.Normal)
        }
    }
    
    var userName: String? {
        didSet {
            if let name = userName {
                welcome.text = "Hello! \(name)"
            }
        }
    }
    
    var bgImageUrl: String? {
        didSet {
            if let url = bgImageUrl {
                ImageLoader.sharedLoader.imageForUrl(url) { (image:UIImage?, url:String) in
                    self.bgImageView.image = image
                    // blur process
                    let blur = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
                    blur.frame = self.bgImageView.frame
                    for v in self.bgImageView.subviews {
                        v.removeFromSuperview()
                    }
                    self.bgImageView.addSubview(blur)
                }
            }
        }
    }
    
    var dataSource: UserDataSource!
    
    @IBOutlet weak var welcome: UILabel!
    @IBOutlet weak var unloginView: UIView!
    @IBOutlet weak var headButton: UIButton!
    @IBOutlet weak var bgImageView: UIImageView!
    
    //MASK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //backgroud
        bgImageView.contentMode = UIViewContentMode.ScaleToFill
        bgImageView.clipsToBounds = true
        
        refresh()
    }
    
    func refresh() {
        if logined {
            headImage = UIImage(named: "default-topic")
            userName  = "Joshua"
            unloginView.hidden = true
            //圆角头像
            headButton.layer.cornerRadius = headButton.frame.width / 2
            headButton.clipsToBounds = true
            headButton.setTitle("", forState: .Normal)
            
        }else {
            headButton.hidden = true
        }
    }
    
}
