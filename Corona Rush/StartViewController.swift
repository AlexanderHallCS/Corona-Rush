//
//  StartViewController.swift
//  Corona Rush
//
//  Created by Alexander Hall on 1/30/21.
//

import UIKit
import AVFoundation

class StartViewController: UIViewController {

    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        playSound(fileName: "La Cumbia Del Coronavirus")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func playSound(fileName: String) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") else {
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let audioPlayer = audioPlayer else {
                return
            }
            audioPlayer.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }

}
