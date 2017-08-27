//
//  ViewController.swift
//  Address Book
//
//  Created by Rob Whitaker on 19/07/2017.
//  Copyright © 2017 RWAPP. All rights reserved.
//

import UIKit

fileprivate var contacts: [Contact] = []

class ContactTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet weak var tableView: UITableView!
	
	fileprivate let cellIdentifier = "Contact Name Cell"
	
	fileprivate let segueIdentifier = "Address Detail Segue"
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Register for notifications of new contacts
		NotificationCenter.default.addObserver(self, selector: #selector(onContactAddedNotification(_:)),
		                                       name: NSNotification.Name(rawValue: newContactAddedNotificationIdentifier),
		                                       object: nil)

		// fix to hide un-needed cell dividers
		tableView.tableFooterView = UIView(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		if let selectedRow = tableView.indexPathForSelectedRow {
		tableView.deselectRow(at: selectedRow, animated: false)
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	// MARK: - Add/Edit Contact
	
	@IBAction func addNewContact(_ sender: Any) {
		// user tapped new contact button, present detail with empty contact for editing
		performSegue(withIdentifier: segueIdentifier, sender: sender)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

		if segue.identifier == segueIdentifier,
			let contactDetail: ContactDetailViewController = segue.destination as? ContactDetailViewController,
			let indexPath = self.tableView.indexPathForSelectedRow {
			// user tapped cell, present detail and pass this contact for viewing
			
			contactDetail.contact = contacts[indexPath.row]
			}
		}
	
	func onContactAddedNotification(_ notification: Notification) {
		// new contact added, reload table
		if let newContact = notification.object as? Contact {
			newContact.saved = true
			contacts.append(newContact)
			tableView.reloadData()
		}
	}

	// MARK: - Table View Datasource
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return contacts.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
		
		cell?.textLabel?.text = contacts[indexPath.row].fullName()
		
		return cell!
	}
}
