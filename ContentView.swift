import SwiftUI

struct ContentView: View {
    @EnvironmentObject var selection: Selection
    @StateObject private var audioPlayerManager = AudioPlayerManager()
    @State private var isPlaying = false

    var body: some View {
        ZStack {
            Group {
                switch selection.value {
                case 0:
                    IntroView().environmentObject(selection)
                case 1, 5:
                    PhaseOneView().environmentObject(selection)
                case 2, 6:
                    PhaseTwoView().environmentObject(selection)
                case 3, 7:
                    PhaseThreeView().environmentObject(selection)
                case 4, 8:
                    PhaseFourView().environmentObject(selection)
                default:
                    Text("Main content for selection \(selection.value)")
                }
            }.zIndex(1)

            if selection.value == 5 {
                Change1View().environmentObject(selection)
            }
            if selection.value == 6 {
                Change2View().environmentObject(selection)
            }
            if selection.value == 7 {
                Change3View().environmentObject(selection)
            }
            if selection.value == 8 {
                EndView().environmentObject(selection)
            }

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        self.isPlaying.toggle()
                        audioPlayerManager.playPause()
                    }) {
                        Image(systemName: isPlaying ? "speaker.wave.2.fill" : "speaker.slash.fill")
                            .font(.system(size: 22))
                            .foregroundColor(isPlaying ? .blue : .white)
                            .padding()
                            .background(isPlaying ? Color.white : Color.gray.opacity(0.5))
                            .clipShape(Circle())
                            .shadow(radius: 10)
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    }
                    .padding(32)
                }
            }
            .zIndex(2)
        }
        .onAppear {
            if let savedValue = UserDefaults.standard.value(forKey: "selectionValue") as? Int {
                selection.value = savedValue
            } else {
                selection.value = 0
            }
            isPlaying = true
            audioPlayerManager.playPause()
        }
        .onChange(of: selection.value) { newValue in
            UserDefaults.standard.set(newValue, forKey: "selectionValue")
        }
    }
}
