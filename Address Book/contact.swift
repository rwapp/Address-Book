//
//  contact.swift
//  Address Book
//
//  Created by Rob Whitaker on 19/07/2017.
//  Copyright © 2017 RWAPP. All rights reserved.
//

import Foundation

class Contact {
	
	var firstName: String?
	var surname: String?
	var email: String?
	var mobile: String?
	var address: String?
	var saved: Bool?
	
	init(firstName: String?, surname: String?, email: String?, mobile: String?, address: String?) {
			
		self.firstName = firstName
		self.surname = surname
		self.email = email
		self.mobile = mobile
		self.address = address
		self.saved = false
	}
	
	func fullName() -> String {
		// returns full name unwraped from data stored
		
		// Patern matching to unwrap all options
		switch (firstName, surname) {
			
			// both first & surname
		case let (.some(firstName), .some(surname)):
			return "\(firstName) \(surname)"
			
			// first name only
		case let (.some(firstName), .none):
			return firstName
			
			// surname only
		case let (.none, .some(surname)):
			return surname
			
			// neither
		case (.none, .none):
			return ""
		}
	}
	}
