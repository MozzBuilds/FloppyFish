//
//  MainMenuPlayButtonTests.swift
//  FloppyFishTests
//
//  Created by Colin Morrison on 13/01/2022.
//

@testable import FloppyFish
import SpriteKit
import XCTest

class MainMenuPlayButtonSpy: MainMenuPlayButton {
    
    private(set) var renderBackgroundCallCount = 0
    private(set) var renderBackgroundParent: SKScene?
    
    private(set) var renderLabelCallCount = 0
    private(set) var renderLabelParent: SKShapeNode?
        
    override func renderBackground(parent: SKScene) {
        super.renderBackground(parent: parent)
        renderBackgroundCallCount += 1
        renderBackgroundParent = parent
    }
    
    override func renderLabel(parent: SKShapeNode) {
        super.renderLabel(parent: parent)
        renderLabelCallCount += 1
        renderLabelParent = parent
    }
}

final class MainMenuPlayButtonTests: XCTestCase {
    
    private var mainMenuSceneSpy: GameMenuSpy!
    private var playButton: MainMenuPlayButton!
    private var playButtonSpy: MainMenuPlayButtonSpy!
    
    private var playBackground: SKShapeNode?
    private var playLabel: SKLabelNode?
    
    override func setUp() {
        
        mainMenuSceneSpy = GameMenuSpy()
        playButton = MainMenuPlayButton(delegate: mainMenuSceneSpy)
        
        playBackground = playButton.playBackground
        playLabel = playButton.playLabel
    }
    
    func testInitialiser_callsRenderBackground_withDelegate() {
        
        playButtonSpy = MainMenuPlayButtonSpy(delegate: mainMenuSceneSpy)

        XCTAssertEqual(playButtonSpy.renderBackgroundCallCount, 1, "Method should be called once")
        XCTAssertEqual(playButtonSpy.renderBackgroundParent, mainMenuSceneSpy, "SKScenes should be equal")
    }
    
    func testRenderBackground_createsShapeNode() throws {
        
        XCTAssert(try XCTUnwrap(playBackground) .isKind(of: SKShapeNode.self))
    }
    
    func testRenderBackground_setsBackgroundProperty_Size() throws {
        
        let expectedWidth = CGFloat(mainMenuSceneSpy.frame.size.width * 0.5)
        let expectedHeight = mainMenuSceneSpy.frame.size.height * 0.1
        let actualWidth = try XCTUnwrap(playBackground?.frame.size.width)
        let actualHeight = try XCTUnwrap(playBackground?.frame.size.height)
        let accuracy = CGFloat(0.01)
        
        XCTAssertEqual(actualWidth, expectedWidth, accuracy: accuracy)
        XCTAssertEqual(actualHeight, expectedHeight, accuracy: accuracy)
    }
    
    func testRenderBackground_setsBackgroundProperty_Colors() throws {
    
        let clearColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        
        XCTAssertEqual(playBackground?.fillColor, clearColor)
        XCTAssertEqual(playBackground?.strokeColor, clearColor)
    }
    
    func testRenderBackground_setsBackgroundProperty_Positions() throws {
    
        XCTAssertEqual(playBackground?.position, CGPoint(x:0, y:0))
        XCTAssertEqual(playBackground?.zPosition, 5)
    }
    
    func testRenderBackground_setsBackgroundProperty_Name() throws {
        
        XCTAssertEqual(playBackground?.name, "playBackground")
    }
        
    func testRenderBackground_callsRenderLabel_withSelfAsParent() {
        
        playButtonSpy = MainMenuPlayButtonSpy(delegate: mainMenuSceneSpy)

        XCTAssertEqual(playButtonSpy.renderLabelCallCount, 1)
        XCTAssertEqual(playButtonSpy.renderLabelParent, playButtonSpy.playBackground.self)
    }
    
    func testRenderBackground_addsChildToDelegate() {
        
        XCTAssertEqual(mainMenuSceneSpy.addChildCallCount, 1)
        XCTAssertEqual(mainMenuSceneSpy.addChildNodesAdded, [playBackground])
        XCTAssertEqual(mainMenuSceneSpy.childNode(withName: "playBackground"), playBackground)
    }
    
    func testRenderLabel_createsLabelNode() {
        
        XCTAssert(try XCTUnwrap(playLabel) .isKind(of: SKLabelNode.self))
    }
    
    func testRenderLabel_setsLabelName() {
                
        XCTAssertEqual(playLabel?.name, "playLabel")
    }
    
    func testRenderLabel_setsLabelPositions() {
                
        XCTAssertEqual(playLabel?.zPosition, 10)
        XCTAssertEqual(playLabel?.horizontalAlignmentMode, .center)
        XCTAssertEqual(playLabel?.verticalAlignmentMode, .center)
    }
    
    func testRenderLabel_setsLabelAttributedText() {
                
        XCTAssertEqual(playLabel?.attributedText?.string, "Play")
    }

    func testRenderLabel_addsChildToDelegate() {

        XCTAssertEqual(playBackground?.children.first, playLabel)
    }
    
    //Untested:
        //playLabel attributed text properties including font, size, color, shadows
}
