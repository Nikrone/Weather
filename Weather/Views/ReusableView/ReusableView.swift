//
//  ReusableView.swift
//  Weather
//
//  Created by Evgeniy Nosko on 7.07.23.
//

import UIKit

// MARK: - ReusableView

protocol ReusableView: AnyObject { }

extension ReusableView where Self: UIView {
    static var reuseID: String {
        return String(describing: classForCoder())
    }
}

// MARK: - NibLoadableView

protocol NibLoadableView: AnyObject { }

extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return String(describing: classForCoder())
    }
    
    static var nib: UINib {
        return UINib(nibName: nibName, bundle: nil)
    }
}

// MARK: - UITableView

extension UITableViewCell: ReusableView { }
extension UITableViewHeaderFooterView: ReusableView { }

extension UITableView {
    func registerCellNib<T: UITableViewCell & NibLoadableView>(ofType type: T.Type) {
        register(T.nib, forCellReuseIdentifier: T.reuseID)
    }
    
    func registerCellClass<T: UITableViewCell>(_ type: T.Type) {
        register(T.self, forCellReuseIdentifier: T.reuseID)
    }
    
    func dequeueCell<T: UITableViewCell>(ofType: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseID, for: indexPath) as? T else {
            fatalError("Class \(T.reuseID) is not registered in TableView")
        }
        return cell
    }
}

// MARK: - CollectionView

extension UICollectionReusableView: ReusableView { }

extension UICollectionView {
    func registerCellNib<T: UICollectionViewCell & NibLoadableView>(ofType type: T.Type) {
        register(T.nib, forCellWithReuseIdentifier: T.reuseID)
    }
    
    func registerCellClass<T: UICollectionViewCell>(_ type: T.Type) {
        register(type, forCellWithReuseIdentifier: T.reuseID)
    }
    
    func dequeueCell<T: UICollectionViewCell>(ofType type: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseID, for: indexPath) as? T else {
            fatalError("Class \(T.reuseID) is not registered in CollectionView")
        }
        return cell
    }
    
    func dequeueHeader<T: UICollectionReusableView>(ofType type: T.Type, for indexPath: IndexPath) -> T {
        guard let header = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.reuseID, for: indexPath) as? T else {
            fatalError("Class \(T.reuseID) is not registered in CollectionView")
        }
        return header
    }
    
    func dequeueFooter<T: UICollectionReusableView>(ofType type: T.Type, for indexPath: IndexPath) -> T {
        guard let footer = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: T.reuseID, for: indexPath) as? T else {
            fatalError("Class \(T.reuseID) is not registered in CollectionView")
        }
        return footer
    }
}
