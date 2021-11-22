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
    
    ///Stored for the life of the app. Needs moved eventually
    static var highScore = 0
    
    private var traveller: SKSpriteNode?
    
    private var obstacleCreator: ObstacleCreator?
    private var backgroundHandler: BackgroundHandler?
    
    private var score = 0
    private var scoreLabel: SKLabelNode?
                
    override func didMove(to view: SKView) {

        ///Set base point for anchoring objects, from centerpoints
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.scaleMode = .resizeFill
        
        ///Initialise objects
        obstacleCreator = ObstacleCreator (delegate: self)
        scoreLabel = childNode(withName: "scoreLabel") as? SKLabelNode

        setUpBackground()
        setUpScoreLabel()
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
        scoreLabel?.text = String(0)
        scoreLabel?.position = CGPoint(x: -frame.size.width / 3, y: frame.size.height / 3)
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
        
        traveller?.physicsBody = SKPhysicsBody(rectangleOf: traveller?.size ?? CGSize(width: 50, height: 50))
        
        ///Setting traveller physics category for interaction
        traveller?.physicsBody?.categoryBitMask = ColliderType.traveller
        
        ///Check if they occupy the same space
        traveller?.physicsBody?.contactTestBitMask = ColliderType.obstacle | ColliderType.minBoundary | ColliderType.maxBoundary
        
        ///Check if they have collided
        traveller?.physicsBody?.collisionBitMask = ColliderType.obstacle | ColliderType.minBoundary | ColliderType.maxBoundary
    }
    
    func setUpTimers() {
        ///Var for timer interals
        let timeInterval = TimeInterval(1.0)
        let delay = DispatchTime.now() + 3.0
        
        ///Generate obstacles at timed intervals
        Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(GameScene.handleObstacleTimer), userInfo:nil, repeats: true)
        
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
            if child.position.x < -self.size.width - 50 {
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
            obstacleCreator?.renderObstacle()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        ///Auto called when user touches anywhere on screen
        if !isPaused {
            for _ in touches {
                traveller?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                let impulse = CGVector(dx: 0, dy: 140)
                traveller?.physicsBody?.applyImpulse(impulse)
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        ///Auto called when two bodies contact eachother,
        
        ///Pause game
        isPaused = true
        
        ///Set final score message
        var scoreMessage = "Final Score: \(score)"
        
        ///Update high score if required, and message
        if score > GameScene.highScore {
            GameScene.highScore = score
            scoreMessage += "\n New high score!"
        } else {
            scoreMessage += "\n High Score: \(GameScene.highScore)"
        }
        
        ///Popup with score
        let gameOverAlert = UIAlertController(title: "Game over!",
                                      message: scoreMessage,
                                      preferredStyle: .alert)
        
        ///Action to start again, with handler block
        gameOverAlert.addAction(UIAlertAction(title: "Play Again?",
                                              style: .default,
                                              handler: {_ in
                                                self.resetScene()
                                              }))
        
        ///Call view controller to present alert
        self.view?.window?.rootViewController?.present(gameOverAlert, animated: true, completion: nil)
        
        //Popup here with option to reset Scene
//        resetScene()
    }
    
    func resetScene() {
        ///Wipes scene and starts fresh
        let gameScene = SKScene(fileNamed: "GameScene")!
        gameScene.scaleMode = .aspectFill
        view?.presentScene(gameScene, transition: SKTransition.fade(withDuration: 0.5))
    }
}
