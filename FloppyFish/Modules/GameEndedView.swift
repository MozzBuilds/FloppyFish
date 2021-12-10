//
//  GameEnd.swift
//  FloppyFish
//
//  Created by Colin Morrison on 08/12/2021.
//

import SpriteKit

class GameEndedView {
    
    let delegate: SKScene
    let score: Int
    let highScore: Int
    
    let maxHeight: CGFloat
    let maxWidth: CGFloat
    let defaultRadius = CGFloat(20)
    
    var gameOverLabel: SKLabelNode
    var scoreLabel: SKLabelNode
    var highScoreLabel: SKLabelNode
    var playAgainLabel: SKLabelNode
    var menuLabel: SKLabelNode
    
    let labels: [SKLabelNode]
        
    init(delegate: SKScene, score: Int, highScore: Int) {
        
        self.delegate = delegate
        self.score = score
        self.highScore = highScore
        
        maxHeight = delegate.frame.size.height / 2
        maxWidth = delegate.frame.size.width / 2
                
        gameOverLabel = SKLabelNode()
        scoreLabel = SKLabelNode()
        highScoreLabel = SKLabelNode()
        playAgainLabel = SKLabelNode()
        menuLabel = SKLabelNode()
        
        labels = [gameOverLabel, scoreLabel, highScoreLabel, playAgainLabel, menuLabel]
        
        setUpUI()
    }
    
    func setUpUI() {
        commonInitialLabelProperties()
        
        renderGameOverLabel()
//        renderGameOverBackground()
        
        renderScoreLabels()
        renderScoreBackground()
        
        renderPlayAgainLabel()
        renderPlayAgainBackground()
        
        renderMenuLabel()
        renderMenuBackground()
    }
    
    //MARK: - Helpers
    
//    func labelFontSizeToFit(label:SKLabelNode, background:SKSpriteNode) {
//
//        let scalingFactor = min(background.size.width / label.frame.width, background.size.height / label.frame.height)
//
//        label.fontSize *= scalingFactor
//    }
    
    //MARK: - Render Labels
    
    func commonInitialLabelProperties() {
        labels.forEach{
            $0.zPosition = 125
            $0.verticalAlignmentMode = .center
            $0.horizontalAlignmentMode = .center
            $0.fontName = "Arial"
            $0.fontSize = 72
            $0.fontColor = .black
        }
    }
    
    func renderGameOverLabel() {
        gameOverLabel.name = "gameOverLabel"
        gameOverLabel.position = CGPoint(x: 0, y: maxHeight * 0.4)
        
        let shadow = NSShadow()
        shadow.shadowBlurRadius = 8
        shadow.shadowOffset = CGSize(width: 15, height: 15)
        shadow.shadowColor = UIColor.black
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Chalkduster", size: 96) ?? UIFont.systemFont(ofSize: 96),
            .foregroundColor: UIColor.orange,
            .shadow: shadow,
        ]
        
        gameOverLabel.attributedText = NSAttributedString(string: "Game Over",
                                                          attributes: attributes)
                
        delegate.addChild(gameOverLabel)
    }
    
    func renderScoreLabels() {
        scoreLabel.name = "gameOverScoreLabel"
        highScoreLabel.name = "gameOverHighScoreLabel"
        
        scoreLabel.text = "Score: \(score)"

        if highScore == score {
            highScoreLabel.text = "New High Score!"
        } else {
            highScoreLabel.text = "Highest: \(highScore)"
        }
    }
    
    func renderPlayAgainLabel() {
        playAgainLabel.name = "playAgainLabel"
        
        let shadow = NSShadow()
        shadow.shadowBlurRadius = 5
        shadow.shadowOffset = CGSize(width: 5, height: 5)
        shadow.shadowColor = UIColor.black
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Arial", size: 96) ?? UIFont.systemFont(ofSize: 96),
            .foregroundColor: UIColor.green,
            .shadow: shadow,
        ]
        
        playAgainLabel.attributedText = NSAttributedString(string: ">",
                                                          attributes: attributes)
    }
    
    func renderMenuLabel() {
        menuLabel.name = "gameOverMenuLabel"
        
        let shadow = NSShadow()
        shadow.shadowBlurRadius = 5
        shadow.shadowOffset = CGSize(width: 5, height: 5)
        shadow.shadowColor = UIColor.black
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Arial", size: 96) ?? UIFont.systemFont(ofSize: 96),
            .foregroundColor: UIColor.red,
            .shadow: shadow,
        ]
        
        menuLabel.attributedText = NSAttributedString(string: "<",
                                                          attributes: attributes)
    }
    
    //MARK: - Render Label Backgrounds
    
    func commonFinalBackgroundProperties(background: SKShapeNode, size: CGSize) {
        background.zPosition = 110
        background.lineWidth = 3
        background.strokeColor = .darkGray
        background.glowWidth = 1

        let shadowWidth = CGFloat(6)
        let shadowSize = CGSize(width: size.width + shadowWidth,
                                height: size.height + shadowWidth)

        background.shadow(color: .gray,
                          size: shadowSize,
                          width: shadowWidth,
                          cornerRadius: defaultRadius)
    }
    
