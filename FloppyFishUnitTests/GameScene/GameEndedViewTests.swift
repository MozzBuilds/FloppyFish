//
//  GameEndedViewTests.swift
//  FloppyFishUnitTests
//
//  Created by Colin Morrison on 13/01/2022.
//

@testable import FloppyFish
import SpriteKit
import XCTest

final class GameEndedViewSpy: GameEndedView {
    
    private(set) var setUpUiCallCount = 0
    private(set) var commonInitialLabelPropertieCallCount = 0
    private(set) var renderGameOverLabeCallCount = 0
    private(set) var renderScoreTextLabelCallCount = 0
    private(set) var renderScoreValueLabelCallCount = 0
    private(set) var renderScoreBackgrounCallCount = 0
    private(set) var renderPlayAgainLabeCallCount = 0
    private(set) var renderPlayAgainBackgroundCallCount = 0
    private(set) var renderMenuLabeCallCount = 0
    private(set) var renderMenuBackgroundCallCount = 0
    
    private(set) var commonFinalBackgroundPropertiesCallCount = 0
    private(set) var commonFinalBackgroundPropertiesBackgrounds: [SKShapeNode] = []
    private(set) var commonFinalBackgroundPropertiesSize: CGSize?
    
    private(set) var renderScoreLabelPositionsCallCount = 0
    private(set) var renderScoreLabelPositionsBackgroundSize: CGSize?
    private(set) var addScoreNotesToDelegateCallCount = 0
    
    override func setUpUI() {
        super.setUpUI()
        setUpUiCallCount += 1
    }
    
    override func commonInitialLabelProperties() {
        commonInitialLabelPropertieCallCount += 1
    }
    
    override func renderGameOverLabel() {
        renderGameOverLabeCallCount += 1
    }
    
    override func renderScoreTextLabels() {
        renderScoreTextLabelCallCount += 1
    }
    
    override func renderScoreValueLabels() {
        renderScoreValueLabelCallCount += 1
    }
    
    override func renderScoreBackground() {
        super.renderScoreBackground()
        
        renderScoreBackgrounCallCount += 1
    }
    
    override func renderPlayAgainLabel() {
        renderPlayAgainLabeCallCount += 1
    }
    
    override func renderPlayAgainBackground() {
        super.renderPlayAgainBackground()
        renderPlayAgainBackgroundCallCount += 1
    }
    
    override func renderMenuLabel() {
        super.renderMenuLabel()
        renderMenuLabeCallCount += 1
    }
    
    override func renderMenuBackground() {
        super.renderMenuBackground()
        renderMenuBackgroundCallCount += 1
    }
    
    override func commonFinalBackgroundProperties(background: SKShapeNode, size: CGSize) {
        commonFinalBackgroundPropertiesCallCount += 1
        commonFinalBackgroundPropertiesBackgrounds.append(background)
        commonFinalBackgroundPropertiesSize = size
    }
    
    override func renderScoreLabelPositions(backgroundSize: CGSize) {
        renderScoreLabelPositionsCallCount += 1
        renderScoreLabelPositionsBackgroundSize = backgroundSize
    }
    
    override func addScoreNodesToDelegate(scoreBackground: SKShapeNode) {
        addScoreNotesToDelegateCallCount += 1
    }
}

final class GameEndedViewTests: XCTestCase {
    
    private var delegate: GameScene!
    private var gameEndedView: GameEndedView!
    private var gameEndedViewSpy: GameEndedViewSpy!
    private var score: Int!
    private var highScore: Int!
    
    override func setUp() {
        
        delegate = GameSceneSpy()
        
        score = 1
        highScore = 2
        
        gameEndedView = GameEndedView(delegate: delegate, score: score, highScore: highScore)
        gameEndedViewSpy = GameEndedViewSpy(delegate: delegate, score: score, highScore: highScore)

    }
    
    //MARK: - Initialiser
    
    func testInitialiser_setsInjectedProperties() {
        
        XCTAssertEqual(gameEndedView.delegate, delegate)
        XCTAssertEqual(gameEndedView.score, score)
        XCTAssertEqual(gameEndedView.highScore, highScore)
    }
    
