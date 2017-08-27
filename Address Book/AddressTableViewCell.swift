//
//  AddressTableViewCell.swift
//  Address Book
//
//  Created by Rob Whitaker on 20/07/2017.
//  Copyright © 2017 RWAPP. All rights reserved.
//

import UIKit

class AddressTableViewCell: UITableViewCell, UITextViewDelegate {
	
	@IBOutlet weak var textView: UITextView?
	
	typealias TextFieldChangedHandlerType = (String) -> Void
	fileprivate var textFieldChangedHander: TextFieldChangedHandlerType?
	
	typealias TextFieldEditEndedHandlerType = () -> Void
	fileprivate var textFieldEditEndedHandler: TextFieldEditEndedHandlerType?
	
	// No placeholder built in to text view, so we need to mimic the behaviour.
	// This colour is equivalent to the iOS detault placeholder colour
	fileprivate let placeholderColour = UIColor.init(red: 0.8039215686,
	                                                 green: 0.8039215686,
	                                                 blue: 0.8235294118,
	                                                 alpha: 1.0)
	
	var placeholderText: String?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
	
	func configureCell(text: String?,
	                   placeholder: String?,
	                   textFieldChangedHandler: TextFieldChangedHandlerType?,
	                   textFieldEditEndedHandler: TextFieldEditEndedHandlerType?) {
		
		// store the provided placeholder so we know if the user has entered any data
		placeholderText = placeholder
		
		if text != nil {
			// contact has been provided, display this and make non-editable
			textView?.text = text
			textView?.isEditable = false
			
		} else {
			// no address provided
			
			if (textView?.isEditable)! {
				
				// text view hasn't been set to non-editable, so we need to add the placeholder text
				textView?.textColor = placeholderColour
				textView?.text = placeholderText
			}
			
			self.textFieldChangedHander = textFieldChangedHandler
			self.textFieldEditEndedHandler = textFieldEditEndedHandler
			
		}
		
	}
	
	func textViewDidChange(_ textView: UITextView) {
		// value changed, pass this back to view
		
		let text = textView.text
		if text != placeholderText {
			if let textFieldChangedHander = textFieldChangedHander {
				textFieldChangedHander(text!)
			}
		}
	}
	
	func textViewDidBeginEditing(_ textView: UITextView) {
		// remove placeholder text on focus so user can enter own data
		
		if textView.text == placeholderText {
			textView.text = ""
			textView.textColor = UIColor.black
		}
	}
	
}
