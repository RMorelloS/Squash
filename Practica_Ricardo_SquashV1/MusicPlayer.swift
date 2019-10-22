//
//  MusicPlayer.swift
//  Practica_Ricardo_SquashV1
//
//  Created by Morello Santos Ricardo on 10/8/19.
//  Copyright © 2019 Morello Santos Ricardo. All rights reserved.
//

import Foundation

import Foundation
import AVFoundation

class MusicPlayer {
    static let shared = MusicPlayer()
    var audioPlayer: AVAudioPlayer?
    var hitAudioPlayer : AVAudioPlayer?
    func startBackgroundMusic(musicToPlay : String) {
        
        if let bundle = Bundle.main.path(forResource: musicToPlay, ofType: "mp3") {
            let backgroundMusic = NSURL(fileURLWithPath: bundle)
         
            do {
                audioPlayer = try AVAudioPlayer(contentsOf:backgroundMusic as URL)
                guard let audioPlayer = audioPlayer else { return }
                audioPlayer.numberOfLoops = -1
                audioPlayer.prepareToPlay()
                if musicToPlay == "notimeforcaution"{
                    audioPlayer.currentTime = 43
                    audioPlayer.volume = 1
                }else if musicToPlay == "gameMusic"{
                    audioPlayer.volume = 0.1
                }
                
                audioPlayer.play()
            } catch {
                print(error)
            }
        }
    }
    func startHitMusic(hitEffect : String){
        if let bundle = Bundle.main.path(forResource: hitEffect, ofType: "mp3") {
            let hitEffectSound = NSURL(fileURLWithPath: bundle)
            do {
                hitAudioPlayer = try AVAudioPlayer(contentsOf:hitEffectSound as URL)
                guard let hitAudioPlayer = hitAudioPlayer else { return }
                if !hitAudioPlayer.isPlaying{
                    hitAudioPlayer.numberOfLoops = 1
                    hitAudioPlayer.prepareToPlay()
                    audioPlayer?.volume = 0.09
                    hitAudioPlayer.volume = 1
                    hitAudioPlayer.play()
                }
            } catch {
                print(error)
            }
        }
    }
    func stopBackgroundMusic(){
        audioPlayer?.stop()
    }
}