    func testInitialiser_setsMaxHeight_andWidth_properties() {
        
        let expectMaxHeight = delegate.size.height * 0.5
        let expectMaxWidth = delegate.size.width * 0.5
        
        XCTAssertEqual(gameEndedView.maxHeight, expectMaxHeight)
        XCTAssertEqual(gameEndedView.maxWidth, expectMaxWidth)
    }
    
    func testInitialiser_initiatesAllLabelNodes() {
        
        XCTAssertNotNil(gameEndedView.gameOverLabel)
        XCTAssertNotNil(gameEndedView.scoreLabelText)
        XCTAssertNotNil(gameEndedView.highScoreLabelText)
        XCTAssertNotNil(gameEndedView.scoreLabelValue)
        XCTAssertNotNil(gameEndedView.highScoreLabelValue)
        XCTAssertNotNil(gameEndedView.playAgainLabel)
        XCTAssertNotNil(gameEndedView.menuLabel)
        XCTAssertNotNil(gameEndedView.labels)
    }
    
    func testInitialiser_initiatesLabelsArray() {
        
        let expectLabels = [gameEndedView.gameOverLabel,
                      gameEndedView.scoreLabelText,
                      gameEndedView.highScoreLabelText,
                      gameEndedView.playAgainLabel,
                      gameEndedView.menuLabel]
        
        XCTAssertEqual(gameEndedView.labels, expectLabels)
    }
    
    func testInitialiser_callsSetUpUI() {
                    
        XCTAssertEqual(gameEndedViewSpy.setUpUiCallCount, 1)
    }
    
    func testSetUpUI_callsManyMethods() {
        
        XCTAssertEqual(gameEndedViewSpy.commonInitialLabelPropertieCallCount, 1)
        XCTAssertEqual(gameEndedViewSpy.renderGameOverLabeCallCount, 1)
        XCTAssertEqual(gameEndedViewSpy.renderScoreTextLabelCallCount, 1)
        XCTAssertEqual(gameEndedViewSpy.renderScoreValueLabelCallCount, 1)
        XCTAssertEqual(gameEndedViewSpy.renderScoreBackgrounCallCount, 1)
        XCTAssertEqual(gameEndedViewSpy.renderPlayAgainLabeCallCount, 1)
        XCTAssertEqual(gameEndedViewSpy.renderPlayAgainBackgroundCallCount, 1)
        XCTAssertEqual(gameEndedViewSpy.renderMenuLabeCallCount, 1)
        XCTAssertEqual(gameEndedViewSpy.renderMenuBackgroundCallCount, 1)
    }
    
    //MARK: - Render Labels
    
    func testRenderGameOverLabel_setsProperties_ofGameOverLabel_andAddsSelfToDelegateChildren() {
        
        let label = gameEndedView.gameOverLabel
        let expectY = gameEndedView.maxHeight * 0.4
        let accuracy = CGFloat(0.01)
        
        XCTAssertEqual(label.name, "gameOverLabel")
        XCTAssertEqual(label.position.x, 0)
        XCTAssertEqual(label.position.y, expectY, accuracy: accuracy)
        XCTAssertEqual(label.attributedText?.string, "GAME OVER")
        XCTAssertNotNil(delegate.childNode(withName:"gameOverLabel"))
    }
    
    func testRenderScoreTextLabels_setsProperties_ofScoreLabel() {
        
        let label = gameEndedView.scoreLabelText
        
        XCTAssertEqual(label.name, "gameOverScoreLabel")
        XCTAssertEqual(label.fontSize, CGFloat(45))
        XCTAssertEqual(label.attributedText?.string, "Your Score")
    }
    
    func testRenderScoreTextLabels_setsProperties_ofHighScoreLabel() {
        
        let label = gameEndedView.highScoreLabelText
        
        XCTAssertEqual(label.name, "gameOverHighScoreLabel")
        XCTAssertEqual(label.attributedText?.string, "High Score")
    }
    
    func testRenderScoreValueLabels_setsProperties_ofScoreLabelValue() {
        
        let label = gameEndedView.scoreLabelValue
        let expectString = String(gameEndedView.score)
        
        XCTAssertEqual(label.name, "gameOverScoreLabelValue")
        XCTAssertEqual(label.attributedText?.string, expectString)
    }
    
