//
//  PauseButton.swift
//  FloppyFish
//
//  Created by Colin Morrison on 12/12/2021.
//

import SpriteKit

struct PauseButton {
    
    private let delegate: SKScene
        
    init(delegate: SKScene) {
        self.delegate = delegate
        renderPauseBackground(parent: delegate)
    }
    
    private func renderPauseLabel(parent: SKShapeNode) {
        let pauseLabel = SKLabelNode()
        pauseLabel.name = "pauseLabel"
        pauseLabel.zPosition = 50
        pauseLabel.horizontalAlignmentMode = .center
        pauseLabel.verticalAlignmentMode = .center
        
        pauseLabel.fontName = "Arial"
        pauseLabel.fontSize = 50
        pauseLabel.fontColor = .black
        pauseLabel.text = "P"
        
        parent.addChild(pauseLabel)
    }
    
    private func renderPauseBackground(parent: SKScene) {
        let pauseBackgroundSize = CGSize(width: 70, height: 70)
        let pauseBackground = SKShapeNode(rectOf: pauseBackgroundSize, cornerRadius: 10)
        
        pauseBackground.name = "pauseBackground"
        
        pauseBackground.position = CGPoint(x: parent.size.width * 0.3,
                                           y: parent.size.height * 0.4)
        pauseBackground.zPosition = 35
        pauseBackground.fillColor = .white
        pauseBackground.alpha = 0.6
        
        renderPauseLabel(parent: pauseBackground)
        parent.addChild(pauseBackground)
    }
    
    func hide() {
        delegate.childNode(withName: "pauseBackground")?.isHidden = true
    }
    
    func show() {
        delegate.childNode(withName: "pauseBackground")?.isHidden = false
    }
}
