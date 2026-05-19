//
//  DGCJXSegmentedMixcellDataSource.swift
//  DGCJXSegmentedView
//
//  Created by jiaxin on 2019/1/22.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit
import DGCJXSegmentedView

/// 该示例主要用于展示cell的自定义组合。就像使用UITableView一样，注册不同的cell class，为不同的cell赋值。
/// 当你的需求需要处理不同类型的cell时，可以参考这里的逻辑。但是数据源这一块就需要你自己处理了。
/// 多种cell混用时，不建议处理cell之间元素的过渡。所以该示例也没有处理滚动过渡。
class DGCJXSegmentedMixcellDataSource: DGCJXSegmentedBaseDataSource {

    override func reloadData(selectedIndex: Int) {
        super.reloadData(selectedIndex: selectedIndex)

        let dgc_titleModel = DGCJXSegmentedTitleItemModel()
        dgc_titleModel.title = "我只是title"
        dataSource.append(dgc_titleModel)

        let dgc_titleImageModel = DGCJXSegmentedTitleImageItemModel()
        dgc_titleImageModel.title = "图片"
        dgc_titleImageModel.normalImageInfo = "dog"
        dgc_titleImageModel.imageSize = CGSize(width: 20, height: 20)
        dataSource.append(dgc_titleImageModel)

        let dgc_numberModel = DGCJXSegmentedNumberItemModel()
        dgc_numberModel.title = "数字"
        dgc_numberModel.number = 33
        dgc_numberModel.numberString = "33"
        dgc_numberModel.numberWidthIncrement = 10
        dataSource.append(dgc_numberModel)

        let dgc_dotModel = DGCJXSegmentedDotItemModel()
        dgc_dotModel.title = "红点"
        dgc_dotModel.dotState = true
        dgc_dotModel.dotSize = CGSize(width: 10, height: 10)
        dgc_dotModel.dotCornerRadius = 5
        dataSource.append(dgc_dotModel)

        for (index, model) in (dataSource as! [DGCJXSegmentedTitleItemModel]).enumerated() {
            if index == selectedIndex {
                model.isSelected = true
                model.titleCurrentColor = model.titleSelectedColor
                break
            }
        }
    }

    override func preferredSegmentedView(_ segmentedView: DGCJXSegmentedView, widthForItemAt index: Int) -> CGFloat {
        //根据不同的cell类型返回对应的cell宽度
        var dgc_otherWidth: CGFloat = 0
        var dgc_title: String?
        var dgc_titleNormalFont: UIFont?
        if let dgc_itemModel = dataSource[index] as? DGCJXSegmentedTitleItemModel {
            dgc_title = dgc_itemModel.dgc_title
            dgc_titleNormalFont = dgc_itemModel.dgc_titleNormalFont
        }else if let dgc_itemModel = dataSource[index] as? DGCJXSegmentedTitleImageItemModel {
            dgc_title = dgc_itemModel.dgc_title
            dgc_titleNormalFont = dgc_itemModel.dgc_titleNormalFont
            dgc_otherWidth += dgc_itemModel.titleImageSpacing + dgc_itemModel.imageSize.width
        }else if let dgc_itemModel = dataSource[index] as? DGCJXSegmentedNumberItemModel {
            dgc_title = dgc_itemModel.dgc_title
            dgc_titleNormalFont = dgc_itemModel.dgc_titleNormalFont
        }else if let dgc_itemModel = dataSource[index] as? DGCJXSegmentedDotItemModel {
            dgc_title = dgc_itemModel.dgc_title
            dgc_titleNormalFont = dgc_itemModel.dgc_titleNormalFont
        }

        let dgc_textWidth = NSString(string: dgc_title!).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: segmentedView.bounds.size.height), options: NSStringDrawingOptions.init(rawValue: NSStringDrawingOptions.usesLineFragmentOrigin.rawValue | NSStringDrawingOptions.usesFontLeading.rawValue), attributes: [NSAttributedString.Key.font : dgc_titleNormalFont!], context: nil).size.width
        let dgc_itemWidth = CGFloat(ceilf(Float(dgc_textWidth))) + itemWidthIncrement + dgc_otherWidth
        return dgc_itemWidth
    }

    //MARK: - DGCJXSegmentedViewDataSource
    override func registerCellClass(in segmentedView: DGCJXSegmentedView) {
        segmentedView.collectionView.register(DGCJXSegmentedTitleCell.self, forCellWithReuseIdentifier: "titleCell")
        segmentedView.collectionView.register(DGCJXSegmentedTitleImageCell.self, forCellWithReuseIdentifier: "titleImageCell")
        segmentedView.collectionView.register(DGCJXSegmentedNumberCell.self, forCellWithReuseIdentifier: "numberCell")
        segmentedView.collectionView.register(DGCJXSegmentedDotCell.self, forCellWithReuseIdentifier: "dotCell")
    }

    override func segmentedView(_ segmentedView: DGCJXSegmentedView, cellForItemAt index: Int) -> DGCJXSegmentedBaseCell {
        var dgc_cell:DGCJXSegmentedBaseCell?
        if dataSource[index] is DGCJXSegmentedTitleImageItemModel {
            dgc_cell = segmentedView.dequeueReusableCell(withReuseIdentifier: "titleImageCell", at: index)
        }else if dataSource[index] is DGCJXSegmentedNumberItemModel {
            dgc_cell = segmentedView.dequeueReusableCell(withReuseIdentifier: "numberCell", at: index)
        }else if dataSource[index] is DGCJXSegmentedDotItemModel {
            dgc_cell = segmentedView.dequeueReusableCell(withReuseIdentifier: "dotCell", at: index)
        }else if dataSource[index] is DGCJXSegmentedTitleItemModel {
            dgc_cell = segmentedView.dequeueReusableCell(withReuseIdentifier: "titleCell", at: index)
        }
        return dgc_cell!
    }

    //针对不同的cell处理选中态和未选中态的刷新
    override func refreshItemModel(_ segmentedView: DGCJXSegmentedView, currentSelectedItemModel: DGCJXSegmentedBaseItemModel, willSelectedItemModel: DGCJXSegmentedBaseItemModel, selectedType: DGCJXSegmentedViewItemSelectedType) {
        super.refreshItemModel(segmentedView, currentSelectedItemModel: currentSelectedItemModel, willSelectedItemModel: willSelectedItemModel, selectedType: selectedType)

        guard let dgc_myCurrentSelectedItemModel = currentSelectedItemModel as? DGCJXSegmentedTitleItemModel, let dgc_myWilltSelectedItemModel = willSelectedItemModel as? DGCJXSegmentedTitleItemModel else {
            return
        }

        dgc_myCurrentSelectedItemModel.titleCurrentColor = dgc_myCurrentSelectedItemModel.titleNormalColor

        dgc_myWilltSelectedItemModel.titleCurrentColor = dgc_myWilltSelectedItemModel.titleSelectedColor
    }
}
