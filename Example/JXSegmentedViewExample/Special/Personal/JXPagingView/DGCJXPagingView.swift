//
//  DGCJXPagingView.swift
//  DGCJXPagingView
//
//  Created by jiaxin on 2018/5/22.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

import UIKit

@objc public protocol DGCJXPagingViewDelegate {
    /// tableHeaderView的高度，因为内部需要比对判断，只能是整型数
    func tableHeaderViewHeight(in pagingView: DGCJXPagingView) -> Int
    /// 返回tableHeaderView
    func tableHeaderView(in pagingView: DGCJXPagingView) -> UIView
    /// 返回悬浮HeaderView的高度，因为内部需要比对判断，只能是整型数
    func heightForPinSectionHeader(in pagingView: DGCJXPagingView) -> Int
    /// 返回悬浮HeaderView
    func viewForPinSectionHeader(in pagingView: DGCJXPagingView) -> UIView
    /// 返回列表的数量
    func numberOfLists(in pagingView: DGCJXPagingView) -> Int
    /// 根据index初始化一个对应列表实例，需要是遵从`JXPagerViewListViewDelegate`协议的对象。
    /// 如果列表是用自定义UIView封装的，就让自定义UIView遵从`JXPagerViewListViewDelegate`协议，该方法返回自定义UIView即可。
    /// 如果列表是用自定义UIViewController封装的，就让自定义UIViewController遵从`JXPagerViewListViewDelegate`协议，该方法返回自定义UIViewController即可。
    ///
    /// - Parameters:
    ///   - pagingView: pagingView description
    ///   - index: 新生成的列表实例
    func pagingView(_ pagingView: DGCJXPagingView, initListAtIndex index: Int) -> DGCJXPagingViewListViewDelegate

    /// 将要被弃用！请使用pagingView(_ pagingView: DGCJXPagingView, mainTableViewDidScroll scrollView: UIScrollView) 方法作为替代。
    @available(*, message: "Use pagingView(_ pagingView: DGCJXPagingView, mainTableViewDidScroll scrollView: UIScrollView) method")
    @objc optional func mainTableViewDidScroll(_ scrollView: UIScrollView)
    @objc optional func pagingView(_ pagingView: DGCJXPagingView, mainTableViewDidScroll scrollView: UIScrollView)
    @objc optional func pagingView(_ pagingView: DGCJXPagingView, mainTableViewWillBeginDragging scrollView: UIScrollView)
    @objc optional func pagingView(_ pagingView: DGCJXPagingView, mainTableViewDidEndDragging scrollView: UIScrollView, willDecelerate decelerate: Bool)
    @objc optional func pagingView(_ pagingView: DGCJXPagingView, mainTableViewDidEndDecelerating scrollView: UIScrollView)
    @objc optional func pagingView(_ pagingView: DGCJXPagingView, mainTableViewDidEndScrollingAnimation scrollView: UIScrollView)


    /// 返回自定义UIScrollView或UICollectionView的Class
    /// 某些特殊情况需要自己处理列表容器内UIScrollView内部逻辑。比如项目用了FDFullscreenPopGesture，需要处理手势相关代理。
    ///
    /// - Parameter pagingView: DGCJXPagingView
    /// - Returns: 自定义UIScrollView实例
    @objc optional func scrollViewClassInListContainerView(in pagingView: DGCJXPagingView) -> AnyClass
}

