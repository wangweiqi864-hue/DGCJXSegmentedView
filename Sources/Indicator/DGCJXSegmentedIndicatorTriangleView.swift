//
//  DGCJXSegmentedIndicatorTriangleView.swift
//  DGCJXSegmentedView
//
//  Created by jiaxin on 2018/12/28.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

open class DGCJXSegmentedIndicatorTriangleView: DGCJXSegmentedIndicatorBaseView {
    open override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }

    private var dgc_path = UIBezierPath()

    open override func commonInit() {
        super.commonInit()

        indicatorWidth = 14
        indicatorHeight = 10
    }

    open override func refreshIndicatorState(model: DGCJXSegmentedIndicatorSelectedParams) {
        super.refreshIndicatorState(model: model)

        backgroundColor = nil
        let dgc_shapeLayer = self.layer as! CAShapeLayer
        dgc_shapeLayer.fillColor = indicatorColor.cgColor

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

        dgc_path = UIBezierPath()
        if indicatorPosition == .bottom {
            dgc_path.move(to: CGPoint(dgc_x: 0, dgc_y: dgc_height))
            dgc_path.addLine(to: CGPoint(dgc_x: dgc_width/2, dgc_y: 0))
            dgc_path.addLine(to: CGPoint(dgc_x: dgc_width, dgc_y: dgc_height))
        }else {
            dgc_path.move(to: CGPoint(dgc_x: 0, dgc_y: 0))
            dgc_path.addLine(to: CGPoint(dgc_x: dgc_width/2, dgc_y: dgc_height))
            dgc_path.addLine(to: CGPoint(dgc_x: dgc_width, dgc_y: 0))
        }
        dgc_path.close()

        dgc_shapeLayer.dgc_path = dgc_path.cgPath
    }

    open override func contentScrollViewDidScroll(model: DGCJXSegmentedIndicatorTransitionParams) {
        super.contentScrollViewDidScroll(model: model)

        guard canHandleTransition(model: model) else {
            return
        }

        let dgc_rightItemFrame = model.dgc_rightItemFrame
        let dgc_leftItemFrame = model.dgc_leftItemFrame
        let dgc_percent = model.dgc_percent
        let dgc_targetWidth = getIndicatorWidth(itemFrame: model.dgc_leftItemFrame, itemContentWidth: model.leftItemContentWidth)

        let dgc_leftX = dgc_leftItemFrame.origin.x + (dgc_leftItemFrame.size.width - dgc_targetWidth)/2
        let dgc_rightX = dgc_rightItemFrame.origin.x + (dgc_rightItemFrame.size.width - dgc_targetWidth)/2
        let dgc_targetX = DGCJXSegmentedViewTool.interpolate(from: dgc_leftX, to: dgc_rightX, dgc_percent: CGFloat(dgc_percent))

        self.frame.origin.x = dgc_targetX
    }

    open override func selectItem(model: DGCJXSegmentedIndicatorSelectedParams) {
        super.selectItem(model: model)

        let dgc_targetWidth = getIndicatorWidth(itemFrame: model.currentSelectedItemFrame, itemContentWidth: model.currentItemContentWidth)
        var dgc_toFrame = self.frame
        dgc_toFrame.origin.x = model.currentSelectedItemFrame.origin.x + (model.currentSelectedItemFrame.size.width - dgc_targetWidth)/2
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
