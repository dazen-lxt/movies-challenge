//
//  UIView.swift
//  Challenge
//
//  Created by Carlos Mario Munoz Perez on 19/10/22.
//

import UIKit

extension UIView {

    func addBottomBorder(withColor color: CGColor, andThickness thickness: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color
        border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness)
        layer.addSublayer(border)
    }
}
