////
////  VideoController.swift
////  SorceryMentor
////
////  Created by Giovana Nogueira on 06/03/24.
////
//
//import SwiftUI
//import AVFoundation
//import AVKit
//
//struct PlayerView: UIViewRepresentable {
//    let videoName: String
//
//    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PlayerView>) {}
//
//    func makeUIView(context: Context) -> UIView {
//        return LoopingPlayerUIView(frame: .zero, videoName: videoName)
//    }
//}
//
//class LoopingPlayerUIView: UIView {
//    private let playerLayer = AVPlayerLayer()
//    private var playerLooper: AVPlayerLooper?
//    let player = AVQueuePlayer()
//
//    init(frame: CGRect, videoName: String) {
//        super.init(frame: .zero)
//        setupPlayer(with: videoName)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func setupPlayer(with videoName: String) {
//        guard let fileUrl = Bundle.main.url(forResource: videoName, withExtension: "mp4") else {
//            fatalError("Failed to find video file: \(videoName)")
//        }
//
//        let asset = AVAsset(url: fileUrl)
//        let item = AVPlayerItem(asset: asset)
//        playerLayer.frame = frame
//        playerLayer.player = player
//        playerLayer.videoGravity = .resizeAspectFill
//        layer.addSublayer(playerLayer)
//
//        playerLooper = AVPlayerLooper(player: player, templateItem: item)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(self.playVideo), name: UIApplication.willEnterForegroundNotification, object: nil)
//
//        player.play()
//    }
//
//    @objc private func playVideo() {
//        self.player.play()
//    }
//
//    @objc private func pauseVideo() {
//        self.player.pause()
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        playerLayer.frame = frame
//    }
//}
//
//extension AVPlayer {
//    var isPlaying: Bool {
//        return rate != 0 && error == nil
//    }
//}
