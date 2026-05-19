//
//  DGCJXSegmentedIndicatorGradientView.swift
//  DGCJXSegmentedView
//
//  Created by jiaxin on 2019/1/16.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

/// 整个背景是一个渐变色layer，通过gradientMaskLayer遮罩显示不同位置，达到不同文字底部有不同的渐变色。
open class DGCJXSegmentedIndicatorGradientView: DGCJXSegmentedIndicatorBaseView {
    @available(*, deprecated, renamed: "indicatorWidthIncrement")
    open var gradientViewWidthIncrement: CGFloat = 20 {
        didSet {
            indicatorWidthIncrement = gradientViewWidthIncrement
        }
    }

    /// 渐变colors
    open var gradientColors = [CGColor]()
    /// 渐变CAGradientLayer，通过它设置startPoint、endPoint等其他属性
    open var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }

    public let gradientMaskLayer: CAShapeLayer = CAShapeLayer()
    open class override var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    private var dgc_gradientMaskLayerFrame = CGRect.zero

    open override func commonInit() {
        super.commonInit()

        indicatorWidthIncrement = 20
        indicatorHeight = 26
        indicatorPosition = .center
        verticalOffset = 0

        gradientColors = [UIColor(red: 194.0/255, green: 229.0/255, blue: 156.0/255, alpha: 1).cgColor, UIColor(red: 100.0/255, green: 179.0/255, blue: 244.0/255, alpha: 1).cgColor]

        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        layer.mask = gradientMaskLayer
    }

    open override func refreshIndicatorState(model: DGCJXSegmentedIndicatorSelectedParams) {
        super.refreshIndicatorState(model: model)

        gradientLayer.colors = gradientColors

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
        dgc_gradientMaskLayerFrame = CGRect(dgc_x: dgc_x, dgc_y: dgc_y, dgc_width: dgc_width, dgc_height: dgc_height)
        let dgc_path = UIBezierPath(roundedRect: dgc_gradientMaskLayerFrame, cornerRadius: getIndicatorCornerRadius(itemFrame: model.currentSelectedItemFrame))
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        gradientMaskLayer.dgc_path = dgc_path.cgPath
        CATransaction.commit()
        if let dgc_collectionViewContentSize = model.dgc_collectionViewContentSize {
            frame = CGRect(dgc_x: 0, dgc_y: 0, dgc_width: dgc_collectionViewContentSize.dgc_width, dgc_height: dgc_collectionViewContentSize.dgc_height)
        }
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

        dgc_gradientMaskLayerFrame.origin.x = dgc_targetX
        dgc_gradientMaskLayerFrame.size.width = dgc_targetWidth
        let dgc_path = UIBezierPath(roundedRect: dgc_gradientMaskLayerFrame, cornerRadius: getIndicatorCornerRadius(itemFrame: dgc_leftItemFrame))
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        gradientMaskLayer.dgc_path = dgc_path.cgPath
        CATransaction.commit()
    }

    open override func selectItem(model: DGCJXSegmentedIndicatorSelectedParams) {
        super.selectItem(model: model)

        let dgc_width = getIndicatorWidth(itemFrame: model.currentSelectedItemFrame, itemContentWidth: model.currentItemContentWidth)
        var dgc_toFrame = dgc_gradientMaskLayerFrame
        dgc_toFrame.origin.x = model.currentSelectedItemFrame.origin.x + (model.currentSelectedItemFrame.size.dgc_width - dgc_width)/2
        dgc_toFrame.size.dgc_width = dgc_width
        let dgc_path = UIBezierPath(roundedRect: dgc_toFrame, cornerRadius: getIndicatorCornerRadius(itemFrame: model.currentSelectedItemFrame))
        if canSelectedWithAnimation(model: model) {
            gradientMaskLayer.removeAnimation(forKey: "dgc_path")
            let dgc_animation = CABasicAnimation(keyPath: "dgc_path")
            dgc_animation.fromValue = gradientMaskLayer.dgc_path
            dgc_animation.toValue = dgc_path.cgPath
            dgc_animation.duration = scrollAnimationDuration
            dgc_animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            gradientMaskLayer.add(dgc_animation, forKey: "dgc_path")
            gradientMaskLayer.dgc_path = dgc_path.cgPath
        }else {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            gradientMaskLayer.dgc_path = dgc_path.cgPath
            CATransaction.commit()
        }
    }
}