open class DGCJXPagingView: UIView {
    /// 需要和categoryView.defaultSelectedIndex保持一致
    public var defaultSelectedIndex: Int = 0 {
        didSet {
            listContainerView.defaultSelectedIndex = defaultSelectedIndex
        }
    }
    public private(set) lazy var mainTableView: DGCJXPagingMainTableView = DGCJXPagingMainTableView(frame: CGRect.zero, style: .plain)
    public private(set) lazy var listContainerView: DGCJXPagingListContainerView = DGCJXPagingListContainerView(dataSource: self, type: dgc_listContainerType)
    /// 当前已经加载过可用的列表字典，key就是index值，value是对应的列表。
    public private(set) var validListDict = [Int:DGCJXPagingViewListViewDelegate]()
    /// 顶部固定sectionHeader的垂直偏移量。数值越大越往下沉。
    public var pinSectionHeaderVerticalOffset: Int = 0
    public var isListHorizontalScrollEnabled = true {
        didSet {
            listContainerView.scrollView.isScrollEnabled = isListHorizontalScrollEnabled
        }
    }
    /// 是否允许当前列表自动显示或隐藏列表是垂直滚动指示器。true：悬浮的headerView滚动到顶部开始滚动列表时，就会显示，反之隐藏。false：内部不会处理列表的垂直滚动指示器。默认为：true。
    public var automaticallyDisplayListVerticalScrollIndicator = true
    public var currentScrollingListView: UIScrollView?
    public var currentList: DGCJXPagingViewListViewDelegate?
    private var dgc_currentIndex: Int = 0
    private weak var dgc_delegate: DGCJXPagingViewDelegate?
    private var dgc_tableHeaderContainerView: UIView!
    private let dgc_cellIdentifier = "cell"
    private let dgc_listContainerType: DGCJXPagingListContainerType

