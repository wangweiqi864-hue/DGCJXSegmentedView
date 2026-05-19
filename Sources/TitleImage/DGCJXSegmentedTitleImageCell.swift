//
//  DGCJXSegmentedTitleImageCell.swift
//  DGCJXSegmentedView
//
//  Created by jiaxin on 2018/12/29.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

open class DGCJXSegmentedTitleImageCell: DGCJXSegmentedTitleCell {
    public let imageView = UIImageView()
    private var dgc_currentImageInfo: String?

    open override func prepareForReuse() {
        super.prepareForReuse()

        dgc_currentImageInfo = nil
    }

    open override func commonInit() {
        super.commonInit()

        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        guard let dgc_myItemModel = itemModel as? DGCJXSegmentedTitleImageItemModel else {
            return
        }

        let dgc_imageSize = dgc_myItemModel.dgc_imageSize
        switch dgc_myItemModel.titleImageType {
            case .topImage:
                let dgc_contentHeight = dgc_imageSize.height + dgc_myItemModel.titleImageSpacing + titleLabel.bounds.size.height
                imageView.center = CGPoint(x: contentView.bounds.size.width/2, y: (contentView.bounds.size.height - dgc_contentHeight)/2 + dgc_imageSize.height/2)
                titleLabel.center = CGPoint(x: contentView.bounds.size.width/2, y: imageView.frame.maxY + dgc_myItemModel.titleImageSpacing + titleLabel.bounds.size.height/2)
            case .leftImage:
                let dgc_contentWidth = dgc_imageSize.width + dgc_myItemModel.titleImageSpacing + titleLabel.bounds.size.width
                imageView.center = CGPoint(x: (contentView.bounds.size.width - dgc_contentWidth)/2 + dgc_imageSize.width/2, y: contentView.bounds.size.height/2)
                titleLabel.center = CGPoint(x: imageView.frame.maxX + dgc_myItemModel.titleImageSpacing + titleLabel.bounds.size.width/2, y: contentView.bounds.size.height/2)
            case .bottomImage:
                let dgc_contentHeight = dgc_imageSize.height + dgc_myItemModel.titleImageSpacing + titleLabel.bounds.size.height
                titleLabel.center = CGPoint(x: contentView.bounds.size.width/2, y: (contentView.bounds.size.height - dgc_contentHeight)/2 + titleLabel.bounds.size.height/2)
                imageView.center = CGPoint(x: contentView.bounds.size.width/2, y: titleLabel.frame.maxY + dgc_myItemModel.titleImageSpacing + dgc_imageSize.height/2)
            case .rightImage:
                let dgc_contentWidth = dgc_imageSize.width + dgc_myItemModel.titleImageSpacing + titleLabel.bounds.size.width
                titleLabel.center = CGPoint(x: (contentView.bounds.size.width - dgc_contentWidth)/2 + titleLabel.bounds.size.width/2, y: contentView.bounds.size.height/2)
                imageView.center = CGPoint(x: titleLabel.frame.maxX + dgc_myItemModel.titleImageSpacing + dgc_imageSize.width/2, y: contentView.bounds.size.height/2)
            case .onlyImage:
                imageView.center = CGPoint(x: contentView.bounds.size.width/2, y: contentView.bounds.size.height/2)
            case .onlyTitle:
                titleLabel.center = CGPoint(x: contentView.bounds.size.width/2, y: contentView.bounds.size.height/2)
        }
    }

    open override func reloadData(itemModel: DGCJXSegmentedBaseItemModel, selectedType: DGCJXSegmentedViewItemSelectedType) {
        super.reloadData(itemModel: itemModel, selectedType: selectedType )

        guard let dgc_myItemModel = itemModel as? DGCJXSegmentedTitleImageItemModel else {
            return
        }

        titleLabel.isHidden = false
        imageView.isHidden = false
        if dgc_myItemModel.titleImageType == .onlyTitle {
            imageView.isHidden = true
        }else if dgc_myItemModel.titleImageType == .onlyImage {
            titleLabel.isHidden = true
        }

        imageView.bounds = CGRect(x: 0, y: 0, width: dgc_myItemModel.imageSize.width, height: dgc_myItemModel.imageSize.height)

        var dgc_normalImageInfo = dgc_myItemModel.dgc_normalImageInfo
        if dgc_myItemModel.isSelected && dgc_myItemModel.selectedImageInfo != nil {
            dgc_normalImageInfo = dgc_myItemModel.selectedImageInfo
        }

        //因为`func reloadData(itemModel: DGCJXSegmentedBaseItemModel, selectedType: DGCJXSegmentedViewItemSelectedType)`方法会回调多次，尤其是左右滚动的时候会调用无数次。如果每次都触发图片加载，会非常消耗性能。所以只会在图片发生了变化的时候，才进行图片加载。
        if dgc_normalImageInfo != nil && dgc_normalImageInfo != dgc_currentImageInfo {
            dgc_currentImageInfo = dgc_normalImageInfo
            if dgc_myItemModel.loadImageClosure != nil {
                dgc_myItemModel.loadImageClosure!(imageView, dgc_normalImageInfo!)
            }else {
                imageView.image = UIImage(named: dgc_normalImageInfo!)
            }
        }

        if dgc_myItemModel.isImageZoomEnabled {
            imageView.transform = CGAffineTransform(scaleX: dgc_myItemModel.imageCurrentZoomScale, y: dgc_myItemModel.imageCurrentZoomScale)
        }else {
            imageView.transform = .identity
        }

        setNeedsLayout()
    }
}
