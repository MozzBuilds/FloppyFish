//
//  ObstacleCreator.swift
//  FloppyFish
//
//  Created by Colin Morrison on 31/10/2021.
//

import Foundation
import SpriteKit

enum ObstacleSizes: CGFloat, CaseIterable {
    case XS = 0.35
    case S = 0.40
    case SM = 0.43
    case M = 0.46
    case ML = 0.48
    case L = 0.51
    case XL = 0.54
    case XXL = 0.58
}

class ObstacleCreator {
    
    private(set) var delegate: SKScene!
    
    private(set) var obstacle1: SKSpriteNode!
    private(set) var obstacle2: SKSpriteNode!
    private(set) var obstacles: [SKSpriteNode]!
    
    private let defaultWidth: CGFloat = 80
    private let defaultHeight: CGFloat = 300
    private(set) var defaultSize: CGSize
    private let defaultColor: UIColor = .black
    
    private(set) var randomPosition: Int?
    
    init(delegate: SKScene) {
        
        self.delegate = delegate
        
        defaultSize = CGSize(width: defaultWidth, height: defaultHeight)
    }
    
    func renderObstacles() {
        
        obstacle1 = SKSpriteNode(imageNamed: "Rock")
        obstacle2 = SKSpriteNode(imageNamed: "Rock")
        obstacles = [obstacle1, obstacle2]

        setSizes()
        setPositions()
        setPhysics()
        
        obstacles?.forEach {
            delegate.addChild($0)
        }
    }
    
    func setSizes() {
        
        let maxHeight = delegate.size.height
            
        ///Choose a random size for obstacle 1 from ItemSizes enum
        guard let randomSize = ObstacleSizes.allCases.randomElement()?.rawValue else { return }
          
        ///Obstacle Sizes (start point for obstacle 2)
        obstacle1.size = CGSize(width: defaultWidth, height: maxHeight * randomSize)
        obstacle2.size = CGSize(width: defaultWidth, height: obstacle1.size.height * 0.4)
    }
    
//    func setPositions() {
//
//        obstacles.forEach{
//            $0.anchorPoint = CGPoint(x: 0.5, y: 0.5)
//            $0.name = "obstacle"
//            $0.position.x = delegate.size.width
//            $0.zPosition = 25
//        }
//
//        ///Calculate middle points
//        let obstacle1HeightMidpoint = obstacle1.size.height / 2
//        let screenHeightMidpoint = delegate.size.height / 2
//
//        let obstacle1PositionTop = screenHeightMidpoint - obstacle1HeightMidpoint
//
//        let obstacle2HeightMidpoint = obstacle2.size.height / 2
//
//        ///Randomise the obstacles being at top or bottom (one at each)
//        randomPosition = Int.random(in: 1...2)
//
//        if (randomPosition == 1) {
//            obstacle1.position.y = obstacle1PositionTop
//            obstacle1.zRotation = .pi
//            obstacle1.xScale = 1.0
//            obstacle2.position.y = -(screenHeightMidpoint - obstacle2HeightMidpoint)
//        }
//
//        else if (randomPosition == 2) {
//            obstacle1.position.y = -(obstacle1PositionTop)
//            obstacle2.position.y = screenHeightMidpoint - obstacle2HeightMidpoint
//            obstacle2.xScale = 1.0
//            obstacle2.zRotation = .pi
//        }
//    }
    
    func setPositions() {

        obstacles.forEach{
            $0.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            $0.name = "obstacle"
            $0.position.x = delegate.size.width
            $0.zPosition = 25
            $0.xScale = 1.0
        }

        let obstacle1PositionCalculation = (delegate.size.height * 0.5) - (obstacle1.size.height * 0.5)
        let obstacle2PositionCalculation = (delegate.size.height * 0.5) - (obstacle2.size.height * 0.5)

        ///Randomise the obstacles being at top or bottom (one at each)
        randomPosition = Int.random(in: 1...2)

        if (randomPosition == 1) {
            obstacle1.position.y = obstacle1PositionCalculation
            obstacle1.zRotation = .pi
            obstacle2.position.y = -obstacle2PositionCalculation
        }

        else if (randomPosition == 2) {
            obstacle1.position.y = -obstacle1PositionCalculation
            obstacle2.position.y = obstacle2PositionCalculation
            obstacle2.zRotation = .pi
        }
    }
    
    func setPhysics() {
        obstacle1.physicsBody = SKPhysicsBody(rectangleOf: obstacle1.size)
        obstacle2.physicsBody = SKPhysicsBody(rectangleOf: obstacle2.size)
        
        obstacles.forEach{
            $0.physicsBody?.collisionBitMask = 0
            $0.physicsBody?.affectedByGravity = false
            $0.physicsBody?.isDynamic = false
        }
    }
}
