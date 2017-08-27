//
//  ContactViewModelTests.swift
//  Address Book
//
//  Created by Rob Whitaker on 20/07/2017.
//  Copyright © 2017 RWAPP. All rights reserved.
//

import XCTest

@testable import Address_Book

class ContactViewModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	func testIsValidEmail() {
		
		let viewModel = ContactViewModel()
		
		XCTAssertFalse(viewModel.isValid(email: "not an email"))
		XCTAssertFalse(viewModel.isValid(email: "not@email"))
		XCTAssertFalse(viewModel.isValid(email: "@not.email"))
		XCTAssertFalse(viewModel.isValid(email: "not@email."))
		XCTAssertFalse(viewModel.isValid(email: "not@email.n"))
		XCTAssertFalse(viewModel.isValid(email: "not@.email"))
		XCTAssertFalse(viewModel.isValid(email: "not@an .email"))
		XCTAssertFalse(viewModel.isValid(email: "not@an@email.com"))
		

		XCTAssertTrue(viewModel.isValid(email: "e@ma.il"))
		XCTAssertTrue(viewModel.isValid(email: ""))
		
	}
	
	func testIsMobileValid() {
		
		let viewModel = ContactViewModel()
		
		XCTAssertFalse(viewModel.isValid(phone: "not a valid phone"))
		
		XCTAssertTrue(viewModel.isValid(phone: "+1234567890"))
		XCTAssertTrue(viewModel.isValid(phone: "1234567890"))
		XCTAssertTrue(viewModel.isValid(phone: "123 456 789 0"))
		XCTAssertTrue(viewModel.isValid(phone: "1800MYAPPLE"))
		XCTAssertTrue(viewModel.isValid(phone: ""))
		
	}
}
