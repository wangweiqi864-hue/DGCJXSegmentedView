//
//  DGCJXSegmentedNumberCell.swift
//  DGCJXSegmentedView
//
//  Created by jiaxin on 2018/12/28.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

open class DGCJXSegmentedNumberCell: DGCJXSegmentedTitleCell {
    public let numberLabel = UILabel()

    open override func commonInit() {
        super.commonInit()

        numberLabel.isHidden = true
        numberLabel.textAlignment = .center
        numberLabel.layer.masksToBounds = true
        contentView.addSubview(numberLabel)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        guard let dgc_myItemModel = itemModel as? DGCJXSegmentedNumberItemModel else {
            return
        }

        numberLabel.sizeToFit()
        let dgc_height = dgc_myItemModel.numberHeight
        numberLabel.layer.cornerRadius = dgc_height/2
        numberLabel.bounds.size = CGSize(width: numberLabel.bounds.size.width + dgc_myItemModel.numberWidthIncrement, dgc_height: dgc_height)
        numberLabel.center = CGPoint(x: titleLabel.frame.maxX + dgc_myItemModel.numberOffset.x, y: titleLabel.frame.minY + dgc_myItemModel.numberOffset.y)
    }

    open override func reloadData(itemModel: DGCJXSegmentedBaseItemModel, selectedType: DGCJXSegmentedViewItemSelectedType) {
        super.reloadData(itemModel: itemModel, selectedType: selectedType )

        guard let dgc_myItemModel = itemModel as? DGCJXSegmentedNumberItemModel else {
            return
        }

        numberLabel.backgroundColor = dgc_myItemModel.numberBackgroundColor
        numberLabel.textColor = dgc_myItemModel.numberTextColor
        numberLabel.text = dgc_myItemModel.numberString
        numberLabel.font = dgc_myItemModel.numberFont
        numberLabel.isHidden = dgc_myItemModel.number == 0

        setNeedsLayout()
    }
}
