//
//  PokedexViewCell.swift
//  PracticalDex
//
//  Created by Allan Rosa on 13/07/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//

import UIKit

class PokedexViewCell: UICollectionViewCell {
    
	@IBOutlet private weak var nameLabel: UILabel!
	@IBOutlet weak var spriteImageView: UIImageView!
	
	func configure(with pokemon: Pokemon){
		
		self.layer.cornerRadius = 10
		
		nameLabel.text = String(format: "%03d", pokemon.number)
		nameLabel.text?.append(" - \(pokemon.name.capitalized)")
		//nameLabel.text = pokemon.name
		nameLabel.backgroundColor = .blue
		nameLabel.textColor = .white
		spriteImageView.image = pokemon.sprites.normal
		
		self.backgroundColor = UIColor(red: 1.0, green: 0.1, blue: 0.1, alpha: 0.5)
			
		print("The cell for \(nameLabel.text!) was set")
	}
}
