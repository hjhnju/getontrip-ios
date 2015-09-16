//
//  CityCenterViewCollection.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/9.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

let cityreuseIdentifier = "cityreuseIdentifierCell"

class CityCenterViewCollection: UICollectionViewController {

    /// 布局
//    let layout = UICollectionViewFlowLayout()
    
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    /// 网络请求加载数据
    var lastSuccessRequest: CityCenterRequest?
    
    /// 数据模型
    var cityCenters = [CityCenter]()
    
    /// 传递城市ID的模型
    var sightId: UIButton?
    
//    init() {
//        super.init(collectionViewLayout: layout)
//    }
//    
//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
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
        layout.sectionInset = UIEdgeInsets(top: lw, left: lw, bottom: 0, right: lw)
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
        lab.textColor = UIColor.whiteColor()
        lab.font = UIFont.boldSystemFontOfSize(16)
        lab.textAlignment = NSTextAlignment.Center
        return lab
        }()
    
    lazy var subtitle: UILabel = {
        var lab = UILabel()
        lab.textAlignment = NSTextAlignment.Center
        lab.font = UIFont.systemFontOfSize(9)
        lab.textColor = UIColor(white: 1.0, alpha: 0.7)
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
    
    lazy var bottomView: UIView = {
        var v = UIView()
        v.backgroundColor = UIColor(hex: 0x747474, alpha: 0.3)
        return v
        }()
    
    lazy var bottomView1: UIView = {
        var v = UIView()
        v.backgroundColor = UIColor.blackColor()
        v.alpha = 0.3
        return v
        }()
    
    lazy var bottomView2: UIView = {
        var v = UIView()
        v.backgroundColor = UIColor.blackColor()
        v.alpha = 0.3
        return v
        }()
    
    lazy var bottomView3: UIView = {
        var v = UIView()
        v.backgroundColor = UIColor.blackColor()
        v.alpha = 0.3
        return v
        }()
    
    lazy var bottomView4: UIView = {
        var v = UIView()
        v.backgroundColor = UIColor.blackColor()
        v.alpha = 0.3
        return v
        }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(iconView)
        addSubview(bottomView1)
        addSubview(bottomView2)
        addSubview(bottomView3)
        addSubview(bottomView4)
        addSubview(bottomView)
        addSubview(title)
        addSubview(subtitle)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconView.frame    = self.bounds
        bottomView1.frame = CGRectMake(0, 0, self.bounds.width, 3)
        bottomView2.frame = CGRectMake(self.bounds.width - 3, 3, 3, self.bounds.height - 6)
        bottomView3.frame = CGRectMake(0, 3, 3, self.bounds.height - 6)
        bottomView4.frame = CGRectMake(0, self.bounds.height - 3, self.bounds.width, 3)
        bottomView.frame  = CGRectMake(3, 3, self.bounds.width - 6, self.bounds.height - 6)
        title.frame       = CGRectMake(0, self.bounds.height * 0.5, self.bounds.width, 20)
        subtitle.frame    = CGRectMake(0, self.bounds.height - 25, self.bounds.width, 20)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
