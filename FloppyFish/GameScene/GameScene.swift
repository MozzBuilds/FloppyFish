//
//  GameScene.swift
//  FloppyFish
//
//  Created by Colin Morrison on 31/10/2021.
//

import SpriteKit
import GameplayKit

struct ColliderType {
    static let traveller: UInt32 = 0
    static let obstacle: UInt32 = 1
    static let minBoundary: UInt32 = 2
    static let maxBoundary: UInt32 = 3
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var highScore = 0
    
    private var traveller: SKSpriteNode?
    
    private var obstacleCreator: ObstacleCreator?
    private var backgroundHandler: BackgroundHandler?
    
    private var score = 0
    private var scoreLabel: SKLabelNode?
    
    private var countDownTime = 3
                
    override func didMove(to view: SKView) {

        ///Set base point for anchoring objects, from centerpoints
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.scaleMode = .resizeFill
        
        ///Initialise objects
        obstacleCreator = ObstacleCreator (delegate: self)
        
        ///Make buttons hidden to start off with
        self.childNode(withName: "pauseNode")?.isHidden = true
        self.childNode(withName: "gameOverBackground")?.isHidden = true
        
        ///Retrieve high score
        highScore = UserDefaults.standard.integer(forKey: "highScore")

        ///Run all setUps
        setUpBackground()
        setUpScoreLabel()
        setUpScoreBackground()
        setUpWorld()
        setUpBoundaries()
        setUpTraveller()
        setUpTimers()
    }
    
    func setUpBackground() {
        backgroundHandler = BackgroundHandler(delegate: self)
        backgroundHandler?.renderBackground()
    }
    
    func setUpScoreLabel() {
        scoreLabel = SKLabelNode()
        scoreLabel?.position = CGPoint(x: -frame.size.width / 3, y: frame.size.height / 2.5)
        scoreLabel?.zPosition = 50
        scoreLabel?.text = String(0)

        ///Styling Properties
        scoreLabel?.fontSize = 50
        scoreLabel?.fontColor = .black
        
        scoreLabel != nil ? addChild(scoreLabel!) : nil
    }
    
    func setUpScoreBackground() {
        let scoreBackgroundSize = CGSize(width: 120, height: 70)
        let scoreBackground = SKShapeNode(rectOf: scoreBackgroundSize, cornerRadius: 10)
        
        ///Styling Properties
        scoreBackground.position = CGPoint(x: -frame.size.width / 3, y: frame.size.height / 2.5 + 20)
        scoreBackground.zPosition = 35
        scoreBackground.fillColor = .white
        scoreBackground.alpha = 0.6
        addChild(scoreBackground)
    }
    
    func setUpWorld() {
        physicsWorld.gravity = CGVector(dx: 0, dy: -8.0)
        physicsWorld.contactDelegate = self
    }
    
    func setUpBoundaries() {
        ///Lower boundary for collision, and upper
        guard let minBoundary = childNode(withName: "minBoundary") as? SKSpriteNode else { return }
        minBoundary.physicsBody = SKPhysicsBody(rectangleOf: minBoundary.size)
        minBoundary.physicsBody?.categoryBitMask = ColliderType.minBoundary
        minBoundary.physicsBody?.collisionBitMask = 0
        minBoundary.physicsBody?.affectedByGravity = false
        minBoundary.physicsBody?.isDynamic = false
        
        guard let maxBoundary = childNode(withName: "maxBoundary") as? SKSpriteNode else { return }
        maxBoundary.physicsBody = SKPhysicsBody(rectangleOf: maxBoundary.size)
        maxBoundary.physicsBody?.categoryBitMask = ColliderType.maxBoundary
        maxBoundary.physicsBody?.collisionBitMask = 0
        maxBoundary.physicsBody?.affectedByGravity = false
        maxBoundary.physicsBody?.isDynamic = false
    }
    
    func setUpTraveller() {
        ///Initialise from GameSceke.sks SpriteNode
        traveller = childNode(withName: "traveller") as? SKSpriteNode
        
        ///Default start position
        traveller?.position = CGPoint(x: -frame.size.width / 3, y: 0)
        
        traveller?.physicsBody = SKPhysicsBody(rectangleOf: traveller?.size ?? CGSize(width: 125, height: 100))
        
        ///Setting traveller physics category for interaction
        traveller?.physicsBody?.categoryBitMask = ColliderType.traveller
        
        ///Check if they occupy the same space
        traveller?.physicsBody?.contactTestBitMask = ColliderType.obstacle | ColliderType.minBoundary | ColliderType.maxBoundary
        
        ///Check if they have collided
        traveller?.physicsBody?.collisionBitMask = ColliderType.obstacle | ColliderType.minBoundary | ColliderType.maxBoundary
        
        ///Initial values only, changed after countdown
        traveller?.physicsBody?.isDynamic = false
        traveller?.physicsBody?.affectedByGravity = false
    }
    
