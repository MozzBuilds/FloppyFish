//
//  CreateObstacle.swift
//  FloppyFish
//
//  Created by Colin Morrison on 31/10/2021.
//

import Foundation
import SpriteKit

enum ItemPositions: CaseIterable {
    case TOP
    case BOTTOM
    case BOTH
}

enum ItemSizes: CGFloat, CaseIterable {
    case XS = 0.2
    case S = 0.3
    case M = 0.4
    case L = 0.5
    case XL = 0.6
}

class CreateObstacle {
    
    let delegator: SKScene
    var item1: SKSpriteNode?
    var item2: SKSpriteNode?
    
    let defaultWidth: CGFloat = 60
    let defaultHeight: CGFloat = 300
    var defaultSize = CGSize(width: 60, height: 300)

    
    init(delegator: SKScene) {
        
        self.delegator = delegator
        
        defaultSize = CGSize(width: defaultWidth, height: 300)
    }
    
    func renderItems() {
        
        ///Randomise the size of the obstacle
        setItemSize()
        
        ///Set the physics. Done before setting position, as we make a copy of item2 for two items at the same time
        item1?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        item1?.physicsBody = SKPhysicsBody(rectangleOf: item1?.size ?? defaultSize)
        item1?.physicsBody?.collisionBitMask = 0
        item1?.physicsBody?.affectedByGravity = false
        
        ///Randomise the position of the obstacle, be it top/bottom or both, according to enum
        let randomItemPosition = ItemPositions.allCases.randomElement()
        
        switch randomItemPosition {
        case .TOP:
            chooseItemPosition(position: ItemPositions.TOP)
        case .BOTTOM:
            chooseItemPosition(position: ItemPositions.BOTTOM)
        case .BOTH:
            chooseItemPosition(position: ItemPositions.BOTH)
        default:
            break
        }
    
        item1 != nil ? delegator.addChild(item1!) : nil
        item2 != nil ? delegator.addChild(item2!) : nil
    }
    
    func setItemSize() {
        
        let maxHeight = delegator.scene?.size.height ?? 700
        
        let standardColor: UIColor = .black
        
        ///Choose a random item from ItemSizes enum
        let randomItemSize = ItemSizes.allCases.randomElement()
        
        let randomItemSizeHeight = randomItemSize?.rawValue ?? 0.4
        
        let size = CGSize(width: defaultWidth, height: maxHeight * randomItemSizeHeight)
        
        item1 = SKSpriteNode(color: standardColor, size: size)
        
        item1?.name = "obstacle"
    }
    
    func chooseItemPosition(position: ItemPositions) {
        
        ///Calculate middle points
        let item1HeightMidpoint = (item1?.size.height ?? defaultHeight) / 2
        let screenHeightMidpoint = (delegator.scene?.size.height ?? 500) / 2
 
        //Set x and z positions, and top position of item1
        item1?.position.x = delegator.scene?.size.width ?? 300
        item1?.zPosition = 30
        let item1PositionTop = screenHeightMidpoint - item1HeightMidpoint
        
        switch position {
        
            case .TOP:
                item1?.position.y = item1PositionTop
                
            case .BOTTOM:
                item1?.position.y = -(item1PositionTop)
                
            case .BOTH:
                
                ///Set item2 to a copy of item1
                item2 = item1?.copy() as? SKSpriteNode
                
                ///Scale the height so our traveller can get through the gap
                item2?.size.height *= 0.4
                let item2HeightMidpoint = (item2?.size.height ?? defaultHeight * 0.4) / 2
                
                ///Randomise the items being at top or bottom (one at each)
                let randomPosition = Int.random(in: 1...2)
                
                if (randomPosition == 1) {
                    item1?.position.y = item1PositionTop
                    item2?.position.y = -(screenHeightMidpoint - item2HeightMidpoint)
                }
                
                else if (randomPosition == 2) {
                    item1?.position.y = -(item1PositionTop)
                    item2?.position.y = screenHeightMidpoint - item2HeightMidpoint
                }
        }
    }
}
