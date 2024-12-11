import SwiftUI

struct EndView: View {
    @EnvironmentObject var selection: Selection
    var body: some View {
        ZStack {
            Color.black.opacity(0.4).edgesIgnoringSafeArea(.all)
            VStack(spacing: 20) {
                Text("Final Lesson: Clouds")
                    .font(.title)
                    .foregroundColor(.white)
                Text("Each cloud passed increases drag, making it harder to control the descent. Overwhelmed by the fluff, the parachute fails to deploy in time. NOW YOU HAVE PASSED ALL TRAININGS. KEEP TRYING, AND ENJOY!")
                    .frame(maxWidth: 400)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .padding()
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                
                Button(action: {
                    selection.value = 4
                }) {
                    HStack {
                        Text("Replay")
                        Image(systemName: "arrow.counterclockwise.circle.fill")
                    }
                }
                .frame(width: 200)
                .font(.system(size: 30))
                .foregroundColor(.black)
                .padding()
                .background(Color.white.opacity(0.6))
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            }
        }
    }
}
