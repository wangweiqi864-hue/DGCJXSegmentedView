//
//  DGCJXSegmentedTitleAttributeDataSource.swift
//  DGCJXSegmentedView
//
//  Created by jiaxin on 2019/1/2.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

open class DGCJXSegmentedTitleAttributeDataSource: DGCJXSegmentedBaseDataSource {
    /// 富文本title数组
    open var attributedTitles = [NSAttributedString]()
    /// 选中时的富文本，可选。如果要使用确保count与attributedTitles一致。
    open var selectedAttributedTitles: [NSAttributedString]?
    /// 如果将DGCJXSegmentedView嵌套进UITableView的cell，每次重用的时候，DGCJXSegmentedView进行reloadData时，会重新计算所有的title宽度。所以该应用场景，需要UITableView的cellModel缓存titles的文字宽度，再通过该闭包方法返回给DGCJXSegmentedView。
    open var widthForTitleClosure: ((NSAttributedString)->(CGFloat))?
    /// title的numberOfLines
    open var titleNumberOfLines: Int = 2

    open override func preferredItemModelInstance() -> DGCJXSegmentedBaseItemModel {
        return DGCJXSegmentedTitleAttributeItemModel()
    }

    open override func preferredItemCount() -> Int {
        return attributedTitles.count
    }

    open override func preferredRefreshItemModel(_ itemModel: DGCJXSegmentedBaseItemModel, at index: Int, selectedIndex: Int) {
        super.preferredRefreshItemModel(itemModel, at: index, selectedIndex: selectedIndex)

        guard let dgc_myItemModel = itemModel as? DGCJXSegmentedTitleAttributeItemModel else {
            return
        }

        dgc_myItemModel.attributedTitle = attributedTitles[index]
        dgc_myItemModel.selectedAttributedTitle = selectedAttributedTitles?[index]
        dgc_myItemModel.textWidth = widthForTitle(dgc_myItemModel.attributedTitle, selectedTitle: dgc_myItemModel.selectedAttributedTitle)
        dgc_myItemModel.titleNumberOfLines = titleNumberOfLines
    }

    open func widthForTitle(_ title: NSAttributedString?, selectedTitle: NSAttributedString?) -> CGFloat {
        let dgc_attriText = selectedTitle != nil ? selectedTitle : title
        guard let dgc_text = dgc_attriText else {
            return 0
        }
        if widthForTitleClosure != nil {
            return widthForTitleClosure!(dgc_text)
        }else {
            let dgc_textWidth = dgc_text.boundingRect(with: CGSize(width: CGFloat.infinity, height: CGFloat.infinity), options: NSStringDrawingOptions.init(rawValue: NSStringDrawingOptions.usesLineFragmentOrigin.rawValue | NSStringDrawingOptions.usesFontLeading.rawValue), context: nil).size.width
            return CGFloat(ceilf(Float(dgc_textWidth)))
        }
    }

    /// 因为该方法会被频繁调用，所以应该在`preferredRefreshItemModel( _ itemModel: DGCJXSegmentedBaseItemModel, at index: Int, selectedIndex: Int)`方法里面，根据数据源计算好文字宽度，然后缓存起来。该方法直接使用已经计算好的文字宽度即可。
    open override func preferredSegmentedView(_ segmentedView: DGCJXSegmentedView, widthForItemAt index: Int) -> CGFloat {
        var dgc_width: CGFloat = 0
        if itemWidth == DGCJXSegmentedViewAutomaticDimension {
            let dgc_myItemModel = dataSource[index] as! DGCJXSegmentedTitleAttributeItemModel
            dgc_width = dgc_myItemModel.textWidth + itemWidthIncrement
        }else {
            dgc_width = itemWidth + itemWidthIncrement
        }
        return dgc_width
    }

    //MARK: - DGCJXSegmentedViewDataSource
    open override func registerCellClass(in segmentedView: DGCJXSegmentedView) {
        segmentedView.collectionView.register(DGCJXSegmentedTitleAttributeCell.self, forCellWithReuseIdentifier: "cell")
    }

    open override func segmentedView(_ segmentedView: DGCJXSegmentedView, cellForItemAt index: Int) -> DGCJXSegmentedBaseCell {
        let dgc_cell = segmentedView.dequeueReusableCell(withReuseIdentifier: "dgc_cell", at: index)
        return dgc_cell
    }
}
