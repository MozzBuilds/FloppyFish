//
//  MainMenuBackgroundTests.swift
//  FloppyFishUnitTests
//
//  Created by Colin Morrison on 13/01/2022.
//

@testable import FloppyFish
import SpriteKit
import XCTest

class MainMenuBackgroundSpy: MainMenuBackground {
        
    private(set) var renderBackgroundCallCount = 0
    private(set) var renderBackgroundParent: SKScene?
    
    override func renderBackground(parent: SKScene) {
        
        renderBackgroundCallCount += 1
        renderBackgroundParent = parent
    }
}

final class MainMenuBackgroundTests: XCTestCase {
    
    private var delegate: GameMenuSpy!
    private var mainMenuBackgroundSpy: MainMenuBackgroundSpy!
    private var mainMenuBackground: MainMenuBackground!
    
    private var background: SKShapeNode?
    
    override func setUp() {
        
        delegate = GameMenuSpy()
        mainMenuBackgroundSpy = MainMenuBackgroundSpy(delegate: delegate)
        mainMenuBackground = MainMenuBackground(delegate: delegate)
        
        background = mainMenuBackground.background
    }
    
    func testInitialiser_callsRenderBackground_withDelegate() {
        
        XCTAssertEqual(mainMenuBackgroundSpy.renderBackgroundCallCount, 1)
        XCTAssertEqual(mainMenuBackgroundSpy.renderBackgroundParent, delegate)

    }
    
    func testRenderBackground_initialisesShapeNode() {
        
        XCTAssert(try XCTUnwrap(background) .isKind(of: SKShapeNode.self))

    }
    
    func testRenderBackground_setsBackgroundFillTexture_toSomething() {
        
        XCTAssertNotNil(background?.fillTexture)
    }
    
    func testRenderBackground_setsBackgroundProperty_Colors() {
    
        let whiteColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        XCTAssertEqual(background?.fillColor, whiteColor)
    }
    
    func testRenderBackground_setsBackgroundProperty_Positions() throws {
    
        XCTAssertEqual(background?.position, CGPoint(x:0, y:0))
        XCTAssertEqual(background?.zPosition, 0)
    }
    
    func testRenderBackground_setsBackgroundProperty_Name() throws {
        
        XCTAssertEqual(background?.name, "mainMenuBackground")
    }
    
    func testRenderBackground_addsChild_toParent() {
        
        XCTAssertEqual(delegate.addChildCallCount, 1)
        XCTAssertEqual(delegate.addChildNodesAdded, [background])
        XCTAssertEqual(delegate.childNode(withName: "mainMenuBackground"), background)
    }

}
