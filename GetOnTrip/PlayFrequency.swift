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
    
    static let sharePlayFrequency = PlayFrequency()
    
    weak var playDetailViewController: SightDetailViewController?
    /// 播放动画按钮所在的cell
    var playCell: LandscapeCell?
    /// 播放类
    var player = AVPlayer()
    /// 播放列表
    var dataSource: [String] = [String]()
    /// 资源管理
    var playerItem: AVPlayerItem?
    /// 音频总长度
    var overallDuration: Int = Int() {
        didSet {
            print("总长度是多少\(overallDuration)")
        }
    }
    /// 进度
    var progressV: Float = 0 {
        didSet {
            print(NSNumber(float: progressV).integerValue)
        }
    }
    /// 现在的播放的时间
    var playCurrentTime: Float = 0 {
        didSet {
            /// 更新播放时间
        }
    }
    /// 是否正在加载
    var isLoading: Bool = false
    /// 默认是首个
    var index = 0 {
        didSet {
            if let url = NSURL(string: dataSource[index]) {
                
                audioPlayer = try! AVAudioPlayer(contentsOfURL: url)
                
//                print(dataSource[index])
//                
//                // 移除通知
//                removeNotification()
//                // 移除监听
//                if let playerIt = playerItem {
//                    removeObserverForPlayerItem(playerIt)
//                }
//                playerItem = AVPlayerItem(URL: url)
//                player = AVPlayer(playerItem: playerItem!)
//                isLoading = true
//                // 添加通知
//                addNotification()
//                // 添加更新
//                addPlayerProgress()
//                // 添加监听
//                addObserverPlayerItem(playerItem!)
            }
        }
    }

    
    /**
     计算缓冲进度
     
     - returns: 缓冲进度
     */
    func availableDuration() -> NSTimeInterval {
        let loadedTimeRanges = player.currentItem?.loadedTimeRanges
        let timeRange = loadedTimeRanges?.first?.CMTimeRangeValue // 获取缓冲区域
        let startSeconds = CMTimeGetSeconds(timeRange?.start ?? CMTime())
        let durationSeconds = CMTimeGetSeconds(timeRange?.duration ?? CMTime())
        return startSeconds + durationSeconds
    }
    


    
    /// 播放
    func play() {
        player.play()
//        avtimer = NSTimer(timeInterval: 0.1, target: self, selector: "timer", userInfo: nil, repeats: true)
//        NSRunLoop.mainRunLoop().addTimer(avtimer!, forMode: NSRunLoopCommonModes)
    }
    
