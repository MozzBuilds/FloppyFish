//
//  GameScene.swift
//  FloppyFish
//
//  Created by Colin Morrison on 31/10/2021.
//

import SpriteKit
import GameplayKit

class GameMenu: SKScene {
    
    override func didMove(to view: SKView) {
//        scaleMode = .resizeFill
        _ = MainMenuBackground(delegate: self)
        _ = MainMenuLogo(delegate: self)
        _ = MainMenuPlayButton(delegate: self)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            
            switch atPoint(touchLocation).name {

            case "playLabel", "playBackground":
                let gameScene = SKScene(fileNamed: "GameScene")!
                gameScene.scaleMode = .aspectFill
                view?.presentScene(gameScene, transition: SKTransition.fade(withDuration: 0.5))
                
            default: break

            }
        }
    }
}
