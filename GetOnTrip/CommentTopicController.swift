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
        
        tableView.registerClass(commentTableViewCell.self, forCellReuseIdentifier: "commentTableView_Cell")
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
        let cell = commentTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        for i in cell.commentAnswersView.subviews {
            i.removeFromSuperview()
        }
        cell.data = data[indexPath.row]
        for item in cell.commentAnswersView.subviews {
            if let it = item as? commentPersonButton {
                it.addTarget(self, action: "commentPersonTouchAction:", forControlEvents: UIControlEvents.TouchUpInside)
            }
        }
        
        if indexPath.row == data.count - 1 {
            loadMore()
        }
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("commentTableView_Cell") as! commentTableViewCell
        
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
        
        issueTextfield.placeholder = "回复 " + btn.from_name + " :"
        to_user = btn.frameUserId
    }
    
    func commentTitleButtonAction() {
        to_user = ""
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

class commentTableViewCell : UITableViewCell {
    
    lazy var iconView: UIImageView = UIImageView()
    
    lazy var titleName: UILabel = UILabel(color: SceneColor.bgBlack, title: "Clara J", fontSize: 14, mutiLines: true)
    
    lazy var content: UILabel = UILabel(color: SceneColor.fontGray, title: "真的假的，我倒是挺想看看有什么好玩的，真的么，太好咯哈哈哈哈哈哈哈哈真有那么神奇的时期...", fontSize: 12, mutiLines: true)
    
    lazy var time: UILabel = UILabel(color: UIColor(hex: 0x696969, alpha: 0.5), title: "1年前", fontSize: 8, mutiLines: true)
    
    lazy var answerLabel: UILabel = UILabel(color: UIColor(hex: 0x696969, alpha: 0.5), title: "回复", fontSize: 8, mutiLines: true)
    
    /// 其他人评论底部view
    lazy var commentAnswersView: UIView = UIView(color: UIColor(hex: 0x696969, alpha: 0.2))
        
    lazy var baseLine = UIView(color: SceneColor.lightGray, alphaF: 0.5)
    
    var answerCommentViewHeight: NSLayoutConstraint?
    
    var data: CommentList? {
        didSet {
            iconView.sd_setImageWithURL(NSURL(string: data!.avatar)!, placeholderImage:PlaceholderImage.defaultSmall)
            titleName.text = data!.from_name
            content.text = data!.content
            time.text = data!.create_time
            
            if data?.to_name == "" {
                answerLabel.hidden = true
            } else {
                answerLabel.hidden = false
            }
            var y: CGFloat = 8
            let w: CGFloat = UIScreen.mainScreen().bounds.width - 75 - 24
            for item in data!.sub_Comment {
                let commentPerson = commentPersonButton(title: "Clara J:", fontSize: 11, radius: 0, titleColor: SceneColor.fontGray)
                commentAnswersView.addSubview(commentPerson)
                commentPerson.upId = String(data!.id)
                commentPerson.to_name = item.to_name
                commentPerson.from_name = item.from_name
                commentPerson.frameUserId = item.from_user_id
                commentPerson.titleLabel?.numberOfLines = 0
                
                let size = (" " + item.from_name + " 回复 :" + item.to_name + " " + item.content).sizeofStringWithFount(UIFont.systemFontOfSize(11), maxSize: CGSizeMake(w, CGFloat.max))
                
                commentPerson.setAttributedTitle(schemeAttributedString(item.from_name, toName: item.to_name, content: item.content), forState: UIControlState.Normal)
                commentPerson.frame = CGRectMake(12, y, size.width, size.height)
                y += size.height + 8
            }
            
            var str = ""
            for i in data!.sub_Comment {
                str = str + i.from_name + "   回复 :" + i.to_name + i.content + "\n"
            }
            answerCommentViewHeight!.constant = str.sizeofStringWithFount(UIFont.systemFontOfSize(11), maxSize: CGSizeMake(UIScreen.mainScreen().bounds.width - 75 - 24, CGFloat.max)).height + 16
            if data?.sub_Comment.count == 0 {
                commentAnswersView.hidden = true
            }
        }
    }
    
    func schemeAttributedString(fromName: String, toName: String, content: String) -> NSAttributedString {
        
        let attrStr = NSString(string: " " + fromName + " 回复 " + toName + " :" + content)
        let attr    = NSMutableAttributedString(string: attrStr as String)
        let comment = attrStr.rangeOfString(" " + fromName)
        let comMess = attrStr.rangeOfString(" 回复 ")
        let attrN   = attrStr.rangeOfString(toName + " :")
        let content = attrStr.rangeOfString(" " + content)
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 8
        style.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        attr.addAttribute(NSForegroundColorAttributeName, value: SceneColor.fontGray, range: comMess)
        attr.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: comment)
        attr.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: attrN)
        attr.addAttribute(NSForegroundColorAttributeName, value: SceneColor.fontGray, range: content)
        attr.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSMakeRange(0, attr.length))
        attr.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(11), range: NSMakeRange(0, attr.length))
        
        return attr
    }
    
    func dataWithCellHeight(comment: CommentList) -> CGFloat {
        
        var str = ""
        for i in comment.sub_Comment {
            str = str + i.from_name + "   回复 :" + i.to_name + i.content + "\n"
        }
        
        var height =  40 + 16 + 9 + comment.content.sizeofStringWithFount(UIFont.systemFontOfSize(11), maxSize: CGSizeMake(UIScreen.mainScreen().bounds.width - 75, CGFloat.max)).height + str.sizeofStringWithFount(UIFont.systemFontOfSize(11), maxSize: CGSizeMake(UIScreen.mainScreen().bounds.width - 75 - 24, CGFloat.max)).height + 16 // + CGFloat(8 * (comment.sub_Comment.count - 1))
        if comment.sub_Comment.count == 0 {
            height = height - 16
        }
        
        return height
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupAddProperty()
        setAutoLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupAddProperty() {
        addSubview(iconView)
        addSubview(titleName)
        addSubview(content)
        addSubview(time)
        addSubview(answerLabel)
        addSubview(commentAnswersView)
        addSubview(baseLine)
        content.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 75
        iconView.contentMode = UIViewContentMode.ScaleAspectFill
        iconView.clipsToBounds = true
    }
    
    private func setAutoLayout() {
        iconView.ff_AlignInner(ff_AlignType.TopLeft, referView: self, size: CGSizeMake(44, 44), offset: CGPointMake(11, 14))
        titleName.ff_AlignHorizontal(ff_AlignType.TopRight, referView: iconView, size: nil, offset: CGPointMake(10, 0))
        content.ff_AlignVertical(ff_AlignType.BottomLeft, referView: titleName, size: nil, offset: CGPointMake(0, 4))
        time.ff_AlignInner(ff_AlignType.TopRight, referView: self, size: nil, offset: CGPointMake(-9, 23))
        answerLabel.ff_AlignHorizontal(ff_AlignType.CenterRight, referView: titleName, size: nil, offset: CGPointMake(6, 0))
        let cons = commentAnswersView.ff_AlignVertical(ff_AlignType.BottomLeft, referView: content, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 75, 0), offset: CGPointMake(0, 7))
        answerCommentViewHeight = commentAnswersView.ff_Constraint(cons, attribute: NSLayoutAttribute.Height)
        baseLine.ff_AlignInner(ff_AlignType.BottomCenter, referView: self, size: CGSizeMake(UIScreen.mainScreen().bounds.width, 0.5), offset: CGPointMake(0, 0))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconView.layer.cornerRadius = min(iconView.bounds.width, iconView.bounds.height) * 0.5
        iconView.clipsToBounds = true
    }
}

/// 评论人按钮
class commentPersonButton: UIButton {
    
    var to_name: String = ""
    
    var upId: String = ""
    
    var frameUserId: String = ""
    
    var from_name: String = ""
}
