//
//  PlayFrequency.swift
//  GetOnTrip
//
//  Created by 王振坤 on 16/1/14.
//  Copyright © 2016年 Joshua. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import CoreMedia

class PlayFrequency: NSObject {
    
//    static let sharePlayFrequency = PlayFrequency()
    
//    weak var playDetailViewController: SightDetailViewController?
//    weak var slide: UISlider?
//    weak var pulsateView: PlayPulsateView?
//    weak var playBeginBtn: UIButton?
//    weak var landscape: Landscape?
    /// 播放动画按钮所在的cell
//    var playCell: LandscapeCell? {
//        willSet {
//            if newValue != nil {
//                if !newValue!.isAddAnimate {
//                    newValue?.pulsateView.playIconAction()
//                    newValue?.pulsateView.hidden = true
//                }
//            }
//        }
//        didSet {
//            oldValue?.pulsateView.hidden = true
//            oldValue?.speechImageView.hidden = false
//        }
//    }
    /// 播放类
    var player = AVPlayer()
    /// 播放列表
    var dataSource: [String] = [String]()
    /// 资源管理
    var playerItem: AVPlayerItem?
    /// 现在播放进度
    var playCurrentProgress: Float = 0
    /// 是否正在播放
    var isPlay: Bool = false {
        didSet {
//            pulsateView?.hidden = !isPlay
//            playCell?.speechImageView.hidden = isPlay
//            playCell?.pulsateView.hidden = !isPlay
//            playBeginBtn?.selected = isPlay
        }
    }
    /// 是否正在加载
    var isLoading: Bool = false
    /// 上一个选择的
    var lastIndex: Int = -1
    /// 总时长
    var totalTimeString: String = ""
    /// 默认是首个
    var index = -1 {
        didSet {
            if let url = NSURL(string: dataSource[index]) {
                /// 如果相同就取消
//                if lastIndex == index { return }
//                
//                print(dataSource[index])
//                // 移除通知
//                removeNotification()
//                // 移除监听
//                if let playerIt = playerItem {
//                    removeObserverForPlayerItem(playerIt)
//                }
//                AVAudioPlayer(data: <#T##NSData#>)
//                playerItem = AVPlayerItem(URL: url)
                player.replaceCurrentItemWithPlayerItem(playerItem)
                
                isLoading = true
                addNotification()                  // 添加通知
                addObserverPlayerItem(playerItem!) // 添加监听
            }
        }
    }
    
