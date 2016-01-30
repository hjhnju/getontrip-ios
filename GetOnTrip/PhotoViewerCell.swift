//
//  PhotoViewerCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 16/1/7.
//  Copyright © 2016年 Joshua. All rights reserved.
//


import UIKit
import SDWebImage
import FFAutoLayout

protocol PhotoViewerCellDelegate: NSObjectProtocol {
    func photoViewerCellDidTapImage()
    ///  照片视图正在缩放
    func photoViewerDidZooming(scale: CGFloat)
    ///   照片视图完成缩放
    func photoViewerDidEndZoom()
}

class PhotoViewerCell: UICollectionViewCell, UIScrollViewDelegate {
    
    weak var photoDelegate: PhotoViewerCellDelegate?
    // MARK: - 懒加载控件
    lazy var imageView = UIImageView()
    /// scrollview
    lazy private var scrollView = UIScrollView()
    /// 刷新控件
    lazy private var indicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    
    var imageStr: String = "" {
        didSet {
            // 重设 scrollView
            resetScrollView()
            indicator.startAnimating()
            if let url = NSURL(string: imageStr) {
                imageView.sd_setImageWithURL(url, completed: { (image, error, cacheType, url) -> Void in
                    self.indicator.stopAnimating()
                    if image != nil {
                        self.imagePostion(image)
                    }
                })
            }
        }
    }
    
    ///  重设 scrollView 内容参数
    private func resetScrollView() {
        scrollView.contentInset = UIEdgeInsetsZero
        scrollView.contentOffset = CGPointZero
        scrollView.contentSize = CGSizeZero
        
        // 重新设置 imageView 的transform
        imageView.transform = CGAffineTransformIdentity
    }
    
    // MARK: - UIScrollViewDelegate
    ///  告诉 scrollView 缩放谁
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        let offsetX = (scrollView.bounds.width - imageView.frame.width) * 0.5
        let offsetY = (scrollView.bounds.height - imageView.frame.height) * 0.5
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
    }
    
    /// 设置位置
    private func imagePostion(image: UIImage) {
        let size = displaySize(image)
        if bounds.height < size.height { // 长图
            imageView.frame = CGRect(origin: CGPointZero, size: size)
            scrollView.contentSize = CGSizeMake(size.width, size.height)// size
//            scrollView.contentInset.top += 68
//            scrollView.contentOffset.y = -68
        } else { // 短图
            let y = (bounds.height - size.height) * 0.5
            imageView.frame = CGRect(origin: CGPointZero, size: size)
//            imageView.center = scrollView.center
            scrollView.contentInset = UIEdgeInsets(top: y, left: 0, bottom: 0, right: 0)
        }
    }
    
    ///  根据图像计算显示的尺寸
    private func displaySize(image: UIImage) -> CGSize {
        let scale = image.size.height / image.size.width
        let h = scrollView.bounds.width * scale
        return CGSize(width: scrollView.bounds.width, height: h)
    }
    
    func clickImage() {
        photoDelegate?.photoViewerCellDidTapImage()
    }
    
    // frame 已经有正确的数值！是因为之前 layout 已经设置过 itemSize
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        scrollView.frame = UIScreen.mainScreen().bounds
        addSubview(scrollView)
//        scrollView.ff_Fill(self)
        scrollView.backgroundColor = UIColor.clearColor()
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 2.0
        scrollView.addSubview(imageView)
        let tap1 = UITapGestureRecognizer(target: self, action: "clickImage")
        scrollView.addGestureRecognizer(tap1)
        let tap = UITapGestureRecognizer(target: self, action: "clickImage")
        imageView.addGestureRecognizer(tap)
        imageView.userInteractionEnabled = true
        
        addSubview(indicator)
        
        backgroundColor = UIColor.clearColor()
        indicator.ff_AlignInner(ff_AlignType.CenterCenter, referView: self, size: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

