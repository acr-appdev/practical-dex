//
//  EvolutionChainViewController.swift
//  PracticalDex
//
//  Created by Allan Rosa on 22/07/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//

import UIKit

class EvolutionViewController: PokemonViewController {

	@IBOutlet weak var label: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		label.text = ("EvolutionViewController: \(pokemon.name)")
		
		// Do any additional setup after loading the view.
	}
	
}
