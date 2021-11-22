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
    
    var settings: Settings?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.settings = Settings()
        
        if let view = self.view as! SKView? {
            /// Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameMenu") {
                /// Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill

                /// Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
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
