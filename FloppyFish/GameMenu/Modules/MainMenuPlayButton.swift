//
//  MenuPlayButton.swift
//  FloppyFish
//
//  Created by Colin Morrison on 12/12/2021.
//

import SpriteKit

struct MainMenuPlayButton {
    
    init(delegate: SKScene) {
        renderBackground(parent: delegate)
    }
    
    private func renderBackground(parent: SKScene) {
        let size = CGSize(width: parent.size.width * 0.4,
                          height: parent.size.height * 0.1)
        
        let playBackground = SKShapeNode(rectOf: size,
                                     cornerRadius: 0)
        
        playBackground.name = "playBackground"
        playBackground.zPosition = 0
        
        playBackground.fillColor = .gray
        playBackground.glowWidth = 3
        playBackground.strokeColor = .black
        playBackground.lineWidth = 5
        
        renderLabel(parent: playBackground)
        
        parent.addChild(playBackground)
    }
    
    private func renderLabel(parent: SKShapeNode) {
        let playLabel = SKLabelNode()
        
        playLabel.name = "playLabel"
        playLabel.horizontalAlignmentMode = .center
        playLabel.verticalAlignmentMode = .center
        
        playLabel.attributedText = attributedShadowedText(string: "Play", font: "Thonburi-Bold", size: CGFloat(96), color: .black, shadowSize: 2, shadowColor: .black)
        
        parent.addChild(playLabel)
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
