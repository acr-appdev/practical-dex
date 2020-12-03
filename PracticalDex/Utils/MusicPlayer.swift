//
//  MusicPlayer.swift
//  PracticalDex
//
//  Created by Allan Rosa on 17/11/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//

import AVFoundation

var bgmPlayer: AVAudioPlayer?

func playBGM(sound: String, type: String) {
	if let path = Bundle.main.path(forResource: sound, ofType: type){
		do {
			bgmPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
			bgmPlayer?.numberOfLoops = -1
			bgmPlayer?.play()
			bgmPlayer?.setVolume(UserDefaults.standard.float(forKey: K.App.Defaults.appVolume), fadeDuration: 0)
			
		} catch {
			print("Error: Could not find and play \(sound).\(type)")
		}
	}
}
