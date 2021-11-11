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
    case XS = 0.35
    case S = 0.40
    case M = 0.45
    case L = 0.50
    case XL = 0.55
}

class CreateObstacle {
    
    let delegator: SKScene
    var item1: SKSpriteNode?
    var item2: SKSpriteNode?
    
    let defaultWidth: CGFloat = 60
    let defaultHeight: CGFloat = 300
    var defaultSize = CGSize(width: 60, height: 300)
    let defaultColor: UIColor = .black
    
    init(delegator: SKScene) {
        
        self.delegator = delegator
        
        defaultSize = CGSize(width: defaultWidth, height: 300)
    }
    
    func renderItem() {
        
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
            
        item2?.removeFromParent()
        
        item1 != nil ? delegator.addChild(item1!) : nil
        item2 != nil ? delegator.addChild(item2!) : nil
        
    }
    
    func setItemSize() {
        
        let maxHeight = delegator.scene?.size.height ?? 700
            
        ///Choose a random item from ItemSizes enum
        let randomItemSize = ItemSizes.allCases.randomElement()
        
        let randomItemSizeHeight = randomItemSize?.rawValue ?? 0.4
        
        let size = CGSize(width: defaultWidth, height: maxHeight * randomItemSizeHeight)
        
        item1 = SKSpriteNode(color: defaultColor, size: size)
    }
    
    func chooseItemPosition(position: ItemPositions) {
        
        ///Calculate middle points
        let item1HeightMidpoint = (item1?.size.height ?? defaultHeight) / 2
        let screenHeightMidpoint = (delegator.scene?.size.height ?? 500) / 2
 
        //Set x and z positions, and top position of item1
        item1?.position.x = delegator.scene?.size.width ?? 300
        item1?.zPosition = 30
        item1?.name = "obstacle1"
        let item1PositionTop: CGFloat = screenHeightMidpoint - item1HeightMidpoint
        
        switch position {
        
            case .TOP:
                item1?.position.y = item1PositionTop
                
            case .BOTTOM:
                item1?.position.y = -(item1PositionTop)
                
            case .BOTH:
                
                ///Set item2 to a copy of item1
                item2 = item1?.copy() as? SKSpriteNode

                ///Scale the initial height so our traveller can get through the gap and we can calculate the size of the gap currently
                item2?.size.height *= 0.4
                
                ///Find the current gap between item 1 and 2
                var gap = (delegator.scene?.size.height)! - (item1?.size.height)! - (item2?.size.height)!
                
                ///If gap > 400, it is too easy, so add 50 to item2 height till gap is no longer > 400
                while gap > 400 {
                    item2?.size.height += CGFloat(50)
                    gap = (delegator.scene?.size.height)! - (item1?.size.height)! - (item2?.size.height)!

                }
                
                ///Set a different colour
                item2?.color = .red
                
                ///Rename to avoid node conflicts
                item2?.name = "obstacle2"
//                item2?.physicsBody = SKPhysicsBody(rectangleOf: item2?.size ?? defaultSize)
                        //THIS LINE IS THE CRASH PROBLEM
                
                let item2HeightMidpoint = (item2?.size.height ?? (defaultHeight * 0.4)) / 2
                
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
