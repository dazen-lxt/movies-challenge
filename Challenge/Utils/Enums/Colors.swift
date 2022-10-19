//
//  Colors.swift
//  Challenge
//
//  Created by Carlos Mario Munoz Perez on 16/10/22.
//

import UIKit

enum Colors {
    static let defaultTextColor: UIColor = UIColor.dynamicColor(
        light: UIColor.color(hexInt: 0x333333),
        dark: UIColor.color(hexInt: 0xCCCCCC)
    )
    static let defaultBackground: UIColor = UIColor.dynamicColor(
        light: UIColor.color(hexInt: 0xFFFFFF),
        dark: UIColor.color(hexInt: 0x000000)
    )
    static let itemBackground: UIColor = UIColor.dynamicColor(
        light: UIColor.color(hexInt: 0xFFE0FF),
        dark: UIColor.color(hexInt: 0x4b0082)
    )
    static let tintColor: UIColor = UIColor.dynamicColor(
        light: UIColor.color(hexInt: 0x4b0082),
        dark: UIColor.color(hexInt: 0xFFE0FF)
    )
    static let inverseTintColor: UIColor = UIColor.dynamicColor(
        light: UIColor.color(hexInt: 0xFFE0FF),
        dark: UIColor.color(hexInt: 0x4b0082)
    )
}
