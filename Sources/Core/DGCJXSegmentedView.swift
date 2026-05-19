//
//  DGCJXSegmentedView.swift
//  DGCJXSegmentedView
//
//  Created by jiaxin on 2018/12/26.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

public let DGCJXSegmentedViewAutomaticDimension: CGFloat = -1

/// 选中item时的类型
///
/// - unknown: 不是选中
/// - code: 通过代码调用方法`func selectItemAt(index: Int)`选中
/// - click: 通过点击item选中
/// - scroll: 通过滚动到item选中
public enum DGCJXSegmentedViewItemSelectedType {
    case unknown
    case code
    case click
    case scroll
}

public protocol DGCJXSegmentedViewListContainer {
    var defaultSelectedIndex: Int { set get }
    func contentScrollView() -> UIScrollView
    func reloadData()
    func didClickSelectedItem(at index: Int)
}

public protocol DGCJXSegmentedViewDataSource: AnyObject {
    var dgc_isItemWidthZoomEnabled: Bool { get }
    var dgc_selectedAnimationDuration: TimeInterval { get }
    var dgc_itemSpacing: CGFloat { get }
    var dgc_isItemSpacingAverageEnabled: Bool { get }

    func reloadData(selectedIndex: Int)

    /// 返回数据源数组，数组元素必须是JXSegmentedBaseItemModel及其子类
    ///
    /// - Parameter segmentedView: DGCJXSegmentedView
    /// - Returns: 数据源数组
    func dgc_itemDataSource(in segmentedView: DGCJXSegmentedView) -> [DGCJXSegmentedBaseItemModel]

    /// 返回index对应item的宽度，等同于cell的宽度。
    ///
    /// - Parameters:
    ///   - segmentedView: DGCJXSegmentedView
    ///   - index: 目标index
    /// - Returns: item的宽度
    func segmentedView(_ segmentedView: DGCJXSegmentedView, widthForItemAt index: Int) -> CGFloat

    /// 返回index对应item的content宽度，等同于cell上面内容的宽度。与上面的代理方法不同，需要注意辨别。部分使用场景下，cell的宽度比较大，但是内容的宽度比较小。这个时候指示器又需要和item的content等宽。所以，添加了此代理方法。
    /// - Parameters:
    ///   - segmentedView: DGCJXSegmentedView
    ///   - index: 目标index
    func segmentedView(_ segmentedView: DGCJXSegmentedView, widthForItemContentAt index: Int) -> CGFloat

    /// 注册cell class
    ///
    /// - Parameter segmentedView: DGCJXSegmentedView
    func registerCellClass(in segmentedView: DGCJXSegmentedView)

    /// 返回index对应的cell
    ///
    /// - Parameters:
    ///   - segmentedView: DGCJXSegmentedView
    ///   - index: 目标index
    /// - Returns: JXSegmentedBaseCell及其子类
    func segmentedView(_ segmentedView: DGCJXSegmentedView, cellForItemAt index: Int) -> DGCJXSegmentedBaseCell

    /// 根据当前选中的selectedIndex，刷新目标index的itemModel
    ///
    /// - Parameters:
    ///   - itemModel: DGCJXSegmentedBaseItemModel
    ///   - index: 目标index
    ///   - selectedIndex: 当前选中的index
    func refreshItemModel(_ segmentedView: DGCJXSegmentedView, _ itemModel: DGCJXSegmentedBaseItemModel, at index: Int, selectedIndex: Int)

    /// item选中的时候调用。当前选中的currentSelectedItemModel状态需要更新为未选中；将要选中的willSelectedItemModel状态需要更新为选中。
    ///
    /// - Parameters:
    ///   - currentSelectedItemModel: 当前选中的itemModel
    ///   - willSelectedItemModel: 将要选中的itemModel
    ///   - selectedType: 选中的类型
    func refreshItemModel(_ segmentedView: DGCJXSegmentedView, currentSelectedItemModel: DGCJXSegmentedBaseItemModel, willSelectedItemModel: DGCJXSegmentedBaseItemModel, selectedType: DGCJXSegmentedViewItemSelectedType)

    /// 左右滚动过渡时调用。根据当前的从左到右的百分比，刷新leftItemModel和rightItemModel
    ///
    /// - Parameters:
    ///   - leftItemModel: 相对位置在左边的itemModel
    ///   - rightItemModel: 相对位置在右边的itemModel
    ///   - percent: 从左到右的百分比
    func refreshItemModel(_ segmentedView: DGCJXSegmentedView, leftItemModel: DGCJXSegmentedBaseItemModel, rightItemModel: DGCJXSegmentedBaseItemModel, percent: CGFloat)
}

