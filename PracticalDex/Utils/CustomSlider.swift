//
//  CustomSlider.swift
//  PracticalDex
//
//  Created by Allan Rosa on 16/11/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//

import UIKit

class CustomSlider: UISlider {
	private let trackHeight: CGFloat = 10
	
	override func trackRect(forBounds bounds: CGRect) -> CGRect {
		let point = CGPoint(x: bounds.minX, y: bounds.midY)
		let length = CGSize(width: bounds.width, height: trackHeight)
		let track = CGRect(origin: point, size: length)
		return track
	}
}
