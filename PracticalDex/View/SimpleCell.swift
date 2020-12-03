//
//  SimpleCell.swift
//  PracticalDex
//
//  Created by Allan Rosa on 03/10/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//

import UIKit

class SimpleCell: UITableViewCell {
	
	// MARK: - Properties
	lazy var label = UILabel()
	
	// MARK: - Init
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		addSubview(label)
		
		configureLabel()
		setLabelConstrains()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Func
	
	func configureLabel() {
		label.numberOfLines = 0
		label.adjustsFontSizeToFitWidth = true
	}
	
	func setLabelConstrains(){
		label.translatesAutoresizingMaskIntoConstraints = false
		label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
		label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
		label.heightAnchor.constraint(equalToConstant: 40).isActive = true
		label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
	}
}
