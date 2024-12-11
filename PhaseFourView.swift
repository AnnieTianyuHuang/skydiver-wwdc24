import SpriteKit
import SwiftUI

class PhaseFourScene: SKScene {
    private var skydiver: SKShapeNode?
    private var cloudButton: SKShapeNode?
    private var stopAddingButton: SKShapeNode?
    private var placeSkydiverButton: SKShapeNode?
    private var isAddingClouds = false
    private var canPlaceSkydiver = false
    private var gameEnded = false
    var selection: Selection?
    
    private var placeButton: SKShapeNode!
    var backgroundImage = SKSpriteNode(imageNamed: "simulator")
    private var statusBubble: SKSpriteNode!
    private var statusLabel: SKLabelNode!
    
    let topBoundary: CGFloat = 20
    let bottomBoundary: CGFloat = 100

    override func didMove(to view: SKView) {
        self.backgroundColor = .white
        resetGame()
    }
    
    func resetGame() {
        self.removeAllChildren()
        self.isAddingClouds = false
        self.canPlaceSkydiver = false
        self.gameEnded = false
        setBackgroundImage(name: "simulator")
        setupCloudButton()
        print("resetted")
    }

    private func setBackgroundImage(name: String) {
        backgroundImage.removeFromParent()
        backgroundImage = SKSpriteNode(imageNamed: name)
        backgroundImage.position = CGPoint(x: size.width / 2, y: size.height / 2 + 5)
        backgroundImage.zPosition = -1
        backgroundImage.setScale(1.0/3.0)
        addChild(backgroundImage)
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
    
    private func setupCloudButton() {
        let buttonSize = CGSize(width: 630, height: 110)
        let cornerRadius: CGFloat = 100
        let backgroundColor = SKColor.black.withAlphaComponent(0.3)
        let buttonRect = CGRect(origin: CGPoint(x: -buttonSize.width / 2, y: -buttonSize.height / 2), size: buttonSize)
        let buttonPath = UIBezierPath(roundedRect: buttonRect, cornerRadius: cornerRadius)
        cloudButton = SKShapeNode(path: buttonPath.cgPath)
        cloudButton!.fillColor = backgroundColor
        cloudButton!.name = "addCloud"
        cloudButton?.position = CGPoint(x: frame.midX, y: frame.midY)
        
        let label = SKLabelNode()
        label.text = "Tap to add clould"
        label.fontSize = 64
        label.fontColor = SKColor.white
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        label.position = CGPoint(x: 0, y: 0)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: label.fontSize, weight: .light),
            .foregroundColor: SKColor.white
        ]
        let attributedText = NSAttributedString(string: "Tap to add clould", attributes: attributes)
        
