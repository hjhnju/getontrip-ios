//
//  SideViewController.swift
//  GetOnTrip
//
//  Created by guojinli on 15/7/27.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var sideTableViewController: UIView!
    
    //MARK: Properties
    var logined: Bool = false
    
    var headImage: UIImage? {
        didSet {
            headButton.setBackgroundImage(headImage, forState: UIControlState.Normal)
        }
    }
    
    var userName: String? {
        didSet {
            if let name = userName {
                user_name.text = "Hello! \(name)"
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
    
    @IBOutlet weak var user_name: UILabel!
    @IBOutlet weak var unloginView: UIView!
    @IBOutlet weak var headButton: UIButton!
    @IBOutlet weak var bgImageView: UIImageView!
    
    @IBOutlet weak var welcome_label: UILabel!
    //MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //backgroud
        bgImageView.contentMode = UIViewContentMode.ScaleToFill
        bgImageView.clipsToBounds = true
        
        if logined {
            refresh()
        }
        welcome_label.hidden = logined ?? false
    }
    
    func refresh() {
        if logined {
            
            headImage = UIImage(named: "default-topic")
            userName  = "Joshua"
            unloginView.hidden = true
            //圆角头像
            headButton.hidden = false
            headButton.layer.cornerRadius = headButton.frame.width / 2
            headButton.clipsToBounds = true
            headButton.setTitle("", forState: .Normal)
            user_name.hidden = false
            
        }else {
            headButton.hidden = true
        }
    }
    
}
