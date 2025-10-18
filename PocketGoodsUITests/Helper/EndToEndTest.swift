//
//  EndToEndTest.swift
//  PocketGoods
//
//  Created by BADR  QABA on 2025-10-13.
//
import XCTest
@testable import CoreApp
@testable import CoreUI

class EndToEndTest: XCTestCase {
    
    var app: XCUIApplication!
    let device = XCUIDevice.shared
    
    func onSetup(){}
    
    func onTearDown(){}
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        continueAfterFailure = false
        
        app = XCUIApplication()
        
        app.launchArguments
            .append(IsInTestEnvironment.testProcessArgument)
        
        onSetup()
        
        app.launch()
        
        device.orientation = UIDeviceOrientation.portrait
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        onTearDown()
        app.terminate()
    }
}
