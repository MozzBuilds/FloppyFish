//
//  MenuLogo.swift
//  FloppyFish
//
//  Created by Colin Morrison on 12/12/2021.
//

import SpriteKit

struct MainMenuLogo {
    
    init(delegate: SKScene) {
        renderBackground(parent: delegate)
    }
    
    private func renderBackground(parent: SKScene) {
        let size = CGSize(width: parent.size.width * 0.8,
                          height: parent.size.height * 0.15)
        
        let logoBackground = SKShapeNode(rectOf: size,
                                     cornerRadius: 0)
        
        logoBackground.position.y = parent.size.height * 0.25
        
        logoBackground.name = "logoBackground"
        logoBackground.zPosition = 5
        
        logoBackground.fillColor = .gray
        logoBackground.glowWidth = 3
        logoBackground.strokeColor = .black
        logoBackground.lineWidth = 5
        
        renderLabel(parent: logoBackground)
        
        parent.addChild(logoBackground)
    }
    
    private func renderLabel(parent: SKShapeNode) {
        let logoLabel = SKLabelNode()
        
        logoLabel.name = "logoLabel"
        logoLabel.horizontalAlignmentMode = .center
        logoLabel.verticalAlignmentMode = .center
        logoLabel.zPosition = 10
        
        logoLabel.attributedText = attributedShadowedText(string: "Flappy Fish", font: "Thonburi-Bold", size: CGFloat(110), color: .black, shadowSize: 2, shadowColor: .black)
        
        parent.addChild(logoLabel)
    }
    
    private func attributedShadowedText(string: String, font: String, size: CGFloat, color: UIColor, shadowSize: CGFloat, shadowColor: UIColor) -> NSAttributedString {
        
        let shadow = NSShadow()
        shadow.shadowBlurRadius = shadowSize
        shadow.shadowOffset = CGSize(width: shadowSize, height: shadowSize)
        shadow.shadowColor = shadowColor
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: font, size: size) ?? UIFont.systemFont(ofSize: size),
            .foregroundColor: color,
            .shadow: shadow
        ]
        
        return NSAttributedString(string: string, attributes: attributes)
    }
}
