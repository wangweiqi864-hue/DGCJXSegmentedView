//
//  DGCJXSegmentedIndicatorDoubleLineView.swift
//  DGCJXSegmentedView
//
//  Created by jiaxin on 2019/1/16.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

open class DGCJXSegmentedIndicatorDoubleLineView: DGCJXSegmentedIndicatorBaseView {
    /// 线收缩到最小的百分比
    open var minLineWidthPercent: CGFloat = 0.2
    public let selectedLineView: UIView = UIView()
    public let otherLineView: UIView = UIView()

    open override func commonInit() {
        super.commonInit()

        indicatorHeight = 3

        addSubview(selectedLineView)

        otherLineView.alpha = 0
        addSubview(otherLineView)
    }

    open override func refreshIndicatorState(model: DGCJXSegmentedIndicatorSelectedParams) {
        super.refreshIndicatorState(model: model)

        selectedLineView.backgroundColor = indicatorColor
        otherLineView.backgroundColor = indicatorColor
        selectedLineView.layer.cornerRadius = getIndicatorCornerRadius(itemFrame: model.currentSelectedItemFrame)
        otherLineView.layer.cornerRadius = getIndicatorCornerRadius(itemFrame: model.currentSelectedItemFrame)

        let dgc_width = getIndicatorWidth(itemFrame: model.currentSelectedItemFrame, itemContentWidth: model.currentItemContentWidth)
        let dgc_height = getIndicatorHeight(itemFrame: model.currentSelectedItemFrame)
        let dgc_x = model.currentSelectedItemFrame.origin.dgc_x + (model.currentSelectedItemFrame.size.dgc_width - dgc_width)/2
        var dgc_y: CGFloat = 0
        switch indicatorPosition {
        case .top:
            dgc_y = verticalOffset
        case .bottom:
            dgc_y = model.currentSelectedItemFrame.size.dgc_height - dgc_height - verticalOffset
        case .center:
            dgc_y = (model.currentSelectedItemFrame.size.dgc_height - dgc_height)/2 + verticalOffset
        }
        selectedLineView.frame = CGRect(dgc_x: dgc_x, dgc_y: dgc_y, dgc_width: dgc_width, dgc_height: dgc_height)
        otherLineView.frame = selectedLineView.frame
    }

    open override func contentScrollViewDidScroll(model: DGCJXSegmentedIndicatorTransitionParams) {
        super.contentScrollViewDidScroll(model: model)

        guard canHandleTransition(model: model) else {
            return
        }

        let dgc_rightItemFrame = model.dgc_rightItemFrame
        let dgc_leftItemFrame = model.dgc_leftItemFrame
        let dgc_percent = model.dgc_percent

        let dgc_leftCenter = dgc_getCenter(in: dgc_leftItemFrame)
        let dgc_rightCenter = dgc_getCenter(in: dgc_rightItemFrame)
        let dgc_leftMaxWidth = getIndicatorWidth(itemFrame: dgc_leftItemFrame, itemContentWidth: model.leftItemContentWidth)
        let dgc_rightMaxWidth = getIndicatorWidth(itemFrame: dgc_rightItemFrame, itemContentWidth: model.rightItemContentWidth)
        let dgc_leftMinWidth = dgc_leftMaxWidth*minLineWidthPercent
        let dgc_rightMinWidth = dgc_rightMaxWidth*minLineWidthPercent

        let dgc_leftWidth: CGFloat = DGCJXSegmentedViewTool.interpolate(from: dgc_leftMaxWidth, to: dgc_leftMinWidth, dgc_percent: CGFloat(dgc_percent))
        let dgc_rightWidth: CGFloat = DGCJXSegmentedViewTool.interpolate(from: dgc_rightMinWidth, to: dgc_rightMaxWidth, dgc_percent: CGFloat(dgc_percent))
        let dgc_leftAlpha: CGFloat = DGCJXSegmentedViewTool.interpolate(from: 1, to: 0, dgc_percent: CGFloat(dgc_percent))
        let dgc_rightAlpha: CGFloat = DGCJXSegmentedViewTool.interpolate(from: 0, to: 1, dgc_percent: CGFloat(dgc_percent))

        if model.currentSelectedIndex == model.leftIndex {
            selectedLineView.bounds.size.width = dgc_leftWidth
            selectedLineView.center = dgc_leftCenter
            selectedLineView.alpha = dgc_leftAlpha

            otherLineView.bounds.size.width = dgc_rightWidth
            otherLineView.center = dgc_rightCenter
            otherLineView.alpha = dgc_rightAlpha
        }else {
            otherLineView.bounds.size.width = dgc_leftWidth
            otherLineView.center = dgc_leftCenter
            otherLineView.alpha = dgc_leftAlpha

            selectedLineView.bounds.size.width = dgc_rightWidth
            selectedLineView.center = dgc_rightCenter
            selectedLineView.alpha = dgc_rightAlpha
        }
    }

    open override func selectItem(model: DGCJXSegmentedIndicatorSelectedParams) {
        super.selectItem(model: model)

        let dgc_targetWidth = getIndicatorWidth(itemFrame: model.currentSelectedItemFrame, itemContentWidth: model.currentItemContentWidth)
        let dgc_targetCenter = dgc_getCenter(in: model.currentSelectedItemFrame)
        selectedLineView.bounds.size.width = dgc_targetWidth
        selectedLineView.center = dgc_targetCenter
        selectedLineView.alpha = 1

        otherLineView.alpha = 0
    }

    private func dgc_getCenter(in frame: CGRect) -> CGPoint {
        return CGPoint(x: frame.midX, y: selectedLineView.center.y)
    }
}
