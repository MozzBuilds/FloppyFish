//
//  ScoreHandlerTests.swift
//  FloppyFishUnitTests
//
//  Created by Colin Morrison on 13/01/2022.
//

@testable import FloppyFish
import SpriteKit
import XCTest

final class ScoreHandlerSpy: ScoreHandler {
    
    private(set) var renderScoreBackgroundCallCount = 0
    private(set) var renderScoreBackgroundParent: SKScene?
    
    private(set) var renderScoreLabelCallCount = 0
    private(set) var renderScoreLabelParent: SKShapeNode?
        
    override func renderScoreBackground(parent: SKScene) {
        
        super.renderScoreBackground(parent: parent)

        renderScoreBackgroundCallCount += 1
        renderScoreBackgroundParent = parent
    }
    
    override func renderScoreLabel(parent: SKShapeNode) {
        
        super.renderScoreLabel(parent: parent)
        
        renderScoreLabelCallCount += 1
        renderScoreLabelParent = parent
    }
}

final class ScoreHandlerTests: XCTestCase {
    
    private var delegate: GameSceneSpy!
    private var scoreHandler: ScoreHandler!
    private var scoreHandlerSpy: ScoreHandlerSpy!
    
    private var scoreLabel: SKLabelNode?
    private var scoreBackground: SKShapeNode?
    
    override func setUp() {
        delegate = GameSceneSpy()
        scoreHandler = ScoreHandler(delegate: delegate)

        scoreLabel = scoreHandler.scoreLabel
        scoreBackground = scoreHandler.scoreBackground

    }
    
    func testInitialPropertiesSet() {
        XCTAssertEqual(scoreHandler.score, 0)
        XCTAssertEqual(scoreHandler.highScore, UserDefaults.standard.integer(forKey: "highScore"))
    }
    
    func testRenderBackground_createsShapeNode() throws {
        
        XCTAssert(try XCTUnwrap(scoreBackground) .isKind(of: SKShapeNode.self))
    }
    
    func testRenderBackground_setsBackgroundProperty_Size() throws {
        
        let actualWidth = try XCTUnwrap(scoreBackground?.frame.size.width)
        let actualHeight = try XCTUnwrap(scoreBackground?.frame.size.height)
        let accuracy = CGFloat(5)
        
        XCTAssertEqual(actualWidth, 120, accuracy: accuracy)
        XCTAssertEqual(actualHeight, 70, accuracy: accuracy)
    }
    
    func testRenderBackground_setsBackgroundProperty_Colors() throws {
    
        let expectedAlpha = CGFloat(try XCTUnwrap(scoreBackground?.alpha))
        let whiteColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        let accuracy = CGFloat(0.01)
        
        XCTAssertEqual(scoreBackground?.fillColor, whiteColor)
        XCTAssertEqual(expectedAlpha, 0.6, accuracy: accuracy)
    }
    
    func testRenderBackground_setsBackgroundProperty_Positions() throws {
        
        let actualX = CGFloat(try XCTUnwrap(scoreBackground?.position.x))
        let actualY = CGFloat(try XCTUnwrap(scoreBackground?.position.y))
        let expectedX = -delegate.size.width * 0.3
        let expectedY = delegate.size.height * 0.4
        let accuracy = CGFloat(0.01)

        XCTAssertEqual(actualX, expectedX, accuracy: accuracy)
        XCTAssertEqual(actualY, expectedY, accuracy: accuracy)
        XCTAssertEqual(scoreBackground?.zPosition, 35)
    }
    
    func testRenderBackground_setsBackgroundProperty_Name() throws {
        
        XCTAssertEqual(scoreBackground?.name, "scoreBackground")
    }
        
    func testRenderBackground_callsRenderLabel_withSelfAsParentArgument() {
        
        scoreHandlerSpy = ScoreHandlerSpy(delegate: delegate)

        XCTAssertEqual(scoreHandlerSpy.renderScoreLabelCallCount, 1)
        XCTAssertEqual(scoreHandlerSpy.renderScoreLabelParent, scoreHandlerSpy.scoreBackground.self)
    }
    
    func testRenderBackground_addsChildToDelegate() {
        
        XCTAssertEqual(delegate.addChildCallCount, 1)
        XCTAssertEqual(delegate.addChildNodesAdded, [scoreBackground])
        XCTAssertEqual(delegate.childNode(withName: "scoreBackground"), scoreBackground)
    }
    
    func testRenderScoreLabel_initialisesScoreLabel() {
        XCTAssert(try XCTUnwrap(scoreHandler.scoreLabel) .isKind(of: SKLabelNode.self))
    }
    
    func testRenderScoreLabel_setsLabelPositions() {
        XCTAssertEqual(scoreLabel?.zPosition, 50)
        XCTAssertEqual(scoreLabel?.horizontalAlignmentMode, .center)
        XCTAssertEqual(scoreLabel?.verticalAlignmentMode, .center)
    }
    
    func testRenderScoreLabel_setsLabelName() {
        XCTAssertEqual(scoreLabel?.name, "scoreLabel")
    }
    
    func testRenderScoreLabel_setsText_andTextProperties() {
        XCTAssertEqual(scoreLabel?.fontName, "Arial-BoldMT")
        XCTAssertEqual(scoreLabel?.fontSize, 60)
        XCTAssertNotEqual(scoreLabel?.fontColor, .clear)
        XCTAssertEqual(scoreLabel?.text, String(0))
    }
    
    func testRenderScoreLabel_addsChild_toParent() {
        XCTAssertEqual(scoreLabel?.parent?.childNode(withName: "scoreLabel"), scoreLabel)
    }
    
    func testUpdateScore_addsOneToScore_andScoreLabelText() {
        scoreHandler.updateScore()
        
        XCTAssertEqual(scoreHandler.score, 1)
        XCTAssertEqual(scoreHandler.scoreLabel?.text, "1")
    }
    
    func testCheckHighScore_updatesHighscore_ifScoreIsGreater() {
        UserDefaults.standard.set(1, forKey: "highScore")
        scoreHandler = ScoreHandler(delegate: delegate)
        XCTAssertEqual(scoreHandler.highScore, 1)
        
        scoreHandler.updateScore()
        scoreHandler.updateScore()
        XCTAssertEqual(scoreHandler.score, 2)

        scoreHandler.checkHighScore()
        XCTAssertEqual(scoreHandler.highScore, 2)
    }
    
    func testCheckHighScore_doesNotUpdateHighSccore_ifScoreIsLower() {
        UserDefaults.standard.set(2, forKey: "highScore")
        scoreHandler = ScoreHandler(delegate: delegate)
        XCTAssertEqual(scoreHandler.highScore, 2)
        
        scoreHandler.updateScore()
        XCTAssertEqual(scoreHandler.score, 1)

        scoreHandler.checkHighScore()
        XCTAssertEqual(scoreHandler.highScore, 2)
    }
    
}
