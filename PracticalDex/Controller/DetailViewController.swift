//
//  ViewController.swift
//  PracticalDex
//
//  Created by Allan Rosa on 15/07/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

	var pokemon = Pokemon()
	
	@IBOutlet weak var spriteImageView: UIImageView!
	@IBOutlet weak var primaryTypeLabel: UILabel!
	@IBOutlet weak var secondaryTypeLabel: UILabel!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var numberLabel: UILabel!
	@IBOutlet weak var generaLabel: UILabel!
	@IBOutlet weak var ability1Label: UILabel!
	@IBOutlet weak var ability2Label: UILabel!
	@IBOutlet weak var ability3Label: UILabel!
	
	override func viewDidLoad() {
        super.viewDidLoad()

		setupInterface(with: pokemon)
		// not working
		let swipeLeft: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(DetailViewController.swipeLeft))
		swipeLeft.direction = .left
		self.view!.addGestureRecognizer(swipeLeft)
        
    }
    
	
	private func setupInterface(with pokemon: Pokemon){
		spriteImageView.image = pokemon.sprites.male
		primaryTypeLabel.text = "\(pokemon.primaryType)"
		primaryTypeLabel.roundedEdges()
		primaryTypeLabel.backgroundColor = colorSelector(for: pokemon.primaryType)
//		switch the types to set the label background color
		if pokemon.secondaryType != nil {
			secondaryTypeLabel.text = "\(pokemon.secondaryType!)"
			secondaryTypeLabel.backgroundColor = colorSelector(for: pokemon.secondaryType!)
			secondaryTypeLabel.roundedEdges()
		} else {
			secondaryTypeLabel.isHidden = true
		}
		
		nameLabel.text = pokemon.name.capitalized
		nameLabel.roundedEdges()
		numberLabel.text = "#\(pokemon.number)"
		numberLabel.roundedEdges()
		
		if pokemon.abilities.count < 3{
			ability2Label.isHidden = true
			ability3Label.isHidden = true
		}
		//print(pokemon.abilities)
		pokemon.abilities.forEach({ ability in
			switch ability.slot {
				case 1:
					ability1Label.text = ability.ability.name.capitalized.replacingOccurrences(of: "-", with: " ")
					ability1Label.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
					ability1Label.roundedEdges()
					if ability.is_hidden {
						ability1Label.font = ability1Label.font.bold()
				}
				case 2:
					ability2Label.text = ability.ability.name.capitalized.replacingOccurrences(of: "-", with: " ")

					ability2Label.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
					ability2Label.roundedEdges()
					ability2Label.isHidden = false
					if ability.is_hidden {
						self.ability2Label.font = ability2Label.font.bold()
				}
				case 3:
					ability3Label.text = ability.ability.name.capitalized.replacingOccurrences(of: "-", with: " ")
					ability3Label.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
					ability3Label.roundedEdges()
					ability3Label.isHidden = false
					if ability.is_hidden {
						self.ability3Label.font = ability3Label.font.bold()
				}
				default:
					print("Error Setting up AbilityLabels")
				}
			})
		
		
		// set generaLabel
		
	}

	@IBAction func backButtonPressed(_ sender: UIButton) {
		self.dismiss(animated: true, completion: nil)
	}
	
	// not working
	@objc private func swipeLeft(gestureRecognizer: UISwipeGestureRecognizer){
		print("swipeLeft to Return triggered")
		self.dismiss(animated: true, completion: nil)
	}
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
