//
//  CollectTopicViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/8.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

class CollectTopicViewController: UITableViewController {

    /// 网络请求加载数据
    var lastSuccessRequest: CollectSightRequest?
    
    var collectTopic = [CollectTopic]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.rowHeight = 107
        tableView.backgroundColor = UIColor.clearColor()
        

        refresh()
        
    }
    
    private func refresh() {
        NSLog("notice:refreshing nearby data.")
        
        //获取数据更新tableview
        if lastSuccessRequest == nil {
            lastSuccessRequest = CollectSightRequest()
        }
        
        lastSuccessRequest?.fetchCollectTopicModels { (handler: [CollectTopic]) -> Void in
            self.collectTopic = handler as [CollectTopic]
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collectTopic.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CollectTopicCell", forIndexPath: indexPath) as? CollectTopicCell
        
        cell!.collectTopic = collectTopic[indexPath.row] as CollectTopic
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
        

        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let topicId = collectTopic[indexPath.row].id
        loadData(topicId!)
    }
    
    
    private func loadData(id: Int) {
        NSLog("notice:refreshing nearby data.")
        
        TopicDetailRequest(topicId: id).fetchModels { (handler: Topic) -> Void in
            
            let topicDetailViewController = UIStoryboard(name: "TopicDetail", bundle: nil).instantiateViewControllerWithIdentifier(StoryBoardIdentifier.TopicDetailViewControllerID) as? TopicDetailViewController
            let topic = handler as Topic
            topic.sight = self.navigationController?.navigationItem.title
            topicDetailViewController!.topic = topic
            super.navigationController?.navigationController?.pushViewController(topicDetailViewController!, animated: true)
        }
        
    }

}

// MARK: - CollectTopicCell
class CollectTopicCell: UITableViewCell {
    
    lazy var iconView: UIImageView = UIImageView(image: UIImage(named: "2.jpg"))
    
    lazy var titleLabel: UILabel = UILabel(color: UIColor(hex: 0x939393, alpha: 1.0), title: "密道传说常年有", fontSize: 13, mutiLines: false)
    
    lazy var subtitleLabel: UILabel = UILabel(color: UIColor.blackColor(), title: "故宫内真有密道吗？入口在哪里？", fontSize: 16, mutiLines: false)
    
    lazy var collect: UIButton = UIButton(image: "eye", title: " 114", fontSize: 12, titleColor: UIColor(hex: 0x2A2D2E, alpha: 1.0))
    
    lazy var baseline: UIView = UIView(color: UIColor.whiteColor(), alphaF: 0.3)
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let x: CGFloat = 9
        let h: CGFloat = 0.5
        let y: CGFloat = self.bounds.height - h
        let w: CGFloat = self.bounds.width - x * 2
        baseline.frame = CGRectMake(x, y, w, h)
    }
    
    var collectTopic: CollectTopic? {
        didSet {
            iconView.sd_setImageWithURL(NSURL(string: collectTopic!.image!))
            titleLabel.text = collectTopic?.title
            subtitleLabel.text = collectTopic?.subtitle
            collect.setTitle(collectTopic?.collect, forState: UIControlState.Normal)
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
        let w: CGFloat = UIScreen.mainScreen().bounds.width - 120 - 27
        titleLabel.preferredMaxLayoutWidth = w
        subtitleLabel.preferredMaxLayoutWidth = w
        titleLabel.numberOfLines = 1
        subtitleLabel.numberOfLines = 3
    }
    
    private func setupAutoLayout() {
        iconView.ff_AlignInner(ff_AlignType.CenterLeft, referView: self, size: CGSizeMake(120, 73), offset: CGPointMake(9, 0))
        titleLabel.ff_AlignHorizontal(ff_AlignType.TopRight, referView: iconView, size: nil, offset: CGPointMake(9, 0))
        subtitleLabel.ff_AlignVertical(ff_AlignType.BottomLeft, referView: titleLabel, size: nil, offset: CGPointMake(0, 5))
        collect.ff_AlignHorizontal(ff_AlignType.BottomRight, referView: iconView, size: nil, offset: CGPointMake(9, 0))
        baseline.ff_AlignInner(ff_AlignType.BottomLeft, referView: self, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 18, 0.5), offset: CGPointMake(9, 0))
    }
}