    // MARK: - 通知、kvo
    /// 去除通知
//    private func removeNotification() {
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: AVPlayerItemPlaybackStalledNotification, object: nil)
//    }
//    
//    /// 添加通知
//    private func addNotification() {
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerCompleted", name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerBackStall", name: AVPlayerItemPlaybackStalledNotification, object: nil)
//    }
//    
//    /// 添加监听
//    private func addObserverPlayerItem(item: AVPlayerItem) {
//        // 监听状态
//        item.addObserver(self, forKeyPath: "status", options: .New, context: nil)
//        // 监听网络加载情况
//        item.addObserver(self, forKeyPath: "loadedTimeRanges", options: .New, context: nil)
//    }
//    
//    /// 删除监听
//    func removeObserverForPlayerItem(item: AVPlayerItem) {
//        item.removeObserver(self, forKeyPath: "status")
//        item.removeObserver(self, forKeyPath: "loadedTimeRanges")
//    }
//    
//    /// 监听响应
//    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
//
//        let playerItem: AVPlayerItem = object as! AVPlayerItem
//        if keyPath == "status" {
//
//            if change!["new"]?.intValue == 1 {
//                isPlay = true
//                player.play()
//                // 开始播放的同时添加进度更新
//                addPlayerProgress()
//            }
//        } else if keyPath == "loadedTimeRanges" {
//            let array = playerItem.loadedTimeRanges
//            let timeRange = array.first?.CMTimeRangeValue
//            if timeRange == nil { return }
//            // 本次缓冲时间范围
//            print( timeRange!.duration.value)
//            
//            let startSeconds = CMTimeGetSeconds(timeRange!.duration)
//            let totalBuffer = startSeconds / CMTimeGetSeconds(playerItem.duration)
//            if totalBuffer * 100 > 2 && isLoading {
//                isLoading = false
//                player.play()
//            }
//            print("共缓冲 \(totalBuffer * 100)")
//        }
//    }
//    
//    
//    /// 通知响应
//    func playerCompleted() {
//        let time = CMTimeMakeWithSeconds(0.5, 1)
//        player.seekToTime(time) { [weak self] (_) -> Void in
//            print("音频播完了")
//            self?.playCell?.playLabel.text = self?.totalTimeString
//            self?.isPlay = false
//        }
//    }
//    
//    func playerBackStall() {
//        isLoading = true
//        print("当音频播放时停顿会调用")
//    }
//    
//    /**
//     添加播放进度
//     */
//    private func addPlayerProgress() {
//        if playerItem == nil { return }
//        //        let item = playerItem!.currentTime()
//        /// 设置进度更新每一秒
//        player.addPeriodicTimeObserverForInterval(CMTimeMake(1, 1), queue: dispatch_get_main_queue()) { (time) -> Void in
//            let currentTime = CMTimeGetSeconds(time)
//            let totalTime = CMTimeGetSeconds(self.playerItem!.duration)
//            if totalTime > 0.0 {
//                self.totalTimeString = String(format: "%02d:%02d", Int(totalTime / 60), Int(totalTime % 60))
//                self.playCell?.playLabel.text = String(format: "%02d:%02d/%02d:%02d", Int(currentTime / 60), Int(currentTime % 60), Int(totalTime / 60), Int(totalTime % 60))
//                if self.playDetailViewController?.index == self.index {
//                    self.playDetailViewController?.currentTimeLabel.text = String(format: "%02d:%02d", Int(currentTime / 60), Int(currentTime % 60))
//                    self.playDetailViewController?.totalTimeLabel.text = String(format: "%02d:%02d", Int(totalTime / 60), Int(totalTime % 60))
//                    self.slide?.setValue(Float(currentTime/totalTime), animated: true)
//                }
//            }
//            self.playCurrentProgress = Float(currentTime/totalTime)
//        }
//    }
//
//    // 滑动选择时间
//    func currentValueSliderAction(sender: UISlider) {
//        
//        print(index)
//        print(playDetailViewController?.index)
//        if playDetailViewController?.index != index {
//            ProgressHUD.showSuccessHUD(nil, text: "正在加载中，请稍候")
//            playDetailViewController?.playBeginButtonAction(playDetailViewController?.playBeginButton ?? UIButton())
//            return
//        }
//        if isLoading {
//            ProgressHUD.showSuccessHUD(nil, text: "正在加载中，请稍候")
//            return
//        }
//        let changedTime = Int64(Float64(sender.value) * CMTimeGetSeconds(self.playerItem!.duration))
//        if self.playerItem!.status == AVPlayerItemStatus.ReadyToPlay {
//            player.seekToTime(CMTimeMake(changedTime, 1), completionHandler: { (isSuccess: Bool) -> Void in
////                self.playButtonAction(self.playDetailViewController?.playBeginButton ?? UIButton())
//            })
//        }
//    }
//    
//    //播放和暂停
//    func playButtonAction(sender: UIButton) {
//        if isPlay == true {
//            self.paushMusic()
//        }else {
//            self.playMusic()
//        }
//    }
//    
//    //上一曲
//    func lastMusicButtonAction(sender: UIButton) {
//        index--
//        if self.index < 0 {
//            self.index = dataSource.count - 1
//        }
//        self.playMusic()
//    }
//    //下一曲
//    func nextMusicButonAction(sender: UIButton) {
//        index++
//        self.playMusic()
//    }
//    
//    
//    //暂停
//    func paushMusic() {
//        player.pause()
//        self.isPlay = false
//    }
//    //播放
//    func playMusic() {
//        
//        player.play()
//        self.isPlay = true
//    }
//    
//    /**
//     因为是单例，可能永远也不会执行到该方法，但为避免以后忘掉，还是写了
//     */
//    deinit {
//        playerItem?.removeObserver(self, forKeyPath: "status", context: nil)
//        playerItem?.removeObserver(self, forKeyPath: "loadedTimeRanges", context: nil)
//        // NSNotificationCenter.defaultCenter().removeObserver(self, name: AVPlayerItemDidPlayToEndTimeNotification, object: playerItem)
//        
//    }

}