        label.attributedText = attributedText
        cloudButton!.addChild(label)
        addChild(cloudButton!)
    }

    private func setupStopAddingButton() {
        let buttonSize = CGSize(width: 270, height: 60)
        let cornerRadius: CGFloat = 100
        let backgroundColor = SKColor.red.withAlphaComponent(0.6)
        let buttonRect = CGRect(origin: CGPoint(x: -buttonSize.width / 2, y: -buttonSize.height / 2), size: buttonSize)
        let buttonPath = UIBezierPath(roundedRect: buttonRect, cornerRadius: cornerRadius)
        stopAddingButton = SKShapeNode(path: buttonPath.cgPath)
        stopAddingButton!.fillColor = backgroundColor
        stopAddingButton!.position = CGPoint(x: self.frame.maxX - 220, y: self.frame.maxY - 90)
        stopAddingButton!.name = "stopAdding"

        let label = SKLabelNode()
        label.text = "Stop Adding"
        label.fontSize = 38
        label.fontColor = SKColor.white
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        label.position = CGPoint(x: 0, y: 0)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: label.fontSize, weight: .light),
            .foregroundColor: SKColor.white
        ]
        let attributedText = NSAttributedString(string: "Finished Adding", attributes: attributes)
        label.attributedText = attributedText
        stopAddingButton!.addChild(label)
        addChild(stopAddingButton!)
    }

    private func setupPlaceSkydiverButton() {
        let buttonSize = CGSize(width: 720, height: 110)
        let cornerRadius: CGFloat = 100
        let backgroundColor = SKColor.black.withAlphaComponent(0.3)
        let buttonRect = CGRect(origin: CGPoint(x: -buttonSize.width / 2, y: -buttonSize.height / 2), size: buttonSize)
        let buttonPath = UIBezierPath(roundedRect: buttonRect, cornerRadius: cornerRadius)
        placeSkydiverButton = SKShapeNode(path: buttonPath.cgPath)
        placeSkydiverButton!.fillColor = backgroundColor
        placeSkydiverButton!.name = "placeSkydiver"
        placeSkydiverButton?.position = CGPoint(x: frame.midX, y: frame.midY)
        
        let label = SKLabelNode()
        label.text = "Click to Place Skydiver"
        label.fontSize = 64
        label.fontColor = SKColor.white
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        label.position = CGPoint(x: 0, y: 0)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: label.fontSize, weight: .light),
            .foregroundColor: SKColor.white
        ]
        let attributedText = NSAttributedString(string: "Click to Place Skydiver", attributes: attributes)
        label.attributedText = attributedText
        placeSkydiverButton!.addChild(label)
        addChild(placeSkydiverButton!)
    }
    
    func addSkydiver(at position: CGPoint) {
        guard position.y > bottomBoundary && position.y < size.height - topBoundary else { return }
        
        if !canPlaceSkydiver { return }
        skydiver?.removeFromParent()
        skydiver = SKShapeNode(circleOfRadius: 10)
        skydiver?.fillColor = SKColor.blue
        skydiver?.strokeColor = SKColor.blue
        skydiver?.alpha = 0
        skydiver?.position = position
        skydiver?.name = "skydiver"
        
        if let skydiverNode = skydiver {
            addChild(skydiverNode)
            determineSkydiverAction(at: position)
        }
        
        statusBubble = SKSpriteNode(imageNamed: "bubbleImage")
        statusBubble.position = CGPoint(x: self.size.width - 150, y: self.size.height - 100)
        self.addChild(statusBubble)
        
        statusLabel = SKLabelNode(fontNamed: "Arial")
        statusLabel.fontSize = 20
        statusLabel.fontColor = SKColor.black
        statusLabel.position = CGPoint(x: 0, y: -80)
        statusBubble.addChild(statusLabel)
    }
    
    func determineSkydiverAction(at position: CGPoint) {
        let topFifth = size.height * 4 / 5
        let bottomFifth = size.height / 5
        
        if position.y > topFifth {
            flyChaotically(from: position)
        } else if position.y < bottomFifth {
            accelerateToGround(from: position)
        } else {
            simulateSkydiving(from: position)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodes = self.nodes(at: location)

        if nodes.contains(where: { $0.name == "addCloud" }) && !isAddingClouds {
            cloudButton?.removeFromParent()
            isAddingClouds = true
            setupStopAddingButton()
        } else if nodes.contains(where: { $0.name == "stopAdding" }) {
            stopAddingButton?.removeFromParent()
            isAddingClouds = false
            setupPlaceSkydiverButton()
        } else if nodes.contains(where: { $0.name == "placeSkydiver" }) && !isAddingClouds {
            placeSkydiverButton?.removeFromParent()
            canPlaceSkydiver = true
        } else if isAddingClouds {
            addCloud(at: location)
        } else if canPlaceSkydiver {
            addSkydiver(at: location)
            canPlaceSkydiver = false
        }
    }
    
    func accelerateToGround(from position: CGPoint) {
        guard let skydiver = self.skydiver else { return }
        let targetY = 150.0
        let duration = 0.5
        let fallAction = SKAction.moveTo(y: targetY, duration: duration)
        let updateAccelerateStatus = SKAction.run { [weak self] in
            self?.updateStatus("Accelerating")
        }
        
        skydiver.run(SKAction.sequence([updateAccelerateStatus, fallAction])) { [weak self] in
            self?.gameEnded = true
            self?.selection?.value = 8
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

    
    func countCloudsPassed(through position: CGPoint) -> Int {
        let cloudsPassed = self.children.filter { node in
            guard let cloud = node as? SKSpriteNode, cloud.name == "cloud" else { return false }
            return position.y > cloud.position.y && abs(cloud.position.x - position.x) < cloud.size.width / 2
        }
        return cloudsPassed.count
    }
    
    func simulateSkydiving(from position: CGPoint) {
        guard let skydiver = skydiver else { return }
        
        let groundLevel: CGFloat = bottomBoundary
        let totalFallDistance = position.y - groundLevel
        
        let accelerateFallDistance = totalFallDistance * 0.5
        let normalFallDistance = totalFallDistance * 0.3
        let freeFallDistance = totalFallDistance - accelerateFallDistance - normalFallDistance
        let riseDistance: CGFloat = 55
        let finalDescentDistance = totalFallDistance - accelerateFallDistance - normalFallDistance - riseDistance
        
        let accelerateAction = SKAction.moveBy(x: 0, y: -accelerateFallDistance, duration: 1)
        let normalFallAction = SKAction.moveBy(x: 0, y: -normalFallDistance, duration: 2)
        let freeFallAction = SKAction.moveBy(x: 0, y: -freeFallDistance, duration: 0.5)
        let slowDescentAction = SKAction.moveBy(x: 0, y: -(finalDescentDistance + riseDistance), duration: 3.5)

        let cloudsPassedCount = self.children.filter { node in
            guard let cloud = node as? SKSpriteNode, cloud.name == "cloud" else { return false }
            return position.y > cloud.position.y && abs(cloud.position.x - position.x) < cloud.size.width / 2
        }.count

        var actions: [SKAction] = [
            SKAction.run { [weak self] in self?.updateStatus("Accelerating") },
            accelerateAction,
            SKAction.run { [weak self] in self?.updateStatus("Normal Falling") },
            normalFallAction
        ]

        if cloudsPassedCount >= 1 {
            actions += [
                SKAction.run { [weak self] in self?.updateStatus("Accelerating") },
                freeFallAction
            ]
        } else {
            actions += [
                    SKAction.run { [weak self] in self?.updateStatus("Parachute Open") },
                    SKAction.moveBy(x: 0, y: riseDistance, duration: 0.5),
                    SKAction.run { [weak self] in
                        self?.updateStatus("Slow Descent")
                        // 在成功开启降落伞并进行缓慢下降时，设置状态为 "Landing"
                        self?.setLandingStatusIfNeeded()
                    },
                    slowDescentAction
                ]
            }
        actions.append(SKAction.run { [weak self] in self?.skydiverLanded() })
        let sequence = SKAction.sequence(actions)
        skydiver.run(sequence)
    }
    
    // 新增的方法
    func setLandingStatusIfNeeded() {
        guard let skydiver = skydiver else { return }
        let groundLevel: CGFloat = bottomBoundary
        updateStatus("Landed")
            
    }


    func addCloud(at position: CGPoint) {
            let cloud = SKSpriteNode(imageNamed: "cloud")
            cloud.size = CGSize(width: 196, height: 122)
            cloud.position = position
            cloud.name = "cloud"
            addChild(cloud)
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
            if let skydiverPosition = skydiver?.position {
                let bubbleOffsetX: CGFloat = 30
                let bubbleOffsetY: CGFloat = 30
                statusBubble.position = CGPoint(x: skydiverPosition.x + bubbleOffsetX, y: skydiverPosition.y + bubbleOffsetY)
            }
        guard let skydiver = skydiver else { return }
        if gameEnded || skydiver.position.y > size.height || skydiver.position.y < 50 {
            skydiverLanded()
        }
    }
    func skydiverLanded() {
        print("Skydiver end")
        self.selection?.value = 8
    }
}

struct PhaseFourView: View {
    let aspectRatio: CGFloat = 3.0 / 4.0
    let minPadding: CGFloat = 50.0
    let cornerRadius: CGFloat = 32.0
    @EnvironmentObject var selection: Selection
    @State private var scene: PhaseFourScene? = nil
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

                if let scene = scene {
                    SpriteView(scene: scene)
                        .frame(
                            width: min(geometry.size.width - minPadding * 2, (geometry.size.height - minPadding * 2) * aspectRatio),
                            height: min((geometry.size.width - minPadding * 2) / aspectRatio, geometry.size.height - minPadding * 2)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                        .padding(minPadding)
                        .id(resetTrigger)
                }
                if selection.value == 8 {
                    EndView().environmentObject(selection)
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            self.scene = self.setupScene()
        }
        .onChange(of: selection.value) { newValue in
            if newValue == 4 {
                self.resetGame()
            }
        }
    }

    private func setupScene() -> PhaseFourScene {
        let newScene = PhaseFourScene()
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
