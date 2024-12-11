import SwiftUI

struct Change3View: View {
    @EnvironmentObject var selection: Selection
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4).edgesIgnoringSafeArea(.all)
            VStack(spacing: 20) {
                Text("Below Safe Altitude (300m)")
                    .font(.title)
                    .foregroundColor(.white)
                Text("No parachute can deploy when you're too close to the ground. As you notice, we alway skydive during sunny days. Let’s see what will happen if it’s cloudy. You will have to chance to place cloud in the sky!")
                    .frame(maxWidth: 400)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .padding()
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                
                Button(action: {
                    selection.value = 3
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
                    selection.value = 4
                }) {
                    HStack {
                        Text("Place Cloud")
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
        }
    }
}

