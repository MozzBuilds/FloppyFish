//
//  WorldPhysics.swift
//  FloppyFish
//
//  Created by Colin Morrison on 12/12/2021.
//

import SpriteKit

class WorldPhysics {
    
    private let delegate: SKScene
    
    init(delegate: SKScene) {
        self.delegate = delegate
    }
    
    func setUpPhysicsWorld() {
        delegate.physicsWorld.gravity = CGVector(dx: 0, dy: -8.0)
        delegate.physicsWorld.contactDelegate = delegate as? SKPhysicsContactDelegate
    }
    
    func addBoundaries() {
        delegate.addChild(maximumBoundary())
        delegate.addChild(minimumBoundary())
    }
    
    private func maximumBoundary() -> SKSpriteNode {
        let maxBoundary =  SKSpriteNode()
        commonBoundaryProperties(boundary: maxBoundary)
        
        maxBoundary.name = "maxBoundary"
        maxBoundary.position.y = delegate.size.height / 2
        maxBoundary.physicsBody?.categoryBitMask = ColliderType.maxBoundary
        
        return maxBoundary
    }
    
    private func minimumBoundary() -> SKSpriteNode {
        let minBoundary =  SKSpriteNode()
        commonBoundaryProperties(boundary: minBoundary)
        
        minBoundary.name = "minBoundary"
        minBoundary.position.y = -delegate.size.height / 2
        minBoundary.physicsBody?.categoryBitMask = ColliderType.minBoundary
        
        return minBoundary
    }
    
    private func commonBoundaryProperties(boundary: SKSpriteNode) {
        boundary.size = CGSize(width: delegate.size.width, height: 1)
        
        boundary.physicsBody = SKPhysicsBody(rectangleOf: boundary.size)
        boundary.physicsBody?.collisionBitMask = 0
        boundary.physicsBody?.affectedByGravity = false
        boundary.physicsBody?.isDynamic = false
    }
}
