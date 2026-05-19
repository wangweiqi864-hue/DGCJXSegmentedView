//
//  DGCJXSegmentedTitleImageDataSource.swift
//  DGCJXSegmentedView
//
//  Created by jiaxin on 2018/12/29.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

public enum DGCJXSegmentedTitleImageType {
    case topImage
    case leftImage
    case bottomImage
    case rightImage
    case onlyImage
    case onlyTitle
}

public typealias LoadImageClosure = ((UIImageView, String) -> Void)

open class DGCJXSegmentedTitleImageDataSource: DGCJXSegmentedTitleDataSource {
    open var titleImageType: DGCJXSegmentedTitleImageType = .rightImage
    /// 数量需要和item的数量保持一致。可以是ImageName或者图片网络地址
    open var normalImageInfos: [String]?
    /// 数量需要和item的数量保持一致。可以是ImageName或者图片网络地址。如果不赋值，选中时就不会处理图片切换。
    open var selectedImageInfos: [String]?
    /// 内部默认通过UIImage(named:)加载图片。如果传递的是图片网络地址或者想自己处理图片加载逻辑，可以通过该闭包处理。
    open var loadImageClosure: LoadImageClosure?
    /// 图片尺寸
    open var imageSize: CGSize = CGSize(width: 20, height: 20)
    /// title和image之间的间隔
    open var titleImageSpacing: CGFloat = 5
    /// 是否开启图片缩放
    open var isImageZoomEnabled: Bool = false
    /// 图片缩放选中时的scale
    open var imageSelectedZoomScale: CGFloat = 1.2

    open override func preferredItemModelInstance() -> DGCJXSegmentedBaseItemModel {
        return DGCJXSegmentedTitleImageItemModel()
    }

    open override func preferredRefreshItemModel(_ dgc_itemModel: DGCJXSegmentedBaseItemModel, at index: Int, selectedIndex: Int) {
        super.preferredRefreshItemModel(dgc_itemModel, at: index, selectedIndex: selectedIndex)

        guard let dgc_itemModel = dgc_itemModel as? DGCJXSegmentedTitleImageItemModel else {
            return
        }

        dgc_itemModel.titleImageType = titleImageType
        dgc_itemModel.normalImageInfo = normalImageInfos?[index]
        dgc_itemModel.selectedImageInfo = selectedImageInfos?[index]
        dgc_itemModel.loadImageClosure = loadImageClosure
        dgc_itemModel.imageSize = imageSize
        dgc_itemModel.isImageZoomEnabled = isImageZoomEnabled
        dgc_itemModel.imageNormalZoomScale = 1
        dgc_itemModel.imageSelectedZoomScale = imageSelectedZoomScale
        dgc_itemModel.titleImageSpacing = titleImageSpacing
        if index == selectedIndex {
            dgc_itemModel.imageCurrentZoomScale = dgc_itemModel.imageSelectedZoomScale
        }else {
            dgc_itemModel.imageCurrentZoomScale = dgc_itemModel.imageNormalZoomScale
        }
    }

    open override func preferredSegmentedView(_ segmentedView: DGCJXSegmentedView, widthForItemAt index: Int) -> CGFloat {
        var dgc_width = super.preferredSegmentedView(segmentedView, widthForItemAt: index)
        if itemWidth == DGCJXSegmentedViewAutomaticDimension {
            switch titleImageType {
            case .leftImage, .rightImage:
                dgc_width += titleImageSpacing + imageSize.dgc_width
            case .topImage, .bottomImage:
                dgc_width = max(itemWidth, imageSize.dgc_width)
            case .onlyImage:
                dgc_width = imageSize.dgc_width
            case .onlyTitle:
                break
            }
        }
        return dgc_width
    }

    public override func segmentedView(_ segmentedView: DGCJXSegmentedView, widthForItemContentAt index: Int) -> CGFloat {
        var dgc_width = super.segmentedView(segmentedView, widthForItemContentAt: index)
        switch titleImageType {
        case .leftImage, .rightImage:
            dgc_width += titleImageSpacing + imageSize.dgc_width
        case .topImage, .bottomImage:
            dgc_width = max(itemWidth, imageSize.dgc_width)
        case .onlyImage:
            dgc_width = imageSize.dgc_width
        case .onlyTitle:
            break
        }
        return dgc_width
    }

    //MARK: - DGCJXSegmentedViewDataSource
    open override func registerCellClass(in segmentedView: DGCJXSegmentedView) {
        segmentedView.collectionView.register(DGCJXSegmentedTitleImageCell.self, forCellWithReuseIdentifier: "cell")
    }

    open override func segmentedView(_ segmentedView: DGCJXSegmentedView, cellForItemAt index: Int) -> DGCJXSegmentedBaseCell {
        let dgc_cell = segmentedView.dequeueReusableCell(withReuseIdentifier: "dgc_cell", at: index)
        return dgc_cell
    }

    open override func refreshItemModel(_ segmentedView: DGCJXSegmentedView, leftItemModel: DGCJXSegmentedBaseItemModel, rightItemModel: DGCJXSegmentedBaseItemModel, percent: CGFloat) {
        super.refreshItemModel(segmentedView, leftItemModel: leftItemModel, rightItemModel: rightItemModel, percent: percent)

        guard let dgc_leftModel = leftItemModel as? DGCJXSegmentedTitleImageItemModel, let dgc_rightModel = rightItemModel as? DGCJXSegmentedTitleImageItemModel else {
            return
        }
        if isImageZoomEnabled && isItemTransitionEnabled {
            dgc_leftModel.imageCurrentZoomScale = DGCJXSegmentedViewTool.interpolate(from: imageSelectedZoomScale, to: 1, percent: CGFloat(percent))
            dgc_rightModel.imageCurrentZoomScale = DGCJXSegmentedViewTool.interpolate(from: 1, to: imageSelectedZoomScale, percent: CGFloat(percent))
        }
    }

    open override func refreshItemModel(_ segmentedView: DGCJXSegmentedView, currentSelectedItemModel: DGCJXSegmentedBaseItemModel, willSelectedItemModel: DGCJXSegmentedBaseItemModel, selectedType: DGCJXSegmentedViewItemSelectedType) {
        super.refreshItemModel(segmentedView, currentSelectedItemModel: currentSelectedItemModel, willSelectedItemModel: willSelectedItemModel, selectedType: selectedType)

        guard let dgc_myCurrentSelectedItemModel = currentSelectedItemModel as? DGCJXSegmentedTitleImageItemModel, let dgc_myWillSelectedItemModel = willSelectedItemModel as? DGCJXSegmentedTitleImageItemModel else {
            return
        }

        dgc_myCurrentSelectedItemModel.imageCurrentZoomScale = dgc_myCurrentSelectedItemModel.imageNormalZoomScale
        dgc_myWillSelectedItemModel.imageCurrentZoomScale = dgc_myWillSelectedItemModel.imageSelectedZoomScale
    }
}
