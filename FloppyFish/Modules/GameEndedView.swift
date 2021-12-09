//
//  GameEnd.swift
//  FloppyFish
//
//  Created by Colin Morrison on 08/12/2021.
//

import SpriteKit

//This class will render all our labels and background nodes
//Will also update with the score, which we can inject
//Can either call this class early, hide it, update score manually, or just initiate when needed

class GameEndedView {
    
    let delegate: SKScene
    let score: Int
    let highScore: Int
    
    let maxHeight: CGFloat
    let maxWidth: CGFloat
    
    var gameOverLabel: SKLabelNode
    var scoreLabel: SKLabelNode
    var highScoreLabel: SKLabelNode
    var playAgainLabel: SKLabelNode
    var menuLabel: SKLabelNode
    
    var gameOverBackground: SKSpriteNode
    var scoreBackground: SKSpriteNode
    var playAgainBackground: SKSpriteNode
    var menuBackground: SKSpriteNode
    
    let labels: [SKLabelNode]
    let backgrounds: [SKSpriteNode]
        
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
        
        gameOverBackground = SKSpriteNode()
        scoreBackground = SKSpriteNode()
        playAgainBackground = SKSpriteNode()
        menuBackground = SKSpriteNode()
        
        backgrounds = [gameOverBackground, scoreBackground, playAgainBackground, menuBackground]
        
        //Do I need to initialise all these, or can I just set them immediately in the class vars? Makes init a lot shorter
        
        setUpUI()
    }
    
    func setUpUI() {
        commonLabelProperties()
        commonBackgroundProperties()
        
        renderGameOverLabel()
        renderGameOverBackground()
        renderScoreLabels()
        renderScoreBackground()
        renderPlayAgainLabel()
        renderPlayAgainBackground()
        renderMenuLabel()
        renderMenuBackground()
    }
    
    func commonLabelProperties() {
        labels.forEach{
            $0.zPosition = 125
            $0.verticalAlignmentMode = .center
            $0.horizontalAlignmentMode = .center
            
            $0.fontName = "Arial"
            $0.fontSize = 72
            $0.fontColor = .black
        }
    }
    
    func commonBackgroundProperties() {
        backgrounds.forEach{
            $0.zPosition = 100
            $0.alpha = 0.8
            //Need to add borders, shading, rounded edges
        }
    }
    
    func renderGameOverLabel() {
        gameOverLabel.name = "gameOverLabel"
        gameOverLabel.text = "Game Over!"
    }
    
    func renderGameOverBackground() {
        gameOverBackground.name = "gameOverBackground"
        gameOverBackground.size = CGSize(width: maxWidth, height: maxHeight * 0.5)
        gameOverBackground.position = CGPoint(x: 0, y: maxHeight * 0.5)
        gameOverBackground.color = .blue
        
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
        scoreBackground.name = "scoreBackground"
        scoreBackground.size = CGSize(width: maxWidth, height: maxHeight * 0.5)
        scoreBackground.position = .zero
        scoreBackground.color = .red
        
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
        playAgainBackground.name = "playAgainBackground"
        playAgainBackground.size = CGSize(width: maxWidth * 0.5, height: maxHeight * 0.2)
        playAgainBackground.position = CGPoint(x: 0, y: -maxHeight * 0.5)
        playAgainBackground.color = .green
                
        playAgainBackground.addChild(playAgainLabel)
        delegate.addChild(playAgainBackground)
    }
    
    func renderMenuLabel() {
        menuLabel.name = "gameOverMenuLabel"
        menuLabel.text = "Menu"
    }
    
    func renderMenuBackground() {
        menuBackground.name = "gameOverMenuBackground"
        menuBackground.size = CGSize(width: maxWidth * 0.5, height: maxHeight * 0.2)
        menuBackground.position = CGPoint(x: 0, y: -maxHeight * 0.7)
        menuBackground.color = .brown

        menuBackground.addChild(menuLabel)
        delegate.addChild(menuBackground)
    }
}
