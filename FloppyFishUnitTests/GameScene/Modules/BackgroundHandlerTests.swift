//
//  BackgroundHandlerTests.swift
//  FloppyFishUnitTests
//
//  Created by Colin Morrison on 13/01/2022.
//

@testable import FloppyFish
import SpriteKit
import XCTest

final class BackgroundHandlerTests: XCTestCase {
    
    private var delegate: GameSceneSpy!
    private var backgroundHandler: BackgroundHandler!
    
    override func setUp() {
        delegate = GameSceneSpy()
        backgroundHandler = BackgroundHandler(delegate: delegate)
    }
    
    func testRenderBackground_addsThreeSpriteNodesToParent() throws {
        
        backgroundHandler.renderBackground()
        let background1 = delegate.addChildNodesAdded[0]
        let background2 = delegate.addChildNodesAdded[1]
        let background3 = delegate.addChildNodesAdded[2]

        XCTAssertNotNil(background1)
        XCTAssertEqual(background1.name, "background")
        XCTAssert(try XCTUnwrap(background1) .isKind(of: SKSpriteNode.self))
        
        XCTAssertNotNil(background2)
        XCTAssertEqual(background1.name, "background")
        XCTAssert(try XCTUnwrap(background2) .isKind(of: SKSpriteNode.self))
        
        XCTAssertNotNil(background3)
        XCTAssertEqual(background1.name, "background")
        XCTAssert(try XCTUnwrap(background3) .isKind(of: SKSpriteNode.self))
    }
    
    func testRenderBackground_setsSizeProperties() throws {
        
        backgroundHandler.renderBackground()
        let background = try XCTUnwrap(delegate.childNode(withName:"background"))
        
        XCTAssertEqual(background.frame.size.width, delegate.size.width)
        XCTAssertEqual(background.frame.size.height, delegate.size.height)
    }
    
    func testRenderBackground_setsPositionProperties_ofAllBackgrounds() throws {
        
        backgroundHandler.renderBackground()
        let background1 = delegate.addChildNodesAdded[0]
        let background2 = delegate.addChildNodesAdded[1]
        let background3 = delegate.addChildNodesAdded[2]
        
        XCTAssertEqual(background1.position.y, 0)
        XCTAssertEqual(background1.zPosition, 0)
        XCTAssertEqual(background1.position.x, 0)
        XCTAssertEqual(background2.position.x, background2.frame.size.width)
        XCTAssertEqual(background3.position.x, background3.frame.size.width * 2)
    }
    
    func testMoveBackground_callsDelegateEnumerate_withCompletion() {
        
        backgroundHandler.moveBackground()
        
        XCTAssertEqual(delegate.enumerateChildNodesCallCount, 1)
        XCTAssertNotNil(delegate.enumerateChildNodesCompletion)
    }
    
    func testMoveBackground_completion_movesBackgroundToFurthestPosition_whenXLessThanDelegateWidth() throws {
        
        backgroundHandler.renderBackground()
        let background1 = delegate.addChildNodesAdded[0]
        let expectX = background1.position.x - 2 + (delegate.size.width * 3)
        
        backgroundHandler.moveBackground()
                
        XCTAssertEqual(background1.position.x, expectX)
    }
    
    func testMoveBackground_completion_changesBackgroundXPosition_byMinus2_whenXIsNotLessThanDelegateWidth() throws {
        
        backgroundHandler.renderBackground()
        let background1InitialX = delegate.addChildNodesAdded[0].position.x
        let background2InitialX = delegate.addChildNodesAdded[1].position.x
        let background3InitialX = delegate.addChildNodesAdded[2].position.x
        
        backgroundHandler.moveBackground()
        let background1FinalX = delegate.addChildNodesAdded[0].position.x
        let background2FinalX = delegate.addChildNodesAdded[1].position.x
        let background3FinalX = delegate.addChildNodesAdded[2].position.x
                
        XCTAssertNotEqual(background1FinalX, background1InitialX - 2)
        XCTAssertEqual(background2FinalX, background2InitialX - 2)
        XCTAssertEqual(background3FinalX, background3InitialX - 2)

    }
    

}
