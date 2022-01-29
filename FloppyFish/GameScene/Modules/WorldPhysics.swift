//
//  WorldPhysics.swift
//  FloppyFish
//
//  Created by Colin Morrison on 12/12/2021.
//

import SpriteKit

class WorldPhysics {
    
    private(set) var delegate: SKScene
    
    private(set) var maxBoundary: SKSpriteNode?
    private(set) var minBoundary: SKSpriteNode?
    
    init(delegate: SKScene) {
        self.delegate = delegate
    }
    
    func setUpPhysicsWorld() {
        delegate.physicsWorld.gravity = CGVector(dx: 0, dy: -8.2)
        delegate.physicsWorld.contactDelegate = delegate as? SKPhysicsContactDelegate
    }
    
    func addBoundaries() {
        maximumBoundary(parent: delegate)
        minimumBoundary(parent: delegate)
    }
    
    func maximumBoundary(parent: SKScene){
        maxBoundary =  SKSpriteNode()
        guard let maxBoundary = maxBoundary else { return }
        commonBoundaryProperties(boundary: maxBoundary)
        
        maxBoundary.name = "maxBoundary"
        maxBoundary.position.y = delegate.size.height / 2
        maxBoundary.physicsBody?.categoryBitMask = ColliderType.maxBoundary
        
        parent.addChild(maxBoundary)
    }
    
    func minimumBoundary(parent: SKScene) {
        minBoundary =  SKSpriteNode()
        guard let minBoundary = minBoundary else { return }

        commonBoundaryProperties(boundary: minBoundary)
        
        minBoundary.name = "minBoundary"
        minBoundary.position.y = -delegate.size.height / 2
        minBoundary.physicsBody?.categoryBitMask = ColliderType.minBoundary
        
        parent.addChild(minBoundary)
    }
    
    func commonBoundaryProperties(boundary: SKSpriteNode) {
        boundary.size = CGSize(width: delegate.size.width, height: 1)
        
        boundary.physicsBody = SKPhysicsBody(rectangleOf: boundary.size)
        boundary.physicsBody?.collisionBitMask = 0
        boundary.physicsBody?.affectedByGravity = false
        boundary.physicsBody?.isDynamic = false
    }
}
