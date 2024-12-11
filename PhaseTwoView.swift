import SwiftUI
import SpriteKit

class PhaseTwoScene: SKScene {
    private var skydiver: SKShapeNode?
    private var placeButton: SKShapeNode!
    private var canPlaceSkydiver = false
    private var gameEnded = false
    var selection: Selection?
    var backgroundImage = SKSpriteNode(imageNamed: "simulator_top_enabled")
    private var statusBubble: SKSpriteNode!
    private var statusLabel: SKLabelNode!
    let topBoundary: CGFloat = 20
    let bottomBoundary: CGFloat = 50

    override func didMove(to view: SKView) {
        gameEnded = false
        resetGame()
    }
    
    func resetGame() {
        self.canPlaceSkydiver = false
        setBackgroundImage(name: "simulator_top_enabled")
        setupPlaceButton()
        print("resetted")
    }
    
    private func addSkydiver(at position: CGPoint) {
        guard position.y > bottomBoundary && position.y < size.height - topBoundary else { return }
        
        skydiver?.removeFromParent()
        skydiver = SKShapeNode(circleOfRadius: 10)
        skydiver?.fillColor = SKColor.blue
        skydiver?.alpha = 0
        skydiver?.position = position
        skydiver?.name = "skydiver"
        
        if let skydiverNode = skydiver {
            addChild(skydiverNode)
            flyChaotically(from: position)
        }
        statusBubble = SKSpriteNode(imageNamed: "bubbleImage")
        
        if let skydiverPosition = skydiver?.position {
            let bubbleOffsetX: CGFloat = 30
            let bubbleOffsetY: CGFloat = 30
            statusBubble.position = CGPoint(x: skydiverPosition.x + bubbleOffsetX, y: skydiverPosition.y + bubbleOffsetY)
        }
        self.addChild(statusBubble)
        statusLabel = SKLabelNode(fontNamed: "Arial")
        statusLabel.fontSize = 20
        statusLabel.fontColor = SKColor.black
        statusLabel.position = CGPoint(x: 0, y: -80)
        statusBubble.addChild(statusLabel)
        updateStatus("Falling")
    }
    
    func updateStatus(_ status: String) {
        statusLabel.text = "Flying to Outer Space"
        
        let textures = [SKTexture(imageNamed: "\(status)1"),
                        SKTexture(imageNamed: "\(status)2"),
                        SKTexture(imageNamed: "\(status)3")]
        let animationAction = SKAction.animate(with: textures, timePerFrame: 0.3)
        let repeatAction = SKAction.repeatForever(animationAction)
        statusBubble.run(repeatAction)
        statusBubble.removeAllActions()
        statusBubble.run(repeatAction)
    }
    
    private func setBackgroundImage(name: String) {
        backgroundImage.removeFromParent()
        backgroundImage = SKSpriteNode(imageNamed: name)
        backgroundImage.position = CGPoint(x: size.width / 2, y: size.height / 2 + 5)
        backgroundImage.zPosition = -1
        backgroundImage.setScale(1.0/3.0)
        addChild(backgroundImage)
    }

    private func setupPlaceButton() {
        let buttonSize = CGSize(width: 630, height: 110)
        let cornerRadius: CGFloat = 100
        let backgroundColor = SKColor.black.withAlphaComponent(0.3)
        let buttonRect = CGRect(origin: CGPoint(x: -buttonSize.width / 2, y: -buttonSize.height / 2), size: buttonSize)
        let buttonPath = UIBezierPath(roundedRect: buttonRect, cornerRadius: cornerRadius)
        placeButton = SKShapeNode(path: buttonPath.cgPath)
        placeButton.fillColor = backgroundColor
        placeButton.position = CGPoint(x: frame.midX, y: frame.maxY - 150)
        placeButton.name = "placeButton"
        
        let label = SKLabelNode()
        label.text = "Tap to Place Skydiver"
        label.fontSize = 64
        label.fontColor = SKColor.white
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        label.position = CGPoint(x: 0, y: 0)

        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: label.fontSize, weight: .light),
            .foregroundColor: SKColor.white
        ]
        let attributedText = NSAttributedString(string: "Tap to Place Skydiver", attributes: attributes)
        label.attributedText = attributedText
        placeButton.addChild(label)
        addChild(placeButton)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodes = nodes(at: location)

        if nodes.contains(where: { $0.name == "placeButton" }) {
            canPlaceSkydiver.toggle()
            placeButton.isHidden = true
            return
        }

        if canPlaceSkydiver {
            let topAllowedZoneHeight = size.height * 4 / 5
            if location.y > topAllowedZoneHeight {
                addSkydiver(at: location)
            }
            canPlaceSkydiver = false
            setBackgroundImage(name: "simulator")
        }
    }

    func flyChaotically(from position: CGPoint) {
            let moveUp = SKAction.moveBy(x: 0, y: 50, duration: 1)

            let updateStatusBubblePosition = SKAction.run { [unowned self] in
                guard let skydiver = self.skydiver else { return }
                self.statusBubble.position = CGPoint(x: skydiver.position.x, y: skydiver.position.y + 30)
            }
            let sequence = SKAction.sequence([
                moveUp,
                updateStatusBubblePosition,
            ])
            let repeatAction = SKAction.repeat(sequence, count: 2)
            let updateFlyStatus = SKAction.run { [unowned self] in
                self.updateStatus("Accelerating")
            }
            let groupAction = SKAction.group([updateFlyStatus, repeatAction])

            skydiver?.run(groupAction) { [unowned self] in
                self.skydiverLanded()
            }
        }


    override func update(_ currentTime: TimeInterval) {
        if let skydiver = skydiver, !gameEnded {
            if skydiver.position.y > self.size.height {
                gameEnded = true
                skydiverLanded()
            }
        }
    }
    
    func skydiverLanded() {
        self.selection?.value = 6
        print("Skydiver has been dragged to outer space")
    }
}

struct PhaseTwoView: View {
    let aspectRatio: CGFloat = 3.0 / 4.0
    let minPadding: CGFloat = 50.0
    let cornerRadius: CGFloat = 32.0
    @EnvironmentObject var selection: Selection
    @State private var scene: SKScene? = nil
    @State private var resetTrigger = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("background_5")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                    .edgesIgnoringSafeArea(.all)
                
                SpriteView(scene: scene ?? setupScene())
                    .frame(
                        width: min(geometry.size.width - minPadding * 2, (geometry.size.height - minPadding * 2) * aspectRatio),
                        height: min((geometry.size.width - minPadding * 2) / aspectRatio, geometry.size.height - minPadding * 2)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                    .padding(minPadding)
                    .id(resetTrigger)
            }
            if selection.value == 6 {
                Change2View().environmentObject(selection)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            self.scene = self.setupScene()
        }
        .onChange(of: selection.value) { newValue in
            if newValue ==  2{
                self.resetGame()
            }
        }
    }

    private func setupScene() -> PhaseTwoScene {
        let newScene = PhaseTwoScene() // 这里应该是您对应的Scene类
        newScene.size = CGSize(width: 900, height: 1200)
        newScene.scaleMode = .aspectFit
        newScene.selection = selection
        return newScene
    }

    private func resetGame() {
        self.scene = self.setupScene()
        self.resetTrigger.toggle() 
    }
}
