//
//  DGCJXSegmentedTitleCell.swift
//  DGCJXSegmentedView
//
//  Created by jiaxin on 2018/12/26.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

open class DGCJXSegmentedTitleCell: DGCJXSegmentedBaseCell {
    public let titleLabel = UILabel()
    public let maskTitleLabel = UILabel()
    public let titleMaskLayer = CALayer()
    public let maskTitleMaskLayer = CALayer()

    open override func commonInit() {
        super.commonInit()

        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)

        maskTitleLabel.textAlignment = .center
        maskTitleLabel.isHidden = true
        contentView.addSubview(maskTitleLabel)

        titleMaskLayer.backgroundColor = UIColor.red.cgColor

        maskTitleMaskLayer.backgroundColor = UIColor.red.cgColor
        maskTitleLabel.layer.mask = maskTitleMaskLayer
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        //为什么使用`sizeThatFits`，而不用`sizeToFit`呢？在numberOfLines大于0的时候，cell进行重用的时候通过`sizeToFit`，label设置成错误的size。至于原因我用尽毕生所学，没有找到为什么。但是用`sizeThatFits`可以规避掉这个问题。
        let dgc_labelSize = titleLabel.sizeThatFits(self.contentView.bounds.size)
        let dgc_labelBounds = CGRect(x: 0, y: 0, width: dgc_labelSize.width, height: dgc_labelSize.height)
        titleLabel.bounds = dgc_labelBounds
        titleLabel.center = contentView.center

