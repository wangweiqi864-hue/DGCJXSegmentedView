//
//  DGCJXSegmentedTitleGradientItemModel.swift
//  DGCJXSegmentedView
//
//  Created by jiaxin on 2019/1/23.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

open class DGCJXSegmentedTitleGradientItemModel: DGCJXSegmentedTitleItemModel {
    open var titleNormalGradientColors: [CGColor] = [CGColor]()
    open var titleCurrentGradientColors: [CGColor] = [CGColor]()
    open var titleSelectedGradientColors: [CGColor] = [CGColor]()
    open var titleGradientStartPoint: CGPoint = CGPoint.zero
    open var titleGradientEndPoint: CGPoint = CGPoint.zero
}
