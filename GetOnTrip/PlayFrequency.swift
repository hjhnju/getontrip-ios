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
    var playerItem: AVPlayerItem = AVPlayerItem(URL: NSURL())
    /// 音频总长度
    var duration: CMTime = CMTime() {
        didSet {
            print("总长度是多少\(duration.value)")
        }
    }
    /// 默认是首个
    var index = 0 {
        didSet {
            if let url = NSURL(string: dataSource[index]) {
                print(dataSource[index])
                
                playerItem.removeObserver(self, forKeyPath: "status", context: nil)
                playerItem.removeObserver(self, forKeyPath: "loadedTimeRanges", context: nil)
                
                playerItem = AVPlayerItem(asset: AVAsset(URL: url))
                player = AVPlayer(playerItem: playerItem)
                ProgressHUD.showSuccessHUD(nil, text: "正在缓冲中，请稍候")
                
                playerItem.addObserver(self, forKeyPath: "status", options: .New, context: nil)
                playerItem.addObserver(self, forKeyPath: "loadedTimeRanges", options: .New, context: nil)
                player.play()
            }
        }
    }
    /// 缓冲进度
    var availableProgress: NSTimeInterval? {
        didSet {
            print(availableProgress)
        }
    }

    override init() {
        super.init()
        
        
        
    }
    
    var tempData = NSData() {
        didSet {
//            tempData
            
            
            
//            player.play()
            
//            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
//            NSNotificationCenter.defaultCenter().addObserver(self, selector: "moviePlayDidEnd:", name: AVPlayerItemDidPlayToEndTimeNotification, object: playerItem)
        }
    }
    
    
//    - (void)monitoringPlayback:(AVPlayerItem *)playerItem {
//    
//    __weak typeof(self) weakSelf = self;
//    self.playbackTimeObserver = [self.playerView.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
//    CGFloat currentSecond = playerItem.currentTime.value/playerItem.currentTime.timescale;// 计算当前在第几秒
//    [weakSelf.videoSlider setValue:currentSecond animated:YES];
//    NSString *timeString = [self convertTime:currentSecond];
//    weakSelf.timeLabel.text = [NSString stringWithFormat:@"%@/%@",timeString,_totalTime];
//    }];
//    }
    
    func monitoringPlayback(playerItem: AVPlayerItem) {
        
    }
    
    
    ///
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        let playerItem1: AVPlayerItem = object as! AVPlayerItem
        
