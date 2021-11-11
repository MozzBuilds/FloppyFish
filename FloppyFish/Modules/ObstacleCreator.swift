//
//  ObstacleCreator.swift
//  FloppyFish
//
//  Created by Colin Morrison on 31/10/2021.
//

import Foundation
import SpriteKit

enum ObstaclePositions: CaseIterable {
    case TOP
    case BOTTOM
    case BOTH
}

enum ObstacleSizes: CGFloat, CaseIterable {
    case XS = 0.35
    case S = 0.40
    case M = 0.45
    case L = 0.50
    case XL = 0.55
}

class ObstacleCreator {
    
    let delegator: SKScene
    var obstacle1: SKSpriteNode?
    var obstacle2: SKSpriteNode?
    
    let defaultWidth: CGFloat = 60
    let defaultHeight: CGFloat = 300
    var defaultSize = CGSize(width: 60, height: 300)
    let defaultColor: UIColor = .black
    
    init(delegator: SKScene) {
        
        self.delegator = delegator
        
        defaultSize = CGSize(width: defaultWidth, height: 300)
    }
    
    func renderObstacle() {
        
        ///Randomise the size of the obstacle
        setObstacleSize()
        
        ///Set the physics. Done before setting position, as we make a copy of obstacle2 for two obstacles at the same time
        obstacle1?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        obstacle1?.physicsBody = SKPhysicsBody(rectangleOf: obstacle1?.size ?? defaultSize)
        obstacle1?.physicsBody?.collisionBitMask = 0
        obstacle1?.physicsBody?.affectedByGravity = false

        ///Randomise the position of the obstacle, be it top/bottom or both, according to enum
        let randomObstaclePosition = ObstaclePositions.allCases.randomElement()
        
        switch randomObstaclePosition {
        case .TOP:
            chooseObstaclePosition(position: ObstaclePositions.TOP)
        case .BOTTOM:
            chooseObstaclePosition(position: ObstaclePositions.BOTTOM)
        case .BOTH:
            chooseObstaclePosition(position: ObstaclePositions.BOTH)
        default:
            break
        }
            
        obstacle2?.removeFromParent()
        
        obstacle1 != nil ? delegator.addChild(obstacle1!) : nil
        obstacle2 != nil ? delegator.addChild(obstacle2!) : nil
        
    }
    
    func setObstacleSize() {
        
        let maxHeight = delegator.scene?.size.height ?? 700
            
        ///Choose a random obstacle from ItemSizes enum
        let randomObstacleSize = ObstacleSizes.allCases.randomElement()
        
        let randomObstacleSizeHeight = randomObstacleSize?.rawValue ?? 0.4
        
        let size = CGSize(width: defaultWidth, height: maxHeight * randomObstacleSizeHeight)
        
        obstacle1 = SKSpriteNode(color: defaultColor, size: size)
    }
    
    func chooseObstaclePosition(position: ObstaclePositions) {
        
        ///Calculate middle points
        let obstacle1HeightMidpoint = (obstacle1?.size.height ?? defaultHeight) / 2
        let screenHeightMidpoint = (delegator.scene?.size.height ?? 500) / 2
 
        //Set x and z positions, and top position of obstacle1
        obstacle1?.position.x = delegator.scene?.size.width ?? 300
        obstacle1?.zPosition = 30
        obstacle1?.name = "obstacle1"
        let obstacle1PositionTop: CGFloat = screenHeightMidpoint - obstacle1HeightMidpoint
        
        switch position {
        
            case .TOP:
                obstacle1?.position.y = obstacle1PositionTop
                
            case .BOTTOM:
                obstacle1?.position.y = -(obstacle1PositionTop)
                
            case .BOTH:
                
                ///Set obstacle2 to a copy of obstacle1
                obstacle2 = obstacle1?.copy() as? SKSpriteNode

                ///Scale the initial height so our traveller can get through the gap and we can calculate the size of the gap currently
                obstacle2?.size.height *= 0.4
                
                ///Find the current gap between obstacle 1 and 2
                var gap = (delegator.scene?.size.height)! - (obstacle1?.size.height)! - (obstacle2?.size.height)!
                
                ///If gap > 400, it is too easy, so add 50 to obstacle2 height till gap is no longer > 400
                while gap > 400 {
                    obstacle2?.size.height += CGFloat(50)
                    gap = (delegator.scene?.size.height)! - (obstacle1?.size.height)! - (obstacle2?.size.height)!

                }
                
                ///Set a different colour
                obstacle2?.color = .red
                
                ///Rename to avoid node conflicts
                obstacle2?.name = "obstacle2"
//                obstacle2?.physicsBody = SKPhysicsBody(rectangleOf: obstacle2?.size ?? defaultSize)
                        //THIS LINE IS THE CRASH PROBLEM
                
                let obstacle2HeightMidpoint = (obstacle2?.size.height ?? (defaultHeight * 0.4)) / 2
                
                ///Randomise the obstacles being at top or bottom (one at each)
                let randomPosition = Int.random(in: 1...2)
                
                if (randomPosition == 1) {
                    obstacle1?.position.y = obstacle1PositionTop
                    obstacle2?.position.y = -(screenHeightMidpoint - obstacle2HeightMidpoint)
                }
                
                else if (randomPosition == 2) {
                    obstacle1?.position.y = -(obstacle1PositionTop)
                    obstacle2?.position.y = screenHeightMidpoint - obstacle2HeightMidpoint
                }
        }
    }
}
