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

class CommentTopicController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    /// 评论列表请求
    var commentListRequest: CommentListRequest?
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
    lazy var commentTitleView = UIView(color: UIColor.whiteColor())
    /// 评论标题
    lazy var commentTitle: UILabel = UILabel(color: SceneColor.bgBlack, title: "评论", fontSize: 16, mutiLines: true)
    /// 评论底线
    lazy var commentBottomLine = UIView(color: SceneColor.lightGray, alphaF: 0.5)
    
    /// 评论提示
    let prompt = UILabel(color: UIColor(hex: 0x2A2D2E, alpha: 0.3), title: "空空如也...\n来抢发第一条评论吧 ＼(^o^)／", fontSize: 13, mutiLines: true)
    
    lazy var issueCommentTopLine: UIView = UIView(color: SceneColor.lightGray, alphaF: 0.5)
    
    var dataDict: NSMutableDictionary = NSMutableDictionary()
    
//    var indexPath: NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    
    var data: [CommentList] = [CommentList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        view.addSubview(commentBottomImage)
        view.addSubview(issueCommentView)
        issueCommentView.addSubview(issueTextfield)
        issueCommentView.addSubview(issueCommentBtn)
        issueCommentView.addSubview(issueCommentTopLine)
        issueCommentBtn.backgroundColor = SceneColor.shallowYellows
        issueCommentBtn.setTitle("发布中...", forState: UIControlState.Selected)
        view.addSubview(commentTitleView)
        commentTitleView.addSubview(commentTitle)
        commentTitleView.addSubview(commentBottomLine)
        issueCommentBtn.addTarget(self, action: "sendCommentData:", forControlEvents: UIControlEvents.TouchUpInside)
        commentTitle.textAlignment = NSTextAlignment.Center
        commentTitle.backgroundColor = SceneColor.crystalWhite
        issueTextfield.borderStyle = UITextBorderStyle.RoundedRect
        
        view.addSubview(prompt)
        prompt.ff_AlignInner(ff_AlignType.CenterCenter, referView: tableView, size: nil, offset: CGPointMake(0, -20))
        prompt.textAlignment = NSTextAlignment.Center
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderHeight = 41
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.registerClass(commentTableViewCell.self, forCellReuseIdentifier: "commentTableView_Cell")
        tableView.contentInset = UIEdgeInsets(top: 41, left: 0, bottom: 0, right: 0)
        
        loadCommentData()
        setupAutoLayout()
    }

    private func loadCommentData() {
        
        if commentListRequest == nil {
            commentListRequest = CommentListRequest()
            commentListRequest!.topicId = topicId
        }
        
        commentListRequest?.fetchCommentListModels({ (handler) -> Void in
            
            for it in handler {
                self.dataDict.setValue(it, forKey: "\(it.id)")
            }
            self.data.removeAll(keepCapacity: true)
            for (_, v) in self.dataDict {
                self.data.append(v as! CommentList)
            }
            self.data.sortInPlace { $0.id > $1.id }
            self.tableView.reloadData()
            self.prompt.hidden = self.data.count > 0 ? true : false
        })
    }
    
    var upId    : String = ""
    var to_user : String = ""
    
    func sendCommentData(btn: UIButton) {
        btn.selected = true
        if sharedUserAccount == nil {
            issueTextfield.resignFirstResponder()
            LoginView.sharedLoginView.addLoginFloating({ (result, error) -> () in
                let resultB = result as! Bool
                if resultB == true {
                    
                    self.sendcommentRequest.fetchAddCommentModels(self.topicId, upId: self.upId, toUserId: self.to_user, content: self.issueTextfield.text ?? "", handler: { (result, status) -> Void in
                        if status == RetCode.SUCCESS {
                            self.loadCommentData()
                            SVProgressHUD.showInfoWithStatus("发送成功")
                            
                        } else {
                            SVProgressHUD.showErrorWithStatus("发送失败，请重试")
                        }
                        btn.selected = false
                    })
                }
                return
            })
        } else {
            
            sendcommentRequest.fetchAddCommentModels(self.topicId, upId: upId, toUserId: to_user, content: self.issueTextfield.text ?? "", handler: { (result, status) -> Void in
                if status == RetCode.SUCCESS {
                    self.loadCommentData()
                    SVProgressHUD.showInfoWithStatus("发送成功")
                    
                } else {
                    SVProgressHUD.showErrorWithStatus("发送失败，请重试")
                }
                btn.selected = false
            })
        }
        issueTextfield.text = ""
        
    }

    
    private func setupAutoLayout() {
        
        commentTitle.bounds = CGRectMake(0, 0, view.bounds.width, 41)
        tableView.ff_AlignInner(ff_AlignType.TopLeft, referView: view, size: CGSizeMake(view.bounds.width, 444 - 50), offset: CGPointMake(0, 0))
        issueCommentView.ff_AlignInner(ff_AlignType.BottomLeft, referView: view, size: CGSizeMake(view.bounds.width, 50), offset: CGPointMake(0, 0))
        commentBottomImage.ff_AlignInner(ff_AlignType.BottomLeft, referView: view, size: CGSizeMake(view.bounds.width, 50), offset: CGPointMake(0, 6))
        issueTextfield.ff_AlignInner(ff_AlignType.CenterLeft, referView: issueCommentView, size: CGSizeMake(view.bounds.width - 19 - 15 - 91 - 9, 34), offset: CGPointMake(9, 0))
        issueCommentTopLine.ff_AlignInner(ff_AlignType.TopLeft, referView: issueCommentView, size: CGSizeMake(view.bounds.width, 0.5))
        issueCommentBtn.ff_AlignInner(ff_AlignType.CenterRight, referView: issueCommentView, size: CGSizeMake(91, 34), offset: CGPointMake(-19, 0))
        commentTitleView.ff_AlignInner(ff_AlignType.TopLeft, referView: view, size: CGSizeMake(view.bounds.width, 41), offset: CGPointMake(0, 0))
        commentTitle.ff_AlignInner(ff_AlignType.CenterCenter, referView: commentTitleView, size: nil)
        commentBottomLine.ff_AlignInner(ff_AlignType.BottomCenter, referView: commentTitleView, size: CGSizeMake(view.bounds.width, 0.5))
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
        cell.commentAnswersView.layoutIfNeeded()
        
        for item in cell.commentAnswersView.subviews {
            if let it = item as? commentPersonButton {
                it.addTarget(self, action: "commentPersonTouchAction:", forControlEvents: UIControlEvents.TouchUpInside)
            }
        }
        
        if indexPath.row == data.count - 1 {
            page = data.count / 6
            if page == commentListRequest!.page {
                page++
                commentListRequest!.page = page
                loadCommentData()
            }
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
        let com = data[indexPath.row]
        upId = String(com.id)
        to_user   = com.to_name
        issueTextfield.placeholder = "回复 " + com.from_name + " :"
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        issueTextfield.resignFirstResponder()
    }
    
    func commentPersonTouchAction(btn: commentPersonButton) {
        
        issueTextfield.placeholder = "回复 " + btn.from_name + " :"
        upId = btn.upId
        to_user   = btn.to_name
        
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
                commentPerson.titleLabel?.numberOfLines = 0
                commentPerson.setTitle(item.from_name + "回复" + item.to_name + item.content, forState: UIControlState.Normal)
                let size = commentPerson.titleLabel?.text!.sizeofStringWithFount(UIFont.systemFontOfSize(11), maxSize: CGSizeMake(w, CGFloat.max))
                commentPerson.frame = CGRectMake(12, y, size!.width, size!.height)
                y += size!.height
            }
            
            var str = ""
            for i in data!.sub_Comment {
                str = str + i.from_name + "回复" + i.to_name + i.content + "\n"
            }
            answerCommentViewHeight!.constant = str.sizeofStringWithFount(UIFont.systemFontOfSize(11), maxSize: CGSizeMake(UIScreen.mainScreen().bounds.width - 75 - 24, CGFloat.max)).height + 8
            if data?.sub_Comment.count == 0 {
                commentAnswersView.hidden = true
            }
        }
    }
    
    func dataWithCellHeight(comment: CommentList) -> CGFloat {
        
        var str = ""
        for i in comment.sub_Comment {
            str = str + i.from_name + "回复" + i.to_name + i.content + "\n"
            
        }
        
        var height =  40 + 16 + 9 + comment.content.sizeofStringWithFount(UIFont.systemFontOfSize(11), maxSize: CGSizeMake(UIScreen.mainScreen().bounds.width - 75, CGFloat.max)).height + str.sizeofStringWithFount(UIFont.systemFontOfSize(11), maxSize: CGSizeMake(UIScreen.mainScreen().bounds.width - 75 - 24, CGFloat.max)).height
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
//        commentAnswersView.addSubview(answerCommentContent)
//        commentAnswersView.addSubview(commentPerson)
        content.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 75
//        answerCommentContent.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 75 - 24
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
//        answerCommentContent.ff_AlignInner(ff_AlignType.TopLeft, referView: commentAnswersView, size: nil, offset: CGPointMake(12, 8))
        answerCommentViewHeight = commentAnswersView.ff_Constraint(cons, attribute: NSLayoutAttribute.Height)
        baseLine.ff_AlignInner(ff_AlignType.BottomCenter, referView: self, size: CGSizeMake(UIScreen.mainScreen().bounds.width, 0.5), offset: CGPointMake(0, 0))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconView.layer.cornerRadius = min(iconView.bounds.width, iconView.bounds.height) * 0.5
        iconView.clipsToBounds = true
    }
}

class commentPersonButton: UIButton {
    
    var to_name: String = ""
    
    var upId: String = ""
    
    var from_name: String = ""
}
