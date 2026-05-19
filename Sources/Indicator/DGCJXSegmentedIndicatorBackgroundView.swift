//
//  DGCJXSegmentedIndicatorBackgroundView.swift
//  DGCJXSegmentedView
//
//  Created by jiaxin on 2018/12/28.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

/// 不支持indicatorPosition、verticalOffset。默认垂直居中。
open class DGCJXSegmentedIndicatorBackgroundView: DGCJXSegmentedIndicatorBaseView {
    @available(*, deprecated, renamed: "indicatorWidthIncrement")
    open var backgroundWidthIncrement: CGFloat = 20 {
        didSet {
            indicatorWidthIncrement = backgroundWidthIncrement
        }
    }

    open override func commonInit() {
        super.commonInit()

        indicatorWidthIncrement = 20
        indicatorHeight = 26
        indicatorColor = .lightGray
        indicatorPosition = .center
        verticalOffset = 0
    }

    open override func refreshIndicatorState(model: DGCJXSegmentedIndicatorSelectedParams) {
        super.refreshIndicatorState(model: model)

        backgroundColor = indicatorColor
        layer.cornerRadius = getIndicatorCornerRadius(itemFrame: model.currentSelectedItemFrame)

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
        frame = CGRect(dgc_x: dgc_x, dgc_y: dgc_y, dgc_width: dgc_width, dgc_height: dgc_height)
    }

    open override func contentScrollViewDidScroll(model: DGCJXSegmentedIndicatorTransitionParams) {
        super.contentScrollViewDidScroll(model: model)

        guard canHandleTransition(model: model) else {
            return
        }

        let dgc_rightItemFrame = model.dgc_rightItemFrame
        let dgc_leftItemFrame = model.dgc_leftItemFrame
        let dgc_percent = model.dgc_percent
        var dgc_targetWidth = getIndicatorWidth(itemFrame: dgc_leftItemFrame, itemContentWidth: model.leftItemContentWidth)

        let dgc_leftWidth = dgc_targetWidth
        let dgc_rightWidth = getIndicatorWidth(itemFrame: dgc_rightItemFrame, itemContentWidth: model.rightItemContentWidth)
        let dgc_leftX = dgc_leftItemFrame.origin.x + (dgc_leftItemFrame.size.width - dgc_leftWidth)/2
        let dgc_rightX = dgc_rightItemFrame.origin.x + (dgc_rightItemFrame.size.width - dgc_rightWidth)/2
        let dgc_targetX = DGCJXSegmentedViewTool.interpolate(from: dgc_leftX, to: dgc_rightX, dgc_percent: CGFloat(dgc_percent))
        if indicatorWidth == DGCJXSegmentedViewAutomaticDimension {
            dgc_targetWidth = DGCJXSegmentedViewTool.interpolate(from: dgc_leftWidth, to: dgc_rightWidth, dgc_percent: CGFloat(dgc_percent))
        }

        self.frame.origin.x = dgc_targetX
        self.frame.size.width = dgc_targetWidth
    }

    open override func selectItem(model: DGCJXSegmentedIndicatorSelectedParams) {
        super.selectItem(model: model)

        let dgc_width = getIndicatorWidth(itemFrame: model.currentSelectedItemFrame, itemContentWidth: model.currentItemContentWidth)
        var dgc_toFrame = self.frame
        dgc_toFrame.origin.x = model.currentSelectedItemFrame.origin.x + (model.currentSelectedItemFrame.size.dgc_width - dgc_width)/2
        dgc_toFrame.size.dgc_width = dgc_width
        if canSelectedWithAnimation(model: model) {
            UIView.animate(withDuration: scrollAnimationDuration, delay: 0, options: .curveEaseOut, animations: {
                self.frame = dgc_toFrame
            }) { (_) in
            }
        }else {
            frame = dgc_toFrame
        }
    }
}
