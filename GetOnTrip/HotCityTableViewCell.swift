//
//  HotCityTableViewCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/12/19.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class HotCityTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    /// 数据源对象
    var dataSource = [HotCity]() {
        didSet {
            initCollectionView()
            collectionView.reloadData()
        }
    }
    
    weak var superController: CityBrowseViewController?
    
    /// 流水布局
    lazy var layout: SearchHotwordLayout = SearchHotwordLayout()
    
    /// 底部容器view
    lazy var collectionView: UICollectionView = { [weak self] in
        let cv = UICollectionView(frame: CGRectZero, collectionViewLayout: self!.layout)
        cv.registerClass(HotCityCollectionViewCell.self, forCellWithReuseIdentifier: "HotCityCollectionViewCell")
        return cv
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(collectionView)
        collectionView.ff_Fill(contentView)
        backgroundColor = UIColor.whiteColor()
        
        layout.minimumLineSpacing = 9
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        
        collectionView.dataSource = self
        collectionView.delegate   = self
        collectionView.bounces    = false
        collectionView.backgroundColor = UIColor.clearColor()
    }
    
    class func hotCityTableViewCellHeightWith(hotcityNum: Int) -> CGFloat {
        let row: Int = hotcityNum / 3 + ((hotcityNum % 3) > 0 ? 1 : 0)
        return HotCity.HotCityImageWidth * CGFloat(row) + 20 + CGFloat((row - 1) * 9)
    }
    
    private func initCollectionView() {
        layout.itemSize = CGSizeMake(HotCity.HotCityImageWidth, HotCity.HotCityImageWidth)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


extension HotCityTableViewCell {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HotCityCollectionViewCell", forIndexPath: indexPath) as! HotCityCollectionViewCell
        cell.data = dataSource[indexPath.row]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let data = dataSource[indexPath.row]
        let vc = CityViewController()
        let city = City(id: data.id)
        vc.cityDataSource = city
        superController?.navigationController?.pushViewController(vc, animated: true)
    }
}
