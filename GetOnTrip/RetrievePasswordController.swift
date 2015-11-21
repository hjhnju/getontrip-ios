
//
//  RetrievePasswordController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/11/20.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout
import SVProgressHUD

class RetrievePasswordController: UIViewController {

    /// 邮箱
    lazy var emailTextField = UITextField(alignment: NSTextAlignment.Left, sizeFout: 18, color: UIColor.blackColor())
    
    /// 发送
    lazy var sendButton    = UIButton(title: "发送", fontSize: 20, radius: 2, titleColor: UIColor.whiteColor())
    
    lazy var backButton    = UIButton(image: "back_white", title: "", fontSize: 0)
    
    lazy var navTitleLabel = UILabel(color: UIColor.whiteColor(), title: "找回密码", fontSize: 24, mutiLines: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initProperty()
        initView()
        initTextField()
        initAutoLayout()
    }

    private func initView() {
        view.addSubview(backButton)
        view.addSubview(navTitleLabel)
        view.addSubview(emailTextField)
        view.addSubview(sendButton)
        sendButton.backgroundColor = SceneColor.lightblue
    }
    
    private func initProperty() {
        view.backgroundColor = UIColor.whiteColor()
        navigationItem.titleView = UILabel(color: UIColor.whiteColor(), title: "找回密码", fontSize: 24, mutiLines: true)
        let backgroundImageView = UIImageView(image: UIImage(named: "login_background"))
        view.addSubview(backgroundImageView)
        backgroundImageView.frame = UIScreen.mainScreen().bounds
        backButton.addTarget(self, action: "backAction", forControlEvents: .TouchUpInside)
        sendButton.addTarget(self, action: "sendButtonAction", forControlEvents: .TouchUpInside)
    }
    
    private func initTextField() {
        emailTextField.placeholder         = "请输入邮箱"
        emailTextField.borderStyle         = UITextBorderStyle.RoundedRect
        emailTextField.autocorrectionType  = UITextAutocorrectionType.Default
        emailTextField.returnKeyType       = UIReturnKeyType.Done
        emailTextField.clearButtonMode     = UITextFieldViewMode.WhileEditing
    }
    
    private func initAutoLayout() {
        let screen = UIScreen.mainScreen().bounds
        let size = CGSizeMake(screen.width - 110, 42)
        backButton.ff_AlignInner(.TopLeft, referView: view, size: CGSizeMake(13, 26), offset: CGPointMake(12, 23))
        navTitleLabel.ff_AlignInner(.TopCenter, referView: view, size: nil, offset: CGPointMake(0, 23))
        emailTextField.ff_AlignInner(.TopCenter, referView: view, size: size, offset: CGPointMake(0, 161))
        sendButton.ff_AlignVertical(.BottomCenter, referView: emailTextField, size: size, offset: CGPointMake(0, 30))
    }
    
    func backAction() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func sendButtonAction() {
        
        let emailStr = emailTextField.text ?? ""
        if emailStr.validateEmail(emailStr) {
            UserRegisterRequest.userSendPasswdEmail(emailStr, handler: { (result, status) -> Void in
                if status == RetCode.SUCCESS {
                    SVProgressHUD.showInfoWithStatus("发送成功，请重新登陆")
                    self.backAction()
                } else {
                    SVProgressHUD.showInfoWithStatus("您输入的邮箱可能有误，请重新输入")
                }
            })
        } else {
            SVProgressHUD.showInfoWithStatus("邮箱格式错误")
        }
        
        
    }

}
