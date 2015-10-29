//
//  SightListController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/28.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout
import SVProgressHUD

class SightViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, SightLabelDelegate, SightTableViewControllerDelegate {
    
    /// 景点id
    var sightId: String = ""
    
    //景点名称
    var sightName: String = ""
    
    //标签导航栏的主视图
    lazy var labelNavView: UIView = UIView()
    
    //指示view
    lazy var indicateView: UIView = UIView(color: UIColor.yellowColor())
    
    //标签导航栏的scrollView
    lazy var labelScrollView = UIScrollView()
    
    /// 标签数组
    var channels: NSArray?
    
    /// 网络请求加载数据(添加)
    var lastSuccessAddRequest: SightTopicRequest?
    
    /// 流水布局
    lazy var layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    /// 底部容器view
    lazy var collectionView: UICollectionView = { [weak self] in
        let cv = UICollectionView(frame: CGRectZero, collectionViewLayout: self!.layout)
        return cv
    }()
    
    /// 索引
    var currentIndex: Int?
    
    var isPopGesture: Bool = false
    
    /// 数据
    var dataSource: NSDictionary? {
        didSet {
            if let data = dataSource {
                channels = data["sightTags"] as? NSArray
                setupChannel()
                collectionView.reloadData()
            }
        }
    }
    
    /// 缓存cell
    lazy var collectionViewCellCache = [String : NSArray]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SceneColor.bgBlack
        
