//
//  DGCJXSegmentedNumberDataSource.swift
//  DGCJXSegmentedView
//
//  Created by jiaxin on 2018/12/28.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import Foundation
import UIKit

open class DGCJXSegmentedNumberDataSource: DGCJXSegmentedTitleDataSource {
    /// 需要和titles数组数量一致，没有数字的item填0！！！
    open var numbers = [Int]()
    /// numberLabel的宽度补偿，numberLabel真实的宽度是文字内容的宽度加上补偿的宽度
    open var numberWidthIncrement: CGFloat = 10
    /// numberLabel的背景色
    open var numberBackgroundColor: UIColor = .red
    /// numberLabel的textColor
    open var numberTextColor: UIColor = .white
    /// numberLabel的font
    open var numberFont: UIFont = UIFont.systemFont(ofSize: 11)
    /// numberLabel的默认位置是center在titleLabel的右上角，可以通过numberOffset控制X、Y轴的偏移
    open var numberOffset: CGPoint = CGPoint.zero
    /// 如果业务需要处理超过999就像是999+，就可以通过这个闭包实现。默认显示不会对number进行处理
    open var numberStringFormatterClosure: ((Int) -> String)?
    /// numberLabel的高度，默认：14
    open var numberHeight: CGFloat = 14

    open override func preferredItemModelInstance() -> DGCJXSegmentedBaseItemModel {
        return DGCJXSegmentedNumberItemModel()
    }

    open override func preferredRefreshItemModel(_ dgc_itemModel: DGCJXSegmentedBaseItemModel, at index: Int, selectedIndex: Int) {
        super.preferredRefreshItemModel(dgc_itemModel, at: index, selectedIndex: selectedIndex)

        guard let dgc_itemModel = dgc_itemModel as? DGCJXSegmentedNumberItemModel else {
            return
        }

        dgc_itemModel.number = numbers[index]
        if numberStringFormatterClosure != nil {
            dgc_itemModel.numberString = numberStringFormatterClosure!(dgc_itemModel.number)
        }else {
            dgc_itemModel.numberString = "\(dgc_itemModel.number)"
        }
        dgc_itemModel.numberTextColor = numberTextColor
        dgc_itemModel.numberBackgroundColor = numberBackgroundColor
        dgc_itemModel.numberOffset = numberOffset
        dgc_itemModel.numberWidthIncrement = numberWidthIncrement
        dgc_itemModel.numberHeight = numberHeight
        dgc_itemModel.numberFont = numberFont
    }

    //MARK: - DGCJXSegmentedViewDataSource
    open override func registerCellClass(in segmentedView: DGCJXSegmentedView) {
        segmentedView.collectionView.register(DGCJXSegmentedNumberCell.self, forCellWithReuseIdentifier: "cell")
    }

    open override func segmentedView(_ segmentedView: DGCJXSegmentedView, cellForItemAt index: Int) -> DGCJXSegmentedBaseCell {
        let dgc_cell = segmentedView.dequeueReusableCell(withReuseIdentifier: "dgc_cell", at: index)
        return dgc_cell
    }
}