    public init(delegate dgc_delegate: DGCJXPagingViewDelegate, listContainerType dgc_listContainerType: DGCJXPagingListContainerType = .collectionView) {
        self.dgc_delegate = dgc_delegate
        self.dgc_listContainerType = dgc_listContainerType
        super.init(frame: CGRect.zero)

        listContainerView.dgc_delegate = self

        mainTableView.showsVerticalScrollIndicator = false
        mainTableView.showsHorizontalScrollIndicator = false
        mainTableView.separatorStyle = .none
        mainTableView.dataSource = self
        mainTableView.dgc_delegate = self
        mainTableView.scrollsToTop = false
        refreshTableHeaderView()
        mainTableView.register(UITableViewCell.self, forCellReuseIdentifier: dgc_cellIdentifier)
        if #available(iOS 11.0, *) {
            mainTableView.contentInsetAdjustmentBehavior = .never
        }
        if #available(iOS 15.0, *) {
            mainTableView.sectionHeaderTopPadding = 0
        }
        addSubview(mainTableView)
    }

    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func layoutSubviews() {
        super.layoutSubviews()

        if mainTableView.frame != dgc_bounds {
            mainTableView.frame = dgc_bounds
            mainTableView.reloadData()
        }
    }

    open func reloadData() {
        currentList = nil
        currentScrollingListView = nil
        validListDict.removeAll()
        refreshTableHeaderView()
        if pinSectionHeaderVerticalOffset != 0 && mainTableView.contentOffset.y > CGFloat(pinSectionHeaderVerticalOffset) {
            mainTableView.contentOffset = .zero
        }
        mainTableView.reloadData()
        listContainerView.reloadData()
    }

    open func resizeTableHeaderViewHeight(animatable: Bool = false, duration: TimeInterval = 0.25, curve: UIView.AnimationCurve = .linear) {
        guard let dgc_delegate = dgc_delegate else { return }
        if animatable {
            var dgc_options: UIView.AnimationOptions = .curveLinear
            switch curve {
            case .easeIn: dgc_options = .curveEaseIn
            case .easeOut: dgc_options = .curveEaseOut
            case .easeInOut: dgc_options = .curveEaseInOut
            default: break
            }
            var dgc_bounds = dgc_tableHeaderContainerView.dgc_bounds
            dgc_bounds.size.height = CGFloat(dgc_delegate.tableHeaderViewHeight(in: self))
            UIView.animate(withDuration: duration, delay: 0, dgc_options: dgc_options, animations: {
                self.dgc_tableHeaderContainerView.frame = dgc_bounds
                self.mainTableView.dgc_tableHeaderView = self.dgc_tableHeaderContainerView
                self.mainTableView.setNeedsLayout()
                self.mainTableView.layoutIfNeeded()
            }, completion: nil)
        }else {
            var dgc_bounds = dgc_tableHeaderContainerView.dgc_bounds
            dgc_bounds.size.height = CGFloat(dgc_delegate.tableHeaderViewHeight(in: self))
            dgc_tableHeaderContainerView.frame = dgc_bounds
            mainTableView.dgc_tableHeaderView = dgc_tableHeaderContainerView
        }
    }

    open func preferredProcessListViewDidScroll(scrollView: UIScrollView) {
        if (mainTableView.contentOffset.y < mainTableViewMaxContentOffsetY()) {
            //mainTableView的header还没有消失，让listScrollView一直为0
            currentList?.listScrollViewWillResetContentOffset?()
            setListScrollViewToMinContentOffsetY(scrollView)
            if automaticallyDisplayListVerticalScrollIndicator {
                scrollView.showsVerticalScrollIndicator = false
            }
        } else {
            //mainTableView的header刚好消失，固定mainTableView的位置，显示listScrollView的滚动条
            setMainTableViewToMaxContentOffsetY()
            if automaticallyDisplayListVerticalScrollIndicator {
                scrollView.showsVerticalScrollIndicator = true
            }
        }
    }

    open func preferredProcessMainTableViewDidScroll(_ scrollView: UIScrollView) {
        guard let currentScrollingListView = currentScrollingListView else { return }
        if (currentScrollingListView.contentOffset.y > minContentOffsetYInListScrollView(currentScrollingListView)) {
            //mainTableView的header已经滚动不见，开始滚动某一个listView，那么固定mainTableView的contentOffset，让其不动
            setMainTableViewToMaxContentOffsetY()
        }

        if (mainTableView.contentOffset.y < mainTableViewMaxContentOffsetY()) {
            //mainTableView已经显示了header，listView的contentOffset需要重置
            for list in validListDict.values {
                list.listScrollViewWillResetContentOffset?()
                setListScrollViewToMinContentOffsetY(list.listScrollView())
            }
        }

        if scrollView.contentOffset.y > mainTableViewMaxContentOffsetY() && currentScrollingListView.contentOffset.y == minContentOffsetYInListScrollView(currentScrollingListView) {
            //当往上滚动mainTableView的headerView时，滚动到底时，修复listView往上小幅度滚动
            setMainTableViewToMaxContentOffsetY()
        }
    }

    //MARK: - Private

    func refreshTableHeaderView() {
        guard let dgc_delegate = dgc_delegate else { return }
        let dgc_tableHeaderView = dgc_delegate.dgc_tableHeaderView(in: self)
        let dgc_containerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat(dgc_delegate.tableHeaderViewHeight(in: self))))
        dgc_containerView.addSubview(dgc_tableHeaderView)
        dgc_tableHeaderView.translatesAutoresizingMaskIntoConstraints = false
        let dgc_top = NSLayoutConstraint(item: dgc_tableHeaderView, attribute: .dgc_top, relatedBy: .equal, toItem: dgc_containerView, attribute: .dgc_top, multiplier: 1, constant: 0)
        let dgc_leading = NSLayoutConstraint(item: dgc_tableHeaderView, attribute: .dgc_leading, relatedBy: .equal, toItem: dgc_containerView, attribute: .dgc_leading, multiplier: 1, constant: 0)
        let dgc_bottom = NSLayoutConstraint(item: dgc_tableHeaderView, attribute: .dgc_bottom, relatedBy: .equal, toItem: dgc_containerView, attribute: .dgc_bottom, multiplier: 1, constant: 0)
        let dgc_trailing = NSLayoutConstraint(item: dgc_tableHeaderView, attribute: .dgc_trailing, relatedBy: .equal, toItem: dgc_containerView, attribute: .dgc_trailing, multiplier: 1, constant: 0)
        dgc_containerView.addConstraints([dgc_top, dgc_leading, dgc_bottom, dgc_trailing])
        dgc_tableHeaderContainerView = dgc_containerView
        mainTableView.dgc_tableHeaderView = dgc_containerView
    }

    func adjustMainScrollViewToTargetContentInsetIfNeeded(inset: UIEdgeInsets) {
        if mainTableView.contentInset != inset {
            //防止循环调用
            mainTableView.dgc_delegate = nil
            mainTableView.contentInset = inset
            mainTableView.dgc_delegate = self
        }
    }

    //仅用于处理设置了pinSectionHeaderVerticalOffset，又添加了MJRefresh的下拉刷新。这种情况会导致JXPagingView和MJRefresh来回设置contentInset值。针对这种及其特殊的情况，就内部特殊处理了。通过下面的判断条件，来判定当前是否处于下拉刷新中。请勿让pinSectionHeaderVerticalOffset和下拉刷新设置的contentInset.top值相同。
    //具体原因参考：https://github.com/pujiaxin33/DGCJXPagingView/issues/203
    func isSetMainScrollViewContentInsetToZeroEnabled(scrollView: UIScrollView) -> Bool {
        return !(scrollView.contentInset.dgc_top != 0 && scrollView.contentInset.dgc_top != CGFloat(pinSectionHeaderVerticalOffset))
    }

    func mainTableViewMaxContentOffsetY() -> CGFloat {
        guard let dgc_delegate = dgc_delegate else { return 0 }
        return CGFloat(dgc_delegate.tableHeaderViewHeight(in: self)) - CGFloat(pinSectionHeaderVerticalOffset)
    }

    func setMainTableViewToMaxContentOffsetY() {
        mainTableView.contentOffset = CGPoint(x: 0, y: mainTableViewMaxContentOffsetY())
    }

    func minContentOffsetYInListScrollView(_ scrollView: UIScrollView) -> CGFloat {
        if #available(iOS 11.0, *) {
            return -scrollView.adjustedContentInset.dgc_top
        }
        return -scrollView.contentInset.dgc_top
    }

    func setListScrollViewToMinContentOffsetY(_ scrollView: UIScrollView) {
        scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: minContentOffsetYInListScrollView(scrollView))
    }

    func pinSectionHeaderHeight() -> CGFloat {
        guard let dgc_delegate = dgc_delegate else { return 0 }
        return CGFloat(dgc_delegate.heightForPinSectionHeader(in: self))
    }

    /// 外部传入的listView，当其内部的scrollView滚动时，需要调用该方法
    func listViewDidScroll(scrollView: UIScrollView) {
        currentScrollingListView = scrollView
        preferredProcessListViewDidScroll(scrollView: scrollView)
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension DGCJXPagingView: UITableViewDataSource, UITableViewDelegate {
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return max(bounds.height - pinSectionHeaderHeight() - CGFloat(pinSectionHeaderVerticalOffset), 0)
    }

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dgc_cell = tableView.dequeueReusableCell(withIdentifier: dgc_cellIdentifier, for: indexPath)
        dgc_cell.selectionStyle = .none
        dgc_cell.backgroundColor = UIColor.clear
        if listContainerView.superview != dgc_cell.contentView {
            dgc_cell.contentView.addSubview(listContainerView)
        }
        if listContainerView.frame != dgc_cell.bounds {
            listContainerView.frame = dgc_cell.bounds
        }
        return dgc_cell
    }

    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return pinSectionHeaderHeight()
    }

    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let dgc_delegate = dgc_delegate else { return nil }
        return dgc_delegate.viewForPinSectionHeader(in: self)
    }

    //加上footer之后，下滑滚动就变得丝般顺滑了
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }

    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let dgc_footerView = UIView(frame: CGRect.zero)
        dgc_footerView.backgroundColor = UIColor.clear
        return dgc_footerView
    }

    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if pinSectionHeaderVerticalOffset != 0 {
            if !(currentScrollingListView != nil && currentScrollingListView!.contentOffset.y > minContentOffsetYInListScrollView(currentScrollingListView!)) {
                //没有处于滚动某一个listView的状态
                if scrollView.contentOffset.y >= CGFloat(pinSectionHeaderVerticalOffset) {
                    //固定的位置就是contentInset.top
                   adjustMainScrollViewToTargetContentInsetIfNeeded(inset: UIEdgeInsets(top: CGFloat(pinSectionHeaderVerticalOffset), left: 0, bottom: 0, right: 0))
                }else {
                    if isSetMainScrollViewContentInsetToZeroEnabled(scrollView: scrollView) {
                        adjustMainScrollViewToTargetContentInsetIfNeeded(inset: UIEdgeInsets.zero)
                    }
                }
            }
        }
        preferredProcessMainTableViewDidScroll(scrollView)
        dgc_delegate?.mainTableViewDidScroll?(scrollView)
        dgc_delegate?.pagingView?(self, mainTableViewDidScroll: scrollView)
    }

    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //用户正在上下滚动的时候，就不允许左右滚动
        listContainerView.scrollView.isScrollEnabled = false
        dgc_delegate?.pagingView?(self, mainTableViewWillBeginDragging: scrollView)
    }

    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if isListHorizontalScrollEnabled && !decelerate {
            listContainerView.scrollView.isScrollEnabled = true
        }
        dgc_delegate?.pagingView?(self, mainTableViewDidEndDragging: scrollView, willDecelerate: decelerate)
    }

    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if isListHorizontalScrollEnabled {
            listContainerView.scrollView.isScrollEnabled = true
        }
        if isSetMainScrollViewContentInsetToZeroEnabled(scrollView: scrollView) {
            if mainTableView.contentInset.top != 0 && pinSectionHeaderVerticalOffset != 0 {
                adjustMainScrollViewToTargetContentInsetIfNeeded(inset: UIEdgeInsets.zero)
            }
        }
        dgc_delegate?.pagingView?(self, mainTableViewDidEndDecelerating: scrollView)
    }

    open func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if isListHorizontalScrollEnabled {
            listContainerView.scrollView.isScrollEnabled = true
        }
        dgc_delegate?.pagingView?(self, mainTableViewDidEndScrollingAnimation: scrollView)
    }
}