    func testRenderScoreValueLabels_setsProperties_ofHighScoreLabelValue() {
        
        let label = gameEndedView.highScoreLabelValue
        let expectString = String(gameEndedView.highScore)
        
        XCTAssertEqual(label.name, "gameOverHighScoreLabelValue")
        XCTAssertEqual(label.attributedText?.string, expectString)
    }
    
    func testRenderPlayAgainLabel_setsProperties_ofPlayAgainLabel() {
        
        let label = gameEndedView.playAgainLabel
        
        XCTAssertEqual(label.name, "playAgainLabel")
        XCTAssertEqual(label.attributedText?.string, ">")
    }
    
    func testRenderMenuLabel_setsProperties_ofMenuLabel() {
        
        let label = gameEndedView.menuLabel
        
        XCTAssertEqual(label.name, "gameOverMenuLabel")
        XCTAssertEqual(label.attributedText?.string, "<")
    }
    
    //MARK: - Render Score Label Background
    
    func testRenderScoreBackground_initialisesScoreBackgroundObject_andSetsProperties() throws {
        
        let node = try XCTUnwrap(gameEndedView.scoreBackground)
        let accuracy = CGFloat(0.01)
        
        XCTAssertEqual(node.name, "scoreGameOverBackground")
        XCTAssertEqual(node.alpha, 0.9, accuracy: accuracy)
        XCTAssertNotNil(node.strokeColor)

    }
    
    func testRenderScoreBackground_callsSubsequentMethods() throws {
        
        let node = try XCTUnwrap(gameEndedViewSpy.scoreBackground)
        
        XCTAssertEqual(gameEndedViewSpy.commonFinalBackgroundPropertiesCallCount, 3)
        XCTAssertEqual(gameEndedViewSpy.commonFinalBackgroundPropertiesBackgrounds[0], node)
        XCTAssertNotNil(gameEndedViewSpy.commonFinalBackgroundPropertiesSize)

        XCTAssertEqual(gameEndedViewSpy.renderScoreLabelPositionsCallCount, 1)
        XCTAssertNotNil(gameEndedViewSpy.renderScoreLabelPositionsBackgroundSize)

        XCTAssertEqual(gameEndedViewSpy.addScoreNotesToDelegateCallCount, 1)
    }
    
    func testrenderScoreLabelPositions_setsAllScoreLabelYPositions() {
        
        let size = CGSize(width: 0.1, height: 0.1)
        let accuracy = CGFloat(0.01)
        
        gameEndedView.renderScoreLabelPositions(backgroundSize: size)
        
        let scoreText = gameEndedView.scoreLabelText
        let scoreValue = gameEndedView.scoreLabelValue
        let highScoreText = gameEndedView.highScoreLabelText
        let highScoreValue = gameEndedView.highScoreLabelValue
        
        let expectScoreTextY = (size.height * 0.5) - scoreText.fontSize
        let expectScoreValueY = expectScoreTextY - (scoreText.fontSize * 2)
        let expectHighScoreTextY = expectScoreValueY - (scoreText.fontSize * 1.5)
        let expectHighScoreValueY = expectHighScoreTextY - (scoreText.fontSize * 2)
        
        XCTAssertEqual(scoreText.position.y, expectScoreTextY, accuracy: accuracy)
        XCTAssertEqual(scoreValue.position.y, expectScoreValueY, accuracy: accuracy)
        XCTAssertEqual(highScoreText.position.y, expectHighScoreTextY, accuracy: accuracy)
        XCTAssertEqual(highScoreValue.position.y, expectHighScoreValueY, accuracy: accuracy)
    }
    
    func testAddScoreNodesToDelegate_addsScoreNodesToScoreBackground() {
        
        let node = gameEndedView.scoreBackground
        
        XCTAssertNotNil(node?.childNode(withName:"gameOverScoreLabel"))
        XCTAssertNotNil(node?.childNode(withName:"gameOverScoreLabelValue"))
        XCTAssertNotNil(node?.childNode(withName:"gameOverHighScoreLabel"))
        XCTAssertNotNil(node?.childNode(withName:"gameOverHighScoreLabelValue"))

    }
    
