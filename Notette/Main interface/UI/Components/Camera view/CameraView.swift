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

class CameraView: UIView {
    
    var capturedImage: UIImage!
    var timer: Timer!
    var canCapture = false
    
    private lazy var videoDataOutput: AVCaptureVideoDataOutput = {
        let v = AVCaptureVideoDataOutput()
        v.alwaysDiscardsLateVideoFrames = true
        v.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_32BGRA as UInt32)] as [String : Any]
        v.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
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
        
        // MARK: timer to capture frames every second
        timer = Timer.scheduledTimer(timeInterval: CAPTURE_RATE, target: self, selector: #selector(self.grabFrame), userInfo: nil, repeats: true)
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
            videoDataOutput.setSampleBufferDelegate(self, queue: queue)
            
            previewLayer.frame = UIScreen.main.bounds
            session.startRunning()
            
        } catch let error {
            debugPrint("\(self.self): \(#function) line: \(#line).  \(error.localizedDescription)")
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @objc func grabFrame() {
        canCapture = true
    }
    
    func imageFromSampleBuffer(sampleBuffer : CMSampleBuffer) -> UIImage
    {
        // Get a CMSampleBuffer's Core Video image buffer for the media data
        let  imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        // Lock the base address of the pixel buffer
        CVPixelBufferLockBaseAddress(imageBuffer!, CVPixelBufferLockFlags.readOnly);
        
        
        // Get the number of bytes per row for the pixel buffer
        let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer!);
        
        // Get the number of bytes per row for the pixel buffer
        let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer!);
        // Get the pixel buffer width and height
        let width = CVPixelBufferGetWidth(imageBuffer!);
        let height = CVPixelBufferGetHeight(imageBuffer!);
        
        // Create a device-dependent RGB color space
        let colorSpace = CGColorSpaceCreateDeviceRGB();
        
        // Create a bitmap graphics context with the sample buffer data
        var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Little.rawValue
        bitmapInfo |= CGImageAlphaInfo.premultipliedFirst.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        //let bitmapInfo: UInt32 = CGBitmapInfo.alphaInfoMask.rawValue
        let context = CGContext.init(data: baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
        // Create a Quartz image from the pixel data in the bitmap graphics context
        let quartzImage = context?.makeImage();
        // Unlock the pixel buffer
        CVPixelBufferUnlockBaseAddress(imageBuffer!, CVPixelBufferLockFlags.readOnly);
        
        // Create an image object from the Quartz image
        let image = UIImage.init(cgImage: quartzImage!);
        
        return (image);
    }

}

protocol FrameExtractorDelegate: class {
    func captured(image: UIImage)
}

// Create a frame capture object that is the delegate
// MARK: Capture delegate

extension CameraView: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {}
    
    // FIXME: Create a frame capture delegate that does all the relevant processing
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        // Fires once every half second or half second
        // color processing
        self.capturedImage = imageFromSampleBuffer(sampleBuffer: sampleBuffer)
        mainStore.dispatch(setLastFrame(frame: self.capturedImage))

        if canCapture {
            
            DispatchQueue.global(qos: .default).async {
                
                guard let colors = ColorThief.getPalette(from: self.capturedImage, colorCount: 9) else {
                    print("Couldn't get it")
                    return
                }
                
                let currentPalette = colors.map { $0.makeUIColor() }
                
                // Set the new color palette
                mainStore.dispatch(setNewColorPalette(colors: currentPalette))
                
            }
            
            canCapture = false
        }
        
    }
    
}
