//
//  GameViewController.swift
//  FloppyFish
//
//  Created by Colin Morrison on 31/10/2021.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var menuScene: GameMenu?
    var gameScene: GameScene?
    var skView: SKView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        skView = (self.view as! SKView)
        
        menuScene = GameMenu(fileNamed: "GameMenu")
        menuScene?.scaleMode = .aspectFill
        skView?.presentScene(menuScene)
            
        skView?.ignoresSiblingOrder = true
        skView?.showsFPS = true
        skView?.showsNodeCount = true
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
        
}
