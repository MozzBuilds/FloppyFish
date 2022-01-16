//
//  TravellerCreator.swift
//  FloppyFish
//
//  Created by Colin Morrison on 12/12/2021.
//

import SpriteKit

class TravellerCreator {
    
    private(set) var traveller: SKSpriteNode
    
    private(set) var delegate: SKScene
    
    init(delegate: SKScene) {
        self.delegate = delegate
        traveller = SKSpriteNode(imageNamed: "Fish_Alive")
    }
    
    func setUpTraveller() {
        traveller.zPosition = 30
        traveller.size = CGSize(width: 125, height: 100)
        traveller.position = CGPoint(x: -delegate.size.width / 3, y: 0)
        traveller.name = "traveller"
        setPhysics()
        delegate.addChild(traveller)
    }
        
    func setPhysics() {
        let physicsBodySize = CGSize(width: traveller.size.width * 0.8, height: traveller.size.height * 0.8)
        
        traveller.physicsBody = SKPhysicsBody(rectangleOf: physicsBodySize)
        
        ///Setting traveller physics category for interaction
        traveller.physicsBody?.categoryBitMask = ColliderType.traveller
        
        ///Check if they occupy the same space
        traveller.physicsBody?.contactTestBitMask = ColliderType.obstacle | ColliderType.minBoundary | ColliderType.maxBoundary
        
        ///Check if they have collided
        traveller.physicsBody?.collisionBitMask = ColliderType.obstacle | ColliderType.minBoundary | ColliderType.maxBoundary
    }
    
    func pauseTraveller() {
        traveller.physicsBody?.isDynamic = false
        traveller.physicsBody?.affectedByGravity = false
    }
    
    func unpauseTraveller() {
        traveller.physicsBody?.isDynamic = true
        traveller.physicsBody?.affectedByGravity = true
    }
    
    func rotate() {
        
        guard let velocityY = traveller.physicsBody?.velocity.dy else { return }
        
        if velocityY < 0 {
            traveller.zRotation = -0.4
        } else if velocityY > 0 {
        traveller.zRotation = 0.4
        } else { traveller.zRotation = 0 }
    }
    
    func applyImpulse() {
        traveller.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        let impulseY = traveller.size.height * 2
        traveller.physicsBody?.applyImpulse(CGVector(dx: 0, dy: impulseY))
    }
    
    func updateTexture() {
        traveller.texture = SKTexture(imageNamed: "Fish_Dead")
    }
}
