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
    /// 描述
    lazy var descLabel: UILabel = UILabel(color: UIColor.whiteColor(), title: "将近拉山", fontSize: 14, mutiLines: true, fontName: Font.PingFangSCRegular)
    /// 蒙版
    lazy var descScrollView: UIScrollView = UIScrollView(color: UIColor(hex: 0x2A2D2E, alpha: 0.5))
    
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
    
    ///  缩放结束，会执行一次
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        
        // 如果 scale < 0.8 直接解除转场
        if scale >= 0.8 {
            // 重新计算边距
            var offsetX = (scrollView.bounds.width - view!.frame.width) * 0.5
            if offsetX < 0 {
                offsetX = 0
            }
            var offsetY = (scrollView.bounds.height - view!.frame.height) * 0.5
            if offsetY < 0 {
                offsetY = 0
            }
            // 重新设置边距
            scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
        }
        
        // 通知代理完成缩放
        photoDelegate?.photoViewerDidEndZoom()
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        let scale = imageView.transform.a
        photoDelegate?.photoViewerDidZooming(scale)
    }
    
    /// 设置位置
    private func imagePostion(image: UIImage) {
        let size = displaySize(image)
        if bounds.height < size.height { // 长图
            imageView.frame = CGRect(origin: CGPointZero, size: size)
            scrollView.contentSize = size
        } else { // 短图
            let y = (bounds.height - size.height) * 0.5
            imageView.frame = CGRect(origin: CGPointZero, size: size)
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
        scrollView.backgroundColor = UIColor.clearColor()
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 2.0
        scrollView.addSubview(imageView)
        
        let tap = UITapGestureRecognizer(target: self, action: "clickImage")
        imageView.addGestureRecognizer(tap)
        imageView.userInteractionEnabled = true
        
        addSubview(indicator)
        addSubview(descScrollView)
        descScrollView.addSubview(descLabel)
        backgroundColor = UIColor.clearColor()
        descLabel.preferredMaxLayoutWidth = Frame.screen.width - 18
        indicator.ff_AlignInner(ff_AlignType.CenterCenter, referView: self, size: nil)
        descScrollView.ff_AlignInner(.BottomLeft, referView: self, size: CGSizeMake(Frame.screen.width, 133), offset: CGPointMake(0, -24))
        descLabel.ff_AlignInner(.TopLeft, referView: descScrollView, size: nil, offset: CGPointMake(9, 7))
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

