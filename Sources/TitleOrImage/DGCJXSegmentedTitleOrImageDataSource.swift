//
//  DGCJXSegmentedTitleOrImageDataSource.swift
//  DGCJXSegmentedView
//
//  Created by jiaxin on 2019/1/22.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

open class DGCJXSegmentedTitleOrImageDataSource: DGCJXSegmentedTitleDataSource {
    /// 数量需要和item的数量保持一致。可以是ImageName或者图片地址。选中时不显示图片就填nil
    open var selectedImageInfos: [String?]?
    /// 内部默认通过UIImage(named:)加载图片。如果传递的是图片地址或者想自己处理图片加载逻辑，可以通过该闭包处理。
    open var loadImageClosure: LoadImageClosure?
    /// 图片尺寸
    open var imageSize: CGSize = CGSize(width: 30, height: 30)

    open override func preferredItemModelInstance() -> DGCJXSegmentedBaseItemModel {
        return DGCJXSegmentedTitleOrImageItemModel()
    }

    open override func reloadData(selectedIndex: Int) {
        selectedAnimationDuration = 0.1

        super.reloadData(selectedIndex: selectedIndex)
    }

    open override func preferredRefreshItemModel( _ dgc_itemModel: DGCJXSegmentedBaseItemModel, at index: Int, selectedIndex: Int) {
        super.preferredRefreshItemModel(dgc_itemModel, at: index, selectedIndex: selectedIndex)

        guard let dgc_itemModel = dgc_itemModel as? DGCJXSegmentedTitleOrImageItemModel else {
            return
        }

        dgc_itemModel.selectedImageInfo = selectedImageInfos?[index]
        dgc_itemModel.loadImageClosure = loadImageClosure
        dgc_itemModel.imageSize = imageSize
    }

    //MARK: - DGCJXSegmentedViewDataSource
    open override func registerCellClass(in segmentedView: DGCJXSegmentedView) {
        segmentedView.collectionView.register(DGCJXSegmentedTitleOrImageCell.self, forCellWithReuseIdentifier: "cell")
    }

    open override func segmentedView(_ segmentedView: DGCJXSegmentedView, cellForItemAt index: Int) -> DGCJXSegmentedBaseCell {
        let dgc_cell = segmentedView.dequeueReusableCell(withReuseIdentifier: "dgc_cell", at: index)
        return dgc_cell
    }

}
