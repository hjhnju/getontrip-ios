//
//  CommentViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/10/13.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout
import MJRefresh

class CommentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,  UIActionSheetDelegate {
    
    /// 评论列表请求
    var lastRequest: CommentListRequest?
    
    /// 发送评论请求
    var sendcommentRequest: CommentAddAndDelRequest = CommentAddAndDelRequest()
    
    /// 话题ID
    var topicId: String = ""
    
    /// 上层的评论的id
    var upId: String = ""
    
    /// 给谁评论
    var toUser: String = ""
    
    var dataSource: [Comment] = [Comment]() {
        didSet {
            if dataSource.count != 0 {
                prompt.hidden = true
            }
        }
    }
    
    /// 评论内容tableview
    lazy var tableView: UITableView = UITableView()
    
    /// 发布底部view
    lazy var issueCommentView: UIView = UIView(color: UIColor.whiteColor())
    
    /// 评论底部小箭头图标
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
    
    var reloadIndexPath: NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    
    // MARK: - 初始化
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        initTableView()
        autolayout()
    }
    
    private func initView() {
        view.backgroundColor = .whiteColor()
        view.addSubview(tableView)
        view.addSubview(commentBottomImage)
        view.addSubview(issueCommentView)
        view.addSubview(commentTitleButton)
        view.addSubview(prompt)
        
        issueCommentView.addSubview(issueTextfield)
        issueCommentView.addSubview(issueCommentBtn)
        issueCommentView.addSubview(issueCommentTopLine)
        issueCommentBtn.backgroundColor = SceneColor.shallowYellows
        issueCommentBtn.setTitle("发布中...", forState: UIControlState.Selected)
        issueCommentBtn.addTarget(self, action: "publishAction:", forControlEvents: .TouchUpInside)
        
        commentTitleButton.addSubview(commentTitle)
        commentTitleButton.addSubview(commentBottomLine)
        commentTitleButton.addTarget(self, action: "commentTitleButtonAction", forControlEvents: .TouchUpInside)
        
        commentTitle.textAlignment = NSTextAlignment.Center
        commentTitle.backgroundColor = SceneColor.white.colorWithAlphaComponent(0.4)
        
        issueTextfield.borderStyle = UITextBorderStyle.RoundedRect
        
        prompt.ff_AlignInner(.CenterCenter, referView: tableView, size: nil, offset: CGPointMake(0, -20))
        prompt.textAlignment = .Center
    }
    
    private func initTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderHeight = 38
        tableView.separatorStyle = .None
        tableView.registerClass(CommentTableViewCell.self, forCellReuseIdentifier: "CommentTableViewCell")
        
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
    
    private func autolayout() {
        let tbH: CGFloat = UIScreen.mainScreen().bounds.height * 0.72 - 88
        commentTitle.bounds = CGRectMake(0, 0, view.bounds.width, 38)
        let cons = tableView.ff_AlignInner(.TopLeft, referView: view, size: CGSizeMake(view.bounds.width, tbH), offset: CGPointMake(0, 38))
        tableViewConH = tableView.ff_Constraint(cons, attribute: .Height)
        issueCommentView.ff_AlignInner(.BottomLeft, referView: view, size: CGSizeMake(view.bounds.width, 50), offset: CGPointMake(0, 0))
        commentBottomImage.ff_AlignInner(.BottomLeft, referView: view, size: CGSizeMake(view.bounds.width, 50), offset: CGPointMake(0, 10))
        issueTextfield.ff_AlignInner(.CenterLeft, referView: issueCommentView, size: CGSizeMake(view.bounds.width - 19 - 15 - 91 - 9, 34), offset: CGPointMake(9, 0))
        issueCommentTopLine.ff_AlignInner(.TopLeft, referView: issueCommentView, size: CGSizeMake(view.bounds.width, 0.5))
        issueCommentBtn.ff_AlignInner(.CenterRight, referView: issueCommentView, size: CGSizeMake(91, 34), offset: CGPointMake(-19, 0))
        commentTitleButton.ff_AlignInner(.TopLeft, referView: view, size: CGSizeMake(view.bounds.width, 38), offset: CGPointMake(0, 0))
        commentTitle.ff_AlignInner(.CenterCenter, referView: commentTitleButton, size: nil)
        commentBottomLine.ff_AlignInner(.BottomCenter, referView: commentTitleButton, size: CGSizeMake(view.bounds.width, 0.5))
    }
    
        
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if issueTextfield.text == "" {
            issueTextfield.resignFirstResponder()
        }
    }
    
    //MARKS: 自定义方法
    /// 点击评论的回复行
    func touchReplyCommentAction(btn: ReplayButton) {
        reloadIndexPath = btn.indexPath!
        let comment  = dataSource[btn.indexPath!.row]
        if Int(btn.index!) >= 0 {
            let replay = comment.sub_Comment[btn.index!]
            
            selectRowForComment(replay)
        } else {
            upId    = ""
            toUser = ""
        }
    }
    
    func commentTitleButtonAction() {
        toUser = ""
        upId   = ""
        issueTextfield.placeholder = ""
        reloadIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    }
    
    /// 是否正在加载中
    var isLoading:Bool = false
    
    func loadData() {
        if isLoading {
            return
        }
        
        isLoading = true
        if lastRequest == nil {
            lastRequest = CommentListRequest()
            lastRequest?.topicId = topicId
        }
        
        lastRequest?.fetchFirstPageModels {[weak self] (result, status) -> Void in
            //处理异常状态
            if RetCode.SUCCESS != status {
                ProgressHUD.showErrorHUD(self?.view, text: "您的网络无法连接")
                self?.tableView.mj_header.endRefreshing()
                self?.isLoading = false
                return
            }
            
            if status == RetCode.SUCCESS {
                if let data = result {
                    self?.dataSource = data
                    self?.tableView.reloadData()
                    self?.tableView.mj_header.endRefreshing()
                    self?.prompt.hidden = self?.dataSource.count > 0 ? true : false
                }
            } else {
                ProgressHUD.showErrorHUD(self?.view, text: "您的网络无法连接")
            }
            
            self?.isLoading = false
        }
    }
    
    /// 底部加载更多
    func loadMore(){
        if isLoading {
            return
        }
        isLoading = true
        //请求下一页
        lastRequest?.fetchNextPageModels { [weak self] (result, status) -> Void in
            if status != RetCode.SUCCESS {
                //不提示
                return
            }
            if let dataSource = result {
                if dataSource.count > 0 {
                    if let cells = self?.dataSource {
                        self?.dataSource = cells + dataSource
                        self?.tableView.reloadData()
                    }
                }
            }
            self?.isLoading = false
        }
    }
    
    //发布评论
    func publishAction(btn: UIButton) {
        let content = self.issueTextfield.text ?? ""
        if content == "" {
            ProgressHUD.showSuccessHUD(self.view, text: "无评论内容")
            return
        }
        
        LoginView.sharedLoginView.doAfterLogin() { (success, error) -> () in
            self.issueTextfield.resignFirstResponder()
            //1.登录成功
            if success {
                //设置为发布中
                btn.selected = true
                //请求发送
                self.sendcommentRequest.fetchAddCommentModels(self.topicId, upId: self.upId, toUserId: self.toUser, content: content, handler: { (result, status) -> Void in
                    if status == RetCode.SUCCESS {
                        ProgressHUD.showSuccessHUD(self.view, text: "发布成功")
                        self.issueTextfield.text = ""
                        self.loadData()
                        let parentVC = self.parentViewController as? TopicViewController
                        let topic: Topic = parentVC?.topicDataSource ?? Topic()
                        topic.commentNum = String((Int(parentVC?.topicDataSource?.commentNum ?? "0") ?? 0) + 1)
                        parentVC?.topicDataSource = topic
                    } else {
                        ProgressHUD.showErrorHUD(self.view, text: "评论发布失败")
                    }
                    //发布结束
                    btn.selected = false
                })
            }
            //2.取消登录或登录失败do nothing
        }
    }
}



