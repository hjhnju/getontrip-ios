//
//  ThemeViewController.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/9/2.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

struct LandscapeLayoutConstants {
    static let columCount:Int = 2
    
    //layout
    static let minLineSpacing:CGFloat = 9
    static let minInteritemSpacing:CGFloat = 10
    static let edgeInset:CGFloat = 9
    
    //cell size
    static let itemWidth = (UIScreen.mainScreen().bounds.width - 2*LandscapeLayoutConstants.edgeInset - LandscapeLayoutConstants.minInteritemSpacing) / 2
}

class ThemeDetailViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //MARK: Outlets and Properties
    
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var collectView: UICollectionView!
    
    var theme: Theme?
    
    var lastRequest: ThemeDetailRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.headImageView.contentMode   = UIViewContentMode.ScaleAspectFill
        self.headImageView.clipsToBounds = true
        
        self.view.backgroundColor = SceneColor.lightBlack
        
        self.titleLabel.font      = UIFont(name: SceneFont.heiti, size: 20)
        self.titleLabel.textColor = SceneColor.white
        self.textLabel.font       = UIFont(name: SceneFont.heiti, size: 11)
        self.textLabel.textColor  = SceneColor.white
        
        self.collectView.delegate        = self
        self.collectView.dataSource      = self
        self.collectView.backgroundColor = SceneColor.gray
        
        self.collectView.showsHorizontalScrollIndicator = false
        //self.collectView.contentInset = UIEdgeInsetsMake(355, 0, 0, 0)
        //self.automaticallyAdjustsScrollViewInsets = false
        
        //先设置已有数据
        if let image = theme?.image {
            headImageView.image = image
        }
        titleLabel.text = theme?.title
        
        //请求数据刷新
        refresh()
    }
    
    func refresh(){
        if self.lastRequest == nil {
            self.lastRequest = ThemeDetailRequest(theme: theme!)
        }
        lastRequest?.fetchFirstPageModels {
            () -> Void in
            if self.theme!.hasDetail() {
                let url = NSURL(string: self.theme!.imageUrl)
                self.headImageView.sd_setImageWithURL(url)
                self.textLabel.attributedText = self.theme!.content.getAttributedString(lineSpacing: 11)
                self.collectView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        println("==============count=\(theme!.landscape.count)==============")
        return theme!.landscape.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(StoryBoardIdentifier.LandscapeCollectionViewCellID, forIndexPath: indexPath) as! LandscapeCollectionViewCell
        
        // Configure the cell
        cell.setDisplayFields(theme!.landscape[indexPath.row])
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let landscape = theme!.landscape[indexPath.row]
        performSegueWithIdentifier(StoryBoardIdentifier.ShowLandscapeSegue, sender: landscape)
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        var itemWidth:CGFloat  = LandscapeLayoutConstants.itemWidth
        var itemHeight:CGFloat = itemWidth * 197 / 193
        return CGSize(width: itemWidth, height: itemHeight)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return LandscapeLayoutConstants.minLineSpacing
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: LandscapeLayoutConstants.edgeInset, left: LandscapeLayoutConstants.edgeInset, bottom: LandscapeLayoutConstants.edgeInset, right: LandscapeLayoutConstants.edgeInset) 
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
}
