//
//  MenuBackground.swift
//  FloppyFish
//
//  Created by Colin Morrison on 12/12/2021.
//

import SpriteKit

class MainMenuBackground {
    
    private(set) var background: SKShapeNode?
    
    init(delegate: SKScene) {
        renderBackground(parent: delegate)
    }
    
    func renderBackground(parent: SKScene) {
        let size = CGSize(width: parent.size.width,
                          height: parent.size.height * 0.85)
        
        background = SKShapeNode(rectOf: size,
                                     cornerRadius: 0)
                
        guard let background = background else { return }
        
        background.name = "mainMenuBackground"
        background.zPosition = 0
        
        background.fillTexture = SKTexture(imageNamed: "Game_Background")
        background.fillColor = .white
        
        parent.addChild(background)
    }
}