    func testAddScoreNodesToDelegate_addsBackgroundToDelegate() {
        
        XCTAssertNotNil(delegate.childNode(withName:"scoreGameOverBackground"))
    }
    
    //MARK: - Render Play Again Background
    
    func testRenderPlayAgainbackground_rendersObject_andSetsProperties () throws {
        
        let node = gameEndedViewSpy.playAgainBackground
        let expectX = gameEndedViewSpy.maxWidth * 0.5
        let expectY = -(gameEndedViewSpy.maxHeight * 0.5)
        let accuracy = CGFloat(0.01)


        XCTAssertEqual(node?.name, "playAgainBackground")
        XCTAssertEqual(node?.position.x, expectX)
        XCTAssertEqual(node?.position.y, expectY)
        XCTAssertNotNil(node?.fillColor)
        XCTAssertEqual(try XCTUnwrap(node?.alpha), 0.8, accuracy: accuracy)

    }
    
    func testRenderPlayAgainbackground_callsHelperMethods () {
        
        let node = gameEndedViewSpy.playAgainBackground
        
        XCTAssertEqual(gameEndedViewSpy.commonFinalBackgroundPropertiesCallCount, 3) ///Called elsewhere beforehand
        XCTAssertEqual(gameEndedViewSpy.commonFinalBackgroundPropertiesBackgrounds[1], node)
        XCTAssertNotNil(gameEndedViewSpy.commonFinalBackgroundPropertiesSize)

    }
    
    func testRenderPlayAgainbackground_addsNodesToSelf_andToDelegate () {
        
        XCTAssertNotNil(gameEndedView.playAgainBackground?.childNode(withName:"playAgainLabel"))

        XCTAssertNotNil(delegate.childNode(withName:"playAgainBackground"))
    }
    
    //MARK: - Render Menu Background
    
    func testRenderMenubackground_rendersObject_andSetsProperties () throws {
        
        let node = gameEndedViewSpy.menuBackground
        let expectX = -(gameEndedViewSpy.maxWidth * 0.5)
        let expectY = -(gameEndedViewSpy.maxHeight * 0.5)
        let accuracy = CGFloat(0.01)


        XCTAssertEqual(node?.name, "gameOverMenuBackground")
        XCTAssertEqual(node?.position.x, expectX)
        XCTAssertEqual(node?.position.y, expectY)
        XCTAssertNotNil(node?.fillColor)
        XCTAssertEqual(try XCTUnwrap(node?.alpha), 0.8, accuracy: accuracy)

    }
    
    func testRenderMenubackground_callsHelperMethods () {
        
        let node = gameEndedViewSpy.menuBackground
        
        XCTAssertEqual(gameEndedViewSpy.commonFinalBackgroundPropertiesCallCount, 3)
        XCTAssertEqual(gameEndedViewSpy.commonFinalBackgroundPropertiesBackgrounds[2], node)
        XCTAssertNotNil(gameEndedViewSpy.commonFinalBackgroundPropertiesSize)

    }
    
    func testRenderMenubackground_addsNodesToSelf_andToDelegate () {
        
        XCTAssertNotNil(gameEndedView.menuBackground?.childNode(withName:"gameOverMenuLabel"))

        XCTAssertNotNil(delegate.childNode(withName:"gameOverMenuBackground"))
    }
    
    //MARK: - Helper Functions
    
    func testCommonInitialLabelProperties_setsZPosition_andAlignments_forAllLabels() {
        
        let labels = gameEndedView.labels
        
        labels.forEach {
            XCTAssertEqual($0.zPosition, 125)
            XCTAssertEqual($0.verticalAlignmentMode, .center)
            XCTAssertEqual($0.horizontalAlignmentMode, .center)
        }
    }
    
    func testCommonFinalBackgroundProperties_setsProperties_forGivenShapeNode_andSize() {
        
        let size = CGSize(width: 0.1, height: 0.1)
        let node = SKShapeNode()
        
        gameEndedView.commonFinalBackgroundProperties(background: node, size: size)
        
        XCTAssertEqual(node.zPosition, 115)
        XCTAssertEqual(node.lineWidth, 3)
        XCTAssertNotNil(node.strokeColor)
        XCTAssertEqual(node.glowWidth, 2)
    }
}
