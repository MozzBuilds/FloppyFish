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
    static let ITEM_COLLIDER: UInt32 = 1
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var traveller: SKSpriteNode?
    
    var obstacleCreator: ObstacleCreator?
    var backgroundHandler: BackgroundHandler?
    
    override func didMove(to view: SKView) {
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        physicsWorld.contactDelegate = self
        
        ///Render base background
        backgroundHandler = BackgroundHandler()
        backgroundHandler?.renderBackground()
        
        ///SetUp the traveller
        setUp()
        
        ///Initialise obstacle creator
        obstacleCreator = ObstacleCreator (delegator: self)
        
        ///Generate obstacles at timed intervals
        Timer.scheduledTimer(timeInterval: TimeInterval(1.0), target: self, selector: #selector(GameScene.handleObstacleTimer), userInfo:nil, repeats: true)
        
        ///Remove obstacles/cleanup
        Timer.scheduledTimer(timeInterval: TimeInterval(3.0), target: self, selector: #selector(GameScene.cleanUp), userInfo: nil, repeats: true)
    }
    
    func setUp() {
        traveller = self.childNode(withName: "traveller") as? SKSpriteNode
        traveller?.physicsBody?.categoryBitMask = ColliderType.TRAVELLER_COLLIDER
        traveller?.physicsBody?.contactTestBitMask = ColliderType.ITEM_COLLIDER
        traveller?.physicsBody?.collisionBitMask = 0
    }
    
    @objc func cleanUp() {
        for child in children {
            if child.position.x < -self.size.width - 50 {
                child.removeFromParent()
            }
        }
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        ///Called before each frame is rendered, moves background
        backgroundHandler?.moveBackground()
        
        let itemBlock: (SKNode, UnsafeMutablePointer<ObjCBool> ) -> () = { (item, stop) in
            let newItem = item as! SKSpriteNode
            newItem.position.x -= 5 //set the speed
        }
        
        enumerateChildNodes(withName: "obstacle1", using: itemBlock)
        enumerateChildNodes(withName: "obstacle2", using: itemBlock)
    }
    
    @objc func handleObstacleTimer(timer: Timer) {
        obstacleCreator?.renderObstacle()
    }
}
