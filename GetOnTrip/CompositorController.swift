//
//  CompositorController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/8/24.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class CompositorController: UIViewController {

    
    lazy var dummyView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.blackColor()
        v.alpha = 0.7
        
        let tap = UITapGestureRecognizer(target: self, action: "close")
        v.addGestureRecognizer(tap)
        
        return v
    }()
    
    lazy var compositorView: UIView = {
        var compositor = UIView()
        compositor.backgroundColor = UIColor(white: 0.2, alpha: 1.0)
//        compositor.alpha = 0.8
        return compositor
    }()
    
    // 默认按钮
    lazy var defaultButton: UIButton = {
        var btn = UIButton()
        btn.setTitle("默认", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Selected)
        btn.setTitleColor(UIColor(hex: 686868, alpha: 1.0), forState: UIControlState.Normal)
        return btn
    }()
    
    // 人气最高
    lazy var popularityButton: UIButton = {
        var btn = UIButton()
        btn.setTitle("人气最高", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Selected)
        btn.setTitleColor(UIColor(hex: 686868, alpha: 1.0), forState: UIControlState.Normal)
        return btn
    }()
    
    // 最近更新
    lazy var latelyUpdateButton: UIButton = {
        var btn = UIButton()
        btn.setTitle("最近更新", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Selected)
        btn.setTitleColor(UIColor(hex: 686868, alpha: 1.0), forState: UIControlState.Normal)
        return btn
    }()
    
    func close() {
        print("来到了这里")
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clearColor()
        
//        self.view.backgroundColor = UIColor(red: 28, green: 28, blue: 28, alpha: 0.3)
        navigationItem.title = "排序"
        view.addSubview(dummyView)
        dummyView.frame = view.frame
        view.addSubview(compositorView)
        
        compositorView.addSubview(defaultButton)
        compositorView.addSubview(popularityButton)
        compositorView.addSubview(latelyUpdateButton)
        
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        dummyView.frame = view.frame
        
        var w: CGFloat = UIScreen.mainScreen().bounds.width
        var h: CGFloat = 150
        self.compositorView.frame = CGRectMake(0, 64, w, h)
        
        compositorView.frame = CGRectMake(0, 0, w, 50)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
