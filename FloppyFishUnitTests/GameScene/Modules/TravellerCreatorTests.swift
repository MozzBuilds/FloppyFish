//
//  TravellerCreatorTests.swift
//  FloppyFishUnitTests
//
//  Created by Colin Morrison on 13/01/2022.
//

@testable import FloppyFish
import SpriteKit
import XCTest

final class TravellerCreatorSpy: TravellerCreator {
    
    private(set) var setPhysicsCallCount = 0
    
    override func setPhysics() {
        setPhysicsCallCount += 1
    }
    
}

final class TravellerCreatorTests: XCTestCase {
    
    private var delegate: GameSceneSpy!
    private var travellerCreator: TravellerCreator!

    private var traveller: SKSpriteNode?
    
    override func setUp() {
        
        delegate = GameSceneSpy()
        travellerCreator = TravellerCreator(delegate: delegate)
        traveller = travellerCreator.traveller
    }
    
    func testInitialiser_setsProperties_andInitiatesTraveller() throws {
                
        XCTAssert(try XCTUnwrap(traveller) .isKind(of: SKSpriteNode.self))
        XCTAssert(try XCTUnwrap(traveller?.texture) .isKind(of: SKTexture.self))
    }
    
    func testSetUpTraveller_setsTravellerProperties() throws {
        
        let expectedX = -delegate.size.width / 3
        let accuracy = CGFloat(0.01)
        
        travellerCreator.setUpTraveller()
        let actualX = CGFloat(try XCTUnwrap(traveller?.position.x))
        
        XCTAssertEqual(traveller?.zPosition, 30)
        XCTAssertEqual(traveller?.size.width, 125)
        XCTAssertEqual(traveller?.size.height, 100)
        XCTAssertEqual(actualX, expectedX, accuracy: accuracy)
        XCTAssertEqual(traveller?.position.y, 0)
        XCTAssertEqual(traveller?.name, "traveller")
    }
    
    func testSetUpTraveller_callsSetPhysics() {
        let travellerCreatorSpy = TravellerCreatorSpy(delegate: delegate)
        
        travellerCreatorSpy.setUpTraveller()

        XCTAssertEqual(travellerCreatorSpy.setPhysicsCallCount, 1)
    }
    
    func testSetUpTraveller_addsChildToParent() {

        travellerCreator.setUpTraveller()

        XCTAssertEqual(delegate.addChildCallCount, 1)
        XCTAssertEqual(delegate.addChildNodesAdded, [travellerCreator.traveller])
        XCTAssertEqual(delegate.childNode(withName: "traveller"), travellerCreator.traveller)
    }
    
    func testSetPhysics_setsPhysicsBody() throws {
        
        travellerCreator.setPhysics()
        let travellerPhysicsBody = try XCTUnwrap(traveller?.physicsBody)
        
        XCTAssert(travellerPhysicsBody .isKind(of: SKPhysicsBody.self))
    }
    
    func testSetPhysics_setsPhysicsCollisionProperties() throws {
        
        let expectCategory = ColliderType.traveller
        let expectContactTest = ColliderType.obstacle | ColliderType.minBoundary | ColliderType.maxBoundary
        let expectCollision = ColliderType.obstacle | ColliderType.minBoundary | ColliderType.maxBoundary
        
        travellerCreator.setPhysics()
        let travellerPhysicsBody = try XCTUnwrap(traveller?.physicsBody)
        
        XCTAssertEqual(travellerPhysicsBody.categoryBitMask, expectCategory)
        XCTAssertEqual(travellerPhysicsBody.contactTestBitMask, expectContactTest)
        XCTAssertEqual(travellerPhysicsBody.collisionBitMask, expectCollision)
    }
    
    func testPauseTraveller_disablesIsDynamic_andGravity() throws {
        
        travellerCreator.setPhysics()
        
        travellerCreator.pauseTraveller()
        let travellerPhysicsBody = try XCTUnwrap(traveller?.physicsBody)

        XCTAssertFalse(travellerPhysicsBody.isDynamic)
        XCTAssertFalse(travellerPhysicsBody.affectedByGravity)
    }
    
    func testUnpauseTraveller_EnablesIsDynamic_andGravity() throws {
        
        travellerCreator.setPhysics()
        
        travellerCreator.unpauseTraveller()
        let travellerPhysicsBody = try XCTUnwrap(traveller?.physicsBody)

        XCTAssertTrue(travellerPhysicsBody.isDynamic)
        XCTAssertTrue(travellerPhysicsBody.affectedByGravity)
    }
    
    func testRotate_setsPositiveZRotation_ifDyVelocity_greaterThanZero() throws {
        
        travellerCreator.setPhysics()
        traveller?.physicsBody?.velocity.dy = 1
        let accuracy = CGFloat(0.01)
        
        travellerCreator.rotate()
        let zRotation = CGFloat(try XCTUnwrap(traveller?.zRotation))
        
        XCTAssertEqual(zRotation, 0.4, accuracy: accuracy)
    }
    
    func testRotate_setsNegativeZRotation_ifDyVelocity_lessThanZero() throws {
        
        travellerCreator.setPhysics()
        traveller?.physicsBody?.velocity.dy = -1
        let accuracy = CGFloat(0.01)

        travellerCreator.rotate()
        let zRotation = CGFloat(try XCTUnwrap(traveller?.zRotation))
        
        XCTAssertEqual(zRotation, -0.4, accuracy: accuracy)
    }
    
    func testRotate_setsNeutralRotation_ifDyVelocity_EqualsZero() {
        
        travellerCreator.setPhysics()
        traveller?.physicsBody?.velocity.dy = 0
        
        travellerCreator.rotate()
        
        XCTAssertEqual(traveller?.zRotation, 0)
    }

    func testUpdateTexture_changesTextureInstance() {
        
        let initialTexture = traveller?.texture
        
        travellerCreator.updateTexture()
        let finalTexture = traveller?.texture
        
        XCTAssertNotEqual(initialTexture, finalTexture)
    }

}