    @objc func setUpCountdown () {
        if countDownTime > 0 {
        
            let countDownLabel = SKLabelNode()
            
            countDownLabel.fontSize = 100
            countDownLabel.zPosition = 50
            countDownLabel.text = String(countDownTime)
            
            addChild(countDownLabel)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                countDownLabel.removeFromParent()
            })
            
            countDownTime -= 1

        } else {
            traveller?.physicsBody?.isDynamic = true
            traveller?.physicsBody?.affectedByGravity = true
            self.childNode(withName: "pauseNode")?.isHidden = false
        }
    }
    
    func setUpTimers() {
        ///Var for timer interals
        let timeInterval = TimeInterval(1.0)
        let delay = DispatchTime.now() + 3.0
        
        ///Generate countdown
        Timer.scheduledTimer(timeInterval: TimeInterval(0.6), target: self, selector: #selector(GameScene.setUpCountdown), userInfo: nil, repeats: true)
        
        ///Generate obstacles at timed intervals
        Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(GameScene.handleObstacleTimer), userInfo:nil, repeats: true)
        
        ///Set traveller rotation
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(GameScene.travellerRotator), userInfo: nil, repeats: true)
        
        ///Remove obstacles/cleanup
        Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(GameScene.cleanUp), userInfo: nil, repeats: true)
        
        ///Update sccore
        DispatchQueue.main.asyncAfter(deadline: delay) {
            Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(GameScene.updateScore), userInfo: nil, repeats: true)
        }
    }
    
    @objc func cleanUp() {
        ///Removes nodes no longer visible on screen
        for child in children {
            if child.position.x < -self.size.width - 30 {
                child.removeFromParent()
            }
        }
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        if !isPaused {
            ///Auto called before each frame is rendered
            backgroundHandler?.moveBackground()

            ///Look out for new nodes
            enumerateChildNodes(withName: "obstacle", using: { (obstacle, stop) in
                let newItem = obstacle as! SKSpriteNode
                newItem.position.x -= 5 ///set the X speed
            })
        }
    }
    
    @objc func updateScore() {
        if !isPaused {
            score += 1
            scoreLabel?.text = String(score)
        }
    }
    
    @objc func handleObstacleTimer(timer: Timer) {
        ///At each scheduled timer interval, render obstacles
        if !isPaused {
            obstacleCreator?.renderObstacles()
        }
    }
    
    @objc func travellerRotator() {
        if (traveller?.physicsBody?.velocity.dy)! < 0 {
            traveller?.zRotation = -0.4
        } else if (traveller?.physicsBody?.velocity.dy)! > 0 {
        traveller?.zRotation = 0.4
        } else { traveller?.zRotation = 0 }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        ///Auto called when user touches anywhere on screen
            for touch in touches {
                
                let touchLocation = touch.location(in: self)
                
                switch atPoint(touchLocation).name {
                
                case "pauseNode":
                    isPaused.toggle()
                    
                case "menuNode", "gameOverMenuLabel":
                    guard let menuScene = SKScene(fileNamed: "GameMenu") else { return }
                    menuScene.scaleMode = .aspectFill
                    view?.presentScene(menuScene, transition: SKTransition.fade(withDuration: 0.5))
                    
                case "playAgainLabel":
                    resetScene()
                    
                default :
                    if !isPaused {
                        traveller?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                        traveller?.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 250))
                    }
                }
            }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        ///Auto called when two bodies contact eachother,
        
        ///Pause game
        isPaused = true
        
        ///Set traveller to other image
        traveller?.texture = SKTexture(imageNamed: "Fish_Dead")
        
        ///Set final score message
        let scoreMessage = "Final Score: \(score)"
        var highScoreMessage = "High Score: \(highScore)"
        
        ///Update high score if required, and message
        if score > highScore {
            highScore = score
            UserDefaults.standard.set(highScore, forKey: "highScore")
            highScoreMessage = "New High Score!"
        }
        
        ///Unhide game over node and set text
        let gameOverNode = childNode(withName: "gameOverBackground")
        gameOverNode?.isHidden = false
        (gameOverNode?.childNode(withName: "gameOverScoreLabel") as? SKLabelNode)?.text = scoreMessage
        (gameOverNode?.childNode(withName: "highScoreLabel") as? SKLabelNode)?.text = highScoreMessage
    }
    
    func resetScene() {
        ///Wipes scene and starts fresh
        let gameScene = SKScene(fileNamed: "GameScene")!
        gameScene.scaleMode = .aspectFill
        view?.presentScene(gameScene, transition: SKTransition.fade(withDuration: 0.5))
    }
}
