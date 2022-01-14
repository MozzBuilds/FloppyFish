//
//  GameMenuTests.swift
//  FloppyFishUnitTests
//
//  Created by Colin Morrison on 13/01/2022.
//

@testable import FloppyFish
import SpriteKit
import XCTest

class GameMenuSpy: GameMenu {
    
    private(set) var addChildCallCount = 0
    private(set) var addChildNodesAdded: [SKNode] = []
    
    override func addChild(_ node: SKNode) {
        
        super.addChild(node)
        
        addChildCallCount += 1
        addChildNodesAdded.append(node)
    }
}

final class GameMenuTests: XCTestCase {
    
    private var gameMenu: GameMenu!
    
    override func setUp() {
        gameMenu = GameMenu()
    }
    
//    func testDidMove_addsThreeChildren_toSelf() {
        
//        XCTAssertEqual(gameMenu.children.count, 3)
        
//        XCTAssert(gameMenu.children[0] is SKShapeNode)
//        XCTAssert(gameMenu.children[1] is SKShapeNode)
//        XCTAssert(gameMenu.children[2] is SKShapeNode)
//        
//        XCTAssertEqual(gameMenu.children[0].name, "mainMenuBackground")
//        XCTAssertEqual(gameMenu.children[1].name, "menuLogo")
//        XCTAssertEqual(gameMenu.children[2].name, "playLabel")
//    }
    
//    func testTouchesBegan_onPlayLabel() {
//
//        let touch = Set<UITouch>()
//        let event = UIEvent()
//
//    }
    
}
