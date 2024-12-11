import SwiftUI
import SpriteKit

struct IntroView: View {
    @EnvironmentObject var selection: Selection
    
    let aspectRatio: CGFloat = 3.0 / 4.0
    let minPadding: CGFloat = 50.0
    let cornerRadius: CGFloat = 32.0
    
    var scene: SKScene {
        let scene = SKScene()
        scene.size = CGSize(width: 900, height: 1200)
        scene.scaleMode = .aspectFit
        
        let backgroundImage = SKSpriteNode(imageNamed: "simulator")
        backgroundImage.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2 + 5)
        backgroundImage.zPosition = -1
        backgroundImage.setScale(1.0/3.0)
        scene.addChild(backgroundImage)
        
        return scene
    }
    
    var body: some View {
        
        ZStack {
            GeometryReader { geometry in
                ZStack {
                    Image("background_5")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                        .edgesIgnoringSafeArea(.all)
                    
                    let spriteWidth = min(geometry.size.width - minPadding * 2, (geometry.size.height - minPadding * 2) * aspectRatio)
                    let spriteHeight = min((geometry.size.width - minPadding * 2) / aspectRatio, geometry.size.height - minPadding * 2)
                    
                    SpriteView(scene: scene)
                        .frame(width: spriteWidth, height: spriteHeight)
                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                        .padding(minPadding)
                    
                    // Centered View with text and button
                    VStack(spacing: 30) {
                        Text(
                            """
                            Hey there! I'm Annie.
                            
                            I started skydiving on my 18th birthday and was instantly hooked.
                            
                            I've noticed a lot of people have the wrong idea about skydiving—they think it's all about falling and danger.
                            
                            But it's so much more. It's about control, physics, and pure joy. lets Experience the thrill of skydiving and the fun of physics in one adventure! Ready to dive into the sky?
                            """
                        )
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.5))
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        
                        
                        Button(action: {
                            selection.value = 1
                        }) {
                            HStack {
                                Text("Let's go")
                                Image(systemName: "arrow.right.circle.fill")
                            }
                        }
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    }
                    .frame(width: spriteWidth * 0.85, height: spriteHeight * 0.9) // Make the new View smaller than SpriteView
                    .padding(.top, spriteHeight * 0.05) // Offset from top to center
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}
