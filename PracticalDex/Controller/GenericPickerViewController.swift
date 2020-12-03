//
//  DialogPickerView.swift
//  PracticalDex
//
//  Created by Allan Rosa on 20/11/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//

import UIKit

/// Expects T as an Array of Arrays, each one should provide data for a row
class GenericPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
	
	// MARK: - Properties
	var pickerView = UIPickerView()
	var presetComponentIndex = 0
	var presetRowIndex = 0

	var completionHandler:((String, Int) -> ())? // Handles the user's input on the UIPickerView
	
	var items: [[Any]] = [] // Initialize an array of items of type T
	
	// MARK: - Init
	override func viewDidLoad(){
		super.viewDidLoad()
		
		// Set up the viewController
		view.backgroundColor = .white
		
		// Set up pickerView
		pickerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 150)
		pickerView.delegate = self
		pickerView.dataSource = self
		
		pickerView.selectRow(presetRowIndex, inComponent: presetComponentIndex, animated: false)
		
		view.addSubview(pickerView)
		pickerView.translatesAutoresizingMaskIntoConstraints = false
		pickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		pickerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
	}

	// MARK: - Functions
	// MARK: Delegate & DataSource methods
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return items[component].count
	}
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return items.count
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return items[component][row] as? String
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

		if let selectedItem = items[component][row] as? String {
			print(selectedItem)
			
			completionHandler?(selectedItem, row)
		}
	}
}