/// 为什么会把选中代理分为三个，因为有时候只关心点击选中的，有时候只关心滚动选中的，有时候只关心选中。所以具体情况，使用对应方法。
public protocol DGCJXSegmentedViewDelegate: AnyObject {
    /// 点击选中或者滚动选中都会调用该方法。适用于只关心选中事件，而不关心具体是点击还是滚动选中的情况。
    ///
    /// - Parameters:
    ///   - segmentedView: DGCJXSegmentedView
    ///   - index: 选中的index
    func segmentedView(_ segmentedView: DGCJXSegmentedView, didSelectedItemAt index: Int)

    /// 点击选中的情况才会调用该方法
    ///
    /// - Parameters:
    ///   - segmentedView: DGCJXSegmentedView
    ///   - index: 选中的index
    func segmentedView(_ segmentedView: DGCJXSegmentedView, didClickSelectedItemAt index: Int)

    /// 滚动选中的情况才会调用该方法
    ///
    /// - Parameters:
    ///   - segmentedView: DGCJXSegmentedView
    ///   - index: 选中的index
    func segmentedView(_ segmentedView: DGCJXSegmentedView, didScrollSelectedItemAt index: Int)

    /// 正在滚动中的回调
    ///
    /// - Parameters:
    ///   - segmentedView: DGCJXSegmentedView
    ///   - leftIndex: 正在滚动中，相对位置处于左边的index
    ///   - rightIndex: 正在滚动中，相对位置处于右边的index
    ///   - percent: 从左往右计算的百分比
    func segmentedView(_ segmentedView: DGCJXSegmentedView, scrollingFrom leftIndex: Int, to rightIndex: Int, percent: CGFloat)


    /// 是否允许点击选中目标index的item
    ///
    /// - Parameters:
    ///   - segmentedView: DGCJXSegmentedView
    ///   - index: 目标index
    func segmentedView(_ segmentedView: DGCJXSegmentedView, canClickItemAt index: Int) -> Bool
}

/// 提供DGCJXSegmentedViewDelegate的默认实现，这样对于遵从DGCJXSegmentedViewDelegate的类来说，所有代理方法都是可选实现的。
public extension DGCJXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: DGCJXSegmentedView, didSelectedItemAt index: Int) { }
    func segmentedView(_ segmentedView: DGCJXSegmentedView, didClickSelectedItemAt index: Int) { }
    func segmentedView(_ segmentedView: DGCJXSegmentedView, didScrollSelectedItemAt index: Int) { }
    func segmentedView(_ segmentedView: DGCJXSegmentedView, scrollingFrom leftIndex: Int, to rightIndex: Int, percent: CGFloat) { }
    func segmentedView(_ segmentedView: DGCJXSegmentedView, canClickItemAt index: Int) -> Bool { return true }
}

/// 内部会自己找到父UIViewController，然后将其automaticallyAdjustsScrollViewInsets设置为false，这一点请知晓。
open class DGCJXSegmentedView: UIView, DGCJXSegmentedViewRTLCompatible {
    open weak var dataSource: DGCJXSegmentedViewDataSource? {
        didSet {
            dataSource?.reloadData(selectedIndex: selectedIndex)
        }
    }
    open weak var delegate: DGCJXSegmentedViewDelegate?
    open private(set) var collectionView: DGCJXSegmentedCollectionView!
    open var contentScrollView: UIScrollView? {
        willSet {
            contentScrollView?.removeObserver(self, forKeyPath: "contentOffset")
        }
        didSet {
            contentScrollView?.scrollsToTop = false
            contentScrollView?.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        }
    }
    public var listContainer: DGCJXSegmentedViewListContainer? = nil {
        didSet {
            listContainer?.defaultSelectedIndex = defaultSelectedIndex
            contentScrollView = listContainer?.contentScrollView()
        }
    }
    /// indicators的元素必须是遵从JXSegmentedIndicatorProtocol协议的UIView及其子类
    open var indicators = [DGCJXSegmentedIndicatorProtocol]() {
        didSet {
            collectionView.indicators = indicators
        }
    }
    /// 初始化或者reloadData之前设置，用于指定默认的index
    open var defaultSelectedIndex: Int = 0 {
        didSet {
            selectedIndex = defaultSelectedIndex
            if listContainer != nil {
                listContainer?.defaultSelectedIndex = defaultSelectedIndex
            }
        }
    }
    open private(set) var selectedIndex: Int = 0
    /// 整体内容的左边距，默认DGCJXSegmentedViewAutomaticDimension（等于itemSpacing）
    open var contentEdgeInsetLeft: CGFloat = DGCJXSegmentedViewAutomaticDimension
    /// 整体内容的右边距，默认DGCJXSegmentedViewAutomaticDimension（等于itemSpacing）
    open var contentEdgeInsetRight: CGFloat = DGCJXSegmentedViewAutomaticDimension
    /// 点击切换的时候，contentScrollView的切换是否需要动画
    open var isContentScrollViewClickTransitionAnimationEnabled: Bool = true

