//
//  ReusableView.swift
//  Challenge
//
//  Created by Carlos Mario Munoz Perez on 16/10/22.
//

import UIKit

public protocol ReusableView: AnyObject {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {

    public static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableView {}

extension UICollectionReusableView: ReusableView {}
