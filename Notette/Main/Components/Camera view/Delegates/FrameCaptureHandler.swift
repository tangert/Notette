//
//  FrameExtractor.swift
//  Notette
//
//  Created by Tyler Angert on 8/1/18.
//  Copyright © 2018 Tyler Angert. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import ColorThiefSwift

fileprivate let CAPTURE_RATE: TimeInterval = 0.75

protocol Capturable {
    var frameCaptureDelegate: AVCaptureVideoDataOutputSampleBufferDelegate? { get set }
}

class FrameCaptureHandler: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var delegateTarget: Capturable!
    var timer: Timer!
    var readyToProcess: Bool! = false
    
    // Variables to send to store
    static var capturedImage: UIImage!
    var palette: [UIColor]!
    
    init(delegateTarget: Capturable) {
        super.init()
        
        self.delegateTarget = delegateTarget
        self.delegateTarget.frameCaptureDelegate = self
        
        // Sets the capturing function ready to process colors
        timer = Timer.scheduledTimer(timeInterval: CAPTURE_RATE, target: self, selector: #selector(self.process), userInfo: nil, repeats: true)
    }
    
    // MARK: Primary output method
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
       
        // Grab the current image
        // Sets the last frame in the store
        FrameCaptureHandler.capturedImage = imageFromSampleBuffer(sampleBuffer: sampleBuffer)
        
        // Processes colors
        if readyToProcess {
            
            DispatchQueue.global(qos: .default).async {
                // Grab all of the relevant colors
                self.palette = self.extractPalette(image: FrameCaptureHandler.capturedImage)
                
                // Send to store
                mainStore.dispatch(setNewColorPalette(colors: self.palette))
            }
            
            self.readyToProcess = false
            
        }
    }
    
    // For capturing dropped frames
    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {}
    
    // Sets the timer bool
    @objc func process() {
        readyToProcess = true
    }
    
    // MARK: Helper methods
    
    func extractPalette(image: UIImage) -> [UIColor] {
        guard let colors = ColorThief.getPalette(from: image, colorCount: 9) else {
            return [UIColor].init(repeating: UIColor.clear, count: 8)
        }
        let currentPalette = colors.map { $0.makeUIColor() }
        return currentPalette
    }

    
    func imageFromSampleBuffer(sampleBuffer : CMSampleBuffer) -> UIImage {
        
        // Get a CMSampleBuffer's Core Video image buffer for the media data
        let  imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        
        // Lock the base address of the pixel buffer
        CVPixelBufferLockBaseAddress(imageBuffer!, CVPixelBufferLockFlags.readOnly)
        
        // Get the number of bytes per row for the pixel buffer
        let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer!)
        
        // Get the number of bytes per row for the pixel buffer
        let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer!)
        
        // Get the pixel buffer width and height
        let width = CVPixelBufferGetWidth(imageBuffer!)
        let height = CVPixelBufferGetHeight(imageBuffer!)
        
        // Create a device-dependent RGB color space
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        // Create a bitmap graphics context with the sample buffer data
        var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Little.rawValue
        bitmapInfo |= CGImageAlphaInfo.premultipliedFirst.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        
        //let bitmapInfo: UInt32 = CGBitmapInfo.alphaInfoMask.rawValue
        let context = CGContext.init(data: baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
        
        // Create a Quartz image from the pixel data in the bitmap graphics context
        let quartzImage = context?.makeImage()
        
        // Unlock the pixel buffer
        CVPixelBufferUnlockBaseAddress(imageBuffer!, CVPixelBufferLockFlags.readOnly)
        
        // Create an image object from the Quartz image
        let image = UIImage.init(cgImage: quartzImage!)
        
        return (image)
    }
    
}
