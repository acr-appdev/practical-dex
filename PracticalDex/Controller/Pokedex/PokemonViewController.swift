//
//  PokemonViewController.swift
//  PracticalDex
//
//  Created by Allan Rosa on 22/07/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//

import UIKit

// A general UIViewController with a pokemon property
class PokemonViewController: UIViewController {

	var pokemon: Pokemon = Pokemon()
	var selectedLanguage = Language(rawValue: UserDefaults.standard.value(forKey: K.App.Defaults.selectedLanguage) as! String) ?? .en
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		selectedLanguage = Language(rawValue: UserDefaults.standard.value(forKey: K.App.Defaults.selectedLanguage) as! String) ?? .en
	}
    
	init(pokemon pkmn: Pokemon){
		pokemon = pkmn
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		pokemon = Pokemon()
		super.init(coder: coder)
	}
}
