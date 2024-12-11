import SwiftUI
import AVFoundation

class AudioPlayerManager: ObservableObject {
    @Published var player: AVAudioPlayer?
    
    init() {
        guard let path = Bundle.main.path(forResource: "BackgroundMusic", ofType: "mp3") else { return }
        let url = URL(fileURLWithPath: path)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set audio session category. \(error)")
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1 // Loop the music infinitely
            player?.prepareToPlay()
        } catch {
            print("Error loading audio file: \(error)")
        }
    }
    
    func playPause() {
        if player?.isPlaying == true {
            player?.pause()
        } else {
            player?.numberOfLoops = -1 // Ensure music loops infinitely when started
            player?.play()
        }
    }
    
    deinit {
        player?.stop()
    }
}
