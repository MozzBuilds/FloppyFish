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
    
    var scoreLabel: SKLabelNode
    var highScoreLabel: SKLabelNode
    
    init(delegate: SKScene, score: Int, highScore: Int) {
        
        self.delegate = delegate
        self.score = score
        self.highScore = highScore
        
        maxHeight = delegate.frame.size.height
        maxWidth = delegate.frame.size.width
        
        scoreLabel = SKLabelNode()
        highScoreLabel = SKLabelNode()
        
        setUpUI()
    }
    
    func setUpUI() {
        gameOverLabel()
        gameOverBackground()
        scoreLabels()
        scoreBackground()
        playAgainLabel()
        playAgainBackground()
        menuLabel()
        menuBackground()
    }
    
    func gameOverLabel() {
        let label = SKLabelNode()
        label.name = "gameOverLabel"
        
        label.position = CGPoint(x: 0, y: maxHeight * 0.2)
        label.zPosition = 100
        label.text = "Game Over!"
        
        label.fontName = "Arial"
        label.fontSize = 72
        label.fontColor = .black
        
        delegate.addChild(label)
    }
    
    func gameOverBackground() {
        
    }
    
    func scoreLabels() {
        scoreLabel.name = "gameOverScoreLabel"
        highScoreLabel.name = "gameOverHighScoreLabel"
        
        scoreLabel.text = "Score: \(score)"

        if highScore == score {
            highScoreLabel.text = "New High Score!"
        } else {
            highScoreLabel.text = "Highest: \(highScore)"
        }
                
        [scoreLabel, highScoreLabel].forEach{
            $0.zPosition = 125
            $0.fontName = "Arial"
            $0.fontSize = 72
            $0.fontColor = .black
        }
    }
    
    func scoreBackground() {
        let background = SKSpriteNode()
        background.name = "scoreBackground"
        
        background.size = CGSize(width: maxWidth * 0.6, height: maxHeight * 0.3)
        background.position = CGPoint(x: 0, y: 0)
        background.zPosition = 100
        
        background.color = .red
        background.alpha = 0.8
        
        scoreLabel.position = CGPoint(x: background.position.x,
                                      y: background.position.y + 50)
        highScoreLabel.position = CGPoint(x: background.position.x,
                                          y: background.position.y - 50)
        
        background.addChild(highScoreLabel)
        background.addChild(scoreLabel)
        delegate.addChild(background)
    }
    
    func playAgainLabel() {
        let label = SKLabelNode()
        label.name = "playAgainLabel"
        
        label.position = CGPoint(x: 0, y: -maxHeight * 0.2)
        label.zPosition = 100
        label.text = "Play?"
        
        label.fontName = "Arial"
        label.fontSize = 72
        label.fontColor = .black
        
        delegate.addChild(label)
    }
    
    func playAgainBackground() {
        
    }
    
    func menuLabel() {
        let label = SKLabelNode()
        label.name = "gameOverMenuLabel"
        
        label.position = CGPoint(x: 0, y: -maxHeight * 0.3)
        label.zPosition = 100
        label.text = "Menu"
        
        label.fontName = "Arial"
        label.fontSize = 72
        label.fontColor = .black
        
        delegate.addChild(label)
    }
    
    func menuBackground() {
        
    }
}
