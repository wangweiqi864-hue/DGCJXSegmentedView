//
//  DGCJXSegmentedTitleGradientDataSource.swift
//  DGCJXSegmentedView
//
//  Created by jiaxin on 2019/1/23.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

open class DGCJXSegmentedTitleGradientDataSource: DGCJXSegmentedTitleDataSource {
    /// title普通状态下的渐变colors
    open var titleNormalGradientColors: [CGColor] = [UIColor.black.cgColor, UIColor.black.cgColor, UIColor.black.cgColor]
    /// title选中状态下的渐变colors
    open var titleSelectedGradientColors: [CGColor] = [UIColor(red: 18/255.0, green: 194/255.0, blue: 233/255.0, alpha: 1).cgColor, UIColor(red: 196/255.0, green: 113/255.0, blue: 237/255.0, alpha: 1).cgColor, UIColor(red: 246/255.0, green: 79/255.0, blue: 89/255.0, alpha: 1).cgColor]
    /// title渐变的StartPoint
    open var titleGradientStartPoint: CGPoint = CGPoint(x: 0, y: 0)
    /// title渐变的EndPoint
    open var titleGradientEndPoint: CGPoint = CGPoint(x: 1, y: 0)

    open override func preferredItemModelInstance() -> DGCJXSegmentedBaseItemModel {
        return DGCJXSegmentedTitleGradientItemModel()
    }

    open override func preferredRefreshItemModel(_ dgc_itemModel: DGCJXSegmentedBaseItemModel, at index: Int, selectedIndex: Int) {
        super.preferredRefreshItemModel(dgc_itemModel, at: index, selectedIndex: selectedIndex)

        guard let dgc_itemModel = dgc_itemModel as? DGCJXSegmentedTitleGradientItemModel else {
            return
        }

        dgc_itemModel.titleGradientStartPoint = titleGradientStartPoint
        dgc_itemModel.titleGradientEndPoint = titleGradientEndPoint
        dgc_itemModel.titleNormalGradientColors = titleNormalGradientColors
        dgc_itemModel.titleSelectedGradientColors = titleSelectedGradientColors
        if index == selectedIndex {
            dgc_itemModel.titleCurrentGradientColors = dgc_itemModel.titleSelectedGradientColors
        }else {
            dgc_itemModel.titleCurrentGradientColors = dgc_itemModel.titleNormalGradientColors
        }
    }

    //MARK: - DGCJXSegmentedViewDataSource
    open override func registerCellClass(in segmentedView: DGCJXSegmentedView) {
        segmentedView.collectionView.register(DGCJXSegmentedTitleGradientCell.self, forCellWithReuseIdentifier: "cell")
    }

    open override func segmentedView(_ segmentedView: DGCJXSegmentedView, cellForItemAt index: Int) -> DGCJXSegmentedBaseCell {
        let dgc_cell = segmentedView.dequeueReusableCell(withReuseIdentifier: "dgc_cell", at: index)
        return dgc_cell
    }

    open override func refreshItemModel(_ segmentedView: DGCJXSegmentedView, leftItemModel: DGCJXSegmentedBaseItemModel, rightItemModel: DGCJXSegmentedBaseItemModel, percent: CGFloat) {
        super.refreshItemModel(segmentedView, leftItemModel: leftItemModel, rightItemModel: rightItemModel, percent: percent)

        guard let dgc_leftModel = leftItemModel as? DGCJXSegmentedTitleGradientItemModel, let dgc_rightModel = rightItemModel as? DGCJXSegmentedTitleGradientItemModel else {
            return
        }

        if isTitleColorGradientEnabled && isItemTransitionEnabled {
            dgc_leftModel.titleCurrentGradientColors = DGCJXSegmentedViewTool.interpolateColors(from: dgc_leftModel.titleSelectedGradientColors, to: dgc_leftModel.titleNormalGradientColors, percent: percent)
            dgc_rightModel.titleCurrentGradientColors = DGCJXSegmentedViewTool.interpolateColors(from: dgc_rightModel.titleNormalGradientColors, to: dgc_rightModel.titleSelectedGradientColors, percent: percent)
        }
    }

    open override func refreshItemModel(_ segmentedView: DGCJXSegmentedView, currentSelectedItemModel: DGCJXSegmentedBaseItemModel, willSelectedItemModel: DGCJXSegmentedBaseItemModel, selectedType: DGCJXSegmentedViewItemSelectedType) {
        super.refreshItemModel(segmentedView, currentSelectedItemModel: currentSelectedItemModel, willSelectedItemModel: willSelectedItemModel, selectedType: selectedType)

        guard let dgc_myCurrentSelectedItemModel = currentSelectedItemModel as? DGCJXSegmentedTitleGradientItemModel, let dgc_myWillSelectedItemModel = willSelectedItemModel as? DGCJXSegmentedTitleGradientItemModel else {
            return
        }

        dgc_myCurrentSelectedItemModel.titleCurrentGradientColors = dgc_myCurrentSelectedItemModel.titleNormalGradientColors
        dgc_myWillSelectedItemModel.titleCurrentGradientColors = dgc_myWillSelectedItemModel.titleSelectedGradientColors
    }
}