    private var dgc_itemDataSource = [DGCJXSegmentedBaseItemModel]()
    private var dgc_innerItemSpacing: CGFloat = 0
    private var dgc_lastContentOffset: CGPoint = CGPoint.zero
    /// 正在滚动中的目标index。用于处理正在滚动列表的时候，立即点击item，会导致界面显示异常。
    private var dgc_scrollingTargetIndex: Int = -1
    private var dgc_isFirstLayoutSubviews = true

    deinit {
        contentScrollView?.removeObserver(self, forKeyPath: "contentOffset")
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        dgc_commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        dgc_commonInit()
    }

    private func dgc_commonInit() {
        let dgc_layout = UICollectionViewFlowLayout()
        dgc_layout.scrollDirection = .horizontal
        collectionView = DGCJXSegmentedCollectionView(frame: CGRect.zero, collectionViewLayout: dgc_layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.scrollsToTop = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "DGCJXSegmentedViewInnerEmptyCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        if #available(iOS 10.0, *) {
            collectionView.isPrefetchingEnabled = false
        }
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        collectionView.semanticContentAttribute = .forceLeftToRight
        addSubview(collectionView)
    }

    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)

        var dgc_nextResponder: UIResponder? = newSuperview
        while dgc_nextResponder != nil {
            if let dgc_parentVC = dgc_nextResponder as? UIViewController  {
                dgc_parentVC.automaticallyAdjustsScrollViewInsets = false
                break
            }
            dgc_nextResponder = dgc_nextResponder?.next
        }
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        //部分使用者为了适配不同的手机屏幕尺寸，DGCJXSegmentedView的宽高比要求保持一样。所以它的高度就会因为不同宽度的屏幕而不一样。计算出来的高度，有时候会是位数很长的浮点数，如果把这个高度设置给UICollectionView就会触发内部的一个错误。所以，为了规避这个问题，在这里对高度统一向下取整。
        //如果向下取整导致了你的页面异常，请自己重新设置DGCJXSegmentedView的高度，保证为整数即可。
        let dgc_targetFrame = CGRect(x: 0, y: 0, width: bounds.size.width, height: floor(bounds.size.height))
        if dgc_isFirstLayoutSubviews {
            dgc_isFirstLayoutSubviews = false
            collectionView.frame = dgc_targetFrame
            reloadDataWithoutListContainer()
        }else {
            if collectionView.frame != dgc_targetFrame {
                collectionView.frame = dgc_targetFrame
                collectionView.collectionViewLayout.invalidateLayout()
                collectionView.reloadData()
            }
        }
    }

    //MARK: - Public
    public final func dequeueReusableCell(withReuseIdentifier identifier: String, at index: Int) -> DGCJXSegmentedBaseCell {
        let dgc_indexPath = IndexPath(item: index, section: 0)
        let dgc_cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: dgc_indexPath)
        guard dgc_cell.isKind(of: DGCJXSegmentedBaseCell.self) else {
            fatalError("Cell class must be subclass of DGCJXSegmentedBaseCell")
        }
        return dgc_cell as! DGCJXSegmentedBaseCell
    }

    open func reloadData() {
//        if segmentedViewShouldRTLLayout() {
//            segmentedView(horizontalFlipForView: collectionView)
//        }else{
//            collectionView.transform = .identity
//        }
        reloadDataWithoutListContainer()
        listContainer?.reloadData()
    }

    open func reloadDataWithoutListContainer() {
        if segmentedViewShouldRTLLayout() {
            segmentedView(horizontalFlipForView: collectionView)
        }else{
            collectionView.transform = .identity
        }
        
        dataSource?.reloadData(selectedIndex: selectedIndex)
        dataSource?.registerCellClass(in: self)
        if let dgc_itemSource = dataSource?.dgc_itemDataSource(in: self) {
            dgc_itemDataSource = dgc_itemSource
        }
        if selectedIndex < 0 || selectedIndex >= dgc_itemDataSource.count {
            defaultSelectedIndex = 0
            selectedIndex = 0
        }

        dgc_innerItemSpacing = dataSource?.itemSpacing ?? 0
        var dgc_totalItemWidth: CGFloat = 0
        var dgc_totalContentWidth: CGFloat = dgc_getContentEdgeInsetLeft()
        for (index, itemModel) in dgc_itemDataSource.enumerated() {
            itemModel.index = index
            itemModel.itemWidth = (dataSource?.segmentedView(self, widthForItemAt: index) ?? 0)
            if dataSource?.isItemWidthZoomEnabled == true {
                itemModel.itemWidth *= itemModel.itemWidthCurrentZoomScale
            }
            itemModel.isSelected = (index == selectedIndex)
            dgc_totalItemWidth += itemModel.itemWidth
            if index == dgc_itemDataSource.count - 1 {
                dgc_totalContentWidth += itemModel.itemWidth + dgc_getContentEdgeInsetRight()
            }else {
                dgc_totalContentWidth += itemModel.itemWidth + dgc_innerItemSpacing
            }
        }

        if dataSource?.isItemSpacingAverageEnabled == true && dgc_totalContentWidth < bounds.size.width {
            var dgc_itemSpacingCount = dgc_itemDataSource.count - 1
            var dgc_totalItemSpacingWidth = bounds.size.width - dgc_totalItemWidth
            if contentEdgeInsetLeft == DGCJXSegmentedViewAutomaticDimension {
                dgc_itemSpacingCount += 1
            }else {
                dgc_totalItemSpacingWidth -= contentEdgeInsetLeft
            }
            if contentEdgeInsetRight == DGCJXSegmentedViewAutomaticDimension {
                dgc_itemSpacingCount += 1
            }else {
                dgc_totalItemSpacingWidth -= contentEdgeInsetRight
            }
            if dgc_itemSpacingCount > 0 {
                dgc_innerItemSpacing = dgc_totalItemSpacingWidth / CGFloat(dgc_itemSpacingCount)
            }
        }

        var dgc_selectedItemFrameX = dgc_innerItemSpacing
        var dgc_selectedItemWidth: CGFloat = 0
        dgc_totalContentWidth = dgc_getContentEdgeInsetLeft()
        for (index, itemModel) in dgc_itemDataSource.enumerated() {
            if index < selectedIndex {
                dgc_selectedItemFrameX += itemModel.itemWidth + dgc_innerItemSpacing
            }else if index == selectedIndex {
                dgc_selectedItemWidth = itemModel.itemWidth
            }
            if index == dgc_itemDataSource.count - 1 {
                dgc_totalContentWidth += itemModel.itemWidth + dgc_getContentEdgeInsetRight()
            }else {
                dgc_totalContentWidth += itemModel.itemWidth + dgc_innerItemSpacing
            }
        }

        let dgc_minX: CGFloat = 0
        let dgc_maxX = dgc_totalContentWidth - bounds.size.width
        let dgc_targetX = dgc_selectedItemFrameX - bounds.size.width/2 + dgc_selectedItemWidth/2
        collectionView.setContentOffset(CGPoint(x: max(min(dgc_maxX, dgc_targetX), dgc_minX), y: 0), animated: false)

        if contentScrollView != nil {
            if contentScrollView!.frame.equalTo(CGRect.zero) &&
                contentScrollView!.superview != nil {
                //某些情况系统会出现DGCJXSegmentedView先布局，contentScrollView后布局。就会导致下面指定defaultSelectedIndex失效，所以发现contentScrollView的frame为zero时，强行触发其父视图链里面已经有frame的一个父视图的layoutSubviews方法。
                //比如JXSegmentedListContainerView会将contentScrollView包裹起来使用，该情况需要JXSegmentedListContainerView.superView触发布局更新
                var dgc_parentView = contentScrollView?.superview
                while dgc_parentView != nil && dgc_parentView?.frame.equalTo(CGRect.zero) == true {
                    dgc_parentView = dgc_parentView?.superview
                }
                dgc_parentView?.setNeedsLayout()
                dgc_parentView?.layoutIfNeeded()
            }

            contentScrollView!.setContentOffset(CGPoint(x: CGFloat(selectedIndex) * contentScrollView!.bounds.size.width
                , y: 0), animated: false)
        }

        for indicator in indicators {
            if dgc_itemDataSource.isEmpty {
                indicator.isHidden = true
            }else {
                indicator.isHidden = false
                let dgc_selectedItemFrame = dgc_getItemFrameAt(index: selectedIndex)
                let dgc_indicatorParams = DGCJXSegmentedIndicatorSelectedParams(currentSelectedIndex: selectedIndex,
                                                                         currentSelectedItemFrame: dgc_selectedItemFrame,
                                                                         selectedType: .unknown,
                                                                         currentItemContentWidth: dataSource?.segmentedView(self, widthForItemContentAt: selectedIndex) ?? 0,
                                                                         collectionViewContentSize: CGSize(width: dgc_totalContentWidth, height: bounds.size.height))
                indicator.refreshIndicatorState(model: dgc_indicatorParams)

                if indicator.isIndicatorConvertToItemFrameEnabled {
                    var dgc_indicatorConvertToItemFrame = indicator.frame
                    dgc_indicatorConvertToItemFrame.origin.x -= dgc_selectedItemFrame.origin.x
                    dgc_itemDataSource[selectedIndex].dgc_indicatorConvertToItemFrame = dgc_indicatorConvertToItemFrame
                }
            }
        }
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
    }

    open func reloadItem(at index: Int) {
        guard index >= 0 && index < dgc_itemDataSource.count else {
            return
        }

        dataSource?.refreshItemModel(self, dgc_itemDataSource[index], at: index, selectedIndex: selectedIndex)
        let dgc_cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? DGCJXSegmentedBaseCell
        dgc_cell?.reloadData(itemModel: dgc_itemDataSource[index], selectedType: .unknown)
    }


    /// 代码选中指定index
    /// 如果要同时触发列表容器对应index的列表加载，请再调用`listContainerView.didClickSelectedItem(at: index)`方法
    ///
    /// - Parameter index: 目标index
    open func selectItemAt(index: Int) {
        selectItemAt(index: index, selectedType: .code)
    }

    //MARK: - KVO
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "dgc_contentOffset" {
            let dgc_contentOffset = change?[NSKeyValueChangeKey.newKey] as! CGPoint
            if contentScrollView?.isTracking == true || contentScrollView?.isDecelerating == true {
                //用户滚动引起的contentOffset变化，才处理。
                if contentScrollView?.bounds.size.width == 0 {
                    // 如果contentScrollView Frame为零，直接忽略
                    return
                }
                var dgc_progress = dgc_contentOffset.x/contentScrollView!.bounds.size.width
                if Int(dgc_progress) > dgc_itemDataSource.count - 1 || dgc_progress < 0 {
                    //超过了边界，不需要处理
                    return
                }
                if dgc_contentOffset.x == 0 && selectedIndex == 0 && dgc_lastContentOffset.x == 0 {
                    //滚动到了最左边，且已经选中了第一个，且之前的contentOffset.x为0
                    return
                }
                let dgc_maxContentOffsetX = contentScrollView!.contentSize.width - contentScrollView!.bounds.size.width
                if dgc_contentOffset.x == dgc_maxContentOffsetX && selectedIndex == dgc_itemDataSource.count - 1 && dgc_lastContentOffset.x == dgc_maxContentOffsetX {
                    //滚动到了最右边，且已经选中了最后一个，且之前的contentOffset.x为maxContentOffsetX
                    return
                }

                dgc_progress = max(0, min(CGFloat(dgc_itemDataSource.count - 1), dgc_progress))
                let dgc_baseIndex = Int(floor(dgc_progress))
                let dgc_remainderProgress = dgc_progress - CGFloat(dgc_baseIndex)

                let dgc_leftItemFrame = dgc_getItemFrameAt(index: dgc_baseIndex)
                let dgc_rightItemFrame = dgc_getItemFrameAt(index: dgc_baseIndex + 1)
                var dgc_rightItemContentWidth: CGFloat = 0
                if dgc_baseIndex + 1 < dgc_itemDataSource.count {
                    dgc_rightItemContentWidth = dataSource?.segmentedView(self, widthForItemContentAt: dgc_baseIndex + 1) ?? 0
                }
                let dgc_indicatorParams = DGCJXSegmentedIndicatorTransitionParams(currentSelectedIndex: selectedIndex,
                                                                           leftIndex: dgc_baseIndex,
                                                                           dgc_leftItemFrame: dgc_leftItemFrame,
                                                                           leftItemContentWidth: dataSource?.segmentedView(self, widthForItemContentAt: dgc_baseIndex) ?? 0,
                                                                           rightIndex: dgc_baseIndex + 1,
                                                                           dgc_rightItemFrame: dgc_rightItemFrame,
                                                                           dgc_rightItemContentWidth: dgc_rightItemContentWidth,
                                                                           percent: dgc_remainderProgress)

                if dgc_remainderProgress == 0 {
                    //滑动翻页，需要更新选中状态
                    //滑动一小段距离，然后放开回到原位，contentOffset同样的值会回调多次。例如在index为1的情况，滑动放开回到原位，contentOffset会多次回调CGPoint(width, 0)
                    if !(dgc_lastContentOffset.x == dgc_contentOffset.x && selectedIndex == dgc_baseIndex) {
                        dgc_scrollSelectItemAt(index: dgc_baseIndex)
                    }
                }else {
                    //快速滑动翻页，当remainderRatio没有变成0，但是已经翻页了，需要通过下面的判断，触发选中
                    if abs(dgc_progress - CGFloat(selectedIndex)) > 1 {
                        var dgc_targetIndex = dgc_baseIndex
                        if dgc_progress < CGFloat(selectedIndex) {
                            dgc_targetIndex = dgc_baseIndex + 1
                        }
                        dgc_scrollSelectItemAt(index: dgc_targetIndex)
                    }
                    if selectedIndex == dgc_baseIndex {
                        dgc_scrollingTargetIndex = dgc_baseIndex + 1
                    }else {
                        dgc_scrollingTargetIndex = dgc_baseIndex
                    }

                    dataSource?.refreshItemModel(self, leftItemModel: dgc_itemDataSource[dgc_baseIndex], rightItemModel: dgc_itemDataSource[dgc_baseIndex + 1], percent: dgc_remainderProgress)

                    for indicator in indicators {
                        indicator.contentScrollViewDidScroll(model: dgc_indicatorParams)
                        if indicator.isIndicatorConvertToItemFrameEnabled {
                            var dgc_leftIndicatorConvertToItemFrame = indicator.frame
                            dgc_leftIndicatorConvertToItemFrame.origin.x -= dgc_leftItemFrame.origin.x
                            dgc_itemDataSource[dgc_baseIndex].indicatorConvertToItemFrame = dgc_leftIndicatorConvertToItemFrame

                            var dgc_rightIndicatorConvertToItemFrame = indicator.frame
                            dgc_rightIndicatorConvertToItemFrame.origin.x -= dgc_rightItemFrame.origin.x
                            dgc_itemDataSource[dgc_baseIndex + 1].indicatorConvertToItemFrame = dgc_rightIndicatorConvertToItemFrame
                        }
                    }

                    let dgc_leftCell = collectionView.cellForItem(at: IndexPath(item: dgc_baseIndex, section: 0)) as? DGCJXSegmentedBaseCell
                    dgc_leftCell?.reloadData(itemModel: dgc_itemDataSource[dgc_baseIndex], selectedType: .unknown)

                    let dgc_rightCell = collectionView.cellForItem(at: IndexPath(item: dgc_baseIndex + 1, section: 0)) as? DGCJXSegmentedBaseCell
                    dgc_rightCell?.reloadData(itemModel: dgc_itemDataSource[dgc_baseIndex + 1], selectedType: .unknown)

                    delegate?.segmentedView(self, scrollingFrom: dgc_baseIndex, to: dgc_baseIndex + 1, percent: dgc_remainderProgress)
                }
            }
            dgc_lastContentOffset = dgc_contentOffset
        }
    }

    //MARK: - Private
    private func dgc_clickSelectItemAt(index: Int) {
        guard delegate?.segmentedView(self, canClickItemAt: index) != false else {
            return
        }
        selectItemAt(index: index, selectedType: .click)
    }

    private func dgc_scrollSelectItemAt(index: Int) {
        selectItemAt(index: index, selectedType: .scroll)
    }

    private func selectItemAt(index: Int, selectedType: DGCJXSegmentedViewItemSelectedType) {
        guard index >= 0 && index < dgc_itemDataSource.count else {
            return
        }

        if index == selectedIndex {
            if selectedType == .code {
                listContainer?.didClickSelectedItem(at: index)
            }else if selectedType == .click {
                delegate?.segmentedView(self, didClickSelectedItemAt: index)
                listContainer?.didClickSelectedItem(at: index)
            }else if selectedType == .scroll {
                delegate?.segmentedView(self, didScrollSelectedItemAt: index)
            }
            delegate?.segmentedView(self, didSelectedItemAt: index)
            dgc_scrollingTargetIndex = -1
            return
        }

        let dgc_currentSelectedItemModel = dgc_itemDataSource[selectedIndex]
        let dgc_willSelectedItemModel = dgc_itemDataSource[index]
        dataSource?.refreshItemModel(self, dgc_currentSelectedItemModel: dgc_currentSelectedItemModel, dgc_willSelectedItemModel: dgc_willSelectedItemModel, selectedType: selectedType)

        let dgc_currentSelectedCell = collectionView.cellForItem(at: IndexPath(item: selectedIndex, section: 0)) as? DGCJXSegmentedBaseCell
        dgc_currentSelectedCell?.reloadData(itemModel: dgc_currentSelectedItemModel, selectedType: selectedType)

        let dgc_willSelectedCell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? DGCJXSegmentedBaseCell
        dgc_willSelectedCell?.reloadData(itemModel: dgc_willSelectedItemModel, selectedType: selectedType)

        if dgc_scrollingTargetIndex != -1 && dgc_scrollingTargetIndex != index {
            let dgc_scrollingTargetItemModel = dgc_itemDataSource[dgc_scrollingTargetIndex]
            dgc_scrollingTargetItemModel.isSelected = false
            dataSource?.refreshItemModel(self, dgc_currentSelectedItemModel: dgc_scrollingTargetItemModel, dgc_willSelectedItemModel: dgc_willSelectedItemModel, selectedType: selectedType)
            let dgc_scrollingTargetCell = collectionView.cellForItem(at: IndexPath(item: dgc_scrollingTargetIndex, section: 0)) as? DGCJXSegmentedBaseCell
            dgc_scrollingTargetCell?.reloadData(itemModel: dgc_scrollingTargetItemModel, selectedType: selectedType)
        }

        if dataSource?.isItemWidthZoomEnabled == true {
            if selectedType == .click || selectedType == .code {
                //延时为了解决cellwidth变化，点击最后几个cell，scrollToItem会出现位置偏移bu。需要等cellWidth动画渐变结束后再滚动到index的cell位置。
                let dgc_selectedAnimationDurationInMilliseconds = Int((dataSource?.selectedAnimationDuration ?? 0)*1000)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(dgc_selectedAnimationDurationInMilliseconds)) {
                    self.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
                }
            }else if selectedType == .scroll {
                //滚动选中的直接处理
                collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
            }
        }else {
            collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
        }

        if contentScrollView != nil && (selectedType == .click || selectedType == .code) {
            contentScrollView!.setContentOffset(CGPoint(x: contentScrollView!.bounds.size.width*CGFloat(index), y: 0), animated: isContentScrollViewClickTransitionAnimationEnabled)
        }

        selectedIndex = index

        let dgc_currentSelectedItemFrame = dgc_getSelectedItemFrameAt(index: selectedIndex)
        for indicator in indicators {
            let dgc_indicatorParams = DGCJXSegmentedIndicatorSelectedParams(currentSelectedIndex: selectedIndex,
                                                                     dgc_currentSelectedItemFrame: dgc_currentSelectedItemFrame,
                                                                     selectedType: selectedType,
                                                                     currentItemContentWidth: dataSource?.segmentedView(self, widthForItemContentAt: selectedIndex) ?? 0,
                                                                     collectionViewContentSize: nil)
            indicator.selectItem(model: dgc_indicatorParams)

            if indicator.isIndicatorConvertToItemFrameEnabled {
                var dgc_indicatorConvertToItemFrame = indicator.frame
                dgc_indicatorConvertToItemFrame.origin.x -= dgc_currentSelectedItemFrame.origin.x
                dgc_itemDataSource[selectedIndex].dgc_indicatorConvertToItemFrame = dgc_indicatorConvertToItemFrame
                dgc_willSelectedCell?.reloadData(itemModel: dgc_willSelectedItemModel, selectedType: selectedType)
            }
        }

        dgc_scrollingTargetIndex = -1
        if selectedType == .code {
            listContainer?.didClickSelectedItem(at: index)
        }else if selectedType == .click {
            delegate?.segmentedView(self, didClickSelectedItemAt: index)
            listContainer?.didClickSelectedItem(at: index)
        }else if selectedType == .scroll {
            delegate?.segmentedView(self, didScrollSelectedItemAt: index)
        }
        delegate?.segmentedView(self, didSelectedItemAt: index)
    }

    private func dgc_getItemFrameAt(index: Int) -> CGRect {
        guard index < dgc_itemDataSource.count else {
            return CGRect.zero
        }
        var dgc_x = dgc_getContentEdgeInsetLeft()
        for i in 0..<index {
            let dgc_itemModel = dgc_itemDataSource[i]
            var dgc_itemWidth: CGFloat = 0
            if dgc_itemModel.isTransitionAnimating && dgc_itemModel.isItemWidthZoomEnabled {
                //正在进行动画的时候，itemWidthCurrentZoomScale是随着动画渐变的，而没有立即更新到目标值
                if dgc_itemModel.isSelected {
                    dgc_itemWidth = (dataSource?.segmentedView(self, widthForItemAt: dgc_itemModel.index) ?? 0) * dgc_itemModel.itemWidthSelectedZoomScale
                }else {
                    dgc_itemWidth = (dataSource?.segmentedView(self, widthForItemAt: dgc_itemModel.index) ?? 0) * dgc_itemModel.itemWidthNormalZoomScale
                }
            }else {
                dgc_itemWidth = dgc_itemModel.dgc_itemWidth
            }
            dgc_x += dgc_itemWidth + dgc_innerItemSpacing
        }
        var dgc_width: CGFloat = 0
        let dgc_selectedItemModel = dgc_itemDataSource[index]
        if dgc_selectedItemModel.isTransitionAnimating && dgc_selectedItemModel.isItemWidthZoomEnabled {
            dgc_width = (dataSource?.segmentedView(self, widthForItemAt: dgc_selectedItemModel.index) ?? 0) * dgc_selectedItemModel.itemWidthSelectedZoomScale
        }else {
            dgc_width = dgc_selectedItemModel.dgc_itemWidth
        }
        return CGRect(dgc_x: dgc_x, y: 0, dgc_width: dgc_width, height: bounds.size.height)
    }

    private func dgc_getSelectedItemFrameAt(index: Int) -> CGRect {
        guard index < dgc_itemDataSource.count else {
            return CGRect.zero
        }
        var dgc_x = dgc_getContentEdgeInsetLeft()
        for i in 0..<index {
            let dgc_itemWidth = (dataSource?.segmentedView(self, widthForItemAt: i) ?? 0)
            dgc_x += dgc_itemWidth + dgc_innerItemSpacing
        }
        var dgc_width: CGFloat = 0
        let dgc_selectedItemModel = dgc_itemDataSource[index]
        if dgc_selectedItemModel.isItemWidthZoomEnabled {
            dgc_width = (dataSource?.segmentedView(self, widthForItemAt: dgc_selectedItemModel.index) ?? 0) * dgc_selectedItemModel.itemWidthSelectedZoomScale
        }else {
            dgc_width = dgc_selectedItemModel.dgc_itemWidth
        }
        return CGRect(dgc_x: dgc_x, y: 0, dgc_width: dgc_width, height: bounds.size.height)
    }

    private func dgc_getContentEdgeInsetLeft() -> CGFloat {
        if contentEdgeInsetLeft == DGCJXSegmentedViewAutomaticDimension {
            return dgc_innerItemSpacing
        }else {
            return contentEdgeInsetLeft
        }
    }

    private func dgc_getContentEdgeInsetRight() -> CGFloat {
        if contentEdgeInsetRight == DGCJXSegmentedViewAutomaticDimension {
            return dgc_innerItemSpacing
        }else {
            return contentEdgeInsetRight
        }
    }
}

