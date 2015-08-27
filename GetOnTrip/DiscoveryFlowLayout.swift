//
//  DiscoveryFlowLayout.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/8/21.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

struct FlowLayoutContants {
    static let columCount:Int = 2
    
    //layout
    static let minLineSpacing:CGFloat = 9
    static let minInteritemSpacing:CGFloat = 10
    static let edgeInset:CGFloat = 9
    
    //cell size
    static let itemWidth = (UIScreen.mainScreen().bounds.width - 2*FlowLayoutContants.edgeInset - FlowLayoutContants.minInteritemSpacing) / 2
}

class DiscoveryFlowLayout: UICollectionViewFlowLayout {
    
    var delegate: UICollectionViewDelegateFlowLayout?
    
    //每一列当前的y轴高度
    var colums: [CGFloat]!
    
    //frame string as key
    var indexMap = [String:NSIndexPath]()
    //indexpath as key
    var frameMap = [NSIndexPath:CGRect]()
    
    override func prepareLayout() {
        //NSLog("DiscoveryFlowLayout.prepareLayout")
        //base init
        self.scrollDirection         = UICollectionViewScrollDirection.Vertical
        self.minimumLineSpacing      = FlowLayoutContants.minLineSpacing
        self.minimumInteritemSpacing = FlowLayoutContants.minInteritemSpacing
        self.sectionInset            = UIEdgeInsets(top: FlowLayoutContants.edgeInset, left: FlowLayoutContants.edgeInset, bottom: FlowLayoutContants.edgeInset, right: FlowLayoutContants.edgeInset)
        
        //delegate
        self.delegate = self.collectionView?.delegate as? UICollectionViewDelegateFlowLayout
        
        colums = [CGFloat]()
        var yOffset: CGFloat = 0
        for i in 0..<FlowLayoutContants.columCount {
            colums.append(yOffset)
        }
        
        let itemCount = self.collectionView?.numberOfItemsInSection(0) ?? 0
        for i in 0..<itemCount {
            self.layoutForItemAtIndexPath(NSIndexPath(forItem: i, inSection: 0))
        }
    }
    
    //计算每个item的frame
    private func layoutForItemAtIndexPath(indexPath: NSIndexPath){
        let itemSize:CGSize = self.delegate!.collectionView!(self.collectionView!, layout: self, sizeForItemAtIndexPath: indexPath)
        
        //找到高度最小列
        var shortestYOffSet = colums[0]
        var shortestColum   = 0
        for i in 1..<colums.count {
            if colums[i] < shortestYOffSet {
                shortestColum = i
                shortestYOffSet = colums[i]
            }
        }
        
        //确定cell的frame
        let x:CGFloat = self.sectionInset.left + (itemSize.width + self.minimumInteritemSpacing) * CGFloat(shortestColum)
        let y = shortestYOffSet + self.sectionInset.top
        let frame = CGRectMake(x, y, itemSize.width, itemSize.height)
        
        //更新最小列的高度
        colums[shortestColum] = shortestYOffSet + self.sectionInset.top + itemSize.height
        
        //对应字典
        indexMap[NSStringFromCGRect(frame)] = indexPath
        frameMap[indexPath] = frame
        
        //NSLog("DiscoveryFlowLayout.layoutForItemAtIndexPath:\(indexPath.section)-\(indexPath.row), frame=\(frame)")
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        var result = [UICollectionViewLayoutAttributes]()
        
        let indexPaths = self.indexPathsOfItemsInRect(rect)
        for indexPath in indexPaths {
            let attribute = self.layoutAttributesForItemAtIndexPath(indexPath)
            result.append(attribute)
        }
        //NSLog("DiscoveryFlowLayout.layoutAttributesForElementsInRect:rect=\(rect)")
        return result
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        var attribute = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        attribute.frame = frameMap[indexPath]!
        //NSLog("DiscoveryFlowLayout.layoutAttributesForItemAtIndexPath:\(indexPath.section)-\(indexPath.row)")
        return attribute
    }
    
    //返回在rect范围内的所有item
    private func indexPathsOfItemsInRect(rect: CGRect) -> [NSIndexPath] {
        var result = [NSIndexPath]()
        for (frameString, indexPath) in indexMap {
            let frame = CGRectFromString(frameString)
            if CGRectIntersectsRect(frame, rect) {
                result.append(indexPath)
            }
        }
        return result
    }
    
    override func collectionViewContentSize() -> CGSize {
        var size = self.collectionView!.frame.size
        
        let maxHeight = maxElement(self.colums)
        size.height = maxHeight
        
        //NSLog("DiscoveryFlowLayout.collectionViewContentSize:\(size)")
        return size
    }
}
