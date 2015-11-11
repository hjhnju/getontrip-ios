//
//  CollectTopicViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/8.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout


let collectContentCellIdentifier = "CollectContent_Cell"
let collectConBookCellIdentifier = "CollectContentBook_Cell"


class CollectContentViewController: UITableViewController {

    /// 网络请求加载数据
    var lastSuccessRequest: CollectSightRequest?
    
    let collectPrompt = UILabel(color: UIColor(hex: 0x2A2D2E, alpha: 0.3), title: "还木有内容...\n收藏点喜欢的吧(∩_∩)", fontSize: 13, mutiLines: true)
    
    var collectContent = [CollectContent]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.addSubview(collectPrompt)
        collectPrompt.ff_AlignInner(ff_AlignType.TopCenter, referView: tableView!, size: nil, offset: CGPointMake(0, 135))
        collectPrompt.textAlignment = NSTextAlignment.Center
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None

        tableView.backgroundColor = UIColor.clearColor()
        tableView.registerClass(CollectContentCell.self, forCellReuseIdentifier: collectContentCellIdentifier)
        tableView.registerClass(CollectContentBookCell.self, forCellReuseIdentifier: collectConBookCellIdentifier)
        refresh()
        
    }
    
    private func refresh() {
        
        CollectSightRequest.sharedCollectType.fetchCollectionModels(1) { (handler) -> Void in
            self.collectContent = handler as! [CollectContent]
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }


    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if collectContent.count == 0 { collectPrompt.hidden = false } else { collectPrompt.hidden = true }
        return collectContent.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: CollectContentCell?
        let data = collectContent[indexPath.row] as CollectContent
        if data.type == "4" {
            cell = tableView.dequeueReusableCellWithIdentifier(collectContentCellIdentifier, forIndexPath: indexPath) as? CollectContentCell
            cell?.collectContent = data
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier(collectConBookCellIdentifier, forIndexPath: indexPath) as? CollectContentBookCell
            cell?.collectContent = data
        }

        if indexPath.row == collectContent.count - 1 {
            cell!.baseline.removeFromSuperview()
        }

        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let col = collectContent[indexPath.row] as CollectContent
        if col.type == "4" {
            let vc = TopicViewController()
            let topic = Topic()
            topic.id       = col.id
            topic.image    = col.image
            topic.title    = col.title
            topic.subtitle = col.subtitle
            vc.topicDataSource = topic
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = BookViewController()
            vc.bookId = col.id
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let collect = collectContent[indexPath.row] as CollectContent
        return collect.type == "4" ? 107 : 125
    }

}

// MARK: - CollectTopicCell

class CollectContentCell: UITableViewCell {

    
    lazy var iconView: UIImageView = UIImageView()
    
    lazy var titleLabel: UILabel = UILabel(color: UIColor(hex: 0x939393, alpha: 1.0), title: "密道传说常年有", fontSize: 13, mutiLines: false)
    
    lazy var subtitleLabel: UILabel = UILabel(color: UIColor.blackColor(), title: "故宫内真有密道吗？入口在哪里？", fontSize: 16, mutiLines: false)
    
    lazy var collect: UIButton = UIButton(image: "icon_star_gray", title: " 114", fontSize: 12, titleColor: UIColor(hex: 0x2A2D2E, alpha: 1.0))
    
    lazy var baseline: UIView = UIView(color: UIColor(hex: 0x979797, alpha: 0.3))
    
    var collectContent: CollectContent? {
        didSet {
            iconView.sd_setImageWithURL(NSURL(string: collectContent!.image))
            titleLabel.text = collectContent?.subtitle
            subtitleLabel.text = collectContent?.title
            collect.setTitle(" " + collectContent!.collect ?? "", forState: UIControlState.Normal)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupProperty()
        setupAutoLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupProperty() {
        
        addSubview(iconView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(collect)
        addSubview(baseline)
        
        iconView.contentMode    = UIViewContentMode.ScaleAspectFill
        iconView.clipsToBounds  = true
        let w: CGFloat = UIScreen.mainScreen().bounds.width - 120 - 27
        titleLabel.preferredMaxLayoutWidth = w
        subtitleLabel.preferredMaxLayoutWidth = w
        titleLabel.numberOfLines = 2
        subtitleLabel.numberOfLines = 3
    }
    
    private func setupAutoLayout() {

        iconView.ff_AlignInner(ff_AlignType.CenterLeft, referView: self, size: CGSizeMake(120, 73), offset: CGPointMake(9, 0))
        titleLabel.ff_AlignHorizontal(ff_AlignType.TopRight, referView: iconView, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 120 - 27, 13), offset: CGPointMake(9, 0))
        subtitleLabel.ff_AlignVertical(ff_AlignType.BottomLeft, referView: titleLabel, size: nil, offset: CGPointMake(0, 5))
        collect.ff_AlignHorizontal(ff_AlignType.BottomRight, referView: iconView, size: nil, offset: CGPointMake(9, 0))
        baseline.ff_AlignInner(ff_AlignType.BottomCenter, referView: self, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 18, 0.5), offset: CGPointMake(0, 0))
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        
    }
}

class CollectContentBookCell: CollectContentCell {
    
    override var collectContent: CollectContent? {
        didSet {
            iconView.sd_setImageWithURL(NSURL(string: collectContent!.image))
            titleLabel.text = collectContent?.subtitle
            subtitleLabel.text = collectContent?.title
            collect.setTitle(" " + collectContent!.collect ?? "", forState: UIControlState.Normal)
        }
    }
    
    lazy var iconBottomView: UIView = UIView(color:UIColor(hex: 0xEDEDED, alpha: 1.0))
    
    private override func setupProperty() {
        super.setupProperty()
        
        addSubview(iconBottomView)
        iconBottomView.addSubview(iconView)
        titleLabel.font = UIFont.systemFontOfSize(16)
        titleLabel.textColor = UIColor.blackColor()
        iconView.clipsToBounds = true
    }
    
    private override func setupAutoLayout() {
        
        iconBottomView.ff_AlignInner(ff_AlignType.CenterLeft, referView: self, size: CGSizeMake(120, 91), offset: CGPointMake(9, 0))
        iconView.ff_AlignInner(ff_AlignType.CenterCenter, referView: iconBottomView, size: CGSizeMake(62, 86.5))
        titleLabel.ff_AlignHorizontal(ff_AlignType.TopRight, referView: iconBottomView, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 120 - 27, 13), offset: CGPointMake(9, 0))
        subtitleLabel.ff_AlignVertical(ff_AlignType.BottomLeft, referView: titleLabel, size: nil, offset: CGPointMake(0, 5))
        collect.ff_AlignHorizontal(ff_AlignType.BottomRight, referView: iconBottomView, size: nil, offset: CGPointMake(9, 0))
        baseline.ff_AlignInner(ff_AlignType.BottomCenter, referView: self, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 18, 0.5), offset: CGPointMake(0, 0))
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        
    }
}
