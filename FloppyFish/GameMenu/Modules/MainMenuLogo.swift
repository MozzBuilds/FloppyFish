//
//  MenuLogo.swift
//  FloppyFish
//
//  Created by Colin Morrison on 12/12/2021.
//

import SpriteKit

class MainMenuLogo {
    
    private(set) var logo: SKShapeNode?
    
    init(delegate: SKScene) {
        renderLogo(parent: delegate)
    }
    
    func renderLogo(parent: SKScene) {
        let size = CGSize(width: parent.size.width * 0.8,
                          height: parent.size.height * 0.25)
        
        logo = SKShapeNode(rectOf: size)
        
        guard let logo = logo else { return }
        
        logo.fillTexture = SKTexture(imageNamed: "Menu_Logo")
        
        logo.position.y = parent.size.height * 0.25
        
        logo.name = "menuLogo"
        logo.zPosition = 5
        
        logo.fillColor = .white
        logo.strokeColor = .clear
                
        parent.addChild(logo)
    }

}
