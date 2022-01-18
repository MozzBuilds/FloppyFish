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
    
}