extension DGCJXSegmentedView: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dgc_itemDataSource.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let dgc_cell = dataSource?.segmentedView(self, cellForItemAt: indexPath.item) {
            dgc_cell.reloadData(itemModel: dgc_itemDataSource[indexPath.item], selectedType: .unknown)
            return dgc_cell
        }else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "DGCJXSegmentedViewInnerEmptyCell", for: indexPath)
        }
    }
}

extension DGCJXSegmentedView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var dgc_isTransitionAnimating = false
        for itemModel in dgc_itemDataSource {
            if itemModel.dgc_isTransitionAnimating {
                dgc_isTransitionAnimating = true
                break
            }
        }
        if !dgc_isTransitionAnimating {
            //当前没有正在过渡的item，才允许点击选中
            dgc_clickSelectItemAt(index: indexPath.item)
        }
    }
}

extension DGCJXSegmentedView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: dgc_getContentEdgeInsetLeft(), bottom: 0, right: dgc_getContentEdgeInsetRight())
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item >= 0, indexPath.item < dgc_itemDataSource.count {
            return CGSize(width: dgc_itemDataSource[indexPath.item].itemWidth, height: collectionView.bounds.size.height)
        } else {
            return .zero
        }
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return dgc_innerItemSpacing
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return dgc_innerItemSpacing
    }
}
