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
                          height: parent.size.height)
        
        let background = SKShapeNode(rectOf: size,
                                     cornerRadius: 0)
        
        background.name = "mainMenuBackground"
        background.zPosition = 0
        
        background.fillColor = .lightGray
        background.glowWidth = 100
        background.strokeColor = .gray
        
        parent.addChild(background)
    }
}
