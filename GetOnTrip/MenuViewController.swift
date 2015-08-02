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
    
    var dataSource: UserDataSource!
    
    @IBOutlet weak var welcome: UILabel!
    
    @IBOutlet weak var unloginView: UIView!
    
    @IBOutlet weak var headButton: UIButton!
    
    //MASK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
