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
        renderGameOverBackground()
        
        renderScoreLabels()
        renderScoreBackground()
        
        renderPlayAgainLabel()
        renderPlayAgainBackground()
        
        renderMenuLabel()
        renderMenuBackground()
    }
    
    //MARK: - Helpers
    
    func labelFontSizeToFit(label:SKLabelNode, background:SKSpriteNode) {

        let scalingFactor = min(background.size.width / label.frame.width, background.size.height / label.frame.height)

        label.fontSize *= scalingFactor
    }
    
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
        gameOverLabel.text = "Game Over!"
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
        playAgainLabel.text = "Play?"
    }
    
    func renderMenuLabel() {
        menuLabel.name = "gameOverMenuLabel"
        menuLabel.text = "Menu"
    }
    
    //MARK: - Render Label Backgrounds
    
    func commonFinalBackgroundProperties(background: SKShapeNode, size: CGSize) {
        background.zPosition = 110
        background.lineWidth = 4
        background.strokeColor = .darkGray
        background.glowWidth = 2
        background.alpha = 0.9


        let shadowWidth = CGFloat(8)
        let shadowSize = CGSize(width: size.width + shadowWidth,
                                height: size.height + shadowWidth)

        background.shadow(color: .gray,
                          size: shadowSize,
                          width: shadowWidth,
                          cornerRadius: defaultRadius)
    }
    
    func renderGameOverBackground() {
        let gameOverBackgroundSize = CGSize(width: maxWidth, height: maxHeight * 0.5)
        let gameOverBackground = SKShapeNode(rectOf: gameOverBackgroundSize, cornerRadius: defaultRadius)
        
        gameOverBackground.name = "gameOverBackground"
        gameOverBackground.position = CGPoint(x: 0, y: maxHeight * 0.5)
        gameOverBackground.fillColor = .blue
        
        commonFinalBackgroundProperties(background: gameOverBackground, size: gameOverBackgroundSize)
        
        gameOverBackground.addChild(gameOverLabel)
        delegate.addChild(gameOverBackground)
    }

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
        playAgainBackground.position = CGPoint(x: 0, y: -maxHeight * 0.5)
        playAgainBackground.fillColor = .green
        
        commonFinalBackgroundProperties(background: playAgainBackground, size: playAgainBackgroundSize)
                
        playAgainBackground.addChild(playAgainLabel)
        delegate.addChild(playAgainBackground)
    }

    func renderMenuBackground() {
        let menuBackgroundSize = CGSize(width: maxWidth * 0.5, height: maxHeight * 0.2)
        let menuBackground = SKShapeNode(rectOf: menuBackgroundSize,
                                         cornerRadius: defaultRadius)
        
        menuBackground.name = "gameOverMenuBackground"
        menuBackground.position = CGPoint(x: 0, y: -maxHeight * 0.7)
        menuBackground.fillColor = .brown
        
        commonFinalBackgroundProperties(background: menuBackground, size: menuBackgroundSize)

        menuBackground.addChild(menuLabel)
        delegate.addChild(menuBackground)
    }
}

extension SKShapeNode {

    func shadow(color: UIColor, size: CGSize, width: CGFloat, cornerRadius: CGFloat) {
        let shadow = SKShapeNode(rectOf: size, cornerRadius: cornerRadius)

        shadow.zPosition = 100
        shadow.lineWidth = width

        shadow.fillColor = .clear
        shadow.strokeColor = color
        shadow.alpha = 0.5

        addChild(shadow)
    }
}
