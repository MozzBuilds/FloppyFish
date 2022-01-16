//
//  GameSceneTests.swift
//  FloppyFishUnitTests
//
//  Created by Colin Morrison on 13/01/2022.
//

@testable import FloppyFish
import SpriteKit
import XCTest

final class GameSceneSpy: GameScene {
    
    private(set) var addChildCallCount = 0
    private(set) var addChildNodesAdded: [SKNode] = []
    private(set) var enumerateChildNodesCallCount = 0
    private(set) var enumerateChildNodesCompletion: ((SKNode, UnsafeMutablePointer<ObjCBool>) -> ())?
    
    override func addChild(_ node: SKNode) {
        
        super.addChild(node)
        
        addChildCallCount += 1
        addChildNodesAdded.append(node)
    }
    
    override func enumerateChildNodes(withName name: String, using block: @escaping (SKNode, UnsafeMutablePointer<ObjCBool>) -> Void) {
        
        super.enumerateChildNodes(withName: name, using: block)
        
        enumerateChildNodesCallCount += 1
        enumerateChildNodesCompletion = block
    }
}

final class GameSceneTests: XCTestCase {
    
    private var gameScene: GameScene?
    
    override func setUp() {
        

    }
}