        //nav bar
        automaticallyAdjustsScrollViewInsets = false
        navigationItem.title = sightName
        navigationItem.backBarButtonItem  = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "search"), style: UIBarButtonItemStyle.Plain, target: self, action: "searchButtonClicked:")

        view.addSubview(labelNavView)
        labelNavView.addSubview(labelScrollView)
        labelNavView.addSubview(indicateView)
        labelScrollView.backgroundColor = SceneColor.bgBlack
        
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate   = self
        collectionView.registerClass(SightCollectionViewCell.self, forCellWithReuseIdentifier: "SightCollectionView_Cell")
        
        loadSightData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.enabled = true
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
//        collectionViewCellCache.removeAll()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupAutlLayout()
        labelNavView.layoutIfNeeded()
        labelScrollView.layoutIfNeeded()
    }
    
    func setupAutlLayout() {
        labelNavView.frame = CGRectMake(0, 64, view.bounds.width, 36)
        labelScrollView.frame = labelNavView.bounds
        collectionView.ff_AlignVertical(ff_AlignType.BottomLeft, referView: labelNavView, size: CGSizeMake(view.bounds.width, view.bounds.height - CGRectGetMaxY(labelNavView.frame)), offset: CGPointMake(0, 0))
        setupLayout()
    }
    
    ///  设置频道标签
    var indicateW: CGFloat?
    func setupChannel() {
       
        /// 间隔
        var x: CGFloat = 0
        let h: CGFloat = 36
        var lW: CGFloat?
        lW = UIScreen.mainScreen().bounds.width / CGFloat(channels!.count)
        if channels!.count >= 7 {
            lW = UIScreen.mainScreen().bounds.width / CGFloat(7)
        } 
        var index: Int = 0
        for label in channels! {
            let tag: SightListTags = label as! SightListTags
            let lab = SightLabel.channelLabelWithTitle(tag.name!, width: lW!, height: h, fontSize: 14) 
            
            lab.delegate = self
            lab.textColor = UIColor.whiteColor()
            lab.backgroundColor = UIColor.clearColor()
            lab.tag = index
            lab.frame = CGRectMake(x, 0, lab.bounds.width, h)
            x += lab.bounds.width
            
            if indicateW == nil {
                indicateW = lab.bounds.width
            }
            
            index++
            labelScrollView.addSubview(lab)
        }
        
        indicateView.bounds = CGRectMake(0, 0, 56, 1.5)
        indicateView.center = CGPointMake(lW! * 0.5, CGRectGetMaxY(labelScrollView.frame) - 1.5)
        labelScrollView.contentSize = CGSizeMake(x, 0)
        labelScrollView.contentInset = UIEdgeInsetsZero
        currentIndex = 0
    }


    private func setupLayout() {
        layout.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 64 - 36)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        collectionView.pagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    // MARK: - collectionView 数据源方法
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataSource != nil ? dataSource!.objectForKey("sightTags")!.count : 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        isPopGesture = indexPath.row == 0 ? true : false
        self.navigationController?.interactivePopGestureRecognizer?.enabled = isPopGesture
        let dataType = dataSource!["sightTags"] as! NSArray
        
        let data = dataType[indexPath.row] as! SightListTags
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SightCollectionView_Cell", forIndexPath: indexPath) as! SightCollectionViewCell
        if (!childViewControllers.contains(cell.landscapeVC)) {
            addChildViewController(cell.landscapeVC)
            addChildViewController(cell.bookVC)
            addChildViewController(cell.videoVC)
            addChildViewController(cell.otherVC)
        }
        let labId = channels![indexPath.row] as! SightListTags
        cell.tagId = labId.id!
        
        cell.sightId = sightId
        if (Int(data.type!) == categoryLabel.sightLabel) {
            cell.type = categoryLabel.sightLabel
        } else if (Int(data.type!) == categoryLabel.videoLabel) {
            cell.type = categoryLabel.videoLabel
        } else if (Int(data.type!) == categoryLabel.bookLabel) {
            cell.type = categoryLabel.bookLabel
        } else {
            cell.type = categoryLabel.otherLabel
        }
        
        
        
        return cell
    }
    
    func collectionViewCellCache(data: NSArray, type: String) {
        collectionViewCellCache[type] = data
    }
    
    
    // MARK - scrollerView 代理方法
    func scrollViewDidScroll(scrollView: UIScrollView) {

        currentIndex = Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
        let labCenter : UILabel = labelScrollView.subviews[currentIndex!] as! UILabel
        
        // 计算当前选中标签的中心点
        var offset: CGFloat = labCenter.center.x - labelScrollView.bounds.width * 0.5
        let maxOffset: CGFloat = labelScrollView.contentSize.width - labelScrollView.bounds.width
        if (offset < 0) { offset = 0 }
        else if (offset > maxOffset) { offset = maxOffset }
        
        let lCount: Int = channels!.count >= 7 ? 7 : channels!.count
        let x: CGFloat = scrollView.contentOffset.x / CGFloat(lCount)  - offset
        let x1: CGFloat = scrollView.contentOffset.x / CGFloat(lCount) + labCenter.bounds.width * 0.5
        if (offset == 0) || (offset == maxOffset) {
            
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                if lCount >= 7 { self.indicateView.frame.origin.x = x }
                else { self.indicateView.center.x = x1 }
                self.labelScrollView.setContentOffset(CGPointMake(offset, 0), animated: true)
            })
        } else {
            self.labelScrollView.setContentOffset(CGPointMake(offset, 0), animated: true)
            if self.indicateView.center.x != UIScreen.mainScreen().bounds.width * 0.5 {
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.indicateView.center.x = UIScreen.mainScreen().bounds.width * 0.5
                })
            }
        }
    }
    
    ///  标签选中方法
    func sightLabelDidSelected(label: SightLabel) {
        
        currentIndex = label.tag
        let indexPath = NSIndexPath(forItem: label.tag, inSection: 0)
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: false)
        
    }
    
    //获取数据
    private func loadSightData() {
        
        if lastSuccessAddRequest == nil {
            lastSuccessAddRequest = SightTopicRequest()
            lastSuccessAddRequest?.sightId = sightId
        }
        
        lastSuccessAddRequest?.fetchFirstPageModels({ [weak self] (data, status) -> Void in
            if status == RetCode.SUCCESS {
                self?.dataSource = data
            } else {
                SVProgressHUD.showErrorWithStatus("您的网络不给力!!!")
            }
        })
    }

    // MARK: - 搜索(下一个控制器)
    func searchButtonClicked(button: UIBarButtonItem) {
        presentViewController(SearchViewController(), animated: true, completion: nil)
    }
    
    ///  搜索跳入之后消失控制器
    func dismissViewController() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