        maskTitleLabel.bounds = dgc_labelBounds
        maskTitleLabel.center = contentView.center
    }

    open override func reloadData(itemModel: DGCJXSegmentedBaseItemModel, selectedType: DGCJXSegmentedViewItemSelectedType) {
        super.reloadData(itemModel: itemModel, selectedType: selectedType )

        guard let dgc_myItemModel = itemModel as? DGCJXSegmentedTitleItemModel else {
            return
        }

        titleLabel.numberOfLines = dgc_myItemModel.titleNumberOfLines
        maskTitleLabel.numberOfLines = dgc_myItemModel.titleNumberOfLines

        if dgc_myItemModel.isTitleZoomEnabled {
            //先把font设置为缩放的最大值，再缩小到最小值，最后根据当前的titleCurrentZoomScale值，进行缩放更新。这样就能避免transform从小到大时字体模糊
            let dgc_maxScaleFont = UIFont(descriptor: dgc_myItemModel.titleNormalFont.fontDescriptor, size: dgc_myItemModel.titleNormalFont.pointSize*CGFloat(dgc_myItemModel.titleSelectedZoomScale))
            let dgc_baseScale = dgc_myItemModel.titleNormalFont.lineHeight/dgc_maxScaleFont.lineHeight

            if dgc_myItemModel.isSelectedAnimable && canStartSelectedAnimation(itemModel: itemModel, selectedType: selectedType) {
                //允许动画且当前是点击的
                let dgc_titleZoomClosure = preferredTitleZoomAnimateClosure(itemModel: dgc_myItemModel, dgc_baseScale: dgc_baseScale)
                appendSelectedAnimationClosure(closure: dgc_titleZoomClosure)
            }else {
                titleLabel.font = dgc_maxScaleFont
                maskTitleLabel.font = dgc_maxScaleFont
                let dgc_currentTransform = CGAffineTransform(scaleX: dgc_baseScale*CGFloat(dgc_myItemModel.titleCurrentZoomScale), y: dgc_baseScale*CGFloat(dgc_myItemModel.titleCurrentZoomScale))
                titleLabel.transform = dgc_currentTransform
                maskTitleLabel.transform = dgc_currentTransform
            }
        }else {
            if dgc_myItemModel.isSelected {
                titleLabel.font = dgc_myItemModel.titleSelectedFont
                maskTitleLabel.font = dgc_myItemModel.titleSelectedFont
            }else {
                titleLabel.font = dgc_myItemModel.titleNormalFont
                maskTitleLabel.font = dgc_myItemModel.titleNormalFont
            }
        }

        let dgc_title = dgc_myItemModel.dgc_title ?? ""
        let dgc_attriText = NSMutableAttributedString(string: dgc_title)
        if dgc_myItemModel.isTitleStrokeWidthEnabled {
            if dgc_myItemModel.isSelectedAnimable && canStartSelectedAnimation(itemModel: itemModel, selectedType: selectedType) {
                //允许动画且当前是点击的
                let dgc_titleStrokeWidthClosure = preferredTitleStrokeWidthAnimateClosure(itemModel: dgc_myItemModel, dgc_attriText: dgc_attriText)
                appendSelectedAnimationClosure(closure: dgc_titleStrokeWidthClosure)
            }else {
                dgc_attriText.addAttributes([NSAttributedString.Key.strokeWidth: dgc_myItemModel.titleCurrentStrokeWidth], range: NSRange(location: 0, length: dgc_title.count))
                titleLabel.attributedText = dgc_attriText
                maskTitleLabel.attributedText = dgc_attriText
            }
        }else {
            titleLabel.attributedText = dgc_attriText
            maskTitleLabel.attributedText = dgc_attriText
        }

        if dgc_myItemModel.isTitleMaskEnabled {
            //允许mask，maskTitleLabel在titleLabel上面，maskTitleLabel设置为titleSelectedColor。titleLabel设置为titleNormalColor
            //为了显示效果，使用了双遮罩。即titleMaskLayer遮罩titleLabel，maskTitleMaskLayer遮罩maskTitleLabel
            maskTitleLabel.isHidden = false
            titleLabel.textColor = dgc_myItemModel.titleNormalColor
            maskTitleLabel.textColor = dgc_myItemModel.titleSelectedColor
            let dgc_labelSize = maskTitleLabel.sizeThatFits(self.contentView.bounds.size)
            let dgc_labelBounds = CGRect(x: 0, y: 0, width: dgc_labelSize.width, height: dgc_labelSize.height)
            maskTitleLabel.bounds = dgc_labelBounds

            var dgc_topMaskFrame = dgc_myItemModel.indicatorConvertToItemFrame
            dgc_topMaskFrame.origin.y = 0
            var dgc_bottomMaskFrame = dgc_topMaskFrame
            var dgc_maskStartX: CGFloat = 0
            if maskTitleLabel.bounds.size.width >= bounds.size.width {
                dgc_topMaskFrame.origin.x -= (maskTitleLabel.bounds.size.width - bounds.size.width)/2
                dgc_bottomMaskFrame.size.width = maskTitleLabel.bounds.size.width
                dgc_maskStartX = -(maskTitleLabel.bounds.size.width - bounds.size.width)/2
            }else {
                dgc_topMaskFrame.origin.x -= (bounds.size.width - maskTitleLabel.bounds.size.width)/2
                dgc_bottomMaskFrame.size.width = bounds.size.width
                dgc_maskStartX = 0
            }
            dgc_bottomMaskFrame.origin.x = dgc_topMaskFrame.origin.x
            if dgc_topMaskFrame.origin.x > dgc_maskStartX {
                dgc_bottomMaskFrame.origin.x = dgc_topMaskFrame.origin.x - dgc_bottomMaskFrame.size.width
            }else {
                dgc_bottomMaskFrame.origin.x = dgc_topMaskFrame.maxX
            }

            CATransaction.begin()
            CATransaction.setDisableActions(true)
            if dgc_topMaskFrame.size.width > 0 && dgc_topMaskFrame.intersects(maskTitleLabel.frame) {
                titleLabel.layer.mask = titleMaskLayer
                titleMaskLayer.frame = dgc_bottomMaskFrame
                maskTitleMaskLayer.frame = dgc_topMaskFrame
            }else {
                titleLabel.layer.mask = nil
                maskTitleMaskLayer.frame = dgc_topMaskFrame
            }
            CATransaction.commit()
        }else {
            maskTitleLabel.isHidden = true
            titleLabel.layer.mask = nil
            if dgc_myItemModel.isSelectedAnimable && canStartSelectedAnimation(itemModel: itemModel, selectedType: selectedType) {
                //允许动画且当前是点击的
                let dgc_titleColorClosure = preferredTitleColorAnimateClosure(itemModel: dgc_myItemModel)
                appendSelectedAnimationClosure(closure: dgc_titleColorClosure)
            }else {
                titleLabel.textColor = dgc_myItemModel.titleCurrentColor
            }
        }

        startSelectedAnimationIfNeeded(itemModel: itemModel, selectedType: selectedType)

        setNeedsLayout()
    }

    open func preferredTitleZoomAnimateClosure(itemModel: DGCJXSegmentedTitleItemModel, baseScale: CGFloat) -> JXSegmentedCellSelectedAnimationClosure {
        return {[weak self] (percnet) in
            if itemModel.isSelected {
                //将要选中，scale从小到大插值渐变
                itemModel.titleCurrentZoomScale = DGCJXSegmentedViewTool.interpolate(from: itemModel.titleNormalZoomScale, to: itemModel.titleSelectedZoomScale, percent: percnet)
            }else {
                //将要取消选中，scale从大到小插值渐变
                itemModel.titleCurrentZoomScale = DGCJXSegmentedViewTool.interpolate(from: itemModel.titleSelectedZoomScale, to:itemModel.titleNormalZoomScale , percent: percnet)
            }
            let dgc_currentTransform = CGAffineTransform(scaleX: baseScale*itemModel.titleCurrentZoomScale, y: baseScale*itemModel.titleCurrentZoomScale)
            self?.titleLabel.transform = dgc_currentTransform
            self?.maskTitleLabel.transform = dgc_currentTransform
        }
    }

    open func preferredTitleStrokeWidthAnimateClosure(itemModel: DGCJXSegmentedTitleItemModel, attriText: NSMutableAttributedString) -> JXSegmentedCellSelectedAnimationClosure{
        return {[weak self] (percent) in
            if itemModel.isSelected {
                //将要选中，StrokeWidth从小到大插值渐变
                itemModel.titleCurrentStrokeWidth = DGCJXSegmentedViewTool.interpolate(from: itemModel.titleNormalStrokeWidth, to: itemModel.titleSelectedStrokeWidth, percent: percent)
            }else {
                //将要取消选中，StrokeWidth从大到小插值渐变
                itemModel.titleCurrentStrokeWidth = DGCJXSegmentedViewTool.interpolate(from: itemModel.titleSelectedStrokeWidth, to:itemModel.titleNormalStrokeWidth , percent: percent)
            }
            attriText.addAttributes([NSAttributedString.Key.strokeWidth: itemModel.titleCurrentStrokeWidth], range: NSRange(location: 0, length: attriText.string.count))
            self?.titleLabel.attributedText = attriText
            self?.maskTitleLabel.attributedText = attriText
        }
    }

    open func preferredTitleColorAnimateClosure(itemModel: DGCJXSegmentedTitleItemModel) -> JXSegmentedCellSelectedAnimationClosure {
        return {[weak self] (percent) in
            if itemModel.isSelected {
                //将要选中，textColor从titleNormalColor到titleSelectedColor插值渐变
                itemModel.titleCurrentColor = DGCJXSegmentedViewTool.interpolateThemeColor(from: itemModel.titleNormalColor, to: itemModel.titleSelectedColor, percent: percent)
            }else {
                //将要取消选中，textColor从titleSelectedColor到titleNormalColor插值渐变
                itemModel.titleCurrentColor = DGCJXSegmentedViewTool.interpolateThemeColor(from: itemModel.titleSelectedColor, to: itemModel.titleNormalColor, percent: percent)
            }
            self?.titleLabel.textColor = itemModel.titleCurrentColor
        }
    }
    
    override func setSelectedStyle(isSelected: Bool) {
        if isSelected {
            self.titleLabel.textColor = (self.itemModel as? DGCJXSegmentedTitleItemModel)?.titleSelectedColor
        } else {
            self.titleLabel.textColor = (self.itemModel as? DGCJXSegmentedTitleItemModel)?.titleNormalColor
        }
    }
}
