//
//  ContactEditTableViewCell.swift
//  Address Book
//
//  Created by Rob Whitaker on 19/07/2017.
//  Copyright © 2017 RWAPP. All rights reserved.
//

import UIKit

class ContactEditTableViewCell: UITableViewCell, UITextFieldDelegate {
	
	@IBOutlet weak var textField: UITextField?
	
	typealias TextFieldChangedHandlerType = (String) -> Void
	fileprivate var textFieldChangedHander: TextFieldChangedHandlerType?
	
	typealias TextFieldEditEndedHandlerType = () -> Void
	fileprivate var textFieldEditEndedHandler: TextFieldEditEndedHandlerType?

    override func awakeFromNib() {
        super.awakeFromNib()
		
		// add target to pass back value when changed
		textField?.addTarget(self, action: #selector(self.textFieldValueChanged(_:)), for: .editingChanged)
    }

	func configureCell(text: String?,
	                   placeholder: String?,
	                   textFieldChangedHandler: TextFieldChangedHandlerType?,
	                   textFieldEditEndedHandler: TextFieldEditEndedHandlerType?) {
		
		if text != nil {
			// contact data provided, display this and make non-editable
			
		textField?.text = text
			textField?.isEnabled = false
			
		} else {
			// no data provided
			
			if (textField?.isEnabled)! {
				// field hasn't been set to non-editable, so add placeholder text
    textField?.placeholder = placeholder
			}
		        self.textFieldChangedHander = textFieldChangedHandler
			self.textFieldEditEndedHandler = textFieldEditEndedHandler
			
		}
	
	}

	func textFieldValueChanged(_ sender: Any) {
		// value changed so pass back to view
		
		if let field = sender as? UITextField {
			if let textFieldChangedHander = textFieldChangedHander {
				textFieldChangedHander(field.text!)
			}
		}
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		// end editing on return
		textField.endEditing(true)
		return false
	}
	
	func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
		// editing finished, pass edit ended handler mo validate/move to next field as required
		if let textFieldEditEndedHandler = textFieldEditEndedHandler {
			textFieldEditEndedHandler()
		}
	}

}
