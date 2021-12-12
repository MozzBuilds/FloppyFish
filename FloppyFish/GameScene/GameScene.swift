//
//  GameScene.swift
//  FloppyFish
//
//  Created by Colin Morrison on 31/10/2021.
//

import SpriteKit
import GameplayKit

struct ColliderType {
    static let traveller: UInt32 = 0
    static let obstacle: UInt32 = 1
    static let minBoundary: UInt32 = 2
    static let maxBoundary: UInt32 = 3
}

class GameScene: SKScene, SKPhysicsContactDelegate {
            
    private var obstacleCreator: ObstacleCreator!
    private var backgroundHandler: BackgroundHandler?
    private var worldPhysics: WorldPhysics!
    private var travellerCreator: TravellerCreator!
    
    private var scoreHandler: ScoreHandler?
    private var pauseButton: PauseButton?
    private var menuButton: MenuButton?
    
    private var countDownTime = 3
                
    override func didMove(to view: SKView) {

        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.scaleMode = .resizeFill
        
        ///Initiate our creators and handlers
        obstacleCreator = ObstacleCreator(delegate: self)
        worldPhysics = WorldPhysics(delegate: self)
        travellerCreator = TravellerCreator(delegate: self)
        
        setUpScene()
    }
    
    func setUpScene() {
        setUpBackground()
        setUpPauseButton()
        setUpMenuButton()
        setUpScoreHandler()
        setUpWorld()
        setUpTraveller()
        setUpTimers()
    }
    
    func setUpBackground() {
        backgroundHandler = BackgroundHandler(delegate: self)
        backgroundHandler?.renderBackground()
    }
    
    func setUpPauseButton() {
        pauseButton = PauseButton(delegate: self)
        pauseButton?.hide()
    }
    
    func setUpMenuButton() {
        menuButton = MenuButton(delegate: self)
        menuButton?.hide()
    }
    
    func setUpScoreHandler() {
        scoreHandler = ScoreHandler(delegate: self)
        scoreHandler?.hide()
    }
    
    func setUpWorld() {
        worldPhysics.setUpPhysicsWorld()
        worldPhysics.addBoundaries()
    }
    
    func setUpTraveller() {
        travellerCreator.pauseTraveller()
    }
    
    func hideGameplayNodes() {
        pauseButton?.hide()
        menuButton?.hide()
        scoreHandler?.hide()
    }
    
    func showGameplayNodes() {
        pauseButton?.show()
        menuButton?.show()
        scoreHandler?.show()
    }
    
    @objc func setUpCountdown () {
        if !isPaused {
            if countDownTime > 0 {
            
                let countDownLabel = SKLabelNode()
                
                countDownLabel.fontSize = 100
                countDownLabel.zPosition = 50
                countDownLabel.text = String(countDownTime)
                
                addChild(countDownLabel)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    countDownLabel.removeFromParent()
                })
                
                countDownTime -= 1

            } else {
                travellerCreator.unpauseTraveller()
                showGameplayNodes()
            }
        }
    }
    
    func setUpTimers() {
        ///Var for timer interals
        let timeInterval = TimeInterval(1.2)
        let delay = DispatchTime.now() + 3.0
        
        ///Generate countdown
        Timer.scheduledTimer(timeInterval: TimeInterval(0.6), target: self, selector: #selector(GameScene.setUpCountdown), userInfo: nil, repeats: true)
        
        ///Generate obstacles at timed intervals
        Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(GameScene.handleObstacleTimer), userInfo:nil, repeats: true)
        
        ///Set traveller rotation
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(GameScene.travellerRotator), userInfo: nil, repeats: true)
        
        ///Remove obstacles/cleanup
        Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(GameScene.cleanUp), userInfo: nil, repeats: true)
        
        ///Update sccore
        DispatchQueue.main.asyncAfter(deadline: delay) {
            Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(GameScene.updateScore), userInfo: nil, repeats: true)
        }
    }
    
    @objc func cleanUp() {
        ///Removes nodes no longer visible on screen
        for child in children {
            if child.position.x < -self.size.width - 30 {
                child.removeFromParent()
            }
        }
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        if !isPaused {
            ///Auto called before each frame is rendered
            backgroundHandler?.moveBackground()

            ///Look out for new nodes
            enumerateChildNodes(withName: "obstacle", using: { (obstacle, stop) in
                let newItem = obstacle as! SKSpriteNode
                newItem.position.x -= 5 ///set the X speed
            })
        }
    }
    
    @objc func updateScore() {
        if !isPaused {
            scoreHandler?.updateScore()
        }
    }
    
    @objc func handleObstacleTimer(timer: Timer) {
        ///At each scheduled timer interval, render obstacles
        if !isPaused {
            obstacleCreator?.renderObstacles()
        }
    }
    
    @objc func travellerRotator() {
        travellerCreator.rotate()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
                
                let touchLocation = touch.location(in: self)
                
                switch atPoint(touchLocation).name {
                
                case "pauseNode":
                    isPaused.toggle()
                    
                case "menuNode", "gameOverMenuLabel", "gameOverMenuBackground":
                    guard let menuScene = SKScene(fileNamed: "GameMenu") else { return }
                    menuScene.scaleMode = .aspectFill
                    view?.presentScene(menuScene, transition: SKTransition.fade(withDuration: 0.5))
                    
                case "playAgainLabel", "playAgainBackground":
                    resetScene()
                    
                default :
                    if !isPaused {
                        travellerCreator.applyImpulse()
                    }
                }
            }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        isPaused = true
        hideGameplayNodes()
        travellerCreator.updateTexture()
        scoreHandler?.checkHighScore()
        
        let _ = GameEndedView(delegate: self, score: scoreHandler!.score, highScore: scoreHandler!.highScore)
    }
    
    func resetScene() {
        let gameScene = SKScene(fileNamed: "GameScene")!
        gameScene.scaleMode = .aspectFill
        view?.presentScene(gameScene, transition: SKTransition.fade(withDuration: 0.5))
    }
}
