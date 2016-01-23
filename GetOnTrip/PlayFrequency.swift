//
//  PlayFrequency.swift
//  GetOnTrip
//
//  Created by 王振坤 on 16/1/14.
//  Copyright © 2016年 Joshua. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMedia
import UIKit
import MediaPlayer

class PlayFrequency: NSObject, AVAudioPlayerDelegate {

    /// 标题
    var title = ""
    /// 副标题
    var subtitle = ""
    /// 播放列表
    var dataSource: [String] = [String]()
    /// 缓存
    var cache: NSCache = NSCache()
    /// 播放类
    var player: AVAudioPlayer?
    /// 外面景点的播放view
    var pulsateView: PlayPulsateView?
    /// 父控制器
    weak var superViewController: SightViewController?
    /// 景观详情控制器
    weak var sightDetailController: SightDetailViewController? {
        didSet {
            sightDetailController?.slide.addTarget(self, action: "adjustDuration:", forControlEvents: .ValueChanged)
            sightDetailController?.playBeginButton.addTarget(self, action: "playBeginButtonAction:", forControlEvents: .TouchUpInside)
            if index == sightDetailController?.index {
                sightDetailController?.playBeginButton.selected = isPlay ? true : false
            }
        }
    }
    /// 定时器
    var timer: NSTimer?
    /// 是否正在加载
    var isLoading: Bool = false
    /// 当前进度
    var slideProgress: Float = 0 {
        didSet {
            if sightDetailController?.index == index {
                sightDetailController?.slide.setValue(slideProgress, animated: true)
            }
        }
    }
    /// 播放cell
    weak var playCell: LandscapeCell? {
        willSet {
            if (newValue != nil) {
                if !newValue!.pulsateView.isAddAnimation {
                    newValue?.pulsateView.playIconAction()
                }
                newValue?.pulsateView.hidden = true
                subtitle = playCell?.landscape?.name ?? ""
            }
        }
        didSet {
            oldValue?.pulsateView.hidden = true
            oldValue?.speechImageView.hidden = false
            oldValue?.restoreDefault()
        }
    }
    /// 是否正在播放
    var isPlay: Bool = false {
        didSet {
            pulsateView?.hidden = isPlay ? false : true
            playCell?.speechImageView.hidden = isPlay ? true : false
            playCell?.pulsateView.hidden = isPlay ? false : true
            sightDetailController?.playBeginButton.selected = isPlay ? true : false
            setupLockScreenSongInfos()
            if index == sightDetailController?.index {
                sightDetailController?.playBeginButton.selected = isPlay ? true : false
            }
        }
    }
    
    /// 此歌总时长
    var songDuration: String = "0"
    /// 景观数据源
    var dataLandscape = [Landscape]() {
        didSet {
            var datas = [String]()
            for item in dataLandscape {
                datas.append(item.audio)
            }
            dataSource = datas
        }
    }

    /// 现在播放的时间
    var currentTime: String = "0" {
        didSet {
            let totalTime = Int(Double(currentTime) ?? 0)
            let songTime  = Int(Double(player?.duration ?? 0) ?? 0)
            playCell?.playLabel.text = String(format: "%02d:%02d/%02d:%02d", totalTime/60, totalTime%60, songTime/60, songTime%60)
            if sightDetailController?.index == index {                
                sightDetailController?.currentTimeLabel.text = String(format: "%02d:%02d", totalTime/60, totalTime%60)
                sightDetailController?.totalTimeLabel.text = String(format: "%02d:%02d", songTime/60, songTime%60)
            }
        }
    }
    /// 默认是首个
    var index = -1 {
        didSet {
            let url = dataSource[index]
            print(url)
            if url != ""  {
                loadData(url)
            }
        }
    }
    // MARK: - 开始播放 音频数据
    var data: NSData? {
        didSet {
            if let avData = data {
                do {
                    isPlay = false
                    player = try AVAudioPlayer(data: avData)
                    player?.delegate = self
                    player?.prepareToPlay()
                    songDuration = "\(player?.duration)"
                    if timer == nil { startTimer() }
                    
                    // 设置音频支持后台播放
                    audio2SupportBackgroundPlay()
                    player?.play()
                    isPlay = true
                    
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func playOrPause(cell: LandscapeCell) {
        if playCell != cell {
            playCell = cell
        }

        if index != cell.playAreaButton.tag {
            index = cell.playAreaButton.tag
            return
        }
        if player == nil {
            ProgressHUD.showErrorHUD(nil, text: "正在加载中，请稍候")
            return
        }
        
        updatePlayOrPauseBtn(player?.playing ?? false)
    }

    
    func updatePlayOrPauseBtn(isPlaying: Bool) {
        if isPlaying { // 播放
            stopTimer()
            player?.pause()
            isPlay = false
        } else { // 停止播放
            startTimer()
            player?.play()
            isPlay = true
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
        var image: UIImage = UIImage()
        
        image = playCell?.iconView.image ?? UIImage()
        let art = MPMediaItemArtwork(image: image ?? UIImage())
        MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = [
            MPMediaItemPropertyPlaybackDuration : (player?.duration ?? 0),
            MPMediaItemPropertyTitle : title,
            MPMediaItemPropertyArtist : subtitle,
            MPMediaItemPropertyArtwork : art,
            MPNowPlayingInfoPropertyPlaybackRate : 1.0
        ]
    }
    
    
    func loadData(url: String) {
        if let tempData = cache.objectForKey(url) {
            data = tempData as? NSData
            return
        }
        ProgressHUD.showSuccessHUD(nil, text: "正在缓冲，请稍候")
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
    
    // MARK: - 自定义方法
    func adjustDuration(sender: UISlider) {
        if index != sightDetailController?.index {
            playCell = sightDetailController?.playCell
            index = sightDetailController?.index ?? -1
            return
        }
        player?.currentTime = Double(sender.value) * (player?.duration ?? 0)
    }
    
    func playBeginButtonAction(sender: UIButton) {
        
        if playCell != sightDetailController?.playCell {
            playCell = sightDetailController?.playCell
        }
        
        if index != sightDetailController?.index {
            index = sightDetailController?.index ?? -1
            return
        }
        updatePlayOrPauseBtn(sender.selected)
//        sender.selected = !sender.selected
    }
    
    // MARK: - 主循环
    func mainLoop() {
        // 进算进度条进度
        let progress = (player?.currentTime ?? 0) / (player?.duration ?? 0)
        slideProgress = Float(progress)
        currentTime = "\((player?.currentTime ?? 0))"
    }
    
    /// 开启定时器
    func startTimer() {
        timer = NSTimer(timeInterval: 1, target: self, selector: "mainLoop", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
    }
    
    /// 停止定时器
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    deinit {
    }
    
    // MARK: - avaudio代理方法
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        stopTimer()
        slideProgress = 0
        currentTime = "0"
        sightDetailController?.playBeginButton.selected = false
        isPlay = false
        playCell?.restoreDefault()
    }
}
