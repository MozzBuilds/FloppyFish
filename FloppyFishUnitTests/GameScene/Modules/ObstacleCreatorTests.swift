//
//  ObstacleCreatorTests.swift
//  FloppyFishUnitTests
//
//  Created by Colin Morrison on 13/01/2022.
//

@testable import FloppyFish
import SpriteKit
import XCTest

final class ObstacleCreatorSpy: ObstacleCreator {
    
    private(set) var setSizesCallCount = 0
    private(set) var setPositionsCallCount = 0
    private(set) var setPhysicsCallCount = 0
    
    override func setSizes() {
        
        setSizesCallCount += 1
    }
    
    override func setPositions() {
        
        setPositionsCallCount += 1
    }
    
    override func setPhysics() {
        
        setPhysicsCallCount += 1
    }
    
}

final class ObstacleCreatorTests: XCTestCase {
    
    private var delegate: GameSceneSpy!
    private var obstacleCreator: ObstacleCreator!
    
    private var obstacle1: SKSpriteNode?
    private var obstacle2: SKSpriteNode?
    
    override func setUp() {
        
        delegate = GameSceneSpy()
        obstacleCreator = ObstacleCreator(delegate: delegate)
        
        obstacleCreator.renderObstacles()
        obstacle1 = obstacleCreator.obstacle1
        obstacle2 = obstacleCreator.obstacle2
    }
    
    func testInitialiser_setsDelegate_andDefaultSizeProperties() {
        
        let expectDefaultSize = CGSize(width: 80, height: 300)
        
        XCTAssertEqual(obstacleCreator.delegate, delegate)
        XCTAssertEqual(obstacleCreator.defaultSize, expectDefaultSize)
    }
    
    func testRenderObstacles_initialisesObstacles_andObstaclesArray() throws {
        
        XCTAssert(try XCTUnwrap(obstacle1) .isKind(of: SKSpriteNode.self))
        XCTAssert(try XCTUnwrap(obstacle2) .isKind(of: SKSpriteNode.self))
        XCTAssertEqual(try XCTUnwrap(obstacleCreator.obstacles) .count, 2)
    }
    
    func testRenderObstacles_callsSetSizes_positions_andPhysics() {
        
        let obstacleCreatorSpy = ObstacleCreatorSpy(delegate: delegate)
        
        obstacleCreatorSpy.renderObstacles()
        
        XCTAssertEqual(obstacleCreatorSpy.setSizesCallCount, 1)
        XCTAssertEqual(obstacleCreatorSpy.setPositionsCallCount, 1)
        XCTAssertEqual(obstacleCreatorSpy.setPhysicsCallCount, 1)
    }
    
    func testRenderObstacles_addsObstaclesToDelegate() {
        

        XCTAssertEqual(delegate.children[0], obstacle1)
        XCTAssertEqual(delegate.children[1], obstacle2)

    }
    
    func testSetSize_setsWidthAndChangesHeight_fromOriginalImageHeight() {
        
        let expectDefaultWidth = CGFloat(80)
        let imageOriginalHeight = CGFloat(1646)
        ///This is the size property of the current image used

        XCTAssertEqual(obstacle1?.size.width, expectDefaultWidth)
        XCTAssertEqual(obstacle2?.size.width, expectDefaultWidth)
        XCTAssertNotEqual(obstacle1?.size.height, imageOriginalHeight)
        XCTAssertNotEqual(obstacle2?.size.height, imageOriginalHeight)
    }

    func testSetPositions_setsCommonProperties() {
                
        XCTAssertEqual(obstacle1?.anchorPoint, CGPoint(x: 0.5, y: 0.5))
        XCTAssertEqual(obstacle1?.name, "obstacle")
        XCTAssertEqual(obstacle1?.position.x, delegate.size.width)
        XCTAssertEqual(obstacle1?.zPosition, 25)
        XCTAssertEqual(obstacle1?.xScale, 1.0)
        
        XCTAssertEqual(obstacle2?.anchorPoint, CGPoint(x: 0.5, y: 0.5))
        XCTAssertEqual(obstacle2?.name, "obstacle")
        XCTAssertEqual(obstacle2?.position.x, delegate.size.width)
        XCTAssertEqual(obstacle2?.zPosition, 25)
        XCTAssertEqual(obstacle2?.xScale, 1.0)

    }
    
    func testSetPositions_setsObstaclePositionProperties_forRandomIntValue_ofOne() throws {
        
        obstacleCreator.renderObstacles()

        let obstacle1Height = try XCTUnwrap(obstacle1?.size.height)
        let obstacle2Height = try XCTUnwrap(obstacle2?.size.height)
        let expectObstacle1TopPositionY = (delegate.size.height * 0.5) - (obstacle1Height * 0.5)
        let expectObstacle2BottomPositionY = -((delegate.size.height * 0.5) - (obstacle2Height * 0.5))
        let accuracy = CGFloat(0.01)
        
        if obstacleCreator.randomPosition == 1 {
            
            XCTAssertEqual(try XCTUnwrap(obstacle1?.position.y),
                           expectObstacle1TopPositionY,
                           accuracy: accuracy)
            
            XCTAssertEqual(try XCTUnwrap(obstacle1?.zRotation),
                           .pi,
                           accuracy: accuracy)
                        
            XCTAssertEqual(try XCTUnwrap(obstacle2?.position.y),
                           expectObstacle2BottomPositionY,
                           accuracy: accuracy)
            
            XCTAssertEqual(obstacle2?.zRotation, 0)
        }
    }
    
    func testSetPositions_setsObstaclePositionProperties_forRandomIntValue_ofTwo() throws {
        
        obstacleCreator.renderObstacles()

        let obstacle1Height = try XCTUnwrap(obstacle1?.size.height)
        let obstacle2Height = try XCTUnwrap(obstacle2?.size.height)
        let expectObstacle1BottomPositionY = -((delegate.size.height * 0.5) - (obstacle1Height * 0.5))
        let expectObstacle2TopPositionY = (delegate.size.height * 0.5) - (obstacle2Height * 0.5)
        let accuracy = CGFloat(0.01)
        
        if obstacleCreator.randomPosition == 2 {
            
            XCTAssertEqual(try XCTUnwrap(obstacle1?.position.y),
                           expectObstacle1BottomPositionY,
                           accuracy: accuracy)
            
            XCTAssertEqual(obstacle1?.zRotation, 0)
            
            XCTAssertEqual(try XCTUnwrap(obstacle2?.position.y),
                           expectObstacle2TopPositionY,
                           accuracy: accuracy)
            
            XCTAssertEqual(try XCTUnwrap(obstacle2?.zRotation),
                           .pi,
                           accuracy: accuracy)
        }
    }
}
