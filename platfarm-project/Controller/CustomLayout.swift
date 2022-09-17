//
//  CustomLayout.swift
//  platfarm-project
//
//  Created by HappyDuck on 2022/09/17.
//

import UIKit

protocol CustomLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, xOffset indexPath: IndexPath) -> CGFloat
}

class CustomLayout: UICollectionViewLayout {
    
    weak var delegate: CustomLayoutDelegate!
    
    var numberOfColumns = 1
    
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    fileprivate var contentHeight: CGFloat = 0
    fileprivate var contentWidth: CGFloat = 130
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
       
            
            var yOffsets = [CGFloat](repeating: 0, count: numberOfColumns)
            var column = 0
            for item in 0..<collectionView!.numberOfItems(inSection: 0) {
                
                let indexPath = IndexPath(item: item, section: 0)
                let height = delegate.collectionView(collectionView!, xOffset: indexPath)

                var frame = CGRect()
                if(item == 0) {
                    frame = CGRect(x: 130, y: yOffsets[column], width: contentWidth, height: 140)
                } else if(item % 2 == 0) {
                    frame = CGRect(x: 250, y: yOffsets[column], width: contentWidth, height: 140)
                } else {
                    frame = CGRect(x: 10, y: yOffsets[column], width: contentWidth, height: 140)
                }
                
                contentHeight = max(contentHeight, frame.maxY)
                
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = frame
                cache.append(attributes)
                
                
                yOffsets[column] = yOffsets[column] + height + 10
                column = column >= (numberOfColumns - 1) ? 0 : column+1
            }
        
        return cache[indexPath.item]
    }
    
    override func prepare() {
        super.prepare()
        
        if cache.isEmpty {
            
            var yOffsets = [CGFloat](repeating: 0, count: numberOfColumns)
            var column = 0
            for item in 0..<collectionView!.numberOfItems(inSection: 0) {
                
                let indexPath = IndexPath(item: item, section: 0)
                let height = delegate.collectionView(collectionView!, xOffset: indexPath)

                var frame = CGRect()
                if(item == 0) {
                    frame = CGRect(x: 130, y: yOffsets[column], width: contentWidth, height: 140)
                } else if(item % 2 == 0) {
                    frame = CGRect(x: 250, y: yOffsets[column], width: contentWidth, height: 140)
                } else {
                    frame = CGRect(x: 10, y: yOffsets[column], width: contentWidth, height: 140)
                }
                
                contentHeight = max(contentHeight, frame.maxY)
                
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = frame
                cache.append(attributes)
                
                
                yOffsets[column] = yOffsets[column] + height + 10
                column = column >= (numberOfColumns - 1) ? 0 : column+1
            }
        }
    }
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cache {
            if CGRectIntersectsRect(attributes.frame, rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
}
