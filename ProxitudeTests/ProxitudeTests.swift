//
//  ProxitudeTests.swift
//  ProxitudeTests
//
//  Created by Michael Liu on 11/22/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

import XCTest
@testable import Proxitude
@testable import Firebase

class ProxitudeTests: XCTestCase {
    
    let query = Query()
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        query.queryRecommended(limit: 5).observe(.value, with: {
            snapshot in
            print("snapshot ------------> \(snapshot)")
            print ("Items -----------------> \(self.query.getItems(snapshot: snapshot))")
        })
        
        query.queryItemByUser(limit: 3, user: "michaelliu@mywheatonedu").observe(.value, with: {
            snapshot in
            print("snapshot ------------> \(snapshot)")
            print ("Items -----------------> \(self.query.getItems(snapshot: snapshot))")
        })
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
