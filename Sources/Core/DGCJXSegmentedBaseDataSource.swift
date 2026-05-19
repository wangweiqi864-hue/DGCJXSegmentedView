//
//  DGCJXSegmentedBaseDataSource.swift
//  DGCJXSegmentedView
//
//  Created by jiaxin on 2018/12/28.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import Foundation
import  UIKit

open class DGCJXSegmentedBaseDataSource: DGCJXSegmentedViewDataSource {
    /// 最终传递给DGCJXSegmentedView的数据源数组
    open var dataSource = [DGCJXSegmentedBaseItemModel]()
    /// cell的宽度。为DGCJXSegmentedViewAutomaticDimension时就以内容计算的宽度为准，否则以itemWidth的具体值为准。
    open var itemWidth: CGFloat = DGCJXSegmentedViewAutomaticDimension
    /// 真实的item宽度 = itemWidth + itemWidthIncrement。
    open var itemWidthIncrement: CGFloat = 0
    /// item之前的间距
    open var itemSpacing: CGFloat = 20
    /// 当collectionView.contentSize.width小于DGCJXSegmentedView的宽度时，是否将itemSpacing均分。
    open var isItemSpacingAverageEnabled: Bool = true
    /// item左右滚动过渡时，是否允许渐变。比如JXSegmentedTitleDataSource的titleZoom、titleNormalColor、titleStrokeWidth等渐变。
    open var isItemTransitionEnabled: Bool = true
    /// 选中的时候，是否需要动画过渡。自定义的cell需要自己处理动画过渡逻辑，动画处理逻辑参考`DGCJXSegmentedTitleCell`
    open var isSelectedAnimable: Bool = false
    /// 选中动画的时长
    open var selectedAnimationDuration: TimeInterval = 0.25
    /// 是否允许item宽度缩放
    open var isItemWidthZoomEnabled: Bool = false
    /// 是否允许item宽度缩放动画
    open var isItemWidthZoomAnimable: Bool = true
    /// item宽度选中时的scale
    open var itemWidthSelectedZoomScale: CGFloat = 1.5

    @available(*, deprecated, renamed: "itemWidth")
    open var itemContentWidth: CGFloat = DGCJXSegmentedViewAutomaticDimension {
        didSet {
            itemWidth = itemContentWidth
        }
    }

    private var dgc_animator: DGCJXSegmentedAnimator?

    deinit {
        dgc_animator?.stop()
    }

    public init() {
    }

    /// 配置完各种属性之后，需要手动调用该方法，更新数据源
    ///
    /// - Parameter selectedIndex: 当前选中的index
    open func reloadData(selectedIndex: Int) {
        dataSource.removeAll()
        for index in 0..<preferredItemCount() {
            let dgc_itemModel = preferredItemModelInstance()
            preferredRefreshItemModel(dgc_itemModel, at: index, selectedIndex: selectedIndex)
            dataSource.append(dgc_itemModel)
        }
    }

    open func preferredItemCount() -> Int {
        return 0
    }

    /// 子类需要重载该方法，用于返回自己定义的JXSegmentedBaseItemModel子类实例
    open func preferredItemModelInstance() -> DGCJXSegmentedBaseItemModel  {
        return DGCJXSegmentedBaseItemModel()
    }

    /// 子类需要重载该方法，用于返回索引为index的item宽度
    open func preferredSegmentedView(_ segmentedView: DGCJXSegmentedView, widthForItemAt index: Int) -> CGFloat {
        return itemWidthIncrement
    }

    /// 子类需要重载该方法，用于更新索引为index的itemModel
    open func preferredRefreshItemModel(_ itemModel: DGCJXSegmentedBaseItemModel, at index: Int, selectedIndex: Int) {
        itemModel.index = index
        itemModel.isItemTransitionEnabled = isItemTransitionEnabled
        itemModel.isSelectedAnimable = isSelectedAnimable
        itemModel.selectedAnimationDuration = selectedAnimationDuration
        itemModel.isItemWidthZoomEnabled = isItemWidthZoomEnabled
        itemModel.itemWidthNormalZoomScale = 1
        itemModel.itemWidthSelectedZoomScale = itemWidthSelectedZoomScale
        if index == selectedIndex {
            itemModel.isSelected = true
            itemModel.itemWidthCurrentZoomScale = itemModel.itemWidthSelectedZoomScale
        }else {
            itemModel.isSelected = false
            itemModel.itemWidthCurrentZoomScale = itemModel.itemWidthNormalZoomScale
        }
    }

    //MARK: - DGCJXSegmentedViewDataSource
    open func itemDataSource(in segmentedView: DGCJXSegmentedView) -> [DGCJXSegmentedBaseItemModel] {
        return dataSource
    }

    /// 自定义子类请继承方法`func preferredWidthForItem(at index: Int) -> CGFloat`
    public final func segmentedView(_ segmentedView: DGCJXSegmentedView, widthForItemAt index: Int) -> CGFloat {
        return preferredSegmentedView(segmentedView, widthForItemAt: index)
    }

