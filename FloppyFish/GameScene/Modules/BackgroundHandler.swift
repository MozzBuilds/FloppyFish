//
//  BackgroundHandler.swift
//  FloppyFish
//
//  Created by Colin Morrison on 11/11/2021.
//

import SpriteKit

class BackgroundHandler {
    
    let delegate: SKScene
    
    init(delegate: SKScene) {
        
        self.delegate = delegate
    }
    
    func renderBackground() {
        
        for i in 0...3 {
            let background = SKSpriteNode(imageNamed: "Game_Background")
            background.name = "background"
            background.size = CGSize(width: delegate.size.width,
                                     height: delegate.size.height)
            
            let positionX = CGFloat(i) * background.size.width
            background.position = CGPoint(x: positionX, y: 0)
            background.zPosition = 0
            delegate.addChild(background)
        }
    }
    
    func moveBackground() {
        
        let block: (SKNode, UnsafeMutablePointer<ObjCBool>) -> () = { (node, error) in
            
            node.position.x -= 2
            
            if node.position.x < -self.delegate.size.width {
                node.position.x += self.delegate.size.width * 3
            }
        }
        
        delegate.enumerateChildNodes(withName: "background", using: block)
    }
}
