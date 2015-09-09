//
//  CityCenterViewCollection.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/9.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

let cityreuseIdentifier = "cityreuseIdentifierCell"

class CityCenterViewCollection: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    /// 布局
    let layout = UICollectionViewFlowLayout()
    
    /// 网络请求加载数据
    var lastSuccessRequest: CityCenterRequest?
    
    /// 数据模型
    var cityCenters = [CityCenter]()
    
    /// 传递城市ID的模型
    var sightId: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = SceneColor.gray
        let w: CGFloat = 170
        let h: CGFloat = 150
        // 每个item的大小
        layout.itemSize = CGSizeMake(w, h)
        // 行间距
        layout.minimumLineSpacing = 15
        // item之间水平间距
        let lw: CGFloat = (UIScreen.mainScreen().bounds.width - w * 2) / 3
        layout.minimumInteritemSpacing = lw
        layout.sectionInset = UIEdgeInsets(top: 0, left: lw, bottom: 0, right: lw)
        // Register cell classes
        collectionView?.registerClass(CityCenterCollectionCell.self, forCellWithReuseIdentifier: cityreuseIdentifier)
        navigationController?.navigationItem.title = sightId?.titleLabel?.text
        println(sightId?.tag)
        refresh()
    }
    
    
    
    private func refresh() {
        NSLog("notice:refreshing nearby data.")
        
        //获取数据更新tableview
        if lastSuccessRequest == nil {
            lastSuccessRequest = CityCenterRequest(cityId: sightId!.tag)
        }
        
        lastSuccessRequest?.fetchCityCenterModels { (handler: [CityCenter]) -> Void in
            self.cityCenters = handler
            self.collectionView?.reloadData()
        }
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cityCenters.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(cityreuseIdentifier, forIndexPath: indexPath) as! CityCenterCollectionCell
        
        cell.collectSight = cityCenters[indexPath.row] as CityCenter
        return cell
    }
}
// 收藏景点的cell
class CityCenterCollectionCell: UICollectionViewCell {
    
    lazy var iconView: UIImageView = {
        var imageView = UIImageView()
        return imageView
        }()
    
    lazy var title: UILabel = {
        var lab = UILabel()
        lab.bounds = CGRectMake(0, 0, 150, 20)
        lab.textAlignment = NSTextAlignment.Center
        lab.backgroundColor = UIColor.orangeColor()
        return lab
        }()
    
    lazy var subtitle: UILabel = {
        var lab = UILabel()
        lab.textAlignment = NSTextAlignment.Center
        lab.backgroundColor = UIColor.orangeColor()
        lab.bounds = CGRectMake(0, 0, 150, 20)
        return lab
        }()
    
    var collectSight: CityCenter? {
        didSet {
            iconView.sd_setImageWithURL(NSURL(string: collectSight!.image!))
            title.text = collectSight?.name
//            subtitle.text = collectSight?.topicNum
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(iconView)
        addSubview(title)
        addSubview(subtitle)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconView.frame = self.bounds
        title.frame = CGRectMake(0, self.bounds.height * 0.5, self.bounds.width, 20)
        subtitle.frame = CGRectMake(0, self.bounds.height - 20, self.bounds.width, 20)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
