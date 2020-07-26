//
//  PokedexUtils.swift
//  PracticalDex
//
//  Created by Allan Rosa on 18/07/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//

import UIKit

func colorSelector(for type: Type) -> UIColor{
	switch type {
		case .Bug:
			return #colorLiteral(red: 0.6589999795, green: 0.7220000029, blue: 0.125, alpha: 1)
		case .Dark:
			return #colorLiteral(red: 0.4390000105, green: 0.3449999988, blue: 0.2820000052, alpha: 1)
		case .Dragon:
			return #colorLiteral(red: 0.4399999976, green: 0.2199999988, blue: 0.9739999771, alpha: 1)
		case .Electric:
			return #colorLiteral(red: 0.9739999771, green: 0.8119999766, blue: 0.1899999976, alpha: 1)
		case .Fairy:
			return #colorLiteral(red: 0.9330000281, green: 0.6000000238, blue: 0.6750000119, alpha: 1)
		case .Fighting:
			return #colorLiteral(red: 0.753000021, green: 0.1879999936, blue: 0.1570000052, alpha: 1)
		case .Fire:
			return #colorLiteral(red: 0.9409999847, green: 0.5019999743, blue: 0.1920000017, alpha: 1)
		case .Flying:
			return #colorLiteral(red: 0.6589999795, green: 0.5640000105, blue: 0.9409999847, alpha: 1)
		case .Ghost:
			return #colorLiteral(red: 0.4390000105, green: 0.3449999988, blue: 0.5960000157, alpha: 1)
		case .Grass:
			return #colorLiteral(red: 0.4709999859, green: 0.7839999795, blue: 0.3140000105, alpha: 1)
		case .Ground:
			return #colorLiteral(red: 0.878000021, green: 0.753000021, blue: 0.4120000005, alpha: 1)
		case .Ice:
			return #colorLiteral(red: 0.5970000029, green: 0.8470000029, blue: 0.8470000029, alpha: 1)
		case .Normal:
			return #colorLiteral(red: 0.6579999924, green: 0.6589999795, blue: 0.4690000117, alpha: 1)
		case .Poison:
			return #colorLiteral(red: 0.625, green: 0.25, blue: 0.6259999871, alpha: 1)
		case .Psychic:
			return #colorLiteral(red: 0.9750000238, green: 0.3449999988, blue: 0.5320000052, alpha: 1)
		case .Rock:
			return #colorLiteral(red: 0.7200000286, green: 0.628000021, blue: 0.2210000008, alpha: 1)
		case .Steel :
			return #colorLiteral(red: 0.7220000029, green: 0.7210000157, blue: 0.8149999976, alpha: 1)
		case .Water:
			return #colorLiteral(red: 0.4050000012, green: 0.5640000105, blue: 0.9409999847, alpha: 1)
		default:
			return #colorLiteral(red: 0.4120000005, green: 0.628000021, blue: 0.5659999847, alpha: 1)
	}
}

// should implement a gradient return later
func colorSelector(for stat: Int) -> UIColor {
	if 0...60 ~= stat { return .red }
	if 61...85 ~= stat { return .orange }
	if 86...100 ~= stat { return .yellow }
	if 100...999 ~= stat { return .green }
	else { return .gray }
}

extension UILabel {
	func roundedEdges(withSize size: CGFloat = 10.0){
		self.clipsToBounds = true
		layer.cornerRadius = size
	}
}

extension UIFont {
	func toggleBold(isBold: Bool) -> UIFont {
		if isBold {
			return UIFont.systemFont(ofSize: self.pointSize)
		} else {
			return UIFont.boldSystemFont(ofSize: self.pointSize)
		}
	}
}

