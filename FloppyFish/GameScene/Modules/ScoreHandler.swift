//
//  ScoreHandler.swift
//  FloppyFish
//
//  Created by Colin Morrison on 12/12/2021.
//

import SpriteKit

class ScoreHandler {
        
    private var delegate: SKScene
    
    private(set) var score = Int(0)
    private(set) var highScore = UserDefaults.standard.integer(forKey: "highScore")

    private var scoreLabel: SKLabelNode
    
    init(delegate: SKScene) {
        self.delegate = delegate
        scoreLabel = SKLabelNode()
        renderScoreBackground(parent: delegate)
    }
    
    private func renderScoreLabel(parent: SKShapeNode) {
        scoreLabel.name = "scoreLabel"
        scoreLabel.zPosition = 50
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.verticalAlignmentMode = .center
        
        scoreLabel.fontName = "Arial"
        scoreLabel.fontSize = 50
        scoreLabel.fontColor = .black
        scoreLabel.text = String(0)
        
        parent.addChild(scoreLabel)
    }
    
    private func renderScoreBackground(parent: SKScene) {
        let scoreBackgroundSize = CGSize(width: 120, height: 70)
        let scoreBackground = SKShapeNode(rectOf: scoreBackgroundSize, cornerRadius: 10)
        
        scoreBackground.name = "scoreBackground"
        
        scoreBackground.position = CGPoint(x: -parent.size.width * 0.3,
                                           y: parent.size.height * 0.4)
        scoreBackground.zPosition = 35
        scoreBackground.fillColor = .white
        scoreBackground.alpha = 0.6
        scoreBackground.shadow(color: .black, size: scoreBackgroundSize, width: 3, cornerRadius: 5)
        
        renderScoreLabel(parent: scoreBackground)
        parent.addChild(scoreBackground)
    }
    
    func updateScore() {
        score += 1
        scoreLabel.text = String(score)
    }
    
    func checkHighScore() {
        if score > highScore {
            highScore = score
            UserDefaults.standard.set(highScore, forKey: "highScore")
        }
    }
    
    func hide() {
        delegate.childNode(withName: "scoreBackground")?.isHidden = true
    }
    
    func show() {
        delegate.childNode(withName: "scoreBackground")?.isHidden = false
    }
}
