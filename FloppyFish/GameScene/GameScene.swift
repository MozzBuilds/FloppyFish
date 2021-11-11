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
    
    private var background: SKSpriteNode?
    private var traveller: SKSpriteNode?
    
    var createObstacle: CreateObstacle?
    
    override func didMove(to view: SKView) {
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        physicsWorld.contactDelegate = self

        renderBackground()
        setUp()
        createObstacle = CreateObstacle(delegator: self)
        
        //Generate Obstacles
        Timer.scheduledTimer(timeInterval: TimeInterval(1.0), target: self, selector: #selector(GameScene.handleItemTimer), userInfo:nil, repeats: true)
        
//        Remove items/cleanup
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
        //called before each frame is rendered
        moveBackground()
        
        let itemBlock: (SKNode, UnsafeMutablePointer<ObjCBool> ) -> () = { (item, stop) in
            let newItem = item as! SKSpriteNode
            newItem.position.x -= 5 //set the speed
        }
        
        enumerateChildNodes(withName: "obstacle1", using: itemBlock)
        enumerateChildNodes(withName: "obstacle2", using: itemBlock)
    }
    
    @objc func handleItemTimer(timer: Timer) {
        createObstacle?.renderItem()
    }
        
    private func renderBackground() {
        
        for i in 0...3 {
            let background = SKSpriteNode(imageNamed: "background")
            background.name = "Background"
            background.size = CGSize(width: (self.scene?.size.width)!, height: (self.scene?.size.height)!)
            background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            
            let positionX = CGFloat(i) * background.size.width
            background.position = CGPoint(x: positionX, y: 0)
            self.addChild(background)
            background.zPosition = 0
        }
    }
    
    private func moveBackground() {
        
        let block: (SKNode, UnsafeMutablePointer<ObjCBool>) -> () = { (node, error) in
            
            node.position.x -= 2
            
            if node.position.x < -((self.scene?.size.width)!) {
                node.position.x += (self.scene?.size.width)! * 3
            }
        }
        self.enumerateChildNodes(withName: "Background", using: block)
    }
}