//    func renderGameOverBackground() {
//        let gameOverBackgroundSize = CGSize(width: maxWidth, height: maxHeight * 0.5)
//        let gameOverBackground = SKShapeNode(rectOf: gameOverBackgroundSize, cornerRadius: defaultRadius)
//
//        gameOverBackground.name = "gameOverBackground"
//        gameOverBackground.position = CGPoint(x: 0, y: maxHeight * 0.5)
//        gameOverBackground.fillColor = .blue
//
//        commonFinalBackgroundProperties(background: gameOverBackground, size: gameOverBackgroundSize)
//
//        gameOverBackground.addChild(gameOverLabel)
//        delegate.addChild(gameOverBackground)
//    }

    func renderScoreBackground() {
        let scoreBackgroundSize = CGSize(width: maxWidth, height: maxHeight * 0.5)
        let scoreBackground = SKShapeNode(rectOf: scoreBackgroundSize, cornerRadius: defaultRadius)
        
        scoreBackground.name = "scoreGameOverBackground"
        scoreBackground.position = .zero
        scoreBackground.fillColor = .red
        
        commonFinalBackgroundProperties(background: scoreBackground, size: scoreBackgroundSize)
        
        scoreLabel.position = CGPoint(x: scoreBackground.position.x,
                                      y: scoreBackground.position.y + 50)
        
        highScoreLabel.position = CGPoint(x: scoreBackground.position.x,
                                          y: scoreBackground.position.y - 50)
        
        scoreBackground.addChild(highScoreLabel)
        scoreBackground.addChild(scoreLabel)
        delegate.addChild(scoreBackground)
    }

    func renderPlayAgainBackground() {
        let playAgainBackgroundSize = CGSize(width: maxWidth * 0.5, height: maxHeight * 0.2)
        let playAgainBackground = SKShapeNode(rectOf: playAgainBackgroundSize, cornerRadius: defaultRadius)
        
        playAgainBackground.name = "playAgainBackground"
        playAgainBackground.position = CGPoint(x: maxWidth * 0.5, y: -maxHeight * 0.5)
        playAgainBackground.fillColor = .white
        playAgainBackground.alpha = 0.7
        
        commonFinalBackgroundProperties(background: playAgainBackground, size: playAgainBackgroundSize)
                
        playAgainBackground.addChild(playAgainLabel)
        delegate.addChild(playAgainBackground)
    }

    func renderMenuBackground() {
        let menuBackgroundSize = CGSize(width: maxWidth * 0.5, height: maxHeight * 0.2)
        let menuBackground = SKShapeNode(rectOf: menuBackgroundSize,
                                         cornerRadius: defaultRadius)
        
        menuBackground.name = "gameOverMenuBackground"
        menuBackground.position = CGPoint(x: -maxWidth * 0.5, y: -maxHeight * 0.5)
        menuBackground.fillColor = .white
        menuBackground.alpha = 0.7
        
        commonFinalBackgroundProperties(background: menuBackground, size: menuBackgroundSize)

        menuBackground.addChild(menuLabel)
        delegate.addChild(menuBackground)
    }
}
