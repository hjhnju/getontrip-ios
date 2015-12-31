//
//  MyDatumViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/12/22.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class SettingDatumViewController: MenuViewController, UITableViewDataSource, UITableViewDelegate {

    static let name = "我的"
    
    lazy var tableView = UITableView()
    
    /// 头部视图
    lazy var headerView = UIView()
    
    /// 头部视图高度约束
    var headerHeightConstraint: NSLayoutConstraint?
    
    lazy var headerButton: UIButton  = UIButton()
    lazy var myBjImageView: UIImageView = UIImageView()
    
    /// 退出登录按钮
    lazy var exitLogin: UIButton = UIButton(title: "退出登录", fontSize: 16, radius: 0, titleColor: SceneColor.frontBlack)
    /// 请登录图片
    lazy var loginIconButton: PleaseLoginButton = PleaseLoginButton(image: "icon_app", title: "", fontSize: 0)
    
    /// 登录文字
    lazy var loginTitleButton = UIButton(title: "请登录", fontSize: 16, radius: 0, titleColor: .whiteColor(), fontName: Font.PingFangSCLight)
    
    /// 登录状态
    var isLoginStatus: Bool = false {
        didSet {
            setupIsLoginSetting()
        }
    }
    
    lazy var userIconImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        initHeaderView()
        initTableView()
    }
    
    ///  初始化属性
    private func initView() {
        
        navBar.titleLabel.text = SettingDatumViewController.name
        view.addSubview(tableView)
        view.backgroundColor = .whiteColor()
        
        isLoginStatus = globalUser != nil ? true : false
        loginIconButton.addTarget(self, action: "pleaseLoginButtonAction", forControlEvents: .TouchUpInside)
        loginTitleButton.addTarget(self, action: "pleaseLoginButtonAction", forControlEvents: .TouchUpInside)
        
        exitLogin.backgroundColor = .whiteColor()
        exitLogin.addTarget(self, action: "exitLoginAction", forControlEvents: .TouchUpInside)
        exitLogin.ff_AlignInner(.BottomLeft, referView: view, size: CGSizeMake(view.bounds.width, 50), offset: CGPointMake(0, 0))
        
    }
    
    private func initHeaderView() {
        view.addSubview(headerView)
        headerView.backgroundColor = SceneColor.whiteGray
        headerView.addSubview(myBjImageView)
        headerView.addSubview(headerButton)
        headerView.addSubview(loginIconButton)
        headerView.addSubview(loginTitleButton)
        headerView.clipsToBounds = true
        myBjImageView.contentMode = .ScaleAspectFill

        headerButton.addTarget(self, action: "switchUserBackgroundPhotoAction", forControlEvents: .TouchUpInside)
        loginIconButton.layer.cornerRadius = 45
        loginIconButton.layer.borderWidth = 1.0
        loginIconButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        myBjImageView.ff_Fill(headerView)
        headerButton.ff_Fill(headerView)
        let cons = headerView.ff_AlignInner(.TopLeft, referView: view, size: CGSizeMake(view.bounds.width, 212), offset: CGPointMake(0, 44))
        headerHeightConstraint = headerView.ff_Constraint(cons, attribute: .Height)
        loginIconButton.ff_AlignInner(.CenterCenter, referView: headerView, size: CGSizeMake(90, 90), offset: CGPointMake(0, -10))
        loginTitleButton.ff_AlignVertical(.BottomCenter, referView: loginIconButton, size: CGSizeMake(UIScreen.mainScreen().bounds.width, 20), offset: CGPointMake(0, 12))
    }
    
    private func initTableView() {
        tableView.dataSource = self
        tableView.delegate   = self
        tableView.separatorStyle = .None
        tableView.backgroundColor = SceneColor.greyWhite
        tableView.registerClass(SettingDatumTableViewCell.self, forCellReuseIdentifier: "SettingDatumTableViewCell")
        tableView.frame = CGRectMake(0, 44, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 44)
        tableView.contentInset = UIEdgeInsets(top: 212, left: 0, bottom: 0, right: 0)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if globalUser != nil && globalUser?.bakimg != "" {
            print(globalUser?.bakimg)
            myBjImageView.sd_setImageWithURL(NSURL(string: globalUser?.bakimg ?? ""))
        } else {
            myBjImageView.sd_setImageWithURL(NSURL(string: "http://www.getontrip.cn/pic/my_background.jpg"))
        }
    }
    
    // MARK: - tableview delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 1 ? 1 : 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SettingDatumTableViewCell", forIndexPath: indexPath) as! SettingDatumTableViewCell
        cell.selectionStyle = .None
        switch indexPath.section {
        case 0:
            cell.currentRow = indexPath.row == 0 ? 0 : 1
            if indexPath.row == 1 { cell.getShadowWithView() }
        case 1:
            cell.currentRow = 2
            cell.getShadowWithView()
            return cell
        default:
            break
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    /// 每行的行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 54
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(color: UIColor.clearColor())
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 {
            navigationController?.pushViewController(indexPath.row == 0 ? FavoriteViewController() : MyCommentViewController(), animated: true)
        } else if indexPath.section == 1 && indexPath.row == 0 {
            navigationController?.pushViewController(MyPraiseViewController(), animated: true)
        }
    }
    
    func pleaseLoginButtonAction() {
        if globalUser != nil {
            navigationController?.pushViewController(SettingViewController(), animated: true)
        } else {
            LoginView.sharedLoginView.doAfterLogin { [weak self] (result, error) -> () in
                if error == nil {
                    self?.isLoginStatus = result
                    return
                }
                self?.isLoginStatus = false
                ProgressHUD.showErrorHUD(self?.view, text: "登录失败")
            }
        }
    }
    
    ///  初始化是否登录设置
    private func setupIsLoginSetting() {
        
        if isLoginStatus == true {
            userIconImageView.sd_setImageWithURL(NSURL(string: globalUser?.icon ?? ""), placeholderImage: UIImage(named: "icon_app"), completed: { [weak self] (image, error, _, _) -> Void in
                self?.loginIconButton.setImage(image, forState: .Normal)
                self?.loginIconButton.setImage(image, forState: .Highlighted)
            })
            loginTitleButton.setTitle(globalUser?.nickname, forState: UIControlState.Normal)
            let str = NSMutableAttributedString(string: globalUser?.nickname ?? "")
//            str.
//            loginTitleButton.setAttributedTitle(NSAttributedString(string: <#T##String#>), forState: <#T##UIControlState#>)
        } else {
            loginIconButton.imageView?.image = UIImage(named: "icon_app")
            loginIconButton.setImage(UIImage(named: "icon_app"), forState: .Normal)
            loginTitleButton.setTitle("请登录", forState: .Normal)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        headerHeightConstraint?.constant = -scrollView.contentOffset.y
    }
    
    /// 切换用户自己的背景图片
    lazy var photoVC: PhotographViewController = PhotographViewController()
    func switchUserBackgroundPhotoAction() {
        photoVC.switchPhotoAction(self, sourceview: headerView, isBackground: true)
    }
    
    /*
    NSMutableAttributedString *str=[[NSMutableAttributedString alloc] initWithString:@"fdsahfjdsafkdhafjkhadjksfhjk" attributes:nil];
    
    NSTextAttachment *attachment=[[NSTextAttachment alloc] initWithData:nil ofType:nil];
    UIImage *img=[UIImage imageNamed:@"qrcode.png"];
    attachment.image=img;
    attachment.bounds=CGRectMake(0, -10, 20, 20);
    NSAttributedString *text=[NSAttributedString attributedStringWithAttachment:attachment];
    
    [str insertAttributedString:text atIndex:2];
    self.textView.attributedText=str;
    */
}
