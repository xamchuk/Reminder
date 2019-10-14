//
//  CircleView.swift
//  Reminder
//
//  Created by Rusłan Chamski on 12/10/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit

@IBDesignable
class CircleView: UIView {


    @IBInspectable var startColor: UIColor = .clear
    @IBInspectable var endColor: UIColor = .black

    @IBInspectable var startPoint: CGPoint = .init(x: 0, y: 0.5)
    @IBInspectable var endPoint: CGPoint = .init(x: 1, y: 0.5)

     @IBInspectable var lineWidth: CGFloat = 0

    let gradient: CAGradientLayer = CAGradientLayer()

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

         let shapeLayer = CAShapeLayer()
               let circularPath = UIBezierPath(arcCenter: .zero, radius: bounds.height / 2 - (lineWidth / 2), startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
               shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.black.cgColor
               shapeLayer.lineWidth = lineWidth
               shapeLayer.fillColor = UIColor.clear.cgColor
               shapeLayer.lineCap = CAShapeLayerLineCap.round
               shapeLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        self.layer.mask = shapeLayer
    }
}
