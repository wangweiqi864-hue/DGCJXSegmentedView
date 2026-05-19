//
//  DGCJXSegmentedTitleAttributeCell.swift
//  DGCJXSegmentedView
//
//  Created by jiaxin on 2019/1/3.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

open class DGCJXSegmentedTitleAttributeCell: DGCJXSegmentedBaseCell {
    open var titleLabel = UILabel()

    open override func commonInit() {
        super.commonInit()

        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)

        let dgc_centerX = NSLayoutConstraint(item: titleLabel, attribute: .dgc_centerX, relatedBy: .equal, toItem: contentView, attribute: .dgc_centerX, multiplier: 1, constant: 0)
        contentView.addConstraint(dgc_centerX)
        let dgc_centerY = NSLayoutConstraint(item: titleLabel, attribute: .dgc_centerY, relatedBy: .equal, toItem: contentView, attribute: .dgc_centerY, multiplier: 1, constant: 0)
        contentView.addConstraint(dgc_centerY)
    }

    open override func reloadData(itemModel: DGCJXSegmentedBaseItemModel, selectedType: DGCJXSegmentedViewItemSelectedType) {
        super.reloadData(itemModel: itemModel, selectedType: selectedType )

        guard let dgc_myItemModel = itemModel as? DGCJXSegmentedTitleAttributeItemModel else {
            return
        }

        titleLabel.numberOfLines = dgc_myItemModel.titleNumberOfLines
        if dgc_myItemModel.isSelected && dgc_myItemModel.selectedAttributedTitle != nil {
            titleLabel.attributedText = dgc_myItemModel.selectedAttributedTitle
        }else {
            titleLabel.attributedText = dgc_myItemModel.attributedTitle
        }
    }
}
