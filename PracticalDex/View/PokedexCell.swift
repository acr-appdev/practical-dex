//
//  PokedexViewCell.swift
//  PracticalDex
//
//  Created by Allan Rosa on 13/07/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//

import UIKit

class PokedexCell: UICollectionViewCell {
    
	@IBOutlet private weak var nameLabel: UILabel!
	@IBOutlet weak var spriteImageView: UIImageView!
	@IBOutlet weak var backgroundImageView: UIImageView!
	
	func configure(with pokemon: Pokemon){
		
		// Set up the background image view
		guard let bgImageName = UserDefaults.standard.string(forKey: K.App.Defaults.selectedWallpaper) else { return }
		backgroundImageView.image = UIImage(named: bgImageName)
		backgroundImageView.layer.cornerRadius = 10
		backgroundImageView.clipsToBounds = true
		backgroundImageView.layer.borderWidth = 2
		backgroundImageView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
		backgroundImageView.roundCorner(size: 10, bottomLeft: false, bottomRight: false)

		// Set up the name label
		nameLabel.text = String(format: "%03d", pokemon.number)
		nameLabel.text?.append(" - \(pokemon.name.capitalized)")
		nameLabel.textColor = .white
		nameLabel.shadowColor = .black
		nameLabel.shadowOffset = CGSize(width: 1, height: 1)
		nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
		nameLabel.adjustsFontSizeToFitWidth = true

		nameLabel.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 0.8)
		nameLabel.clipsToBounds = true
		nameLabel.layer.borderWidth = 2
		nameLabel.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
		
		nameLabel.roundCorner(size: 10, topLeft: false, topRight: false)

		// Set up the sprite view
		spriteImageView.image = pokemon.sprites.male
	}
}
