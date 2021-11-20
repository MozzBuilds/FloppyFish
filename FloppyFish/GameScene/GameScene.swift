//
//  GameScene.swift
//  FloppyFish
//
//  Created by Colin Morrison on 31/10/2021.
//

import SpriteKit
import GameplayKit

struct ColliderType {
    static let TRAVELLER_COLLIDER: UInt32 = 0
    static let OBSTACLE_COLLIDER: UInt32 = 1
    static let MIN_BOUNDARY_COLLIDER: UInt32 = 2
    static let MAX_BOUNDARY_COLLIDER: UInt32 = 3
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var traveller: SKSpriteNode?
    
    private var obstacleCreator: ObstacleCreator?
    private var backgroundHandler: BackgroundHandler?
    
    private var playToggle = true
            
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene?.scaleMode = SKSceneScaleMode.resizeFill
        
        obstacleCreator = ObstacleCreator (delegate: self)

        setUpBackground()
        setUpWorld()
        setUpBoundaries()
        setUpTraveller()
        setUpTimers()
    }
    
    func setUpBackground() {
        backgroundHandler = BackgroundHandler(delegate: self)
        backgroundHandler?.renderBackground()
    }
    
    func setUpWorld() {
        physicsWorld.gravity = CGVector(dx: 0, dy: -8.0)
        physicsWorld.contactDelegate = self
    }
    
    func setUpBoundaries() {
        guard let minBoundary = self.childNode(withName: "minBoundary") as? SKSpriteNode else { return }
        minBoundary.physicsBody = SKPhysicsBody(rectangleOf: minBoundary.size)
        minBoundary.physicsBody?.categoryBitMask = ColliderType.MIN_BOUNDARY_COLLIDER
        minBoundary.physicsBody?.collisionBitMask = 0
        minBoundary.physicsBody?.affectedByGravity = false
        minBoundary.physicsBody?.isDynamic = false
        
        guard let maxBoundary = self.childNode(withName: "maxBoundary") as? SKSpriteNode else { return }
        maxBoundary.physicsBody = SKPhysicsBody(rectangleOf: maxBoundary.size)
        maxBoundary.physicsBody?.categoryBitMask = ColliderType.MAX_BOUNDARY_COLLIDER
        maxBoundary.physicsBody?.collisionBitMask = 0
        maxBoundary.physicsBody?.affectedByGravity = false
        maxBoundary.physicsBody?.isDynamic = false
    }
    
    func setUpTraveller() {
        traveller = self.childNode(withName: "traveller") as? SKSpriteNode
        traveller?.position = CGPoint(x: -frame.size.width / 3, y: 0)
        traveller?.physicsBody = SKPhysicsBody(rectangleOf: traveller?.size ?? CGSize(width: 50, height: 50))
        traveller?.physicsBody?.categoryBitMask = ColliderType.TRAVELLER_COLLIDER
        traveller?.physicsBody?.contactTestBitMask = ColliderType.OBSTACLE_COLLIDER | ColliderType.MIN_BOUNDARY_COLLIDER | ColliderType.MAX_BOUNDARY_COLLIDER
        traveller?.physicsBody?.collisionBitMask = ColliderType.OBSTACLE_COLLIDER | ColliderType.MIN_BOUNDARY_COLLIDER | ColliderType.MAX_BOUNDARY_COLLIDER
        traveller?.physicsBody?.affectedByGravity = true
        traveller?.physicsBody?.isDynamic = true
    }
    
    func setUpTimers() {
        if playToggle == true {
            ///Generate obstacles at timed intervals
            Timer.scheduledTimer(timeInterval: TimeInterval(1.0), target: self, selector: #selector(GameScene.handleObstacleTimer), userInfo:nil, repeats: true)
            
            ///Remove obstacles/cleanup
            Timer.scheduledTimer(timeInterval: TimeInterval(1.0), target: self, selector: #selector(GameScene.cleanUp), userInfo: nil, repeats: true)
        }
    }
    
    @objc func cleanUp() {
        ///Removes nodes no longer visible on screen, looping through all nodes
        for child in children {
            if child.position.x < -self.size.width - 50 {
                child.removeFromParent()
            }
        }
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        ///Called before each frame is rendered, moves background
        if playToggle == true {
            backgroundHandler?.moveBackground()
            
            let obstacleBlock: (SKNode, UnsafeMutablePointer<ObjCBool> ) -> () = { (obstacle, stop) in
                let newItem = obstacle as! SKSpriteNode
                newItem.position.x -= 5 ///set the X speed
            }
            
            enumerateChildNodes(withName: "obstacle1", using: obstacleBlock)
            enumerateChildNodes(withName: "obstacle2", using: obstacleBlock)
        }
    }
    
    @objc func handleObstacleTimer(timer: Timer) {
        ///Handler for the scheduled timer
        playToggle == true ? obstacleCreator?.renderObstacle() : nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for _ in touches {
            traveller?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            let impulse = CGVector(dx: 0, dy: 140)
            traveller?.physicsBody?.applyImpulse(impulse)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        ///Called when two bodies contact eachother,
        
        ///Stop Game
        playToggle = false
        
        ///Popup here with option to reset Scene
        resetScene()
    }
    
    func resetScene() {
        let gameScene = SKScene(fileNamed: "GameScene")!
        gameScene.scaleMode = .aspectFill
        view?.presentScene(gameScene, transition: SKTransition.fade(withDuration: 0.9))    }
}
