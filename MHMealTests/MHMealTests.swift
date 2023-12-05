//
//  MHMealTests.swift
//  MHMealTests
//
//  Created by 박성헌 on 2021/10/30.
//  Copyright © 2021 n30gu1. All rights reserved.
//

import XCTest
@testable import MHMeal

class MHMealTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testLoadingBreakfastAtViewModel() throws {
        let viewModel = ContentViewModel()
        viewModel.date = Date()
        viewModel.mealType = .breakfast
        viewModel.fetch()
        
    }
    
//    func testNetManager() throws {
//        let netManager = NetManager()
//        
//        netManager.fetch(from: Date(), to: Date().addingTimeInterval(604800))
//    }

}
