//
//  UICollectionViewCell+ReusableCell.swift
//  Challenge
//
//  Created by Carlos Mario Munoz Perez on 16/10/22.
//

import UIKit

extension UICollectionView {

    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell: T = dequeueReusableCell(
            withReuseIdentifier: T.defaultReuseIdentifier,
            for: indexPath
        ) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        return cell
    }
}
