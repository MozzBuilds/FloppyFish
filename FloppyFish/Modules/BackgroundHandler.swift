//
//  BackgroundHandler.swift
//  FloppyFish
//
//  Created by Colin Morrison on 11/11/2021.
//

import SpriteKit

class BackgroundHandler {
    
    let delegate: SKScene?
    
    init(delegate: SKScene) {
        
        self.delegate = delegate
    }
    
    func renderBackground() {
        
        for i in 0...3 {
            let background = SKSpriteNode(imageNamed: "background")
            background.name = "Background"
            background.size = CGSize(width: (delegate?.scene?.size.width)!, height: (delegate?.scene?.size.height)!)
            background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            
            let positionX = CGFloat(i) * background.size.width
            background.position = CGPoint(x: positionX, y: 0)
            delegate?.addChild(background)
            background.zPosition = 0
        }
    }
    
    func moveBackground() {
        
        let block: (SKNode, UnsafeMutablePointer<ObjCBool>) -> () = { (node, error) in
            
            node.position.x -= 2
            
            if node.position.x < -((self.delegate?.scene?.size.width)!) {
                node.position.x += (self.delegate?.scene?.size.width)! * 3
            }
        }
        delegate?.enumerateChildNodes(withName: "Background", using: block)
    }
}
