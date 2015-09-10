//
//  CollectTopicViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/8.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

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
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return collectTopic.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("CollectTopicCell", forIndexPath: indexPath) as? CollectTopicCell
        
        cell!.collectTopic = collectTopic[indexPath.row] as CollectTopic
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
        

        return cell!
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - CollectTopicCell
class CollectTopicCell: UITableViewCell {
    /// 图片
    @IBOutlet weak var iconView: UIImageView!
    /// 标题
    @IBOutlet weak var titleLabel: UILabel!
    /// 副标题
    @IBOutlet weak var subtitleLabel: UILabel!
    /// 收藏数
    @IBOutlet weak var collect: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let x: CGFloat = 9
        let h: CGFloat = 0.5
        let y: CGFloat = self.bounds.height - h
        let w: CGFloat = self.bounds.width - x * 2
        baseline.frame = CGRectMake(x, y, w, h)
    }
    
    /// 设置底线
    lazy var baseline: UIView! = {
        var baselineView = UIView()
        baselineView.backgroundColor = UIColor(white: 0xFFFFFF, alpha: 0.3)
        return baselineView
    }()
    
    var collectTopic: CollectTopic? {
        didSet {
            iconView.sd_setImageWithURL(NSURL(string: collectTopic!.image!))
            titleLabel.text = collectTopic?.title
            subtitleLabel.text = collectTopic?.subtitle
            collect.text = collectTopic?.collect
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addSubview(baseline)
    }
}