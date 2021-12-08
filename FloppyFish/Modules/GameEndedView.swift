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
    
    init(delegate: SKScene, score: Int, highScore: Int) {
        
        self.delegate = delegate
        self.score = score
        self.highScore = highScore
        
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
        
        label.position = CGPoint(x: 0, y: delegate.frame.size.height / 5)
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
        let scoreMessage = "Score: \(score)"
        var highScoreMessage = "Highest: \(highScore)"
        
        if highScore == score {
            highScoreMessage = "New High Score!"
        }
        
        let scoreLabel = SKLabelNode()
        let highScoreLabel = SKLabelNode()
        let labels = [scoreLabel, highScoreLabel]
        
        scoreLabel.name = "gameOverScoreLabel"
        highScoreLabel.name = "gameOverHighScoreLabel"
        
        scoreLabel.position = CGPoint(x: 0, y: delegate.frame.size.height / 10)
        highScoreLabel.position = CGPoint(x: 0, y: -delegate.frame.size.height / 10)
        
        scoreLabel.text = scoreMessage
        highScoreLabel.text = highScoreMessage
        
        labels.forEach{
            $0.zPosition = 100
            $0.fontName = "Arial"
            $0.fontSize = 72
            $0.fontColor = .white
            delegate.addChild($0)
        }
    }
    
    func scoreBackground() {
        
    }
    
    func playAgainLabel() {
        let label = SKLabelNode()
        label.name = "playAgainLabel"
        
        label.position = CGPoint(x: 0,
                                 y: -delegate.frame.size.height / 5)
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
        
        label.position = CGPoint(x: 0,
                                 y: -delegate.frame.size.height / 3)
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