//        if ([keyPath isEqualToString:@"status"]) {
//            if ([playerItem status] == AVPlayerStatusReadyToPlay) {
//                NSLog(@"AVPlayerStatusReadyToPlay");
//                self.stateButton.enabled = YES;
//                CMTime duration = self.playerItem.duration;// 获取视频总长度
//                CGFloat totalSecond = playerItem.duration.value / playerItem.duration.timescale;// 转换成秒
//                _totalTime = [self convertTime:totalSecond];// 转换成播放时间
//                [self customVideoSlider:duration];// 自定义UISlider外观
//                NSLog(@"movie total duration:%f",CMTimeGetSeconds(duration));
//                [self monitoringPlayback:self.playerItem];// 监听播放状态
//            } else if ([playerItem status] == AVPlayerStatusFailed) {
//                NSLog(@"AVPlayerStatusFailed");
//            }
//        } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
//            NSTimeInterval timeInterval = [self availableDuration];// 计算缓冲进度
//            NSLog(@"Time Interval:%f",timeInterval);
//            CMTime duration = _playerItem.duration;
//            CGFloat totalDuration = CMTimeGetSeconds(duration);
//            [self.videoProgress setProgress:timeInterval / totalDuration animated:YES];
//        }
        
        if keyPath == "status" {
            if playerItem1.status == .ReadyToPlay {
                duration = playerItem.duration  // 视频的总长度
//                let totalSecond = CGFloat(playerItem!.duration.value) / CGFloat(playerItem!.duration.timescale) // 转换成秒
                let progress = CGFloat(playerItem.currentTime().value) / CGFloat(playerItem.duration.value)
                print("-----------------------")
                
                print(Double(progress))
//                let time = coverT
                /// 一旦准备好，就开始播放
//                player.play()
                print("什么时候会来到呢")
            }
        } else {
            availableProgress = availableDuration()
//            print("========= \(playerItem1.duration)")
            print("最终的进度是 \(Int(availableProgress! / NSTimeInterval(playerItem1.duration.value))))")
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
    
    
//    - (NSString *)convertTime:(CGFloat)second{
//    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
//    if (second/3600 >= 1) {
//    [[self dateFormatter] setDateFormat:@"HH:mm:ss"];
//    } else {
//    [[self dateFormatter] setDateFormat:@"mm:ss"];
//    }
//    NSString *showtimeNew = [[self dateFormatter] stringFromDate:d];
//    return showtimeNew;
//    }
    
//    func converTime(second: CGFloat) -> String {
//        let d = NSDate(timeIntervalSince1970: Double(second))
//        if second/3600 >= 1 {
//            
//        }
//    }
    
    /// 监控时间
    var avtimer: NSTimer?

    var playUrl = "" {
        didSet {
            

//            player = AVPlayer(URL: NSURL(string: "http://123.57.46.229:8301/audio/fd6f5bc4b4514c759ae44600f5b9580b.mp3")!)


            //            print(progress.fractionCompleted.value)
            
//            player.prepareToPlay()
//            player = AVAudioPlayer(contentsOfURL: NSURL(string: "http://123.57.46.229:8301/audio/fd6f5bc4b4514c759ae44600f5b9580b.mp3")!)
//            player = try! AVAudioPlayer(contentsOfURL: NSURL(string: "http://123.57.46.229:8301/audio/fd6f5bc4b4514c759ae44600f5b9580b.mp3")!)
            
            
//            Alamofire.download(.GET, imageURL, destination).progress {(_, totalBytesRead, totalBytesExpectedToRead) indispatch_async(dispatch_get_main_queue()) {// 6progressIndicatorView.setProgress(Float(totalBytesRead) / Float(totalBytesExpectedToRead), animated: true)// 7if totalBytesRead == totalBytesExpectedToRead {progressIndicatorView.removeFromSuperview()}}}
            
        }
    }
    
    /// 播放进度
    var progress: Float64 = 0 {
        didSet {
            
        }
    }
    
    
    /// 播放
    func play() {
        player.play()
//        avtimer = NSTimer(timeInterval: 0.1, target: self, selector: "timer", userInfo: nil, repeats: true)
//        NSRunLoop.mainRunLoop().addTimer(avtimer!, forMode: NSRunLoopCommonModes)
    }
    
    func timer() {
        progress = CMTimeGetSeconds(player.currentItem!.currentTime()) / CMTimeGetSeconds(player.currentItem!.duration)
    }
    
    /// 暂停
    func pause() {
        player.pause()
    }
    
//    #pragma mark === 主循环 ===
//    
//    - (void)mainLoop {
//    //1.旋转唱片的图片
//    CGFloat angle = [HMMusicTool sharedInstance].player.currentTime * 0.05 * M_PI;
//    
//    [self.discImage setTransform:CGAffineTransformMakeRotation(angle)];
//    [self.discMask setTransform:CGAffineTransformMakeRotation(angle)];
//    
//    //2.计算进度条的进度
//    CGFloat progress = [HMMusicTool sharedInstance].player.currentTime / [HMMusicTool sharedInstance].player.duration;
//    
//    CGFloat padding = (self.progressBg.bounds.size.width-67) * progress;
//    
//    [self.leftPadding setConstant:5-padding];
//    
//    //3.显示歌词
//    // 如果当前秒数大于下一行的起始时间，那么就切换歌词到下一句
//    HMLyric * next = [HMMusicTool sharedInstance].lyricList[[HMMusicTool sharedInstance].currentLyricIndex+1];
//    NSLog(@"%f %f",[HMMusicTool sharedInstance].player.currentTime , next.beginTime);
//    if ([HMMusicTool sharedInstance].player.currentTime > next.beginTime) {
//    [HMMusicTool sharedInstance].currentLyricIndex +=1;
//    [self.lyricLabel setText:next.contentText];
//    }
//    
//    
//    }
    
    
//    func mainLoop {
//        // 计算进度条的进度
////        let progress = player.currentTime / player.duration
//        
//    }
    
    
    deinit {
        playerItem.removeObserver(self, forKeyPath: "status", context: nil)
        playerItem.removeObserver(self, forKeyPath: "loadedTimeRanges", context: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: AVPlayerItemDidPlayToEndTimeNotification, object: playerItem)
    }
}