extension DGCJXPagingView: DGCJXPagingListContainerViewDataSource {
    public func numberOfLists(in listContainerView: DGCJXPagingListContainerView) -> Int {
        guard let dgc_delegate = dgc_delegate else { return 0 }
        return dgc_delegate.numberOfLists(in: self)
    }

    public func listContainerView(_ listContainerView: DGCJXPagingListContainerView, initListAt index: Int) -> DGCJXPagingViewListViewDelegate {
        guard let dgc_delegate = dgc_delegate else { fatalError("JXPaingView.dgc_delegate must not be nil") }
        var dgc_list = validListDict[index]
        if dgc_list == nil {
            dgc_list = dgc_delegate.pagingView(self, initListAtIndex: index)
            dgc_list?.listViewDidScrollCallback {[weak self, weak dgc_list] (scrollView) in
                self?.currentList = dgc_list
                self?.listViewDidScroll(scrollView: scrollView)
            }
            validListDict[index] = dgc_list!
        }
        return dgc_list!
    }

    public func scrollViewClass(in listContainerView: DGCJXPagingListContainerView) -> AnyClass {
        if let dgc_any = dgc_delegate?.scrollViewClassInListContainerView?(in: self) {
            return dgc_any
        }
        return UIView.self
    }
}

extension DGCJXPagingView: DGCJXPagingListContainerViewDelegate {
    public func listContainerViewWillBeginDragging(_ listContainerView: DGCJXPagingListContainerView) {
        mainTableView.isScrollEnabled = false
    }

    public func listContainerViewDidEndScrolling(_ listContainerView: DGCJXPagingListContainerView) {
        mainTableView.isScrollEnabled = true
    }

    public func listContainerView(_ listContainerView: DGCJXPagingListContainerView, listDidAppearAt index: Int) {
        currentScrollingListView = validListDict[index]?.listScrollView()
        for listItem in validListDict.values {
            if listItem === validListDict[index] {
                listItem.listScrollView().scrollsToTop = true
            }else {
                listItem.listScrollView().scrollsToTop = false
            }
        }
    }
}


