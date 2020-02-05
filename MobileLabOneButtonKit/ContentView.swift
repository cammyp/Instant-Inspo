import SwiftUI
import AVFoundation
import SpriteKit
import GameplayKit

struct ContentView: View {
    
    // Track current index
    @State private var currentIndex = 0
    // Player for sound clips
    let audioPlayer = AVPlayer()
    
    // Set to 'true' or 'false' to control content sequence.
    let randomize = false
    // Set to array size
    let arraySize = 6
    // Background colors
    let bgColors = [0xedd7b1,
                    0xede6cd,
                    0xc3d7ed,
                    0xcdedce,
                    0xfaf3e7,
                    0xf6d7d4]
    // String array for label
    let labels = ["If you only knew how powerful you are",
                  "Become who you are truly meant to be and more",
                  "Be your biggest cheerleader",
                  "To be alive is to lean into the future",
                  "Uniqueness matters",
                  "Who are you not to be brilliant?"]
    // MP3 sound file array
    let sounds = ["",
                  "",
                  "",
                  "",
                  "",
                  ""]
    
    // Compute next index.
    var nextIndex: Int {
        if randomize {
            return Int.random(in: 1..<arraySize)
        } else {
            return (currentIndex + 1 == arraySize) ? 0 : currentIndex + 1
        }
    }
    
    // Play sound helper method.
    func playSound(filename: String) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "") else { return }
        
        let playerItem = AVPlayerItem(url: url)
        audioPlayer.replaceCurrentItem(with: playerItem)
        audioPlayer.play()
    }
    
    // Main view render method.
    var body: some View {
        // Use ZStack to layer elements.
        ZStack {
            // Backgrond color.
            Color(bgColors[currentIndex])
            
            // Only show one background image
            Image("background")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

            // Set text.
            Text(labels[currentIndex])
                .font(.custom("Futura-Medium", size: 48))
                .foregroundColor(.white)
                .padding()
                // add shadow to text
                .clipped()
                .shadow(color: Color.black, radius: 1, x: 0, y: 0)
            
            // Button for entire view.
            Button(action: {
                // Increment index when tapped.
                self.currentIndex = self.nextIndex
                
                // Play sound if available.
                let sound = self.sounds[self.currentIndex]
                if !sound.isEmpty {
                    self.playSound(filename: sound)
                }
            }) {
                Color.clear.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear() {
            do {
               // Override device mute control.
               try AVAudioSession.sharedInstance().setCategory(.playback)
            } catch(let error) {
                print(error.localizedDescription)
            }
        }
    }
}

// Show preview in Canvas.
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
