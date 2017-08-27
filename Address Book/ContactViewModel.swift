//
//  contactViewModel.swift
//  Address Book
//
//  Created by Rob Whitaker on 19/07/2017.
//  Copyright © 2017 RWAPP. All rights reserved.
//

import Foundation

extension String {
	
	// string extension using regex to remove spaces from the end of text
	func trimTrailingWhitespace() -> String {
		return self.replacingOccurrences(of: "\\s+$",
		                                         with: "",
		                                         options: .regularExpression)
	}
}

class ContactViewModel {

var contactFirstName: String?
var contactSurname: String?
var contactEmail: String?
var contactMobile: String?
var contactAddress: String?
	var contactSaved: Bool?
	
	let fieldDefaults = ["First Name", "Last Name", "Email Address", "Phone Number", "Address"]

	init(contactFirstName: String? = nil,
	     contactSurname: String? = nil,
	     contactEmail: String? = nil,
	     contactMobile: String? = nil,
	     contactAddress: String? = nil,
	     contactSaved: Bool? = nil) {
		
		self.contactFirstName = contactFirstName
		self.contactSurname = contactSurname
		self.contactEmail = contactEmail
		self.contactMobile = contactMobile
		self.contactAddress = contactAddress
		self.contactSaved = contactSaved
	}
	
	init(contact: Contact) {
		self.contactFirstName = contact.firstName
		self.contactSurname = contact.surname
		self.contactEmail = contact.email
		self.contactMobile = contact.mobile
		self.contactAddress = contact.address
		self.contactSaved = contact.saved
	}
	
	func isValid(email: String) -> Bool {
		
		// basic validation to ensure address has no spaces, has the right characters in the right places etc
		
		if email.characters.count == 0 {
			return true
		}
		
		if email.characters.count < 5 {
			// too short
			return false
		}
		
		// checking for . and @
		guard let atLocation = email.characters.index(of: "@") else { return false }
		guard let dotLocation = email.characters.index(of: ".") else { return false }
		
		if email.characters.index(of: " ") != nil {
			// contains a space
			return false
		}
		
		let atStartRange = email.startIndex..<atLocation
		if email[atStartRange].characters.count < 1 {
			// nothing before @
			return false
		}

		let dotEndRange = dotLocation..<email.endIndex
		if email[dotEndRange].characters.count < 3 {
			// not enough characters in the domain
			return false
		}
		
		let atToDotRange = atLocation..<dotLocation
		if email[atToDotRange].characters.count < 3 {
			// . comes before @
			return false
		}
		
		var noOfAts = 0
		for char in email.characters {
			if char == "@" {
				noOfAts += 1
			}
			if noOfAts > 1 {
				// more than one @
				return false
			}
		}
		
		return true
	}
	
	func isValid(phone: String) -> Bool {
		// checking phone number contins at least one number
		
		if phone.characters.count == 0 {
			return true
		}
		
		let numbers = NSCharacterSet.decimalDigits
		if phone.rangeOfCharacter(from: numbers) == nil {
			return false
		}
		return true
	}
	
	func hasName() -> Bool {
		// ensure we have at least one name to display the contact
		
		if let lastName = contactSurname {
			if lastName.characters.count > 0 {
			return true
		}
		}
		
		if let firstName = contactFirstName {
		if firstName.characters.count > 0 {
			return true
		}
		}
		
		return false
	}
	
	func addContact() -> Contact? {
		
		// perform final validation checks before saving
		guard contactSurname != nil || contactFirstName != nil else { return nil }
		guard (contactEmail != nil && isValid(email: contactEmail!)) || contactEmail == nil else { return nil }
		guard (contactMobile != nil && isValid(phone: contactMobile!)) || contactMobile == nil else {return nil }
		
		// return finalised contact object
			return Contact(firstName: contactFirstName?.trimTrailingWhitespace(),
			               surname: contactSurname?.trimTrailingWhitespace(),
			               email: contactEmail?.trimTrailingWhitespace(),
			               mobile: contactMobile?.trimTrailingWhitespace(),
			               address: contactAddress?.trimTrailingWhitespace())

	}
	
}
