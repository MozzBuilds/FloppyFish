//
//  PauseButton.swift
//  FloppyFish
//
//  Created by Colin Morrison on 12/12/2021.
//

import SpriteKit

class PauseButton {
    
    private let delegate: SKScene
    
    private(set) var pauseLogoBackground: SKShapeNode?
    private(set) var pauseLogo: SKShapeNode?
        
    init(delegate: SKScene) {
        self.delegate = delegate
        renderPauseLogoBackground(parent: delegate)
    }
    
    func renderPauseLogoBackground(parent: SKScene) {
        let pauseLogoBackgroundSize = CGSize(width: 90, height: 70)
        pauseLogoBackground = SKShapeNode(rectOf: pauseLogoBackgroundSize, cornerRadius: 10)
        
        guard let pauseLogoBackground = pauseLogoBackground else { return }

        pauseLogoBackground.name = "pauseLogoBackground"
        
        pauseLogoBackground.position = CGPoint(x: parent.size.width * 0.3,
                                           y: parent.size.height * 0.4)
        
        pauseLogoBackground.zPosition = 35
        pauseLogoBackground.fillColor = .white
        pauseLogoBackground.alpha = 0.6

        renderPauseLogo(parent: pauseLogoBackground)
        parent.addChild(pauseLogoBackground)
    }
    
    func renderPauseLogo(parent: SKShapeNode) {
        let pauseLogoSize = CGSize(width: 70, height: 50)
        pauseLogo = SKShapeNode(rectOf: pauseLogoSize, cornerRadius: 10)
        
        guard let pauseLogo = pauseLogo else { return }
        
        pauseLogo.name = "pauseLogo"
        pauseLogo.zPosition = 50
        pauseLogo.fillTexture = SKTexture(imageNamed: "Pause_Button")
        pauseLogo.fillColor = .white
        pauseLogo.strokeColor = .clear
        
        parent.addChild(pauseLogo)
    }
    
    func hide() {
        delegate.childNode(withName: "pauseLogoBackground")?.isHidden = true
    }
    
    func show() {
        delegate.childNode(withName: "pauseLogoBackground")?.isHidden = false
    }
}


