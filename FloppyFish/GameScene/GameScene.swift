//
//  GameScene.swift
//  FloppyFish
//
//  Created by Colin Morrison on 31/10/2021.
//

import SpriteKit
import GameplayKit

struct ColliderType {
    static let FISH_COLLIDER: UInt32 = 0
    static let ITEM_COLLIDER: UInt32 = 1
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var background: SKSpriteNode?
    private var fish: SKSpriteNode?
    
    var createObstacle: CreateObstacle?
    
    override func didMove(to view: SKView) {
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        physicsWorld.contactDelegate = self

        renderBackground()
        setUp()
        createObstacle = CreateObstacle(delegator: self)
        
        //Generate Obstacles
        Timer.scheduledTimer(timeInterval: TimeInterval(2.3), target: self, selector: #selector(GameScene.handleItemTimer), userInfo:nil, repeats: true)
        
//        Remove items/cleanup
        Timer.scheduledTimer(timeInterval: TimeInterval(1.0), target: self, selector: #selector(GameScene.cleanUp), userInfo: nil, repeats: true)
    }
    
    func setUp() {
        fish = self.childNode(withName: "fish") as? SKSpriteNode
        fish?.physicsBody?.categoryBitMask = ColliderType.FISH_COLLIDER
        fish?.physicsBody?.contactTestBitMask = ColliderType.ITEM_COLLIDER
        fish?.physicsBody?.collisionBitMask = 0
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
            newItem.position.x -= 3 //set the speed
        }
        
        enumerateChildNodes(withName: "small", using: itemBlock)
        enumerateChildNodes(withName: "medium", using: itemBlock)
        enumerateChildNodes(withName: "large", using: itemBlock)

    }
    
    @objc func handleItemTimer(timer: Timer) {
        let identifier = Int.random(in: 1...8)
        
        switch identifier {
        case 1...2:
            renderItems(position: "top")
        case 3...4:
            renderItems(position: "bottom")
        case 5...8:
            renderItems(position: "both")
        default:
            break
        }
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
    
    @objc private func renderItems(position: String) {
        var item: SKSpriteNode?
        
        let sizeCases = Int.random(in: 1...3)
        
        let maxHeight = self.scene?.size.height ?? 700
        let width: CGFloat = 60
        let color: UIColor = .black
        
        let defaultSize = CGSize(width: width, height: 300)
        
        switch sizeCases {
        
        case 1:
            let size = CGSize(width: width, height: maxHeight * 0.4)
            item = SKSpriteNode(color: color, size: size)
            item?.name = "small"
        case 2:
            let size = CGSize(width: width, height: maxHeight * 0.5)
            item = SKSpriteNode(color: color, size: size)
            item?.name = "medium"
        case 3:
            let size = CGSize(width: width, height: maxHeight * 0.6)
            item = SKSpriteNode(color: color, size: size)
            item?.name = "large"
        default:
            item = SKSpriteNode(color: color, size: defaultSize)
        }
        
        item?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        item?.zPosition = 30
        item?.physicsBody = SKPhysicsBody(rectangleOf: item?.size ?? defaultSize)
        
        let itemHeightMid = (item?.size.height ?? 300) / 2
        let screenHeightMid = (self.scene?.size.height ?? 1000) / 2
        
        item?.position.x = self.scene?.size.width ?? 300
        item?.physicsBody?.collisionBitMask = 0
        item?.physicsBody?.affectedByGravity = false
        
        let item2: SKSpriteNode?
        let positionTop: CGFloat = screenHeightMid - itemHeightMid
        let positionBottom: CGFloat = -(positionTop)
        
        switch position {
        case "top":
            item?.position.y = positionTop
        case "bottom":
            item?.position.y = positionBottom
        case "both":
            item2 = item?.copy() as? SKSpriteNode
            item2?.size.height *= 0.4
            let item2Height = item2?.size.height ?? 300
            
            let randomPosition = Int.random(in: 1...2)
            
            if (randomPosition == 1) {
                item?.position.y = positionTop
                item2?.position.y = -(screenHeightMid - (item2Height / 2))
            } else if (randomPosition == 2) {
                item?.position.y = positionBottom
                item2?.position.y = screenHeightMid - (item2Height / 2)
            }
            addChild(item2!)
        default: break
        }
    
        addChild(item!)
    }
}
