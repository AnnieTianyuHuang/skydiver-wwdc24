import SwiftUI
import SpriteKit

class SkyDivingScene: SKScene {
    private var skydiver: SKShapeNode?
    private var placeButton: SKShapeNode!
    private var canPlaceSkydiver = false
    var selection: Selection?
    var backgroundImage = SKSpriteNode(imageNamed: "simulator_mid_enabled")
    private var statusBubble: SKSpriteNode!
    private var statusLabel: SKLabelNode!
    
    let topBoundary: CGFloat = 20
    let bottomBoundary: CGFloat = 50
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        resetGame()
    }
    
    func resetGame() {
        self.canPlaceSkydiver = false
        setBackgroundImage(name: "simulator_mid_enabled")
        setupPlaceButton()
        print("resetted")
    }
    
    func updateStatus(_ status: String) {
        statusLabel.text = status
        let textures = [SKTexture(imageNamed: "\(status)1"),
                        SKTexture(imageNamed: "\(status)2"),
                        SKTexture(imageNamed: "\(status)3")]
        let animationAction = SKAction.animate(with: textures, timePerFrame: 0.3)
        let repeatAction = SKAction.repeatForever(animationAction)
        statusBubble.run(repeatAction)
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        if let skydiverPosition = skydiver?.position {
            let bubbleOffsetX: CGFloat = 30
            let bubbleOffsetY: CGFloat = 30
            statusBubble.position = CGPoint(x: skydiverPosition.x + bubbleOffsetX, y: skydiverPosition.y + bubbleOffsetY)
        }
    }
    
    private func setupPlaceButton() {
        let buttonSize = CGSize(width: 630, height: 110)
        let cornerRadius: CGFloat = 100
        let backgroundColor = SKColor.black.withAlphaComponent(0.3)
        let buttonRect = CGRect(origin: CGPoint(x: -buttonSize.width / 2, y: -buttonSize.height / 2), size: buttonSize)
        let buttonPath = UIBezierPath(roundedRect: buttonRect, cornerRadius: cornerRadius)
        
        placeButton = SKShapeNode(path: buttonPath.cgPath)
        placeButton.fillColor = backgroundColor
        placeButton.position = CGPoint(x: frame.midX, y: frame.midY)
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
            let middleFifthTop = size.height * 4 / 5
            let middleFifthBottom = size.height * 1 / 5
            if location.y < middleFifthTop && location.y > middleFifthBottom {
                addSkydiver(at: location)
                setBackgroundImage(name: "simulator")
                canPlaceSkydiver = false
            }
        }
    }
    
    private func setBackgroundImage(name: String) {
        backgroundImage.removeFromParent()
        backgroundImage = SKSpriteNode(imageNamed: name)
        backgroundImage.position = CGPoint(x: size.width / 2, y: size.height / 2 + 5)
        backgroundImage.zPosition = -1
        backgroundImage.setScale(1.0/3.0)
        addChild(backgroundImage)
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
            simulateSkydiving(from: position)
        }
        
        statusBubble = SKSpriteNode(imageNamed: "bubbleImage")
        statusBubble.position = CGPoint(x: self.size.width - 150, y: self.size.height - 100) // 示例位置
        self.addChild(statusBubble)
        statusLabel = SKLabelNode(fontNamed: "Arial")
        statusLabel.fontSize = 20
        statusLabel.fontColor = SKColor.black
        statusLabel.position = CGPoint(x: 0, y: -80)
        statusBubble.addChild(statusLabel)
        updateStatus("Accelerating")
    }
    
    func simulateSkydiving(from position: CGPoint) {
        guard let skydiver = skydiver else { return }

        let groundLevel: CGFloat = bottomBoundary
        let totalFallDistance = position.y - groundLevel
        
        // accelerating
        let updateAccelerateStatus = SKAction.run { [weak self] in self?.updateStatus("Accelerating") }
        let accelerateFallDistance = totalFallDistance * 0.5
        let accelerateAction = SKAction.moveBy(x: 0, y: -accelerateFallDistance, duration: 1)
        
        // normal falling
        let updateNormalFallStatus = SKAction.run { [weak self] in self?.updateStatus("Normal Falling") }
        let normalFallDistance = totalFallDistance * 0.3
        let normalFallAction = SKAction.moveBy(x: 0, y: -normalFallDistance, duration: 2)
        
        // parachute open
        let updateParachuteOpenStatus = SKAction.run { [weak self] in self?.updateStatus("Parachute Open") }
        let riseDistance: CGFloat = 55
        let parachuteOpenAction = SKAction.moveBy(x: 0, y: riseDistance, duration: 0.5)
        
        // slow descent
        let updateSlowDescentStatus = SKAction.run { [weak self] in self?.updateStatus("Slow Descent") }
        let finalDescentDistance = position.y - groundLevel - accelerateFallDistance - normalFallDistance - riseDistance
        let slowDescentAction = SKAction.moveBy(x: 0, y: -finalDescentDistance, duration: 3.5)
        
        let sequence = SKAction.sequence([
            updateAccelerateStatus, accelerateAction,
            updateNormalFallStatus, normalFallAction,
            updateParachuteOpenStatus, parachuteOpenAction,
            updateSlowDescentStatus, slowDescentAction,
            SKAction.run { [weak self] in self?.skydiverLanded() }
        ])
        skydiver.run(sequence)
    }
    
    func skydiverLanded() {
        print("Skydiver has landed.")
        selection?.value = 5
        let landedTexture = SKTexture(imageNamed: "landed")
        statusBubble.texture = landedTexture
        statusBubble.removeAllActions()
        updateStatus("Landed")
    }
    
}

struct PhaseOneView: View {
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
            if selection.value == 5 {
                Change1View().environmentObject(selection)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            self.scene = self.setupScene()
        }
        .onChange(of: selection.value) { newValue in
            if newValue ==  1{
                self.resetGame()
            }
        }
    }

    private func setupScene() -> SkyDivingScene {
        let newScene = SkyDivingScene()
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
