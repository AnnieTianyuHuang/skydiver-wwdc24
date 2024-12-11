import SwiftUI

struct Change2View: View {
    @EnvironmentObject var selection: Selection
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4).edgesIgnoringSafeArea(.all)
            VStack(spacing: 20) {
                Text("Above Kármán Line (100km)")
                    .font(.title)
                    .foregroundColor(.white)
                Text("Above that you will drift into the void of space, where Earth's grasp weakens. What will happen if we go lower the limits?")
                    .frame(maxWidth: 400)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .padding()
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                
                Button(action: {
                    selection.value = 2
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
                
                Button(action: {
                    selection.value = 3
                }) {
                    HStack {
                        Text("Try Lower")
                        Image(systemName: "arrow.right.circle.fill")
                    }
                }
                .frame(width: 200)
                .font(.system(size: 30))
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            }
            .padding()
        }
    }
}
