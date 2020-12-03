//
//  SettingsDetailViewController.swift
//  PracticalDex
//
//  Created by Allan Rosa on 02/10/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//

import UIKit


class SettingsDetailViewController: UIViewController {
	
	// MARK: - Properties
	var tableView: UITableView!
	var contents: [String] = []
	let reuseId = "SimpleCell"
	
	// MARK: - Init
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureUI()
	}
	
	// MARK: - Helper Functions
	
	func configureTableView() {
		tableView = UITableView()
		tableView.delegate = self
		tableView.dataSource = self
		tableView.rowHeight = 60
		
		tableView.register(SimpleCell.self, forCellReuseIdentifier: reuseId)
		view.addSubview(tableView)
		tableView.frame = view.frame
	}
	
	func configureUI(){
		configureTableView()
		
		navigationController?.isNavigationBarHidden = false
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationController?.navigationBar.isTranslucent = false
		navigationController?.navigationBar.barStyle = .black
		navigationController?.navigationBar.barTintColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
	}
	
}
//MARK: - Data Source & Delegate
extension SettingsDetailViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return contents.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: reuseId) as! SimpleCell
		cell.label.text = contents[indexPath.row]
		return cell
	}
	
	
}
