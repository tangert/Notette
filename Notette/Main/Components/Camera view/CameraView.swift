//
//  CameraView.swift
//  Notette
//
//  Created by Tyler Angert on 7/30/18.
//  Copyright © 2018 Tyler Angert. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import ColorThiefSwift

fileprivate let CAPTURE_RATE: TimeInterval = 0.75

class CameraView: UIView, Capturable {
    
    // MARK: Delegate
    var frameCaptureDelegate: AVCaptureVideoDataOutputSampleBufferDelegate?
    
    // MARK: Lazy var initialization
    // Only loaded when needed to save memory
    
    private lazy var videoDataOutput: AVCaptureVideoDataOutput = {
        let v = AVCaptureVideoDataOutput()
        v.alwaysDiscardsLateVideoFrames = true
        v.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_32BGRA as UInt32)] as [String : Any]
        v.setSampleBufferDelegate(self.frameCaptureDelegate, queue: videoDataOutputQueue)
        v.connection(with: .video)?.isEnabled = true
        return v
    }()
    
    private let videoDataOutputQueue: DispatchQueue = DispatchQueue(label: "JKVideoDataOutputQueue")
    
    // MARK: Video orientation
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        
        let l = AVCaptureVideoPreviewLayer(session: session)
        
        // can you make this automatic?
        l.connection?.videoOrientation = .landscapeRight
        l.videoGravity = AVLayerVideoGravity.resizeAspectFill
        l.bounds = UIScreen.main.bounds
        
        return l
    }()
    
    private let captureDevice: AVCaptureDevice? = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
    
    // MARK: Video quality
    private lazy var session: AVCaptureSession = {
        let s = AVCaptureSession()
        s.sessionPreset = .high
        return s
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // MARK: initialize delegate
        let _ = FrameCaptureHandler(delegateTarget: self)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        contentMode = .scaleAspectFill
        beginSession()
    }
    
    private func beginSession() {
        
        do {
            guard let captureDevice = captureDevice else {
                fatalError("Camera doesn't work on the simulator! You have to test this on an actual device!")
            }
            
            let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            if session.canAddInput(deviceInput) {
                session.addInput(deviceInput)
            }
            
            if session.canAddOutput(videoDataOutput) {
                session.addOutput(videoDataOutput)
            }
            
            session.commitConfiguration()
            
            layer.masksToBounds = true
            layer.addSublayer(previewLayer)
            
            let queue = DispatchQueue(label: "fr.popigny.videoQueue", attributes: [])
            videoDataOutput.setSampleBufferDelegate(self.frameCaptureDelegate, queue: queue)
            
            previewLayer.frame = UIScreen.main.bounds
            session.startRunning()
            
        } catch let error {
            debugPrint("\(self.self): \(#function) line: \(#line).  \(error.localizedDescription)")
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

}
