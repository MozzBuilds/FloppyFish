//
//  MenuBackground.swift
//  FloppyFish
//
//  Created by Colin Morrison on 12/12/2021.
//

import SpriteKit

struct MainMenuBackground {
    
    init(delegate: SKScene) {
        renderBackground(parent: delegate)
    }
    
    private func renderBackground(parent: SKScene) {
        let size = CGSize(width: parent.size.width,
                          height: parent.size.height * 0.85)
        
        let background = SKShapeNode(rectOf: size,
                                     cornerRadius: 0)
                
        background.name = "mainMenuBackground"
        background.zPosition = 0
        
        background.fillTexture = SKTexture(imageNamed: "Game_Background")
        background.fillColor = .white
        
        parent.addChild(background)
    }
}
