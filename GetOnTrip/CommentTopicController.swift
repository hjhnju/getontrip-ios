//
//  CommentTopicController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/10/13.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout
import SVProgressHUD
import MJRefresh

class CommentTopicController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    /// 评论列表请求
    var lastRequest: CommentListRequest?
    var page: Int = 0
    
    /// 发送评论请求
    var sendcommentRequest: CommentAddRequest = CommentAddRequest()
    
    /// 话题ID
    var topicId: String = ""
    
    /// 评论内容tableview
    lazy var tableView: UITableView = UITableView()
    /// 发布底部view
    lazy var issueCommentView: UIView = UIView(color: UIColor.whiteColor())
    lazy var commentBottomImage: UIImageView = UIImageView(image: UIImage(named: "comment_Bottom"))
    /// 发布textfield
    lazy var issueTextfield: UITextField = UITextField()
    /// 发布按钮
    lazy var issueCommentBtn: UIButton = UIButton(title: "确认发布", fontSize: 12, radius: 10, titleColor: UIColor(hex: 0x696969, alpha: 1.0))
    /// 评论标题view
    lazy var commentTitleButton: UIButton = UIButton(color: UIColor.whiteColor())
    /// 评论标题
    lazy var commentTitle: UILabel = UILabel(color: SceneColor.bgBlack, title: "评论", fontSize: 16, mutiLines: true)
    /// 评论底线
    lazy var commentBottomLine = UIView(color: SceneColor.lightGray, alphaF: 0.5)
    
    /// 评论提示
    let prompt = UILabel(color: UIColor(hex: 0x2A2D2E, alpha: 0.3), title: "空空如也...\n来抢发第一条评论吧 ＼(^o^)／", fontSize: 13, mutiLines: true)
    
    lazy var issueCommentTopLine: UIView = UIView(color: SceneColor.lightGray, alphaF: 0.5)
    
    var tableViewConH: NSLayoutConstraint?
    
    var dataDict: NSMutableDictionary = NSMutableDictionary()
        
    var data: [CommentList] = [CommentList]() {
        didSet {
            if data.count != 0 {
                prompt.hidden = true
            }
        }
    }
    
    var reloadIndexPath: NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    
    // MARK: - 初始化
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initProperty()
        initRefresh()
        setupAutoLayout()
    }
    
    private func initProperty() {
        view.addSubview(tableView)
        view.addSubview(commentBottomImage)
        view.addSubview(issueCommentView)
        issueCommentView.addSubview(issueTextfield)
        issueCommentView.addSubview(issueCommentBtn)
        issueCommentView.addSubview(issueCommentTopLine)
        issueCommentBtn.backgroundColor = SceneColor.shallowYellows
        issueCommentBtn.setTitle("发布中...", forState: UIControlState.Selected)
        view.addSubview(commentTitleButton)
        commentTitleButton.addSubview(commentTitle)
        commentTitleButton.addSubview(commentBottomLine)
        issueCommentBtn.addTarget(self, action: "sendCommentData:", forControlEvents: UIControlEvents.TouchUpInside)
        commentTitle.textAlignment = NSTextAlignment.Center
        commentTitle.backgroundColor = SceneColor.white.colorWithAlphaComponent(0.4)
        issueTextfield.borderStyle = UITextBorderStyle.RoundedRect
        
        view.addSubview(prompt)
        prompt.ff_AlignInner(ff_AlignType.CenterCenter, referView: tableView, size: nil, offset: CGPointMake(0, -20))
        prompt.textAlignment = NSTextAlignment.Center
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderHeight = 41
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        tableView.registerClass(CommentTableViewCell.self, forCellReuseIdentifier: "commentTableView_Cell")
        commentTitleButton.addTarget(self, action: "commentTitleButtonAction", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    private func initRefresh() {
        //上拉刷新
        
        let tbHeaderView = MJRefreshNormalHeader(refreshingBlock: loadData)
        tbHeaderView.automaticallyChangeAlpha = true
        tbHeaderView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        tbHeaderView.lastUpdatedTimeLabel?.hidden = true
        tbHeaderView.stateLabel?.hidden = true
        tbHeaderView.arrowView?.image = UIImage()
        tableView.mj_header = tbHeaderView
        if !tableView.mj_header.isRefreshing() {
            tableView.mj_header.beginRefreshing()
        }
    }
    
    var upId    : String = ""
    var to_user : String = ""
    
    func sendCommentData(btn: UIButton) {
        btn.selected = true
        
        LoginView.sharedLoginView.doAfterLogin() { (success, error) -> () in
            self.issueTextfield.resignFirstResponder()
            if success {
                self.sendcommentRequest.fetchAddCommentModels(self.topicId, upId: self.upId, toUserId: self.to_user, content: self.issueTextfield.text ?? "", handler: { (result, status) -> Void in
                    if status == RetCode.SUCCESS {
                        SVProgressHUD.showInfoWithStatus("发送成功")
                        self.loadData()
                    } else {
                        SVProgressHUD.showErrorWithStatus("评论发送失败，请重试")
                    }
                    btn.selected = false
                })
            } else {
                SVProgressHUD.showErrorWithStatus("网络无法连接")
            }
            return
        }
        
        issueTextfield.text = ""
    }
    
    private func setupAutoLayout() {
        let tbH: CGFloat = UIScreen.mainScreen().bounds.height / 1.6 - 91
        commentTitle.bounds = CGRectMake(0, 0, view.bounds.width, 41)
        let cons = tableView.ff_AlignInner(ff_AlignType.TopLeft, referView: view, size: CGSizeMake(view.bounds.width, tbH), offset: CGPointMake(0, 41))
        tableViewConH = tableView.ff_Constraint(cons, attribute: NSLayoutAttribute.Height)
        issueCommentView.ff_AlignInner(ff_AlignType.BottomLeft, referView: view, size: CGSizeMake(view.bounds.width, 50), offset: CGPointMake(0, 0))
        commentBottomImage.ff_AlignInner(ff_AlignType.BottomLeft, referView: view, size: CGSizeMake(view.bounds.width, 50), offset: CGPointMake(0, 6))
        issueTextfield.ff_AlignInner(ff_AlignType.CenterLeft, referView: issueCommentView, size: CGSizeMake(view.bounds.width - 19 - 15 - 91 - 9, 34), offset: CGPointMake(9, 0))
        issueCommentTopLine.ff_AlignInner(ff_AlignType.TopLeft, referView: issueCommentView, size: CGSizeMake(view.bounds.width, 0.5))
        issueCommentBtn.ff_AlignInner(ff_AlignType.CenterRight, referView: issueCommentView, size: CGSizeMake(91, 34), offset: CGPointMake(-19, 0))
        commentTitleButton.ff_AlignInner(ff_AlignType.TopLeft, referView: view, size: CGSizeMake(view.bounds.width, 41), offset: CGPointMake(0, 0))
        commentTitle.ff_AlignInner(ff_AlignType.CenterCenter, referView: commentTitleButton, size: nil)
        commentBottomLine.ff_AlignInner(ff_AlignType.BottomCenter, referView: commentTitleButton, size: CGSizeMake(view.bounds.width, 0.5))
    }
    

    
    // MARK: - tableview datasource and delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
//        let cell = tableView.dequeueReusableCellWithIdentifier("commentTableView_Cell", forIndexPath: indexPath) as! commentTableViewCell
        let cell = CommentTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        for i in cell.commentAnswersView.subviews {
            i.removeFromSuperview()
        }
        cell.data = data[indexPath.row]
        for item in cell.commentAnswersView.subviews {
            if let it = item as? commentPersonButton {
                it.addTarget(self, action: "commentPersonTouchAction:", forControlEvents: UIControlEvents.TouchUpInside)
                it.indexPath = indexPath
            }
        }
        
        if indexPath.row == data.count - 1 {
            loadMore()
        }
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("commentTableView_Cell") as! CommentTableViewCell
        
        return cell.dataWithCellHeight(data[indexPath.row])
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        reloadIndexPath = indexPath
        let com  = data[indexPath.row]
        upId     = String(com.id)
        to_user  = com.from_user_id
        issueTextfield.placeholder = "回复 " + com.from_name + " :"
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        issueTextfield.resignFirstResponder()
    }
    
    func commentPersonTouchAction(btn: commentPersonButton) {
        reloadIndexPath = btn.indexPath!
        
        let com  = data[btn.indexPath!.row]
        upId = String(com.id)
        if Int(btn.index! - 1) >= 0 {
            let comm = com.sub_Comment[btn.index!]
            to_user = comm.from_user_id
        } else {
            upId = ""
            to_user = ""
        }
        
        issueTextfield.placeholder = "回复 " + btn.from_name + " :"
        issueTextfield.becomeFirstResponder()
        to_user = btn.frameUserId
    }
    
    func commentTitleButtonAction() {
        to_user = ""
        upId = ""
        issueTextfield.placeholder = ""
        reloadIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    }
    
    
    // MARK - 是否正在加载中
    var isLoading:Bool = false
    
    func loadData() {
        if self.isLoading {
            return
        }
        
        self.isLoading = true
        if lastRequest == nil {
            lastRequest = CommentListRequest()
            lastRequest!.topicId = topicId
        }
        
        lastRequest?.fetchFirstPageModels {[weak self] (result, status) -> Void in
            //处理异常状态
            if RetCode.SUCCESS != status {
                SVProgressHUD.showInfoWithStatus("您的网络不给力!")
                self?.tableView.mj_header.endRefreshing()
                self?.isLoading = false
                return
            }
            
            if status == RetCode.SUCCESS {
                if let data = result {
                    for it in data {
                        self!.dataDict.setValue(it, forKey: "\(it.id)")
                    }
                    self!.data.removeAll(keepCapacity: true)
                    for (_, v) in self!.dataDict {
                        self!.data.append(v as! CommentList)
                    }
                    self!.data.sortInPlace { $0.id > $1.id }
                    self!.tableView.reloadData()
                    self!.tableView.mj_header.endRefreshing()
                    self!.prompt.hidden = self!.data.count > 0 ? true : false
                }
            } else {
                SVProgressHUD.showErrorWithStatus("您的网络连接不稳定，请稍候后连接")
            }
            
            self?.isLoading = false
        }
    }
    
    /// 底部加载更多
    func loadMore(){
        if self.isLoading {
            return
        }
        self.isLoading = true
        //请求下一页
        self.lastRequest?.fetchNextPageModels { [weak self] (result, status) -> Void in
            
            if status != RetCode.SUCCESS { SVProgressHUD.showErrorWithStatus("您的网络连接不稳定，请稍候后连接"); return }
            if let dataSource = result {
                if dataSource.count > 0 {
                    if let cells = self?.data {
                        self?.data = cells + dataSource
                    }
                }
            }
            self?.isLoading = false
        }
    }
}

