//
//  SplashVideoViewController.swift
//  AppmazoKit
//
//  Created by James Hickman on 5/18/18.
//  Copyright © 2018 Appmazo, LLC. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

public class SplashVideoViewController: UIViewController {
    private var videoURL: URL
    private var videoSize: CGSize

    private let videoView = UIView()
    private var completion: (() -> Void)?
    
    // MARK: - Init
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    public init(videoURL: URL, videoSize: CGSize) {
        self.videoURL = videoURL
        self.videoSize = videoSize
        
        super.init(nibName: nil, bundle: nil)
    
        view.backgroundColor = UIColor.black
        
        NotificationCenter.default.addObserver(self, selector:#selector(playerDidFinishPlaying(_:)),name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(videoView, centeredWithView: view)
        
        NSLayoutConstraint(item: videoView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: videoSize.width).isActive = true
        NSLayoutConstraint(item: videoView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: videoSize.height).isActive = true
    }
    
    // MARK: - SplashVideoViewController
    
    public func playVideo(completion: (() -> Void)?) {
        self.completion = completion
        
        let avPlayer = AVPlayer(url: videoURL)
        let avPlayerController = AVPlayerViewController()
        avPlayerController.player = avPlayer
        avPlayerController.view.frame = videoView.bounds
        avPlayerController.showsPlaybackControls = false
        avPlayerController.player?.play()
        videoView.addSubview(avPlayerController.view)
    }
    
    @objc private func playerDidFinishPlaying(_ sender: NSNotification) {
        completion?()
    }

}
