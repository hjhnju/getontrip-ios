//
//  SearchHotwordLayout.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/12/9.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class SearchHotwordLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let attributesToReturn = super.layoutAttributesForElementsInRect(rect)
        for attributes in attributesToReturn! {
            if nil == attributes.representedElementKind {
                let indexPath = attributes.indexPath
                attributes.frame = layoutAttributesForItemAtIndexPath(indexPath)?.frame ?? CGRectZero
            }
        }
        return attributesToReturn
    }
    
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let currentItemAttributes = super.layoutAttributesForItemAtIndexPath(indexPath)
        let sectionInset = (collectionView?.collectionViewLayout as! UICollectionViewFlowLayout).sectionInset
        
        if indexPath.item == 0 {
            currentItemAttributes?.frame.origin.x = sectionInset.left
            return currentItemAttributes
        }
        
        let previousIndexPath = NSIndexPath(forItem: indexPath.item - 1, inSection: indexPath.section)
        let previousFrame = layoutAttributesForItemAtIndexPath(previousIndexPath)?.frame ?? CGRectZero
        let previousFrameRightPoint = (previousFrame.origin.x) + (previousFrame.size.width) + 10
        let currentFrame = currentItemAttributes?.frame ?? CGRectZero
        let strecthedCurrentFrame = CGRectMake(0, currentFrame.origin.y, collectionView!.frame.size.width, currentFrame.size.height)
        
        if !CGRectIntersectsRect(previousFrame, strecthedCurrentFrame) {
            currentItemAttributes?.frame.origin.x = sectionInset.left
            return currentItemAttributes
        }
       
        currentItemAttributes?.frame.origin.x = previousFrameRightPoint
        return currentItemAttributes
    }
    
}
