//
//  ContactDetailViewController.swift
//  Address Book
//
//  Created by Rob Whitaker on 19/07/2017.
//  Copyright © 2017 RWAPP. All rights reserved.
//

import UIKit

let newContactAddedNotificationIdentifier = "NewContactAddedNotification"

class ContactDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var saveButton: UIButton!
	
	// Constraints to move save button/table if covered when keyboard appears
	@IBOutlet var keyboardHeightLayoutConstraintCell: NSLayoutConstraint!
	@IBOutlet var keyboardHeightLayoutConstraintButton: NSLayoutConstraint!

	fileprivate let cellIdentifier = "Contact Detail Cell"
	fileprivate let addressCellIdentifier = "Address Cell"
	
	fileprivate let contactCellHeight: CGFloat = 44.0
	fileprivate let addressCellHeight: CGFloat = 132.0
	
	// fields to display
	fileprivate enum ContactField: Int {
		case firstName, surname, email, mobile, address
		
		// total of fields, for calclating table cells
		static let count: Int = {
			var max: Int = 0
			while let _ = ContactField(rawValue: max) { max += 1 }
			return max
		}()
	}
	
	fileprivate var contactViewModel: ContactViewModel = ContactViewModel()

	var contact: Contact?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// registering for keyboard show/hide notifications
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)),
		                                       name: NSNotification.Name.UIKeyboardWillShow,
		                                       object: nil)
		NotificationCenter.default.addObserver(self, selector:#selector(self.keyboardNotification(notification:)),
		                                       name: NSNotification.Name.UIKeyboardWillHide,
		                                       object: nil)
		
		self.keyboardHeightLayoutConstraintCell?.constant = saveButton.frame.height + 8

		if contact == nil {
			// not been provided with a contact object, so set up the view to make an editable one
			
			self.title = "New Contact"
			saveButton.isHidden = false
			
		} else {
			// contact object provided, so set up the view to display the selected contact
			
			self.title = contact?.fullName()
			contactViewModel = ContactViewModel.init(contact: contact!)

		}
		
		// fix to hide un-needed cell dividers
		tableView.tableFooterView = UIView(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
		
    }
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

	// MARK: - Table View Data Source
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return ContactField.count
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		
		// first rows are standard height, last row is address, which needs to be taller
		if indexPath.row < ContactField.count - 1 {
			return contactCellHeight
		} else {
			return addressCellHeight
		}
	}
	
	// MARK: - Cells
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		if indexPath.row == ContactField.count - 1 {
			// last cell, show multi-line address cell
		return addressCell()
		}
		
		// all other cells show single-line text cells
		return contactCellFor(row: indexPath.row)
		
	}
	
	func completionHandlerFor(row: Int) -> (Void) -> Void {
		
		// handler to move to nect cell on EndEditing
		return {
			let nextCell = self.tableView.cellForRow(at: IndexPath.init(row: row + 1,
			                                                       section: 0)) as? ContactEditTableViewCell
			nextCell?.textField?.becomeFirstResponder()
		}
	}
	
	func contactCellFor(row: Int) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ContactEditTableViewCell
		
		if let saved = contactViewModel.contactSaved {
			if saved {
				// if this is an existing contact we want to disable erditing
				cell?.textField?.isEnabled = false
			}
		}
		
		// set red hightlight for validation errors
		// hidden by default
		cell?.textField?.layer.borderColor = UIColor.red.cgColor
		
		// enum makes switch statement more readable
		if let contactField = ContactField(rawValue: row) {
			
			switch contactField {
			case .firstName:
				
				// setting up cell
				cell?.configureCell(text: contactViewModel.contactFirstName,
				                    placeholder: contactViewModel.fieldDefaults[row],
				                    textFieldChangedHandler: {[weak self] (newText) in
										
										// setting handler to pass changed data to viewModel
										if let strongSelf = self {
											strongSelf.contactViewModel.contactFirstName = newText
										}
					},
				                    textFieldEditEndedHandler: completionHandlerFor(row: row))
				
			case .surname:
				
				cell?.configureCell(text: contactViewModel.contactSurname,
				                    placeholder: contactViewModel.fieldDefaults[row],
				                    textFieldChangedHandler: {[weak self] (newText) in
										if let strongSelf = self {
											strongSelf.contactViewModel.contactSurname = newText
										}
					}, textFieldEditEndedHandler: completionHandlerFor(row: row))
				
			case .email:
				
				cell?.textField?.keyboardType = .emailAddress
				cell?.configureCell(text: contactViewModel.contactEmail,
				                    placeholder: contactViewModel.fieldDefaults[row],
				                    textFieldChangedHandler: {[weak self] (newText) in
										if let strongSelf = self {
											strongSelf.contactViewModel.contactEmail = newText
											
										}
					}, textFieldEditEndedHandler: {[weak self] in
						
						//perform validation
						if let strongSelf = self {
							if let email = strongSelf.contactViewModel.contactEmail {
								if !strongSelf.contactViewModel.isValid(email: email) {
									
									// invalid data show cell highlight
									cell?.textField?.layer.borderWidth = 1.0
								} else {
									cell?.textField?.layer.borderWidth = 0.0
								}
							}
						}
						
						// move to next cell
						let nextCell = self?.tableView.cellForRow(at: IndexPath.init(row: row + 1,
						                                                             section: 0)) as? ContactEditTableViewCell
						nextCell?.textField?.becomeFirstResponder()
						
				})
				
			case .mobile:
				
				cell?.textField?.keyboardType = .phonePad
				cell?.configureCell(text: contactViewModel.contactMobile,
				                    placeholder: contactViewModel.fieldDefaults[row],
				                    textFieldChangedHandler: {[weak self] (newText) in
										if let strongSelf = self {
											strongSelf.contactViewModel.contactMobile = newText
										}
					}, textFieldEditEndedHandler: {[weak self] in
						
						// perform validation
						if let strongSelf = self {
							if let mobile = strongSelf.contactViewModel.contactMobile {
								if !strongSelf.contactViewModel.isValid(phone: mobile) {
									
									// invalid data show cell highlight
									cell?.textField?.layer.borderWidth = 1.0
									
								} else {
									cell?.textField?.layer.borderWidth = 0.0
								}
							}
						}
				})
				
			case .address:
				print("Error: Trying to set up an address on a contact cell")
				break
				
			}
		}
		return cell!
		
	}
	
	func addressCell() -> UITableViewCell {
		
		// setting up custom address cell with multi-line text input
		
	let cell = tableView.dequeueReusableCell(withIdentifier: addressCellIdentifier) as? AddressTableViewCell
		
		if let saved = contactViewModel.contactSaved {
			if saved {
				cell?.textView?.isEditable = false
			}
		}

	cell?.configureCell(text: contactViewModel.contactAddress,
	placeholder: contactViewModel.fieldDefaults[ContactField.count - 1],
	textFieldChangedHandler: {[weak self] (newText) in
	if let strongSelf = self {
	strongSelf.contactViewModel.contactAddress = newText
	}
	}, textFieldEditEndedHandler: { _ in
		
		cell?.textView?.resignFirstResponder()
	})
		
	return cell!
	}

	// MARK: - Save New Contact
	
	@IBAction func onSaveTap(_ sender: UIButton) {
		
		guard isValidContact() else {
			return
		}
		
		// Attempt to save contact through ViewModel, pass saved object through notification if save completed
		if let contact = contactViewModel.addContact() {
			let newContactNotification = Notification(name: Notification.Name(rawValue: newContactAddedNotificationIdentifier),
			                                          object: contact,
			                                          userInfo: nil)
			
			NotificationCenter.default.post(newContactNotification)
			navigationController?.popViewController(animated: true)
		} else {
			// contact rejected, probably due to validation error
			errorDialogWith(message: "Unable to save contact")
		}

	}
	
	func isValidContact() -> Bool {
		
		// use validation checks in ViewModel to check if contact can be saved, pass feedback to user if not
		
		guard contactViewModel.hasName() else {
			errorDialogWith(message: "Please enter at least one name")
			return false
		}
		
		if let email = contactViewModel.contactEmail {
			guard contactViewModel.isValid(email: email) else {
				errorDialogWith(message: "Please check the email address")
				return false
			}
		}
		
		if let phone = contactViewModel.contactMobile {
			guard contactViewModel.isValid(phone: phone) else {
				errorDialogWith(message: "Please check the phone number")
				return false
			}
		}
		
		return true
		
	}
	
	func errorDialogWith(message: String) {
		let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}
	
	// MARK: - Keyboard show/hide

	@objc func keyboardNotification(notification: NSNotification) {
		
		// Keyboard is changing dimensions, make adjustemts to the view as needed
		
		if let userInfo = notification.userInfo {
			
			// details from disctionary about keyboard animation
			let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
			let duration: TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
			let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
			let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
			let animationCurve: UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
			if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
				
				// Keyboard hidden, pin everything to the bottom of the screen
				self.keyboardHeightLayoutConstraintCell?.constant = saveButton.frame.height + 8
				self.keyboardHeightLayoutConstraintButton?.constant = 0.0
				
			} else {
				
				// Keyboard moving, pin everything to the top of the keyboard
				self.keyboardHeightLayoutConstraintCell?.constant = (endFrame?.size.height)! + saveButton.frame.height + 8
				self.keyboardHeightLayoutConstraintButton?.constant = (endFrame?.size.height)! + 8
			}
			
			UIView.animate(withDuration: duration,
			               delay: TimeInterval(0),
			               options: animationCurve,
			               animations: { self.view.layoutIfNeeded() },
			               completion: { _ in
							
							// if the viewable area is less than the height of the table view, allow scrolling
							if self.tableView.frame.height < self.view.frame.height - (endFrame?.size.height)! {
								self.tableView.isScrollEnabled = true
							} else {
								self.tableView.isScrollEnabled = false
							}
			})
		}
	}
}
