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
    case SM = 0.43
    case M = 0.46
    case ML = 0.48
    case L = 0.51
    case XL = 0.54
    case XXL = 0.58
}

class ObstacleCreator {
    
    let delegate: SKScene
    var obstacle1: SKSpriteNode?
    var obstacle2: SKSpriteNode?
    
    let defaultWidth: CGFloat = 60
    let defaultHeight: CGFloat = 300
    var defaultSize = CGSize(width: 60, height: 300)
    let defaultColor: UIColor = .black
    
    init(delegate: SKScene) {
        
        self.delegate = delegate
        
        defaultSize = CGSize(width: defaultWidth, height: 300)
    }
    
    func renderObstacle() {
        ///Randomise the size of the obstacle and set anchor
        setObstacleSize()
        obstacle1?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let randomObstaclePosition = Int.random(in: 1...9)
        
        switch randomObstaclePosition {
        case 1...2:
            chooseObstaclePosition(position: ObstaclePositions.TOP)
        case 3...4:
            chooseObstaclePosition(position: ObstaclePositions.BOTTOM)
        case 5...9:
            chooseObstaclePosition(position: ObstaclePositions.BOTH)
        default:
            break
        }
            
        obstacle2?.removeFromParent()
        
        obstacle1 != nil ? delegate.addChild(obstacle1!) : nil
        obstacle2 != nil ? delegate.addChild(obstacle2!) : nil
    }
    
    func setObstacleSize() {
        
        let maxHeight = delegate.scene?.size.height ?? 700
            
        ///Choose a random obstacle from ItemSizes enum
        let randomObstacleSize = ObstacleSizes.allCases.randomElement()
        
        let randomObstacleSizeHeight = randomObstacleSize?.rawValue ?? 0.4
        
        let size = CGSize(width: defaultWidth, height: maxHeight * randomObstacleSizeHeight)
        
        obstacle1 = SKSpriteNode(color: defaultColor, size: size)
    }
    
    func chooseObstaclePosition(position: ObstaclePositions) {
        
        ///Calculate middle points
        let obstacle1HeightMidpoint = (obstacle1?.size.height ?? defaultHeight) / 2
        let screenHeightMidpoint = (delegate.scene?.size.height ?? 500) / 2
 
        //Set start position, and z (below score label)
        obstacle1?.position.x = delegate.scene?.size.width ?? 300
        obstacle1?.zPosition = 25
        obstacle1?.name = "obstacle"
        let obstacle1PositionTop: CGFloat = screenHeightMidpoint - obstacle1HeightMidpoint
        
        switch position {
        
            case .TOP:
                obstacle1?.position.y = obstacle1PositionTop
                obstacle1?.physicsBody = SKPhysicsBody(rectangleOf: obstacle1?.size ?? defaultSize)
                obstacle1?.physicsBody?.collisionBitMask = 0
                obstacle1?.physicsBody?.affectedByGravity = false
                obstacle1?.physicsBody?.isDynamic = false
                
            case .BOTTOM:
                obstacle1?.position.y = -(obstacle1PositionTop)
                obstacle1?.physicsBody = SKPhysicsBody(rectangleOf: obstacle1?.size ?? defaultSize)
                obstacle1?.physicsBody?.collisionBitMask = 0
                obstacle1?.physicsBody?.affectedByGravity = false
                obstacle1?.physicsBody?.isDynamic = false
                
            case .BOTH:
                
                ///Set obstacle2 to a copy of obstacle1
                obstacle2 = obstacle1?.copy() as? SKSpriteNode

                ///Scale the initial height so our traveller can get through the gap and we can calculate the size of the gap currently
                obstacle2?.size.height *= 0.4
                
                ///Find the current gap between obstacle 1 and 2
                var gap = (delegate.scene?.size.height)! - (obstacle1?.size.height)! - (obstacle2?.size.height)!
                
                ///If gap > 400, it is too easy, so add 50 to obstacle2 height till gap is no longer > 400
                while gap > 400 {
                    obstacle2?.size.height += CGFloat(50)
                    gap = (delegate.scene?.size.height)! - (obstacle1?.size.height)! - (obstacle2?.size.height)!
                }
                
                ///Set a different colour
                obstacle2?.color = .red
                
                ///Set the physics body sizes now size is complete
                obstacle1?.position.y = obstacle1PositionTop
                obstacle1?.physicsBody = SKPhysicsBody(rectangleOf: obstacle1?.size ?? defaultSize)
                obstacle1?.physicsBody?.collisionBitMask = 0
                obstacle1?.physicsBody?.affectedByGravity = false
                obstacle1?.physicsBody?.isDynamic = false
                
                obstacle2?.physicsBody = SKPhysicsBody(rectangleOf: obstacle2?.size ?? defaultSize)
                obstacle2?.physicsBody?.collisionBitMask = 0
                obstacle2?.physicsBody?.affectedByGravity = false
                obstacle2?.physicsBody?.isDynamic = false
                
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
