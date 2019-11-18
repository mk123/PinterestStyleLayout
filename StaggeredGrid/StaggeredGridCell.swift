//
//  StaggeredGridCell.swift
//  StaggeredGrid
//
//  Created by Manjeet kumar on 18/11/19.
//  Copyright © 2019 ManjeetKumar. All rights reserved.
//

import UIKit

class StaggeredGridCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var imageViewHeightLayoutConstraint: NSLayoutConstraint!
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? GridLayoutAttributes {
            imageViewHeightLayoutConstraint.constant = attributes.photoHeight
        }
        
    }
}
