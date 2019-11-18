//
//  StaggeredGridLayout.swift
//  StaggeredGrid
//
//  Created by Manjeet kumar on 17/11/19.
//  Copyright © 2019 ManjeetKumar. All rights reserved.
//

import UIKit

protocol StaggeredGridLayoutProtocol: AnyObject {
    func collectionview(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat
    
   func collectionview(_ collectionView: UICollectionView, heightForAnnotationtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat
}

class GridLayoutAttributes: UICollectionViewLayoutAttributes {
    var photoHeight: CGFloat = 0
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as? GridLayoutAttributes
        if let copy = copy {
            copy.photoHeight = self.photoHeight
        }
        return copy
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let attributes = object as? GridLayoutAttributes {
            if attributes.photoHeight == self.photoHeight {
                return super.isEqual(object)
            }
        }
        return false
    }
    
}

class StaggeredGridLayout: UICollectionViewLayout {
    weak var delegate: StaggeredGridLayoutProtocol?
    
    private let numberOfColumns = 2
    private let cellPadding: CGFloat = 6
    
    private var cache: [GridLayoutAttributes] = []
    
    private var contentHeight: CGFloat = 0
    
    
    private var contentWidth: CGFloat {
      guard let collectionView = collectionView else {
        return 0
      }
      let insets = collectionView.contentInset
        // TODO: Try to remove insets
      return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override class var layoutAttributesClass: AnyClass {
        return GridLayoutAttributes.self
    }
    
    override var collectionViewContentSize: CGSize {
      return CGSize(width: contentWidth, height: contentHeight)
    }
    
    
    
    override func prepare() {
        guard cache.isEmpty, let collectionView = collectionView else {
            return
        }
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffsets: [CGFloat] = []
        for column in 0..<numberOfColumns {
            xOffsets.append(CGFloat(column) * columnWidth)
        }
        
        var column = 0
        var yOffsets: [CGFloat] = Array<CGFloat>.init(repeating: 0, count: numberOfColumns)
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let width = columnWidth - (2 * cellPadding)
            let photoHeight = delegate?.collectionview(collectionView, heightForPhotoAtIndexPath: indexPath, withWidth: width) ?? 100
            let annotationHeight = delegate?.collectionview(collectionView, heightForAnnotationtIndexPath: indexPath, withWidth: width) ?? 60
            let height = cellPadding + photoHeight + annotationHeight + cellPadding
            let frame = CGRect(x: xOffsets[column], y: yOffsets[column], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
              
            let attributes = GridLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            attributes.photoHeight = photoHeight
            cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffsets[column] = yOffsets[column] + height
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect)
        -> [UICollectionViewLayoutAttributes]? {
      var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
      
      // Loop through the cache and look for items in the rect
      for attributes in cache {
        if attributes.frame.intersects(rect) {
          visibleLayoutAttributes.append(attributes)
        }
      }
      return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath)
        -> UICollectionViewLayoutAttributes? {
      return cache[indexPath.item]
    }

}
