//
//  DGCJXSegmentedTitleGradientCell.swift
//  DGCJXSegmentedView
//
//  Created by jiaxin on 2019/1/23.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

open class DGCJXSegmentedTitleGradientCell: DGCJXSegmentedTitleCell {
    public let gradientLayer = CAGradientLayer()
    private var dgc_canStartSelectedAnimation: Bool = false

    open override func commonInit() {
        super.commonInit()

        titleLabel.removeFromSuperview()
        maskTitleLabel.removeFromSuperview()

        gradientLayer.colors = [UIColor.red.cgColor, UIColor.yellow.cgColor, UIColor.green.cgColor]
        contentView.layer.addSublayer(gradientLayer)
        gradientLayer.mask = titleLabel.layer
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        CATransaction.begin()
        CATransaction.setDisableActions(true)
        gradientLayer.frame = titleLabel.frame
        CATransaction.commit()
        titleLabel.frame = gradientLayer.bounds
    }

    open override func reloadData(itemModel: DGCJXSegmentedBaseItemModel, selectedType: DGCJXSegmentedViewItemSelectedType) {
        super.reloadData(itemModel: itemModel, selectedType: selectedType)

        guard let dgc_myItemModel = itemModel as? DGCJXSegmentedTitleGradientItemModel else {
            return
        }

        if dgc_myItemModel.isSelectedAnimable && dgc_canStartSelectedAnimation(itemModel: dgc_myItemModel, selectedType: selectedType) {
            let dgc_closure: JXSegmentedCellSelectedAnimationClosure = {[weak self] (percent) in
                if dgc_myItemModel.isSelected {
                    dgc_myItemModel.titleCurrentGradientColors = DGCJXSegmentedViewTool.interpolateColors(from: dgc_myItemModel.titleNormalGradientColors, to: dgc_myItemModel.titleSelectedGradientColors, percent: percent)
                }else {
                    dgc_myItemModel.titleCurrentGradientColors = DGCJXSegmentedViewTool.interpolateColors(from: dgc_myItemModel.titleSelectedGradientColors, to: dgc_myItemModel.titleNormalGradientColors, percent: percent)
                }
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                self?.gradientLayer.colors = dgc_myItemModel.titleCurrentGradientColors
                CATransaction.commit()
                self?.setNeedsLayout()
                self?.layoutIfNeeded()
            }
            appendSelectedAnimationClosure(dgc_closure: dgc_closure)
            dgc_canStartSelectedAnimation = true
            startSelectedAnimationIfNeeded(itemModel: dgc_myItemModel, selectedType: selectedType)
            dgc_canStartSelectedAnimation = false
        }else {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            gradientLayer.startPoint = dgc_myItemModel.titleGradientStartPoint
            gradientLayer.endPoint = dgc_myItemModel.titleGradientEndPoint
            gradientLayer.colors = dgc_myItemModel.titleCurrentGradientColors
            CATransaction.commit()
        }
    }

    open override func startSelectedAnimationIfNeeded(itemModel: DGCJXSegmentedBaseItemModel, selectedType: DGCJXSegmentedViewItemSelectedType) {
        if dgc_canStartSelectedAnimation {
            super.startSelectedAnimationIfNeeded(itemModel: itemModel, selectedType: selectedType)
        }
    }
}
