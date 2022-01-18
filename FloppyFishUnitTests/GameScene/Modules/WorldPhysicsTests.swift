//
//  WorldPhysicsTests.swift
//  FloppyFishUnitTests
//
//  Created by Colin Morrison on 13/01/2022.
//


@testable import FloppyFish
import SpriteKit
import XCTest

final class WorldPhysicsSpy: WorldPhysics {
    
    private(set) var maximumBoundaryCallCount = 0
    private(set) var maximumBoundaryParent: SKScene?
    private(set) var minimumBoundaryCallCount = 0
    private(set) var minimumBoundaryParent: SKScene?
    private(set) var commonBoundaryPropertiesCallCount = 0
    private(set) var commonBoundaryPropertiesNode: SKSpriteNode?

    override func maximumBoundary(parent: SKScene) {
        super.maximumBoundary(parent: parent)
        maximumBoundaryCallCount += 1
        maximumBoundaryParent = parent
    }
    
    override func minimumBoundary(parent: SKScene) {
        super.minimumBoundary(parent: parent)
        minimumBoundaryCallCount += 1
        minimumBoundaryParent = parent
    }
    
    override func commonBoundaryProperties(boundary: SKSpriteNode) {
        commonBoundaryPropertiesCallCount += 1
        commonBoundaryPropertiesNode = boundary
    }
}

final class WorldPhysicsTests: XCTestCase {
    
    private var delegate: GameSceneSpy!
    private var worldPhysics: WorldPhysics!
    
    override func setUp() {
        
        delegate = GameSceneSpy()
        worldPhysics = WorldPhysics(delegate: delegate)
    }
    
    func testInitialiser_setsProperties() {
        
        XCTAssertEqual(worldPhysics.delegate, delegate)
    }
    
    func testSetupPhysicsWorld_setsDelegateProperties() {
        
        let expectedGravity = CGVector(dx: 0, dy: -8.0)
        
        worldPhysics.setUpPhysicsWorld()
        
        XCTAssertEqual(delegate.physicsWorld.gravity, expectedGravity)
        XCTAssertNotNil(delegate.physicsWorld.contactDelegate)
    }
    
    func testAddBoundaries_callsBoundaryMakers() {
        
        let worldPhysicsSpy = WorldPhysicsSpy(delegate: delegate)
        
        worldPhysicsSpy.addBoundaries()
        
        XCTAssertEqual(worldPhysicsSpy.maximumBoundaryCallCount, 1)
        XCTAssertEqual(worldPhysicsSpy.maximumBoundaryParent, delegate)
        XCTAssertEqual(worldPhysicsSpy.minimumBoundaryCallCount, 1)
        XCTAssertEqual(worldPhysicsSpy.minimumBoundaryParent, delegate)
    }
    
    func testCommonBoundaryProperties_setsProperties() throws {
        
        let node = SKSpriteNode()
        
        worldPhysics.commonBoundaryProperties(boundary: node)
        let nodePhysicsBody = try XCTUnwrap(node.physicsBody)
        
        XCTAssertEqual(node.size.width, delegate.size.width)
        XCTAssertEqual(node.size.height, 1)
        XCTAssert(nodePhysicsBody .isKind(of: SKPhysicsBody.self))
        XCTAssertEqual(nodePhysicsBody.collisionBitMask, 0)
        XCTAssertFalse(nodePhysicsBody.affectedByGravity)
        XCTAssertFalse(nodePhysicsBody.isDynamic)
    }
    
    func testMaximumBoundary_initialisesMaxBoundary_asSpriteNode() throws {

        worldPhysics.maximumBoundary(parent: delegate)
        let maxBoundary = try XCTUnwrap(worldPhysics.maxBoundary)
        
        XCTAssert(maxBoundary .isKind(of: SKSpriteNode.self))
    }
    
    func testMaximumBoundary_callsCommonBoundaryProperties_withMaxBoundary() {
        
        let worldPhysicsSpy = WorldPhysicsSpy(delegate: delegate)

        worldPhysicsSpy.maximumBoundary(parent: delegate)

        XCTAssertEqual(worldPhysicsSpy.commonBoundaryPropertiesCallCount, 1)
        XCTAssertEqual(worldPhysicsSpy.commonBoundaryPropertiesNode, worldPhysicsSpy.maxBoundary)
    }
    
    func testMaximumBoundary_setsMaxBoundaryProperties() throws {
        let expectedY = delegate.size.height * 0.5
        let accuracy = CGFloat(0.01)
        
        worldPhysics.maximumBoundary(parent: delegate)
        let maxBoundary = try XCTUnwrap(worldPhysics.maxBoundary)
        let physicsBody = try XCTUnwrap(maxBoundary.physicsBody)

        XCTAssertEqual(maxBoundary.name, "maxBoundary")
        XCTAssertEqual(maxBoundary.position.x, 0)
        XCTAssertEqual(maxBoundary.position.y, expectedY, accuracy: accuracy)
        XCTAssertEqual(physicsBody.categoryBitMask, ColliderType.maxBoundary)
    }
    
    func testMaximumBoundary_addsSelfToParent() {
        
        worldPhysics.maximumBoundary(parent: delegate)
        
        XCTAssertEqual(delegate.addChildCallCount, 1)
        XCTAssertEqual(delegate.addChildNodesAdded, [worldPhysics.maxBoundary])
        XCTAssertEqual(delegate.childNode(withName: "maxBoundary"), worldPhysics.maxBoundary)
    }
    
    func testMinimumBoundary_initialisesMiniBoundary_asSpriteNode() throws {

        worldPhysics.minimumBoundary(parent: delegate)
        let minBoundary = try XCTUnwrap(worldPhysics.minBoundary)
        
        XCTAssert(minBoundary .isKind(of: SKSpriteNode.self))
    }
    
    func testMinimumBoundary_callsCommonBoundaryProperties_withMinBoundary() {
        
        let worldPhysicsSpy = WorldPhysicsSpy(delegate: delegate)

        worldPhysicsSpy.minimumBoundary(parent: delegate)

        XCTAssertEqual(worldPhysicsSpy.commonBoundaryPropertiesCallCount, 1)
        XCTAssertEqual(worldPhysicsSpy.commonBoundaryPropertiesNode, worldPhysicsSpy.minBoundary)
    }
    
    func testMinimumBoundary_setsMinBoundaryProperties() throws {
        let expectedY = -delegate.size.height * 0.5
        let accuracy = CGFloat(0.01)
        
        worldPhysics.minimumBoundary(parent: delegate)
        let minBoundary = try XCTUnwrap(worldPhysics.minBoundary)
        let physicsBody = try XCTUnwrap(minBoundary.physicsBody)

        XCTAssertEqual(minBoundary.name, "minBoundary")
        XCTAssertEqual(minBoundary.position.x, 0)
        XCTAssertEqual(minBoundary.position.y, expectedY, accuracy: accuracy)
        XCTAssertEqual(physicsBody.categoryBitMask, ColliderType.minBoundary)
    }
    
    func testMinimumBoundary_addsSelfToParent() {
        
        worldPhysics.minimumBoundary(parent: delegate)
        
        XCTAssertEqual(delegate.addChildCallCount, 1)
        XCTAssertEqual(delegate.addChildNodesAdded, [worldPhysics.minBoundary])
        XCTAssertEqual(delegate.childNode(withName: "minBoundary"), worldPhysics.minBoundary)
    }
}
