//
//  GradientView.swift
//  Reminder
//
//  Created by Rusłan Chamski on 12/10/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit

class GradientView: UIView {

    // MARK: - Properties
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

    @IBInspectable var startColor: UIColor = .clear
    @IBInspectable var endColor: UIColor = .black

    @IBInspectable var startPoint: CGPoint = .init(x: 0, y: 0.5)
    @IBInspectable var endPoint: CGPoint = .init(x: 1, y: 0.5)

    let gradient: CAGradientLayer = CAGradientLayer()


    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
    }
    // MARK: - Draw
    override func draw(_ rect: CGRect) {
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.frame = CGRect(x: CGFloat(0),
                                y: CGFloat(0),
                                width: bounds.width,
                                height: bounds.height)
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.zPosition = -1
        layer.addSublayer(gradient)
    }
}
