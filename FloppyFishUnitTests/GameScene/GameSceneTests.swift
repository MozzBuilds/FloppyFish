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
    
    //MARK: - Properties
    
    private(set) var addChildCallCount = 0
    private(set) var addChildNodesAdded: [SKNode] = []
    private(set) var enumerateChildNodesCallCount = 0
    private(set) var enumerateChildNodesCompletion: ((SKNode, UnsafeMutablePointer<ObjCBool>) -> ())?
    private(set) var setUpSceneCallCount = 0
    private(set) var setUpBackgroundCallCount = 0
    private(set) var setUpPauseButtonCallCount = 0
    private(set) var setUpScoreHandlerCallCount = 0
    private(set) var setUpWorldCallCount = 0
    private(set) var setUpTravellerCallCount = 0
    private(set) var setUpTimersCallCount = 0
    private(set) var showGameplayNodesCallCount = 0
    
    //MARK: - Inherited Methods
    
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
    
    //MARK: - GameScene Methods
    
    override func setUpScene() {
        
        super.setUpScene()
        
        setUpSceneCallCount += 1
    }
    
    override func setUpBackground() {
        setUpBackgroundCallCount += 1
    }
    
    override func setUpPauseButton() {
        setUpPauseButtonCallCount += 1
    }
    
    override func setUpScoreHandler() {
        setUpScoreHandlerCallCount += 1
    }
    
    override func setUpWorld() {
        setUpWorldCallCount += 1
    }
    
    override func setUpTraveller() {
        
        super.setUpTraveller()
        
        setUpTravellerCallCount += 1
    }
    
    override func setUpTimers() {
        setUpTimersCallCount += 1
    }
    
    override func showGameplayNodes() {
        showGameplayNodesCallCount += 1
    }
}

final class GameSceneTests: XCTestCase {
    
    private var gameScene: GameScene!
    private var gameSceneSpy: GameSceneSpy!
    
    override func setUp() {
        
        let view = SKView()
        
        gameScene = GameScene()
        gameScene?.didMove(to: view)
        
        gameSceneSpy = GameSceneSpy()
        gameSceneSpy?.didMove(to: view)
    }
    
    //MARK: - Initialiser
    
    func testInitialiser_initiatesHelpers() {
        
        XCTAssertNotNil(gameScene?.obstacleCreator)
        XCTAssertNotNil(gameScene?.worldPhysics)
        XCTAssertNotNil(gameScene?.travellerCreator)
    }
    
    func testInitialiser_setsScaleMode() {
        
        XCTAssertEqual(gameScene?.scaleMode, .resizeFill)
    }
    
    func testInitialiser_callsSetUpScene() {
            
        XCTAssertEqual(gameSceneSpy.setUpSceneCallCount, 1)
    }
    
    //MARK: - SetUps
    func testSetUpScene_callsManyMethods() {
        
        XCTAssertEqual(gameSceneSpy.setUpBackgroundCallCount, 1)
        XCTAssertEqual(gameSceneSpy.setUpPauseButtonCallCount, 1)
        XCTAssertEqual(gameSceneSpy.setUpScoreHandlerCallCount, 1)
        XCTAssertEqual(gameSceneSpy.setUpWorldCallCount, 1)
        XCTAssertEqual(gameSceneSpy.setUpTravellerCallCount, 1)
        XCTAssertEqual(gameSceneSpy.setUpTimersCallCount, 1)
    }
    
    func testSetUpBackground_setsUpBackgroundObject() {
        
        XCTAssertNotNil(gameScene?.backgroundHandler)
        XCTAssertNotNil(gameScene?.childNode(withName:"background"))
    }
    
    func testSetUpPauseButton_setsUpPauseButtonObject_hiddenByDefault() throws {
        
        XCTAssertNotNil(gameScene?.pauseButton)
        XCTAssertTrue(try XCTUnwrap(gameScene.pauseButton?.pauseLogoBackground?.isHidden))
    }
    
    func testSetUpScoreHandler_setsUpScoreHandlerObject_hiddenBYDefault() throws {
        
        XCTAssertNotNil(gameScene?.scoreHandler)
        XCTAssertTrue(try XCTUnwrap(gameScene.scoreHandler?.scoreBackground?.isHidden))
    }
    
    func testSetUpWorld_callsWorldPhysics_setUpPhysicsWorld() {
        
        XCTAssertEqual(gameScene.physicsWorld.gravity, CGVector(dx: 0, dy: -8.0))
    }
    
    func testSetUpWorld_callsWorldPhysics_addBoundaries() {
        
        XCTAssertNotNil(gameScene?.childNode(withName:"minBoundary"))
        XCTAssertNotNil(gameScene?.childNode(withName:"maxBoundary"))
    }

    func testSetUpTraveller_callsTravellerCreator_setUpTraveller() {
        
        XCTAssertNotNil(gameScene?.childNode(withName:"traveller"))
    }
    
    func testSetUpTraveller_callsTravellerCreator_pauseTraveller() throws {
        
        XCTAssertFalse(try XCTUnwrap(gameScene.travellerCreator.traveller.physicsBody?.isDynamic))
    }
    
    //MARK: - Show/Hide
    
    func testShowGameplayNodes_callsPauseButton_show() {
        
        gameScene.showGameplayNodes()
        
        XCTAssertFalse(try XCTUnwrap(gameScene.pauseButton?.pauseLogoBackground?.isHidden))
    }
    
    func testShowGameplayNodes_callsScoreHandler_show() {
        
        gameScene.showGameplayNodes()
        
        XCTAssertFalse(try XCTUnwrap(gameScene.scoreHandler?.scoreBackground?.isHidden))
    }

