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
    var dataSource: [String]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    /// 流水布局
    lazy var layout: SearchHotwordLayout = SearchHotwordLayout()
    
    /// 底部容器view
    lazy var collectionView: UICollectionView = { [weak self] in
        let cv = UICollectionView(frame: CGRectZero, collectionViewLayout: self!.layout)
        cv.registerClass(SearchHotwordCollectionCell.self, forCellWithReuseIdentifier: "HotCityTableViewCell")
        return cv
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(collectionView)
        collectionView.ff_Fill(contentView)
        backgroundColor = UIColor.clearColor()
        
        layout.minimumLineSpacing = 17
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 13, left: 9, bottom: 0, right: 9)
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        
        collectionView.dataSource = self
        collectionView.delegate   = self
        collectionView.bounces    = false
        collectionView.backgroundColor = UIColor.clearColor()
        
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
        return dataSource?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HotCityTableViewCell", forIndexPath: indexPath) as! BaseCollectionCell
//        cell.hotwordButton.setTitle(dataSource?[indexPath.row], forState: .Normal)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let w = (dataSource?[indexPath.row].sizeofStringWithFount1(UIFont.systemFontOfSize(16), maxSize: CGSizeMake(CGFloat.max, CGFloat.max)).width)! + 30
        return CGSizeMake(w, 32)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        endEditing(true)
//        superController?.searchBar.text = dataSource?[indexPath.row] ?? ""
//        superController?.searchBar(superController?.searchBar ?? UISearchBar(), textDidChange: dataSource?[indexPath.row] ?? "")
//        superController?.recordTableView.hidden = true
    }
}
