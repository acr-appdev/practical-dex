//
//  BezierProgressBar.swift
//  PracticalDex
//
//  Created by Allan Rosa on 25/07/20.
//  Copyright © 2020 Allan Rosa. All rights reserved.
//

import UIKit

// @IBDesignable lets the class be rendered in Storyboard
@IBDesignable class PlainHorizontalProgressBar: UIView {
	// @IBInspectable enables us to define the property in Storyboard
    @IBInspectable var color: UIColor = .gray {
        didSet { setNeedsDisplay() }
    }
	// UIView.tintColor could be used to simplify the code if not implementing gradients

	// variable to control the progress
    var progress: CGFloat = 0 {
        didSet { setNeedsDisplay() }
    }

    private let progressLayer = CALayer()
    private let backgroundMask = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }

    private func setupLayers() {
        layer.addSublayer(progressLayer)
    }

    override func draw(_ rect: CGRect) {
        backgroundMask.path = UIBezierPath(roundedRect: rect, cornerRadius: rect.height * 0.25).cgPath
        layer.mask = backgroundMask

        let progressRect = CGRect(origin: .zero, size: CGSize(width: rect.width * progress, height: rect.height))

        progressLayer.frame = progressRect
        progressLayer.backgroundColor = color.cgColor
    }
}

