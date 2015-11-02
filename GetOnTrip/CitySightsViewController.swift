//
//  SightListCityController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/10/15.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout
import SVProgressHUD

let sightListCityIdentifier = "SightListCity_Cell"

class CitySightsViewController: UICollectionViewController {
    
    /// 城市ID
    var cityId: String?
    
    /// 网络请求加载数据
    var lastSuccessRequest: CitySightsRequest?
    
    /// 界面布局
    let layout = UICollectionViewFlowLayout()
        
    var sightCityList: [CitySightBrief]? {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    init() {
        super.init(collectionViewLayout: layout)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = SceneColor.frontBlack
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "search"), style: UIBarButtonItemStyle.Plain, target: self, action: "searchButtonClicked:")
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: "", action: "")
        let w: CGFloat = 170
        let h: CGFloat = 150
        // 每个item的大小
        layout.itemSize = CGSizeMake(w, h)
        layout.minimumLineSpacing = 15
        let lw: CGFloat = (UIScreen.mainScreen().bounds.width - w * 2) / 3
        layout.minimumInteritemSpacing = lw
        layout.sectionInset = UIEdgeInsets(top: lw, left: lw, bottom: 0, right: lw)
        
        collectionView?.backgroundColor = SceneColor.bgBlack
        collectionView?.registerClass(SightListCityCell.self, forCellWithReuseIdentifier: sightListCityIdentifier)
        
        refresh()
    }
    
    private func refresh() {
        NSLog("notice:refreshing nearby data.")
        
        //获取数据更新tableview
        if lastSuccessRequest == nil {
            lastSuccessRequest = CitySightsRequest()
            lastSuccessRequest?.cityId = cityId
        }
        
        lastSuccessRequest?.fetchSightCityModels { (handler: [CitySightBrief]) -> Void in
            self.sightCityList = handler
        }
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (sightCityList == nil) { return 0 }
        return sightCityList!.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(sightListCityIdentifier, forIndexPath: indexPath) as! SightListCityCell
        cell.collectBtn.addTarget(self, action: "collectButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.collectBtn.tag = indexPath.row
        cell.sightBrief = sightCityList![indexPath.row] as CitySightBrief
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let vc = SightViewController()
        let sight = sightCityList![indexPath.row] as CitySightBrief
        vc.title = cityId
        vc.sightId = sight.id
        vc.sightName = sight.name
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - 搜索(下一个控制器)
    func searchButtonClicked(button: UIBarButtonItem) {
        
        let search = SearchViewController()
        
        presentViewController(search, animated: true, completion: nil)
    }
    
    ///  收藏功能
    ///
    ///  - parameter sender: 收藏按钮
    func collectButtonClick(sender: UIButton) {
        
        let sight = sightCityList![sender.tag] as CitySightBrief
        if sharedUserAccount == nil {
            LoginView.sharedLoginView.addLoginFloating({ (result, error) -> () in
                let resultB = result as! Bool
                if resultB == true {
                    CollectAddAndCancel.sharedCollectAddCancel.fetchCollectionModels(2, objid: sight.id, isAdd: !sender.selected, handler: { (result, status) -> Void in
                        if status == RetCode.SUCCESS {
                            if result == "1" {
                                sender.selected = !sender.selected
                                SVProgressHUD.showInfoWithStatus(sender.selected ? "已收藏" : "已取消")
                            } else {
                                SVProgressHUD.showInfoWithStatus("您的网络不给力!")
                            }
                        }
                    })
                }
            })
        } else {
            CollectAddAndCancel.sharedCollectAddCancel.fetchCollectionModels(2, objid: sight.id, isAdd: !sender.selected, handler: { (result, status) -> Void in
                if status == RetCode.SUCCESS {
                    if result == "1" {
                        sender.selected = !sender.selected
                        SVProgressHUD.showInfoWithStatus(sender.selected ? "已收藏" : "已取消")
                    } else {
                        SVProgressHUD.showInfoWithStatus("您的网络不给力!")
                    }
                }
            })
        }
    }
}

// MARK: - SightListCityCell
class SightListCityCell: UICollectionViewCell {
    
    lazy var iconView: UIImageView = UIImageView()
    
    lazy var cityName: UILabel = UILabel(color: UIColor.whiteColor(), title: "北京", fontSize: 16, mutiLines: true)
    
    lazy var topicNum: UILabel = UILabel(color: UIColor(hex: 0xFFFFFF, alpha: 0.7), title: "共10个话题", fontSize: 11, mutiLines: false)
    
    lazy var collectBtn: CitySightCollectButton = CitySightCollectButton(image: "search_fav", title: "", fontSize: 0)
    
    lazy var shade: UIView = UIView(color: UIColor.blackColor(), alphaF: 0.2)
    
    lazy var shadeTop: UIView = UIView(color: UIColor(hex: 0x747474, alpha: 0.7))
    
    lazy var shadeLeft: UIView = UIView(color: UIColor(hex: 0x747474, alpha: 0.7))
    
    lazy var shadeRight: UIView = UIView(color: UIColor(hex: 0x747474, alpha: 0.7))
    
    lazy var shadeBottom: UIView = UIView(color: UIColor(hex: 0x747474, alpha: 0.7))
    
    var sightBrief: CitySightBrief? {
        didSet {
            iconView.sd_setImageWithURL(NSURL(string: sightBrief!.image), placeholderImage:PlaceholderImage.defaultSmall)
            cityName.text = sightBrief!.name
            topicNum.text = sightBrief!.topics
            
            if sightBrief!.collected != "" {
                collectBtn.selected = true
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupAddProperty()
        setupAutoLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAddProperty() {
        addSubview(iconView)
        addSubview(shade)
        addSubview(shadeTop)
        addSubview(shadeLeft)
        addSubview(shadeRight)
        addSubview(shadeBottom)
        addSubview(cityName)
        addSubview(topicNum)
        addSubview(collectBtn)
        
        collectBtn.setImage(UIImage(named: "collect_yellow"), forState: UIControlState.Selected)
        iconView.contentMode = UIViewContentMode.ScaleAspectFill
        iconView.clipsToBounds = true
    }
    
    private func setupAutoLayout() {
        iconView.ff_AlignInner(ff_AlignType.TopLeft, referView: self, size: bounds.size, offset: CGPointMake(0, 0))
        cityName.ff_AlignInner(ff_AlignType.CenterCenter, referView: self, size: nil, offset: CGPointMake(0, 0))
        topicNum.ff_AlignInner(ff_AlignType.BottomCenter, referView: self, size: nil, offset: CGPointMake(0, -11))
        shade.ff_AlignInner(ff_AlignType.TopLeft, referView: self, size: bounds.size, offset: CGPointMake(0, 0))
        shadeTop.ff_AlignInner(ff_AlignType.TopLeft, referView: self, size: CGSizeMake(bounds.width, 2), offset: CGPointMake(0, 0))
        shadeLeft.ff_AlignInner(ff_AlignType.CenterLeft, referView: self, size: CGSizeMake(2, bounds.height), offset: CGPointMake(0, 0))
        shadeRight.ff_AlignInner(ff_AlignType.CenterRight, referView: self, size: CGSizeMake(2, bounds.height), offset: CGPointMake(0, 0))
        shadeBottom.ff_AlignInner(ff_AlignType.BottomLeft, referView: self, size: CGSizeMake(bounds.width, 2), offset: CGPointMake(0, 0))
        collectBtn.ff_AlignInner(ff_AlignType.TopRight, referView: self, size: CGSizeMake(40, 40), offset: CGPointMake(0, 0))
    }
}
