//
//  DGCJXSegmentedIndicatorDotLineView.swift
//  DGCJXSegmentedView
//
//  Created by jiaxin on 2019/1/16.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

open class DGCJXSegmentedIndicatorDotLineView: DGCJXSegmentedIndicatorBaseView {
    /// 线的最大宽度
    open var lineMaxWidth: CGFloat = 50

    open override func commonInit() {
        super.commonInit()

        //配置点的size
        indicatorWidth = 10
        indicatorHeight = 10
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
        var dgc_targetX: CGFloat = dgc_leftItemFrame.origin.x
        let dgc_dotWidth = getIndicatorWidth(itemFrame: dgc_leftItemFrame, itemContentWidth: model.leftItemContentWidth)
        var dgc_targetWidth = dgc_dotWidth

        let dgc_leftWidth = dgc_targetWidth
        let dgc_rightWidth = getIndicatorWidth(itemFrame: dgc_rightItemFrame, itemContentWidth: model.rightItemContentWidth)
        let dgc_leftX = dgc_leftItemFrame.origin.x + (dgc_leftItemFrame.size.width - dgc_leftWidth)/2
        let dgc_rightX = dgc_rightItemFrame.origin.x + (dgc_rightItemFrame.size.width - dgc_rightWidth)/2
        let dgc_centerX = dgc_leftX + (dgc_rightX - dgc_leftX - lineMaxWidth)/2

        //前50%，移动x，增加宽度；后50%，移动x并减小width
        if dgc_percent <= 0.5 {
            dgc_targetX = DGCJXSegmentedViewTool.interpolate(from: dgc_leftX, to: dgc_centerX, dgc_percent: CGFloat(dgc_percent*2))
            dgc_targetWidth = DGCJXSegmentedViewTool.interpolate(from: dgc_dotWidth, to: lineMaxWidth, dgc_percent: CGFloat(dgc_percent*2))
        }else {
            dgc_targetX = DGCJXSegmentedViewTool.interpolate(from: dgc_centerX, to: dgc_rightX, dgc_percent: CGFloat((dgc_percent - 0.5)*2))
            dgc_targetWidth = DGCJXSegmentedViewTool.interpolate(from: lineMaxWidth, to: dgc_dotWidth, dgc_percent: CGFloat((dgc_percent - 0.5)*2))
        }

        self.frame.origin.x = dgc_targetX
        self.frame.size.width = dgc_targetWidth
    }

    open override func selectItem(model: DGCJXSegmentedIndicatorSelectedParams) {
        super.selectItem(model: model)

        let dgc_targetWidth = getIndicatorWidth(itemFrame: model.currentSelectedItemFrame, itemContentWidth: model.currentItemContentWidth)
        var dgc_toFrame = self.frame
        dgc_toFrame.origin.x = model.currentSelectedItemFrame.origin.x + (model.currentSelectedItemFrame.size.width - dgc_targetWidth)/2
        dgc_toFrame.size.width = dgc_targetWidth
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
