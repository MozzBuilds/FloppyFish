//
//  MenuButton.swift
//  FloppyFish
//
//  Created by Colin Morrison on 12/12/2021.
//

import SpriteKit

struct MenuButton {
    
    private let delegate: SKScene
        
    init(delegate: SKScene) {
        self.delegate = delegate
        rendermenuBackground(parent: delegate)
    }
    
    private func rendermenuLabel(parent: SKShapeNode) {
        let menuLabel = SKLabelNode()
        menuLabel.name = "menuLabel"
        menuLabel.zPosition = 50
        menuLabel.horizontalAlignmentMode = .center
        menuLabel.verticalAlignmentMode = .center
        
        menuLabel.fontName = "Arial"
        menuLabel.fontSize = 50
        menuLabel.fontColor = .black
        menuLabel.text = "M"
        
        parent.addChild(menuLabel)
    }
    
    private func rendermenuBackground(parent: SKScene) {
        let menuBackgroundSize = CGSize(width: 70, height: 70)
        let menuBackground = SKShapeNode(rectOf: menuBackgroundSize, cornerRadius: 10)
        
        menuBackground.name = "menuBackground"
        
        menuBackground.position = CGPoint(x: parent.size.width * 0.2,
                                           y: parent.size.height * 0.4)
        menuBackground.zPosition = 35
        menuBackground.fillColor = .white
        menuBackground.alpha = 0.6
        menuBackground.shadow(color: .black, size: menuBackgroundSize, width: 3, cornerRadius: 5)
        
        rendermenuLabel(parent: menuBackground)
        parent.addChild(menuBackground)
    }
    
    func hide() {
        delegate.childNode(withName: "menuBackground")?.isHidden = true
    }
    
    func show() {
        delegate.childNode(withName: "menuBackground")?.isHidden = false
    }
}
