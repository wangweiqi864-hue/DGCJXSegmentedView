//
//  DGCJXSegmentedDotCell.swift
//  DGCJXSegmentedView
//
//  Created by jiaxin on 2018/12/28.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

open class DGCJXSegmentedDotCell: DGCJXSegmentedTitleCell {
    open var dotView = UIView()

    open override func commonInit() {
        super.commonInit()

        contentView.addSubview(dotView)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        guard let dgc_myItemModel = itemModel as? DGCJXSegmentedDotItemModel else {
            return
        }

        dotView.center = CGPoint(x: titleLabel.frame.maxX + dgc_myItemModel.dotOffset.x, y: titleLabel.frame.minY + dgc_myItemModel.dotOffset.y)
    }

    open override func reloadData(itemModel: DGCJXSegmentedBaseItemModel, selectedType: DGCJXSegmentedViewItemSelectedType) {
        super.reloadData(itemModel: itemModel, selectedType: selectedType )

        guard let dgc_myItemModel = itemModel as? DGCJXSegmentedDotItemModel else {
            return
        }

        dotView.backgroundColor = dgc_myItemModel.dotColor
        dotView.bounds = CGRect(x: 0, y: 0, width: dgc_myItemModel.dotSize.width, height: dgc_myItemModel.dotSize.height)
        dotView.isHidden = !dgc_myItemModel.dotState
        dotView.layer.cornerRadius = dgc_myItemModel.dotCornerRadius
    }
}
