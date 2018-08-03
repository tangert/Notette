//
//  Synthesizer.swift
//  Notette
//
//  Created by Tyler Angert on 8/3/18.
//  Copyright © 2018 Tyler Angert. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class Synthesizer: AVAudioEngine {
    
    var sampler: AVAudioUnitSampler!
    var reverb: AVAudioUnitReverb!
    var delay: AVAudioUnitDelay!
    
    override init() {
        super.init()
        
        sampler = AVAudioUnitSampler()
        reverb = AVAudioUnitReverb()
        delay = AVAudioUnitDelay()
    }
    
    func startEngine() {
        
        setupEngine(instrument: sampler, effects: [reverb,delay])
        setupReverb(reverb)
        setupDelay(delay)
        
        if self.isRunning {
            print("audio engine already running")
            return
        }
        do {
            try self.start()
            print("audio engine started")
        } catch {
            print("could not start audio engine")
            return
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback,
                                         with: AVAudioSessionCategoryOptions.mixWithOthers)
        } catch {
            print("audioSession: couldn't set category \(error)")
            return
        }
        do {
            try audioSession.setActive(true)
        } catch {
            print("audioSession: couldn't set category active \(error)")
            return
        }
    }
    
    func setupEngine(instrument: AVAudioUnitMIDIInstrument, effects: [AVAudioUnitEffect]) {
        
        // 1. Attach all effects and instrument
        self.attach(instrument)
        
        for e in effects {
            self.attach(e)
        }
        
        // 2: Connect sampler to first effect
        self.connect(instrument, to: effects[0], format: nil)
        
        // 3: Link effects to each other
        for i in 1..<effects.count-1 {
            
            // Ex: connects sampler -> delay
            //              delay   -> reverb
            //              reverb  -> mainMix
            
            self.connect(effects[i], to: effects[i+1], format: nil)
        }
        
        // 4: Connect last effect to main mix
        self.connect(effects[effects.count-1], to: self.mainMixerNode, format: nil)
    }
    
    func setupReverb(_ reverb: AVAudioUnitReverb) {
        reverb.loadFactoryPreset(.mediumHall)
        reverb.wetDryMix = 30.0
    }
    
    func setupDelay(_ delay: AVAudioUnitDelay) {
        delay.wetDryMix = 15.0
        delay.delayTime = 0.50
        delay.feedback = 75.0
        delay.lowPassCutoff = 16000.0
    }
}
