//
//  Extensions+UICollectionView.swift
//  App
//
//  Created by MGAbouarab on 29/12/2023.
//

import UIKit

extension UICollectionViewFlowLayout {
    
    open override var flipsHorizontallyInOppositeLayoutDirection: Bool {
        return Language.isRTL() ? true : false
    }
    
}
