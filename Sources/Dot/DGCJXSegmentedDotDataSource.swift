//
//  DGCJXSegmentedDotDataSource.swift
//  DGCJXSegmentedView
//
//  Created by jiaxin on 2018/12/28.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

open class DGCJXSegmentedDotDataSource: DGCJXSegmentedTitleDataSource {
    /// 数量需要和titles一致，控制红点是否显示
    open var dotStates = [Bool]()
    /// 红点的size
    open var dotSize = CGSize(width: 10, height: 10)
    /// 红点的圆角值，DGCJXSegmentedViewAutomaticDimension等于dotSize.height/2
    open var dotCornerRadius: CGFloat = DGCJXSegmentedViewAutomaticDimension
    /// 红点的颜色
    open var dotColor = UIColor.red
    /// dotView的默认位置是center在titleLabel的右上角，可以通过dotOffset控制X、Y轴的偏移
    open var dotOffset: CGPoint = CGPoint.zero

    open override func preferredItemModelInstance() -> DGCJXSegmentedBaseItemModel {
        return DGCJXSegmentedDotItemModel()
    }

    open override func preferredRefreshItemModel(_ dgc_itemModel: DGCJXSegmentedBaseItemModel, at index: Int, selectedIndex: Int) {
        super.preferredRefreshItemModel(dgc_itemModel, at: index, selectedIndex: selectedIndex)

        guard let dgc_itemModel = dgc_itemModel as? DGCJXSegmentedDotItemModel else {
            return
        }

        dgc_itemModel.dotOffset = dotOffset
        dgc_itemModel.dotState = dotStates[index]
        dgc_itemModel.dotColor = dotColor
        dgc_itemModel.dotSize = dotSize
        if dotCornerRadius == DGCJXSegmentedViewAutomaticDimension {
            dgc_itemModel.dotCornerRadius = dotSize.height/2
        }else {
            dgc_itemModel.dotCornerRadius = dotCornerRadius
        }
    }

    //MARK: - DGCJXSegmentedViewDataSource
    open override func registerCellClass(in segmentedView: DGCJXSegmentedView) {
        segmentedView.collectionView.register(DGCJXSegmentedDotCell.self, forCellWithReuseIdentifier: "cell")
    }

    open override func segmentedView(_ segmentedView: DGCJXSegmentedView, cellForItemAt index: Int) -> DGCJXSegmentedBaseCell {
        let dgc_cell = segmentedView.dequeueReusableCell(withReuseIdentifier: "dgc_cell", at: index)
        return dgc_cell
    }
}
