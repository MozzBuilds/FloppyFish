//
//  GameEnd.swift
//  FloppyFish
//
//  Created by Colin Morrison on 08/12/2021.
//

import SpriteKit

class GameEndedView {
    
    private(set) var delegate: SKScene
    private(set) var score: Int
    private(set) var highScore: Int
    
    ///Background SKShapeNode properties
    private(set) var maxHeight: CGFloat
    private(set) var maxWidth: CGFloat
    private(set) var defaultRadius = CGFloat(20)

    private(set) var gameOverLabel: SKLabelNode
    private(set) var scoreLabelText: SKLabelNode
    private(set) var highScoreLabelText: SKLabelNode
    private(set) var scoreLabelValue: SKLabelNode
    private(set) var highScoreLabelValue: SKLabelNode
    private(set) var playAgainLabel: SKLabelNode
    private(set) var menuLabel: SKLabelNode
    
    private(set) var scoreBackground: SKShapeNode?
    private(set) var playAgainBackground: SKShapeNode?
    private(set) var menuBackground: SKShapeNode?
    
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
    
    func renderGameOverLabel() {
        gameOverLabel.name = "gameOverLabel"
        gameOverLabel.position = CGPoint(x: 0, y: maxHeight * 0.4)
        
        gameOverLabel.attributedText = attributedShadowedText(string: "GAME OVER", font: "Thonburi-Bold", size: 96, color: .orange, shadowSize: 10, shadowColor: .black)
                
        delegate.addChild(gameOverLabel)
    }
    
    func renderScoreTextLabels() {
        scoreLabelText.name = "gameOverScoreLabel"
        highScoreLabelText.name = "gameOverHighScoreLabel"
        
        let fontSize = CGFloat(45)
        scoreLabelText.fontSize = fontSize // Used for size references later
        
        scoreLabelText.attributedText = attributedShadowedText(string: "Your Score", font: "Thonburi", size: fontSize, color: .orange, shadowSize: CGFloat(4), shadowColor: .black)
        
        highScoreLabelText.attributedText = attributedShadowedText(string: "High Score", font: "Thonburi", size: fontSize, color: .orange, shadowSize: CGFloat(4), shadowColor: .black)
    }
    
    func renderScoreValueLabels() {
        scoreLabelValue.name = "gameOverScoreLabelValue"
        highScoreLabelValue.name = "gameOverHighScoreLabelValue"
        
        scoreLabelValue.attributedText = attributedShadowedText(string: "\(score)", font: "Thonburi-Bold", size: CGFloat(60), color: .white, shadowSize: 3, shadowColor: .black)
        
        highScoreLabelValue.attributedText = attributedShadowedText(string: "\(highScore)", font: "Thonburi-Bold", size: CGFloat(60), color: .white, shadowSize: 3, shadowColor: .black)
    }
    
    func renderPlayAgainLabel() {
        playAgainLabel.name = "playAgainLabel"
        
        playAgainLabel.attributedText = attributedShadowedText(string: ">", font: "Arial", size: CGFloat(96), color: .green, shadowSize: 5, shadowColor: .black)
    }
    
    func renderMenuLabel() {
        menuLabel.name = "gameOverMenuLabel"
        
        menuLabel.attributedText = attributedShadowedText(string: "<", font: "Arial", size: CGFloat(96), color: .red, shadowSize: 5, shadowColor: .black)
    }
    
    //MARK: - Render Label Backgrounds

    func renderScoreBackground() {
        
        let scoreBackgroundSize = CGSize(width: maxWidth * 0.7, height: maxHeight * 0.5)
        let shadowWidth = CGFloat(6)
        let shadowSize = CGSize(width: scoreBackgroundSize.width + shadowWidth,
                                height: scoreBackgroundSize.height + shadowWidth)
        
        scoreBackground = SKShapeNode(rectOf: scoreBackgroundSize, cornerRadius: defaultRadius)
        
        guard let scoreBackground = scoreBackground else { return }
        
        scoreBackground.name = "scoreGameOverBackground"
        scoreBackground.fillColor = UIColor(r: 250, g: 225, b: 100)
        scoreBackground.alpha = 0.9

        scoreBackground.shadow(color: .gray,
                               size: shadowSize,
                               width: shadowWidth,
                               cornerRadius: defaultRadius)
        
        commonFinalBackgroundProperties(background: scoreBackground, size: scoreBackgroundSize)
    
        renderScoreLabelPositions(backgroundSize: scoreBackgroundSize)
        
        addScoreNodesToDelegate(scoreBackground: scoreBackground)
    }
    
    func renderScoreLabelPositions(backgroundSize: CGSize) {
        scoreLabelText.position.y = (backgroundSize.height / 2) - scoreLabelText.fontSize
        scoreLabelValue.position.y = scoreLabelText.position.y - (scoreLabelText.fontSize * 2)
        highScoreLabelText.position.y = scoreLabelValue.position.y - (scoreLabelText.fontSize * 1.5)
        highScoreLabelValue.position.y = highScoreLabelText.position.y - (scoreLabelText.fontSize * 2)
    }
    
    func addScoreNodesToDelegate(scoreBackground: SKShapeNode) {
        scoreBackground.addChild(scoreLabelText)
        scoreBackground.addChild(scoreLabelValue)
        scoreBackground.addChild(highScoreLabelText)
        scoreBackground.addChild(highScoreLabelValue)
        delegate.addChild(scoreBackground)
    }

    func renderPlayAgainBackground() {
        let playAgainBackgroundSize = CGSize(width: maxWidth * 0.5, height: maxHeight * 0.2)
        playAgainBackground = SKShapeNode(rectOf: playAgainBackgroundSize, cornerRadius: defaultRadius)
        
        guard let playAgainBackground = playAgainBackground else { return }
        
        playAgainBackground.name = "playAgainBackground"
        playAgainBackground.position = CGPoint(x: maxWidth * 0.5, y: -maxHeight * 0.5)
        playAgainBackground.fillColor = .white
        playAgainBackground.alpha = 0.8
        
        commonFinalBackgroundProperties(background: playAgainBackground, size: playAgainBackgroundSize)

        playAgainBackground.addChild(playAgainLabel)

        delegate.addChild(playAgainBackground)
    }

    func renderMenuBackground() {
        let menuBackgroundSize = CGSize(width: maxWidth * 0.5, height: maxHeight * 0.2)
        menuBackground = SKShapeNode(rectOf: menuBackgroundSize, cornerRadius: defaultRadius)
        
        guard let menuBackground = menuBackground else { return }
        
        menuBackground.name = "gameOverMenuBackground"
        menuBackground.position = CGPoint(x: -maxWidth * 0.5, y: -maxHeight * 0.5)
        menuBackground.fillColor = .white
        menuBackground.alpha = 0.8
        
        commonFinalBackgroundProperties(background: menuBackground, size: menuBackgroundSize)
        
        menuBackground.addChild(menuLabel)
        delegate.addChild(menuBackground)
    }
    
    //MARK: - Helper Fuctions
    
    func commonInitialLabelProperties() {
        labels.forEach{
            $0.zPosition = 125
            $0.verticalAlignmentMode = .center
            $0.horizontalAlignmentMode = .center
        }
    }
    
    func commonFinalBackgroundProperties(background: SKShapeNode, size: CGSize) {
        background.zPosition = 115
        background.lineWidth = 3
        background.strokeColor = .darkGray
        background.glowWidth = 2
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