    func testHideGameplayNodes_callsPauseButton_hide() {
        
        gameScene.showGameplayNodes()
        
        gameScene.hideGameplayNodes()
        
        XCTAssertTrue(try XCTUnwrap(gameScene.pauseButton?.pauseLogoBackground?.isHidden))
    }
    
    func testHideGameplayNodes_callsScoreHandler_hide() {
        
        gameScene.showGameplayNodes()
        
        gameScene.hideGameplayNodes()
        
        XCTAssertTrue(try XCTUnwrap(gameScene.scoreHandler?.scoreBackground?.isHidden))
    }
    
    //MARK: - Countdown
    
    func testSetUpCountdown_returns_ifIsPause_isNotTrue() {
        
        gameScene.isPaused = true
        gameScene.setUpCountdown()
        
        XCTAssertNil(gameScene.countDownLabel)
    }
    
    func testSetUpCountdown_ifTimerGreaterThanZero_initsCountDownLabel_andProperties() throws {
        
        let countDownTime = gameScene.countDownTime
        
        gameScene.setUpCountdown()
        let label = try XCTUnwrap(gameScene.countDownLabel)
        
        XCTAssertEqual(label.fontName, "ArialMT")
        XCTAssertEqual(label.fontSize, 144)
        XCTAssertEqual(label.text, String(countDownTime))
        XCTAssertEqual(label.zPosition, 50)
    }
    
    func testSetUpCountdown_ifTimerGreaterThanZero_removesLabelFromParent_afterTimeDelay() throws {
                
        gameScene.setUpCountdown()
        let label = try XCTUnwrap(gameScene.countDownLabel)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
            XCTAssertNil(label.parent)
        })
    }
    
    func testSetUpCountdown_ifTimerGreaterThanZero_updatesCountDownTime() throws {
        
        let expectCountDownTime = gameScene.countDownTime - 1
        
        gameScene.setUpCountdown()
        
        XCTAssertEqual(gameScene.countDownTime, expectCountDownTime)
    }
    
    func testSetUpCountdown_ifTimerLessThan_orEqualtoZero_unpausesGame() {
        
        while gameSceneSpy.countDownTime > 0 {
            gameSceneSpy.setUpCountdown()
        }
        
        gameSceneSpy.setUpCountdown()

        XCTAssertTrue(try XCTUnwrap(gameSceneSpy.travellerCreator.traveller.physicsBody?.isDynamic))
        XCTAssertEqual(gameSceneSpy.showGameplayNodesCallCount, 1)
    }
    
    func testCleanUp_removesNodes_offScreen() {
        
        let node = SKNode()
        node.name = "testNode"
        gameScene.addChild(node)
        node.position.x = -gameScene.size.width - 40
        
        XCTAssertNotNil(gameScene.childNode(withName:"testNode"))
        
        gameScene.cleanUp()
        
        XCTAssertNil(gameScene.childNode(withName:"testNode"))
    }
    
    //MARK: - Update
    
    func testUpdate_doesNothing_ifGamePaused() {
        
        gameSceneSpy.isPaused = true

        gameSceneSpy.update(CFTimeInterval(0.01))
        
        XCTAssertEqual(gameSceneSpy.enumerateChildNodesCallCount, 0)
    }
    
    func testUpdate_movesBackground_ifGameNotPaused() {
        
        let node = gameScene.childNode(withName: "background")
        let initialPosition = node?.position
        
        gameScene.update(CFTimeInterval(0.01))
        let newPosition = node?.position
        
        XCTAssertNotEqual(initialPosition, newPosition)
    }
    
    func testUpdate_enumeratesChildNodes_ifGameNotPaused() {
        
        gameSceneSpy.update(CFTimeInterval(0.01))
        
        ///Three nodes call this - background, and two obstacles
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02, execute: {
            XCTAssertEqual(self.gameSceneSpy.enumerateChildNodesCallCount, 3)
        })
    }
    
    func testUpdate_enumeratesNewChildNode_andSetX_ifGameNotPaused() {
        
        gameSceneSpy.update(CFTimeInterval(0.01))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02, execute: {
            
            let node = self.gameSceneSpy.childNode(withName: "newItem")
                        
            self.gameSceneSpy.update(CFTimeInterval(0.01))
            
            let nodeFinalX = (node?.position.x ?? 0) - 5
            
            XCTAssertEqual(node?.position.x, nodeFinalX)
        })
    }

    func testUpdateScore_doesNothing_ifGamePaused() {
        
        gameScene.isPaused = true
        
        gameScene.updateScore()
        
        XCTAssertEqual(gameScene.scoreHandler?.score, 0)
    }
    
    func testUpdateScore_callsScoreHandler_updateScore_ifGameNotPaused() {
                
        gameScene.updateScore()
        
        XCTAssertEqual(gameScene.scoreHandler?.score, 1)
    }
    
    func testHandleObstacleTimer_doesNothing_ifGamePause() {
        
        gameScene.isPaused = true

        gameScene.handleObstacleTimer(timer: Timer())
    }
    
    func testHandleObstacleTimer_callsObstacleCreator_renderObstacles_ifGameNotPaused() {
        
        gameScene.handleObstacleTimer(timer: Timer())

        XCTAssertNotNil(gameScene.childNode(withName:"obstacle"))
    }
    
    func testTravellerRotator_callsTravellerCreator_rotate() {
        
        let traveller = gameScene.travellerCreator.traveller
        gameScene.travellerCreator.unpauseTraveller()
        traveller.physicsBody?.velocity.dy = 1
        let initialRotation = gameScene.travellerCreator.traveller.zRotation
        
        gameScene.travellerRotator()
        let finalRotation = gameScene.travellerCreator.traveller.zRotation

        XCTAssertNotEqual(initialRotation, finalRotation)
    }
}
