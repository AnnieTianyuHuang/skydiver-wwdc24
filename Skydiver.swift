import SpriteKit

class Skydiver: SKSpriteNode {
    
    private var textures: [SKTexture] = []
    private var animation: SKAction?
    private var currentState: SkydiverState = .falling 
    
    enum SkydiverState: Int {
        case falling = 1, panic, parachute, landing, crash
    }
    
    init() {
        let texture = SKTexture(imageNamed: "state1_frame1")
        super.init(texture: texture, color: .clear, size: texture.size())
        
        loadTextures()
        setupAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadTextures() {
        for state in 1...5 {
            var stateTextures: [SKTexture] = []
            for frame in 1...3 {
                let texture = SKTexture(imageNamed: "state\(state)_frame\(frame)")
                stateTextures.append(texture)
            }
            textures.append(contentsOf: stateTextures)
        }
    }
    
    private func setupAnimation() {
        let animation = SKAction.animate(with: textures, timePerFrame: 0.1)
        self.animation = SKAction.repeatForever(animation)
    }
    
    func changeState(to state: SkydiverState) {
        removeAllActions()
        switch state {
        case .falling, .panic, .parachute, .landing, .crash:
            run(animation!, withKey: "animation")
        }
    }
    
    func simulateSkydiving() {
        let delay = SKAction.wait(forDuration: 5.0)
        let changeStateAction = SKAction.run {
            let randomState = Int.random(in: 1...5)
            self.changeState(to: SkydiverState(rawValue: randomState)!)
        }
        let sequence = SKAction.sequence([delay, changeStateAction])
        run(SKAction.repeatForever(sequence))
    }
}
