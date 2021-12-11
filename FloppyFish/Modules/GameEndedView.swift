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
    var scoreLabelText: SKLabelNode
    var highScoreLabelText: SKLabelNode
    var scoreLabelValue: SKLabelNode
    var highScoreLabelValue: SKLabelNode
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
        scoreLabelText = SKLabelNode()
        highScoreLabelText = SKLabelNode()
        scoreLabelValue = SKLabelNode()
        highScoreLabelValue = SKLabelNode()
        playAgainLabel = SKLabelNode()
        menuLabel = SKLabelNode()
        
        labels = [gameOverLabel, scoreLabelText, highScoreLabelText, playAgainLabel, menuLabel]
        
        setUpUI()
    }
    
    func setUpUI() {
        commonInitialLabelProperties()
        
        renderGameOverLabel()
        
        renderScoreTextLabels()
        renderScoreValueLabels()
        renderScoreBackground()
        
        renderPlayAgainLabel()
        renderPlayAgainBackground()
        
        renderMenuLabel()
        renderMenuBackground()
    }
    
    //MARK: - Render Labels
    
    func commonInitialLabelProperties() {
        labels.forEach{
            $0.zPosition = 125
            $0.verticalAlignmentMode = .center
            $0.horizontalAlignmentMode = .center
        }
    }
    
    func renderGameOverLabel() {
        gameOverLabel.name = "gameOverLabel"
        gameOverLabel.position = CGPoint(x: 0, y: maxHeight * 0.4)
        
        let shadow = NSShadow()
        shadow.shadowBlurRadius = 20
        shadow.shadowOffset = CGSize(width: 10, height: 10)
        shadow.shadowColor = UIColor.black
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Thonburi-Bold", size: 96) ?? UIFont.systemFont(ofSize: 96),
            .foregroundColor: UIColor.orange,
            .shadow: shadow,
        ]
        
        gameOverLabel.attributedText = NSAttributedString(string: "GAME OVER",
                                                          attributes: attributes)
                
        delegate.addChild(gameOverLabel)
    }
    
    func renderScoreTextLabels() {
        scoreLabelText.name = "gameOverScoreLabel"
        highScoreLabelText.name = "gameOverHighScoreLabel"
        
        let textFontSize = CGFloat(45)
        scoreLabelText.fontSize = textFontSize

        let textShadow = NSShadow()
        textShadow.shadowBlurRadius = 6
        textShadow.shadowOffset = CGSize(width: 4, height: 4)
        textShadow.shadowColor = UIColor.black

        
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Thonburi",
                          size: textFontSize) ?? UIFont.systemFont(ofSize: textFontSize),
            .foregroundColor: UIColor.orange,
            .shadow: textShadow,
        ]
                
        let scoreTextAttributed = NSAttributedString(string: "Your Score",
                                                       attributes: textAttributes)
        
        let highScoreTextAttributed = NSAttributedString(string: "High Score",
                                                       attributes: textAttributes)
        
        scoreLabelText.attributedText = scoreTextAttributed
        highScoreLabelText.attributedText = highScoreTextAttributed
    }
    
    func renderScoreValueLabels() {
        scoreLabelValue.name = "gameOverScoreLabelValue"
        highScoreLabelValue.name = "gameOverHighScoreLabelValue"
        
        let valueShadow = NSShadow()
        valueShadow.shadowBlurRadius = 3
        valueShadow.shadowOffset = CGSize(width: 3, height: 3)
        valueShadow.shadowColor = UIColor.black
        
        let valueAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Thonburi-Bold",
                          size: 60) ?? UIFont.systemFont(ofSize: 60),
            .foregroundColor: UIColor.white,
            .shadow: valueShadow,
        ]
        
        let scoreValueAttributedText = NSAttributedString(string: "\(score)",
                                                      attributes: valueAttributes)
        
        let highScoreValueAttributedText = NSAttributedString(string: "\(highScore)",
                                                      attributes: valueAttributes)
        
        scoreLabelValue.attributedText = scoreValueAttributedText
        highScoreLabelValue.attributedText = highScoreValueAttributedText
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

    func renderScoreBackground() {
        let scoreBackgroundSize = CGSize(width: maxWidth * 0.7, height: maxHeight * 0.5)
        let scoreBackground = SKShapeNode(rectOf: scoreBackgroundSize, cornerRadius: defaultRadius)
        
        scoreBackground.name = "scoreGameOverBackground"
        scoreBackground.position = .zero
        scoreBackground.fillColor = UIColor(r: 250, g: 225, b: 100)
        scoreBackground.alpha = 0.9
        
        commonFinalBackgroundProperties(background: scoreBackground, size: scoreBackgroundSize)
        
        scoreLabelText.position.y = (scoreBackgroundSize.height / 2) - scoreLabelText.fontSize
        scoreLabelValue.position.y = scoreLabelText.position.y - (scoreLabelText.fontSize * 2)
        highScoreLabelText.position.y = scoreLabelValue.position.y - (scoreLabelText.fontSize * 1.5)
        highScoreLabelValue.position.y = highScoreLabelText.position.y - (scoreLabelText.fontSize * 2)
        
        scoreBackground.addChild(scoreLabelText)
        scoreBackground.addChild(scoreLabelValue)
        scoreBackground.addChild(highScoreLabelText)
        scoreBackground.addChild(highScoreLabelValue)
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