//    func timer() {
////        progress = CMTimeGetSeconds(player.currentItem!.currentTime()) / CMTimeGetSeconds(player.currentItem!.duration)
//    }
    
    /// 暂停
    func pause() {
        player.pause()
    }
    
    
    
    deinit {
        playerItem?.removeObserver(self, forKeyPath: "status", context: nil)
        playerItem?.removeObserver(self, forKeyPath: "loadedTimeRanges", context: nil)
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: AVPlayerItemDidPlayToEndTimeNotification, object: playerItem)
        
    }
    
    func playerItemDuration() -> CMTime {
        let playerItem: AVPlayerItem = player.currentItem!
        if playerItem.status == .ReadyToPlay {
            return playerItem.duration
        }
        
        return kCMTimeInvalid
    }
    
    // MARK: - 通知、kvo
    /**
    去除通知
    */
    private func removeNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: AVPlayerItemPlaybackStalledNotification, object: nil)
    }
    
    /// 添加通知
    private func addNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerCompleted", name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerBackStall", name: AVPlayerItemPlaybackStalledNotification, object: nil)
    }
    
    /// 添加监听
    private func addObserverPlayerItem(item: AVPlayerItem) {
        // 监听状态
        item.addObserver(self, forKeyPath: "status", options: .New, context: nil)
        // 监听网络加载情况
        item.addObserver(self, forKeyPath: "loadedTimeRanges", options: .New, context: nil)
    }
    
    /// 删除监听
    func removeObserverForPlayerItem(item: AVPlayerItem) {
        item.removeObserver(self, forKeyPath: "status")
        item.removeObserver(self, forKeyPath: "loadedTimeRanges")
    }
    
    /// 监听响应
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        print("应该会来吧")
        let playerItem: AVPlayerItem = object as! AVPlayerItem
        print(keyPath)
        if keyPath == "status" {
            print(change)
//            let status: AVPlayerStatus = change!["new"]! as? AVPlayerStatus ??  AVPlayerStatus(rawValue: 0)!
            

            if change!["new"]?.intValue == 1 {
                print("正在播放， 音频总长度是\(NSNumber(float: Float(playerItemDuration().value)))")
                let total: Float = Float(CMTimeGetSeconds(playerItem.duration))
                // 设置总显示时间
                let tot: Int32 = NSNumber(float: total).intValue
                
                print("============\(NSNumber(float: total).intValue)")
                print("\((tot/3600)):\((tot/60)):\((tot%60))")
            }
        } else if keyPath == "loadedTimeRanges" {
            let array = playerItem.loadedTimeRanges
            print(array)
            let timeRange = array.first?.CMTimeRangeValue
            if timeRange == nil { return }
            // 本次缓冲时间范围
            print( timeRange!.duration.value)
            
            
            let startSeconds = CMTimeGetSeconds(CMTime(value: timeRange!.duration.value, timescale: CMTimeScale.init(1.0)))
            let durationSeconds = CMTimeGetSeconds(playerItemDuration())
            let totalBuffer = startSeconds / durationSeconds
            if totalBuffer * 100 > 2 && isLoading {
                isLoading = false
                player.play()
            }
            print("共缓冲 \(Float(_builtinFloatLiteral: totalBuffer.value) * 100)")
        }
    }
    
    
    /// 通知响应
    func playerCompleted() {
        let time = CMTimeMakeWithSeconds(0.5, 1)
        player.seekToTime(time) { (_) -> Void in
            print("音频播完了")
            print(self.playerItem?.duration)
        }
    }
    
    func playerBackStall() {
        isLoading = true
        
    }
    
    /**
     添加播放进度
     */
    private func addPlayerProgress() {
        if playerItem == nil { return }
        //        let item = playerItem!.currentTime()
        /// 设置进度更新每一秒
        player.addPeriodicTimeObserverForInterval(CMTimeMake(1, 1), queue: dispatch_get_main_queue()) { (time) -> Void in
            let currentTime = CMTimeGetSeconds(time)
            //            AVPlayerItem().duration
            
            let totalTime: Float = Float(CMTimeGetSeconds(self.playerItem!.duration))
            self.overallDuration = NSNumber(float: Float(totalTime)).integerValue
            // 设置进度条显示
            if currentTime != 0.0 {
                print(NSNumber(float: Float(totalTime)).integerValue)
                self.progressV = Float(currentTime) / Float(totalTime)
            }
            let tot: Int = NSNumber(float: totalTime).integerValue
            /// 现在的时间
            print(tot / 3600,tot / 60,tot % 60)
            self.playCurrentTime = Float(currentTime)
        }
    }
    
    
    
    
    
    
    
    
    
    
    

    var audioPlayer = AVAudioPlayer()
    var isPlaying = false
    var timer:NSTimer!
    
    
    
    func playOrPauseMusic(sender: AnyObject) {
        if isPlaying {
            audioPlayer.pause()
            isPlaying = false
        } else {
            audioPlayer.play()
            isPlaying = true
            
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateTime", userInfo: nil, repeats: true)
        }
    }
    
    func updateTime() {
        var currentTime = Int(audioPlayer.currentTime)
        var minutes = currentTime/60
        var seconds = currentTime - minutes * 60
        
        playedTime.text = NSString(format: "%02d:%02d", minutes,seconds) as String
    }
    
    func stopMusic(sender: AnyObject) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        isPlaying = false
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
