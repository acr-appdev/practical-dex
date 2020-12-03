//
//  StatsViewController.swift
//  PracticalDex
//
//  Created by Allan Rosa on 22/07/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//

import UIKit

class StatsViewController: PokemonViewController {

	@IBOutlet weak var labelHP: UILabel!
	@IBOutlet weak var barHP: PlainHorizontalProgressBar!
	@IBOutlet weak var labelAtk: UILabel!
	@IBOutlet weak var barAtk: PlainHorizontalProgressBar!
	@IBOutlet weak var labelDef: UILabel!
	@IBOutlet weak var barDef: PlainHorizontalProgressBar!
	@IBOutlet weak var labelSpA: UILabel!
	@IBOutlet weak var barSpA: PlainHorizontalProgressBar!
	@IBOutlet weak var labelSpD: UILabel!
	@IBOutlet weak var barSpD: PlainHorizontalProgressBar!
	@IBOutlet weak var labelSpe: UILabel!
	@IBOutlet weak var barSpe: PlainHorizontalProgressBar!
	
	
	override func viewDidLoad() {
        super.viewDidLoad()

		configureInterface(with: self.pokemon)
		
        // Do any additional setup after loading the view.
    }
	
	private func configureInterface(with pkmn: Pokemon){
		labelHP.text  = String(pkmn.stats.base.hp )
		labelAtk.text = String(pkmn.stats.base.atk)
		labelDef.text = String(pkmn.stats.base.def)
		labelSpA.text = String(pkmn.stats.base.spa)
		labelSpD.text = String(pkmn.stats.base.spd)
		labelSpe.text = String(pkmn.stats.base.spe)
		
		barHP.color  = colorSelector(for: pkmn.stats.base.hp )
		barAtk.color = colorSelector(for: pkmn.stats.base.atk)
		barDef.color = colorSelector(for: pkmn.stats.base.def)
		barSpA.color = colorSelector(for: pkmn.stats.base.spa)
		barSpD.color = colorSelector(for: pkmn.stats.base.spd)
		barSpe.color = colorSelector(for: pkmn.stats.base.spe)
		
		barHP.progress  = generateBarSize(for: pkmn.stats.base.hp )
		barAtk.progress = generateBarSize(for: pkmn.stats.base.atk)
		barDef.progress = generateBarSize(for: pkmn.stats.base.def)
		barSpA.progress = generateBarSize(for: pkmn.stats.base.spa)
		barSpD.progress = generateBarSize(for: pkmn.stats.base.spd)
		barSpe.progress = generateBarSize(for: pkmn.stats.base.spe)
		
		
	}
	
	private func generateBarSize(for stat: Int) -> CGFloat {
		let percentage: CGFloat = CGFloat(stat * 2)/255.0
		return percentage
	}
}
