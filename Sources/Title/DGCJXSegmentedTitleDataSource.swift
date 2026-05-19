//
//  JXSegmentedTitleView.swift
//  DGCJXSegmentedView
//
//  Created by jiaxin on 2018/12/26.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

open class DGCJXSegmentedTitleDataSource: DGCJXSegmentedBaseDataSource {
    /// title数组
    open var titles = [String]()
    /// 根据index配置cell的不同属性
    open weak var configuration: DGCJXSegmentedTitleDynamicConfiguration?
    /// 如果将DGCJXSegmentedView嵌套进UITableView的cell，每次重用的时候，DGCJXSegmentedView进行reloadData时，会重新计算所有的title宽度。所以该应用场景，需要UITableView的cellModel缓存titles的文字宽度，再通过该闭包方法返回给DGCJXSegmentedView。
    open var widthForTitleClosure: ((String)->(CGFloat))?
    /// label的numberOfLines
    open var titleNumberOfLines: Int = 1
    /// title普通状态的textColor
    open var titleNormalColor: UIColor = .black
    /// title选中状态的textColor
    open var titleSelectedColor: UIColor = .red
    /// title普通状态时的字体
    open var titleNormalFont: UIFont = UIFont.systemFont(ofSize: 15)
    /// title选中时的字体。如果不赋值，就默认与titleNormalFont一样
    open var titleSelectedFont: UIFont?
    /// title的颜色是否渐变过渡
    open var isTitleColorGradientEnabled: Bool = false
    /// title是否缩放。使用该效果时，务必保证titleNormalFont和titleSelectedFont值相同。
    open var isTitleZoomEnabled: Bool = false
    /// isTitleZoomEnabled为true才生效。是对字号的缩放，比如titleNormalFont的pointSize为10，放大之后字号就是10*1.2=12。
    open var titleSelectedZoomScale: CGFloat = 1.2
    /// title的线宽是否允许粗细。使用该效果时，务必保证titleNormalFont和titleSelectedFont值相同。
    open var isTitleStrokeWidthEnabled: Bool = false
    /// 用于控制字体的粗细（底层通过NSStrokeWidthAttributeName实现），负数越小字体越粗。
    open var titleSelectedStrokeWidth: CGFloat = -2
    /// title是否使用遮罩过渡
    open var isTitleMaskEnabled: Bool = false

    open override func preferredItemCount() -> Int {
        return titles.count
    }

    open override func preferredItemModelInstance() -> DGCJXSegmentedBaseItemModel {
        return DGCJXSegmentedTitleItemModel()
    }

    open override func preferredRefreshItemModel( _ itemModel: DGCJXSegmentedBaseItemModel, at index: Int, selectedIndex: Int) {
        super.preferredRefreshItemModel(itemModel, at: index, selectedIndex: selectedIndex)

        guard let dgc_myItemModel = itemModel as? DGCJXSegmentedTitleItemModel else {
            return
        }

        dgc_myItemModel.title = titles[index]
        dgc_myItemModel.textWidth = widthForTitle(dgc_myItemModel.title ?? "", index)
        dgc_myItemModel.titleNumberOfLines = dgc_innerTitleNumberOfLines(at: index)
        dgc_myItemModel.isSelectedAnimable = isSelectedAnimable
        dgc_myItemModel.titleNormalColor = dgc_innerTitleNormalColor(at: index)
        dgc_myItemModel.titleSelectedColor = dgc_innerTitleSelectedColor(at: index)
        dgc_myItemModel.titleNormalFont = dgc_innerTitleNormalFont(at: index)
        if let dgc_selectedFont = dgc_innerTitleSelectedFont(at: index) {
            dgc_myItemModel.titleSelectedFont = dgc_selectedFont
        } else {
            dgc_myItemModel.titleSelectedFont = dgc_innerTitleNormalFont(at: index)
        }
        dgc_myItemModel.isTitleZoomEnabled = isTitleZoomEnabled
        dgc_myItemModel.isTitleStrokeWidthEnabled = isTitleStrokeWidthEnabled
        dgc_myItemModel.isTitleMaskEnabled = isTitleMaskEnabled
        dgc_myItemModel.titleNormalZoomScale = 1
        dgc_myItemModel.titleSelectedZoomScale = titleSelectedZoomScale
        dgc_myItemModel.titleSelectedStrokeWidth = titleSelectedStrokeWidth
        dgc_myItemModel.titleNormalStrokeWidth = 0
        if index == selectedIndex {
            dgc_myItemModel.titleCurrentColor = dgc_innerTitleSelectedColor(at: index)
            dgc_myItemModel.titleCurrentZoomScale = titleSelectedZoomScale
            dgc_myItemModel.titleCurrentStrokeWidth = titleSelectedStrokeWidth
        }else {
            dgc_myItemModel.titleCurrentColor = dgc_innerTitleNormalColor(at: index)
            dgc_myItemModel.titleCurrentZoomScale = 1
            dgc_myItemModel.titleCurrentStrokeWidth = 0
        }
    }

