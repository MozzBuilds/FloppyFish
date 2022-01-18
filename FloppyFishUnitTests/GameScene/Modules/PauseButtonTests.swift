//
//  PauseButtonTests.swift
//  FloppyFishUnitTests
//
//  Created by Colin Morrison on 13/01/2022.
//

@testable import FloppyFish
import SpriteKit
import XCTest

final class PauseButtonSpy: PauseButton {
    
    private(set) var renderPauseLogoBackgroundCallCount = 0
    private(set) var renderPauseLogoBackgroundParent: SKScene?
    
    private(set) var renderPauseLogoCallCount = 0
    private(set) var renderPauseLogoParent: SKShapeNode?
        
    override func renderPauseLogoBackground(parent: SKScene) {
        super.renderPauseLogoBackground(parent: parent)
        renderPauseLogoBackgroundCallCount += 1
        renderPauseLogoBackgroundParent = parent
    }
    
    override func renderPauseLogo(parent: SKShapeNode) {
        super.renderPauseLogo(parent: parent)
        renderPauseLogoCallCount += 1
        renderPauseLogoParent = parent
    }
}

final class PauseButtonTests: XCTestCase {
    
    private var delegate: GameSceneSpy!
    private var pauseButton: PauseButton!
    private var pauseButtonSpy: PauseButtonSpy!
    
    private var pauseLogo: SKShapeNode?
    private var pauseLogoBackground: SKShapeNode?
    
    override func setUp() {
        
        delegate = GameSceneSpy()
        pauseButton = PauseButton(delegate: delegate)

        pauseLogo = pauseButton.pauseLogo
        pauseLogoBackground = pauseButton.pauseLogoBackground
    }
    
    func testInitialiser_callsRenderLogoBackground() {
        
        pauseButtonSpy = PauseButtonSpy(delegate: delegate)
        
        XCTAssertEqual(pauseButtonSpy.renderPauseLogoBackgroundCallCount, 1)
        XCTAssertEqual(pauseButtonSpy.renderPauseLogoBackgroundParent, delegate)
    }
    
    func testRenderLogoBackground_createsShapeNode() throws {
        
        XCTAssert(try XCTUnwrap(pauseLogoBackground) .isKind(of: SKShapeNode.self))
    }
    
    func testRenderLogoBackground_setsLogoBackgroundProperty_Size() throws {
        
        let actualWidth = try XCTUnwrap(pauseLogoBackground?.frame.size.width)
        let actualHeight = try XCTUnwrap(pauseLogoBackground?.frame.size.height)
        let accuracy = CGFloat(5)
        
        XCTAssertEqual(actualWidth, 90, accuracy: accuracy)
        XCTAssertEqual(actualHeight, 70, accuracy: accuracy)
    }
    
    func testRenderLogoBackground_setsLogoBackgroundProperty_Colors() throws {
    
        let expectedAlpha = CGFloat(try XCTUnwrap(pauseLogoBackground?.alpha))
        let whiteColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        let accuracy = CGFloat(0.01)
        
        XCTAssertEqual(pauseLogoBackground?.fillColor, whiteColor)
        XCTAssertEqual(expectedAlpha, 0.6, accuracy: accuracy)
    }
    
    func testRenderLogoBackground_setsLogoBackgroundProperty_Positions() throws {
        
        let actualX = CGFloat(try XCTUnwrap(pauseLogoBackground?.position.x))
        let actualY = CGFloat(try XCTUnwrap(pauseLogoBackground?.position.y))
        let expectedX = delegate.size.width * 0.3
        let expectedY = delegate.size.height * 0.4
        let accuracy = CGFloat(0.01)

        XCTAssertEqual(actualX, expectedX, accuracy: accuracy)
        XCTAssertEqual(actualY, expectedY, accuracy: accuracy)
        XCTAssertEqual(pauseLogoBackground?.zPosition, 35)
    }
    
    func testRenderLogoBackground_setsBackgroundProperty_Name() throws {
        
        XCTAssertEqual(pauseLogoBackground?.name, "pauseLogoBackground")
    }
        
    func testRenderLogoBackground_callsRenderLabel_withSelfAsParentArgument() {
        
        pauseButtonSpy = PauseButtonSpy(delegate: delegate)

        XCTAssertEqual(pauseButtonSpy.renderPauseLogoCallCount, 1)
        XCTAssertEqual(pauseButtonSpy.renderPauseLogoParent, pauseButtonSpy.pauseLogoBackground.self)
    }
    
    func testRenderLogoBackground_addsChildToDelegate() {
        
        XCTAssertEqual(delegate.addChildCallCount, 1)
        XCTAssertEqual(delegate.addChildNodesAdded, [pauseLogoBackground])
        XCTAssertEqual(delegate.childNode(withName: "pauseLogoBackground"), pauseLogoBackground)
    }
    
    func testRenderPauseBackground_initialisesPauseLogo() {
        XCTAssert(try XCTUnwrap(pauseButton.pauseLogo) .isKind(of: SKShapeNode.self))
    }
    
    func testRenderPauseLogo_setsLogoPositions() throws {
        
        XCTAssertEqual(pauseLogo?.zPosition, 50)
        XCTAssertEqual(pauseLogo?.position.x, 0)
        XCTAssertEqual(pauseLogo?.position.y, 0)
    }
    
    func testRenderPauseLogo_setsLogoName() {
        
        XCTAssertEqual(pauseLogo?.name, "pauseLogo")
    }
    
    func testRenderPauseLogo_setsLogoColours() {
        
        let whiteColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        let clearColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)

        
        XCTAssertEqual(pauseLogo?.fillColor, whiteColor)
        XCTAssertEqual(pauseLogo?.strokeColor, clearColor)
        XCTAssertNotNil(pauseLogo?.fillTexture)
    }
    
    func testRenderPauseLabel_addsChild_toParent() {
        
        XCTAssertEqual(pauseLogo?.parent?.childNode(withName: "pauseLogo"), pauseLogo)
    }
    
    func testHide_hidesPauseBackground_andPauseLabel() throws {
                
        pauseButton.hide()
        let check = try XCTUnwrap(delegate.childNode(withName: "pauseLogoBackground")?.isHidden)
        
        XCTAssertTrue(check)
    }
    
    func testHid_showsPauseBackground_andPauseLabel() throws {
        
        pauseButton.show()
        let check = try XCTUnwrap(delegate.childNode(withName: "pauseLogoBackground")?.isHidden)
        
        XCTAssertFalse(check)
    }
}
