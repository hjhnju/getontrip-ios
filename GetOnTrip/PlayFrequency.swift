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
import UIKit
import MediaPlayer

class PlayFrequency: NSObject {

    /// 播放列表
    var dataSource: [String] = [String]()
    /// 缓存
    var cache: NSCache = NSCache()
    /// 播放类
    var player: AVAudioPlayer?
    /// 父控制器
    weak var superViewController: SightViewController?
    /// 定时器
    var timer: NSTimer?
    /// 播放cell
    weak var playCell: LandscapeCell? {
        willSet {
            
        }
        didSet {
            
        }
    }
    
    /// 此歌总时长
    var songDuration: String = "" {
        didSet {
            print(songDuration)

        }
    }
    /// 景观数据源
    var dataLandscape = [Landscape]() {
        didSet {
            (parentViewController as? SightViewController)?.playController.dataSource = audios
        }
    }

    /// 现在播放的时间
    var currentTime: String = "" {
        didSet {
            print(currentTime)
        }
    }
    /// 默认是首个
    var index = -1 {
        didSet {
            let url = dataSource[index]
            if url != ""  {
                loadData(url)
            }
        }
    }
    /// 音频数据
    var data: NSData? {
        didSet {
            if let avData = data {
                do {
                    player = try AVAudioPlayer(data: avData)
                    player?.prepareToPlay()
                    songDuration = "\(player?.duration)"
                    if timer == nil {
                        timer = NSTimer(timeInterval: 1, target: self, selector: "mainLoop", userInfo: nil, repeats: true)
                        NSRunLoop.mainRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
                    }
                    // 配置UI界面
                    
                    
                    // 设置音频支持后台播放
                    audio2SupportBackgroundPlay()
                    setupLockScreenSongInfos()
                    player?.play()

                } catch {
                    print(error)
                }
            }
        }
    }
    
    func playOrPause(sender: UIButton) {
        if player == nil { return }
        // 播放速率调为1
//        player!.rate = 1
        if player!.playing { // 如果是正在播放就暂停
            player?.pause()
            updatePlayOrPauseBtn(false)
        } else { // 如果是暂停就播放
//            superViewController?.timer?.fireDate = NSDate() // 设定定时器时间为现在
//            superViewController?.timer?.fire()
        }
    }

    
    func updatePlayOrPauseBtn(isPlaying: Bool) {
        if isPlaying { // 播放
            player?.pause()
        } else { // 停止播放
            player?.play()
        }
    }
    
    /// 设置允许进行后台播放
    func audio2SupportBackgroundPlay() {

        let device = UIDevice.currentDevice()
        if device.respondsToSelector("multitaskingSupported") {
            print("Unsupported device!")
            return
        }
        
        if !device.multitaskingSupported {
            print("Unsupported multiTasking!")
            return
        }
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback)
        } catch {
            print(error)
            return
        }
        
        do {
            try session.setActive(true)
        } catch {
            print(error)
            return
        }
    }
    
    
    
    func setupLockScreenSongInfos() {
        
        let art = MPMediaItemArtwork(image: UIImage(named: "icon_app")!)

        MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = [
            MPMediaItemPropertyPlaybackDuration : player?.duration,
            MPMediaItemPropertyTitle : "北京",
            MPMediaItemPropertyArtist : "天安门广场",
            MPMediaItemPropertyArtwork : art,
            MPNowPlayingInfoPropertyPlaybackRate : 1.0
        ]
    }
    
    
    func loadData(url: String) {
        if let tempData = cache.objectForKey(url) {
            print("来到了")
            data = tempData as? NSData
            return
        }
        
        HttpRequest.download(url) { (result, status) -> () in
            if let tempData = result {
                self.data = tempData
                self.cache.setObject(tempData, forKey: url)
                return
            }
            if status != RetCode.SUCCESS {
                ProgressHUD.showErrorHUD(nil, text: "网络无法连接")
            }
        }
    }
    
    override init() {
        super.init()

        cache.totalCostLimit = 30 * 1024 * 1024
        cache.countLimit     = 20
    }
    
    // MARK: - 主循环
    func mainLoop() {
        print("每次都来吧")
        // 进算进度条进度
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
        print("======================================会走吧")
    }
}
