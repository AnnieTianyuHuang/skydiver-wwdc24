import SwiftUI

struct Change1View: View {
    @EnvironmentObject var selection: Selection
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
            VStack(spacing: 20) {
                Text("""
                    CONGRATULATIONS!

                    You've successfully completed a parachute jump.

                    Did you notice the safety altitude limit in the game? What happens if you go higher?

                    Let's find out!
                    """)
                    .frame(maxWidth: 400)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .padding()
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                
                
                Button(action: {
                    selection.value = 1
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
                    selection.value = 2
                }) {
                    HStack {
                        Text("Try Higher")
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