    public func segmentedView(_ segmentedView: DGCJXSegmentedView, widthForItemContentAt index: Int) -> CGFloat {
        return self.segmentedView(segmentedView, widthForItemAt: index)
    }

    open func registerCellClass(in segmentedView: DGCJXSegmentedView) {

    }

    open func segmentedView(_ segmentedView: DGCJXSegmentedView, cellForItemAt index: Int) -> DGCJXSegmentedBaseCell {
        return DGCJXSegmentedBaseCell()
    }

    open func refreshItemModel(_ segmentedView: DGCJXSegmentedView, currentSelectedItemModel: DGCJXSegmentedBaseItemModel, willSelectedItemModel: DGCJXSegmentedBaseItemModel, selectedType: DGCJXSegmentedViewItemSelectedType) {
        currentSelectedItemModel.isSelected = false
        willSelectedItemModel.isSelected = true

        if isItemWidthZoomEnabled {
            if (selectedType == .scroll && !isItemTransitionEnabled) ||
                selectedType == .click ||
                selectedType == .code {
                dgc_animator = DGCJXSegmentedAnimator()
                dgc_animator?.duration = selectedAnimationDuration
                dgc_animator?.progressClosure = {[weak self] (percent) in
                    guard let self = self else { return }
                    currentSelectedItemModel.itemWidthCurrentZoomScale = DGCJXSegmentedViewTool.interpolate(from: currentSelectedItemModel.itemWidthSelectedZoomScale, to: currentSelectedItemModel.itemWidthNormalZoomScale, percent: percent)
                    currentSelectedItemModel.itemWidth = self.dgc_itemWidthWithZoom(at: currentSelectedItemModel.index, model: currentSelectedItemModel)
                    willSelectedItemModel.itemWidthCurrentZoomScale = DGCJXSegmentedViewTool.interpolate(from: willSelectedItemModel.itemWidthNormalZoomScale, to: willSelectedItemModel.itemWidthSelectedZoomScale, percent: percent)
                    willSelectedItemModel.itemWidth = self.dgc_itemWidthWithZoom(at: willSelectedItemModel.index, model: willSelectedItemModel)
                    segmentedView.collectionView.collectionViewLayout.invalidateLayout()
                }
                if isItemWidthZoomAnimable {
                    dgc_animator?.start()
                }else {
                    dgc_animator?.stop()
                }
            }
        }else {
            currentSelectedItemModel.itemWidthCurrentZoomScale = currentSelectedItemModel.itemWidthNormalZoomScale
            willSelectedItemModel.itemWidthCurrentZoomScale = willSelectedItemModel.itemWidthSelectedZoomScale
        }
    }

    open func refreshItemModel(_ segmentedView: DGCJXSegmentedView, leftItemModel: DGCJXSegmentedBaseItemModel, rightItemModel: DGCJXSegmentedBaseItemModel, percent: CGFloat) {
        //如果正在进行itemWidth缩放动画，用户又立马滚动了contentScrollView，需要停止动画。
        dgc_animator?.stop()
        dgc_animator = nil
        if isItemWidthZoomEnabled && isItemTransitionEnabled {
            //允许itemWidth缩放动画且允许item渐变过渡
            leftItemModel.itemWidthCurrentZoomScale = DGCJXSegmentedViewTool.interpolate(from: leftItemModel.itemWidthSelectedZoomScale, to: leftItemModel.itemWidthNormalZoomScale, percent: percent)
            leftItemModel.itemWidth = dgc_itemWidthWithZoom(at: leftItemModel.index, model: leftItemModel)
            rightItemModel.itemWidthCurrentZoomScale = DGCJXSegmentedViewTool.interpolate(from: rightItemModel.itemWidthNormalZoomScale, to: rightItemModel.itemWidthSelectedZoomScale, percent: percent)
            rightItemModel.itemWidth = dgc_itemWidthWithZoom(at: rightItemModel.index, model: rightItemModel)
            segmentedView.collectionView.collectionViewLayout.invalidateLayout()
        }
    }

    /// 自定义子类请继承方法`func preferredRefreshItemModel(_ itemModel: DGCJXSegmentedBaseItemModel, at index: Int, selectedIndex: Int)`
    public final func refreshItemModel(_ segmentedView: DGCJXSegmentedView, _ itemModel: DGCJXSegmentedBaseItemModel, at index: Int, selectedIndex: Int) {
        preferredRefreshItemModel(itemModel, at: index, selectedIndex: selectedIndex)
    }

    private func dgc_itemWidthWithZoom(at index: Int, model: DGCJXSegmentedBaseItemModel) -> CGFloat {
        var dgc_width = self.segmentedView(DGCJXSegmentedView(), widthForItemAt: index)
        if isItemWidthZoomEnabled {
            dgc_width *= model.itemWidthCurrentZoomScale
        }
        return dgc_width
    }
}
