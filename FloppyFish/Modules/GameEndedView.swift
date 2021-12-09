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
    let defaultRadius = CGFloat(15)
    
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
    
    //MARK: - Render Labels and Backgrounds
    
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
    
    func commonFinalBackgroundProperties(background: SKShapeNode) {
        background.zPosition = 100
        background.lineWidth = 5
        
        background.strokeColor = .black
        background.alpha = 0.8
    }
    
    func renderGameOverLabel() {
        gameOverLabel.name = "gameOverLabel"
        gameOverLabel.text = "Game Over!"
    }
    
    func renderGameOverBackground() {
        let gameOverBackground = SKShapeNode(rectOf: CGSize(width: maxWidth, height: maxHeight * 0.5),
                                        cornerRadius: defaultRadius)
        
        gameOverBackground.name = "gameOverBackground"
        gameOverBackground.position = CGPoint(x: 0, y: maxHeight * 0.5)
        gameOverBackground.fillColor = .blue
        
        commonFinalBackgroundProperties(background: gameOverBackground)
        
        gameOverBackground.addChild(gameOverLabel)
        delegate.addChild(gameOverBackground)
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
    
    func renderScoreBackground() {
        let scoreBackground = SKShapeNode(rectOf: CGSize(width: maxWidth, height: maxHeight * 0.5),
                                          cornerRadius: defaultRadius)
        
        scoreBackground.name = "scoreBackground"
        scoreBackground.position = .zero
        scoreBackground.fillColor = .red
        
        commonFinalBackgroundProperties(background: scoreBackground)
        
        scoreLabel.position = CGPoint(x: scoreBackground.position.x,
                                      y: scoreBackground.position.y + 50)
        
        highScoreLabel.position = CGPoint(x: scoreBackground.position.x,
                                          y: scoreBackground.position.y - 50)
        
        scoreBackground.addChild(highScoreLabel)
        scoreBackground.addChild(scoreLabel)
        delegate.addChild(scoreBackground)
    }
    
    func renderPlayAgainLabel() {
        playAgainLabel.name = "playAgainLabel"
        playAgainLabel.text = "Play?"
    }
    
    func renderPlayAgainBackground() {
        let playAgainBackground = SKShapeNode(rectOf: CGSize(width: maxWidth * 0.5, height: maxHeight * 0.2),
                                              cornerRadius: defaultRadius)
        
        playAgainBackground.name = "playAgainBackground"
        playAgainBackground.position = CGPoint(x: 0, y: -maxHeight * 0.5)
        playAgainBackground.fillColor = .green
        
        commonFinalBackgroundProperties(background: playAgainBackground)
                
        playAgainBackground.addChild(playAgainLabel)
        delegate.addChild(playAgainBackground)
    }
    
    func renderMenuLabel() {
        menuLabel.name = "gameOverMenuLabel"
        menuLabel.text = "Menu"
    }
    
    func renderMenuBackground() {
        let menuBackground = SKShapeNode(rectOf: CGSize(width: maxWidth * 0.5, height: maxHeight * 0.2),
                                         cornerRadius: defaultRadius)
        
        menuBackground.name = "gameOverMenuBackground"
        menuBackground.position = CGPoint(x: 0, y: -maxHeight * 0.7)
        menuBackground.fillColor = .brown
        
        commonFinalBackgroundProperties(background: menuBackground)

        menuBackground.addChild(menuLabel)
        delegate.addChild(menuBackground)
    }
}

//extension SKSpriteNode {
//    func addBorder(color: UIColor, width: CGFloat) {
//        let border = SKShapeNode(rectOf: size, cornerRadius: 25)
//
//        border.zPosition = 110
//        border.lineWidth = width
//
//        border.fillColor = .clear
//        border.strokeColor = color
//        border.alpha = 0.9
//
//        addChild(border)
//    }
//
//    func addShadow(width: CGFloat) {
//        let shadow = SKShapeNode(rectOf: size, cornerRadius: 35)
//        shadow.zPosition = 100
//        shadow.lineWidth = width
//
//        shadow.fillColor = .clear
//        shadow.strokeColor = .darkGray
//        shadow.alpha = 0.2
//
//        addChild(shadow)
//    }
//
//    func cropCorners() {
//        let cropNode = SKCropNode()
//        let maskNode = SKShapeNode(rectOf: size, cornerRadius: 20)
//        maskNode.fillColor = .black
//        cropNode.maskNode = maskNode
//        addChild(cropNode)
//
//    }
//}