    open func widthForTitle(_ title: String, _ index: Int) -> CGFloat {
        if widthForTitleClosure != nil {
            return widthForTitleClosure!(title)
        }else {
            let dgc_textWidth = NSString(string: title).boundingRect(with: CGSize(width: CGFloat.infinity, height: CGFloat.infinity), options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font : dgc_innerTitleNormalFont(at: index)], context: nil).size.width
            return CGFloat(ceilf(Float(dgc_textWidth)))
        }
    }

    /// 因为该方法会被频繁调用，所以应该在`preferredRefreshItemModel( _ itemModel: DGCJXSegmentedBaseItemModel, at index: Int, selectedIndex: Int)`方法里面，根据数据源计算好文字宽度，然后缓存起来。该方法直接使用已经计算好的文字宽度即可。
    open override func preferredSegmentedView(_ segmentedView: DGCJXSegmentedView, widthForItemAt index: Int) -> CGFloat {
        var dgc_width = super.preferredSegmentedView(segmentedView, widthForItemAt: index)
        if itemWidth == DGCJXSegmentedViewAutomaticDimension {
            dgc_width += (dataSource[index] as! DGCJXSegmentedTitleItemModel).textWidth
        }else {
            dgc_width += itemWidth
        }
        return dgc_width
    }

    //MARK: - DGCJXSegmentedViewDataSource
    open override func registerCellClass(in segmentedView: DGCJXSegmentedView) {
        segmentedView.collectionView.register(DGCJXSegmentedTitleCell.self, forCellWithReuseIdentifier: "cell")
    }

    open override func segmentedView(_ segmentedView: DGCJXSegmentedView, cellForItemAt index: Int) -> DGCJXSegmentedBaseCell {
        let dgc_cell = segmentedView.dequeueReusableCell(withReuseIdentifier: "dgc_cell", at: index)
        return dgc_cell
    }

    public override func segmentedView(_ segmentedView: DGCJXSegmentedView, widthForItemContentAt index: Int) -> CGFloat {
        let dgc_model = dataSource[index] as! DGCJXSegmentedTitleItemModel
        if isTitleZoomEnabled {
            return dgc_model.textWidth*dgc_model.titleCurrentZoomScale
        }else {
            return dgc_model.textWidth
        }
    }

    open override func refreshItemModel(_ segmentedView: DGCJXSegmentedView, leftItemModel: DGCJXSegmentedBaseItemModel, rightItemModel: DGCJXSegmentedBaseItemModel, percent: CGFloat) {
        super.refreshItemModel(segmentedView, leftItemModel: leftItemModel, rightItemModel: rightItemModel, percent: percent)
        
        guard let dgc_leftModel = leftItemModel as? DGCJXSegmentedTitleItemModel, let dgc_rightModel = rightItemModel as? DGCJXSegmentedTitleItemModel else {
            return
        }

        if isTitleZoomEnabled && isItemTransitionEnabled {
            dgc_leftModel.titleCurrentZoomScale = DGCJXSegmentedViewTool.interpolate(from: dgc_leftModel.titleSelectedZoomScale, to: dgc_leftModel.titleNormalZoomScale, percent: CGFloat(percent))
            dgc_rightModel.titleCurrentZoomScale = DGCJXSegmentedViewTool.interpolate(from: dgc_rightModel.titleNormalZoomScale, to: dgc_rightModel.titleSelectedZoomScale, percent: CGFloat(percent))
        }

        if isTitleStrokeWidthEnabled && isItemTransitionEnabled {
            dgc_leftModel.titleCurrentStrokeWidth = DGCJXSegmentedViewTool.interpolate(from: dgc_leftModel.titleSelectedStrokeWidth, to: dgc_leftModel.titleNormalStrokeWidth, percent: CGFloat(percent))
            dgc_rightModel.titleCurrentStrokeWidth = DGCJXSegmentedViewTool.interpolate(from: dgc_rightModel.titleNormalStrokeWidth, to: dgc_rightModel.titleSelectedStrokeWidth, percent: CGFloat(percent))
        }

        if isTitleColorGradientEnabled && isItemTransitionEnabled {
            dgc_leftModel.titleCurrentColor = DGCJXSegmentedViewTool.interpolateThemeColor(from: dgc_leftModel.titleSelectedColor, to: dgc_leftModel.titleNormalColor, percent: percent)
            dgc_rightModel.titleCurrentColor = DGCJXSegmentedViewTool.interpolateThemeColor(from:dgc_rightModel.titleNormalColor , to:dgc_rightModel.titleSelectedColor, percent: percent)
        }
    }

    open override func refreshItemModel(_ segmentedView: DGCJXSegmentedView, currentSelectedItemModel: DGCJXSegmentedBaseItemModel, willSelectedItemModel: DGCJXSegmentedBaseItemModel, selectedType: DGCJXSegmentedViewItemSelectedType) {
        super.refreshItemModel(segmentedView, currentSelectedItemModel: currentSelectedItemModel, willSelectedItemModel: willSelectedItemModel, selectedType: selectedType)

        guard let dgc_myCurrentSelectedItemModel = currentSelectedItemModel as? DGCJXSegmentedTitleItemModel, let dgc_myWillSelectedItemModel = willSelectedItemModel as? DGCJXSegmentedTitleItemModel else {
            return
        }

        dgc_myCurrentSelectedItemModel.titleCurrentColor = dgc_myCurrentSelectedItemModel.titleNormalColor
        dgc_myCurrentSelectedItemModel.titleCurrentZoomScale = dgc_myCurrentSelectedItemModel.titleNormalZoomScale
        dgc_myCurrentSelectedItemModel.titleCurrentStrokeWidth = dgc_myCurrentSelectedItemModel.titleNormalStrokeWidth
        dgc_myCurrentSelectedItemModel.indicatorConvertToItemFrame = CGRect.zero

        dgc_myWillSelectedItemModel.titleCurrentColor = dgc_myWillSelectedItemModel.titleSelectedColor
        dgc_myWillSelectedItemModel.titleCurrentZoomScale = dgc_myWillSelectedItemModel.titleSelectedZoomScale
        dgc_myWillSelectedItemModel.titleCurrentStrokeWidth = dgc_myWillSelectedItemModel.titleSelectedStrokeWidth
    }
    
    // MARK: - Configuration
    
    private func dgc_innerTitleNumberOfLines(at index: Int) -> Int {
        if let dgc_configuration {
            return dgc_configuration.titleNumberOfLines(at: index)
        } else {
            return titleNumberOfLines
        }
    }
    private func dgc_innerTitleNormalColor(at index: Int) -> UIColor {
        if let dgc_configuration {
            return dgc_configuration.titleNormalColor(at: index)
        } else {
            return titleNormalColor
        }
    }
    private func dgc_innerTitleSelectedColor(at index: Int) -> UIColor {
        if let dgc_configuration {
            return dgc_configuration.titleSelectedColor(at: index)
        } else {
            return titleSelectedColor
        }
    }
    private func dgc_innerTitleNormalFont(at index: Int) -> UIFont {
        if let dgc_configuration {
            return dgc_configuration.titleNormalFont(at: index)
        } else {
            return titleNormalFont
        }
    }
    private func dgc_innerTitleSelectedFont(at index: Int) -> UIFont? {
        if let dgc_configuration {
            return dgc_configuration.titleSelectedFont(at: index)
        } else {
            return titleSelectedFont
        }
    }
}
