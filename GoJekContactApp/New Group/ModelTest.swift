//
//  ModelTest.swift
//  Tests
//
//  Created by Faraz on 20/05/19.
//  Copyright © 2019 Faraz. All rights reserved.
//

import XCTest

class ModelTest: XCTestCase {
    
    var aaruna: ContactViewModel!

    override func setUp() {
        super.setUp()
        
        let details: [String:Any] = [
            "id": 5236,
            "first_name": "Aaruna",
            "last_name": "Pandit",
            "profile_pic": "/images/missing.png",
            "favorite": true,
            "url": "https://gojek-contacts-app.herokuapp.com/contacts/5236.json"
        ]
        
        aaruna = Contact(withDetail: details)
    }

    override func tearDown() {
        super.tearDown()
        
        aaruna = nil
    }

    func testExample() {
        XCTAssertEqual(aaruna.firstName, "Aaruna")
        XCTAssertEqual(aaruna.lastName, "Pandit")
    }3

}
