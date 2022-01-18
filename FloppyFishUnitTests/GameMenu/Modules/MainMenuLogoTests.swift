//
//  MainMenuLogoTests.swift
//  FloppyFishUnitTests
//
//  Created by Colin Morrison on 13/01/2022.
//

@testable import FloppyFish
import SpriteKit
import XCTest

class MainMenuLogoSpy: MainMenuLogo {
        
    private(set) var renderLogoCallCount = 0
    private(set) var renderLogoParent: SKScene?
    
    override func renderLogo(parent: SKScene) {
        renderLogoCallCount += 1
        renderLogoParent = parent
    }
}

final class MainMenuLogoTests: XCTestCase {
    
    private var delegate: GameMenuSpy!
    private var mainMenuLogoSpy: MainMenuLogoSpy!
    private var mainMenuLogo: MainMenuLogo!
    
    private var logo: SKShapeNode?
    
    override func setUp() {
        
        delegate = GameMenuSpy()
        mainMenuLogoSpy = MainMenuLogoSpy(delegate: delegate)
        mainMenuLogo = MainMenuLogo(delegate: delegate)
        
        logo = mainMenuLogo.logo
    }
    
    func testInitialiser_callsRenderLogo_withDelegate() {
        
        XCTAssertEqual(mainMenuLogoSpy.renderLogoCallCount, 1)
        XCTAssertEqual(mainMenuLogoSpy.renderLogoParent, delegate)
    }
    
    func testRenderLogo_initialisesShapeNode() {
        
        XCTAssert(try XCTUnwrap(logo) .isKind(of: SKShapeNode.self))
    }
    
    func testRenderLogo_setsLogoFillTexture_toSomething() {
        
        XCTAssertNotNil(logo?.fillTexture)
    }
    
    func testRenderLogo_setsLogoSizeProperties() throws {
        
        let expectedWidth = CGFloat(delegate.frame.size.width * 0.8)
        let expectedHeight = CGFloat(delegate.frame.size.height * 0.25)
        let actualWidth = try XCTUnwrap(logo?.frame.size.width)
        let actualHeight = try XCTUnwrap(logo?.frame.size.height)
        let accuracy = CGFloat(0.01)

        XCTAssertEqual(actualWidth, expectedWidth, accuracy: accuracy)
        XCTAssertEqual(actualHeight, expectedHeight, accuracy: accuracy)
    }
    
    func testRenderLogo_setsLogoProperty_Colors() {
    
        let whiteColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        let clearColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        
        XCTAssertEqual(logo?.fillColor, whiteColor)
        XCTAssertEqual(logo?.strokeColor, clearColor)
    }
    
    func testRenderLogo_setsLogoProperty_Positions() throws {
    
        XCTAssertEqual(logo?.position, CGPoint(x:0, y:(delegate.size.height * 0.25)))
        XCTAssertEqual(logo?.zPosition, 5)
    }
    
    func testRenderLogo_setsLogoProperty_Name() throws {
        
        XCTAssertEqual(logo?.name, "menuLogo")
    }
    
    func testRenderLogo_addsChild_toParent() {
        
        XCTAssertEqual(delegate.addChildCallCount, 1)
        XCTAssertEqual(delegate.addChildNodesAdded, [logo])
        XCTAssertEqual(delegate.childNode(withName: "menuLogo"), logo)
    }

}
