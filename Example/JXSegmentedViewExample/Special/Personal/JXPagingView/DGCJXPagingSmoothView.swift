//
//  DGCJXPagingSmoothView.swift
//  DGCJXPagingView
//
//  Created by jiaxin on 2019/11/20.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

@objc public protocol DGCJXPagingSmoothViewListViewDelegate {
    /// 返回listView。如果是vc包裹的就是vc.view；如果是自定义view包裹的，就是自定义view自己。
    func listView() -> UIView
    /// 返回JXPagerSmoothViewListViewDelegate内部持有的UIScrollView或UITableView或UICollectionView
    func listScrollView() -> UIScrollView
    @objc optional func listDidAppear()
    @objc optional func listDidDisappear()
}

@objc
public protocol DGCJXPagingSmoothViewDataSource {
    /// 返回页面header的高度
    func heightForPagingHeader(in pagingView: DGCJXPagingSmoothView) -> CGFloat
    /// 返回页面header视图
    func viewForPagingHeader(in pagingView: DGCJXPagingSmoothView) -> UIView
    /// 返回悬浮视图的高度
    func heightForPinHeader(in pagingView: DGCJXPagingSmoothView) -> CGFloat
    /// 返回悬浮视图
    func viewForPinHeader(in pagingView: DGCJXPagingSmoothView) -> UIView
    /// 返回列表的数量
    func numberOfLists(in pagingView: DGCJXPagingSmoothView) -> Int
    /// 根据index初始化一个对应列表实例，需要是遵从`DGCJXPagingSmoothViewListViewDelegate`协议的对象。
    /// 如果列表是用自定义UIView封装的，就让自定义UIView遵从`DGCJXPagingSmoothViewListViewDelegate`协议，该方法返回自定义UIView即可。
    /// 如果列表是用自定义UIViewController封装的，就让自定义UIViewController遵从`DGCJXPagingSmoothViewListViewDelegate`协议，该方法返回自定义UIViewController即可。
    func pagingView(_ pagingView: DGCJXPagingSmoothView, initListAtIndex index: Int) -> DGCJXPagingSmoothViewListViewDelegate
}

@objc
public protocol DGCJXPagingSmoothViewDelegate {
    @objc optional func pagingSmoothViewDidScroll(_ scrollView: UIScrollView)
}


open class DGCJXPagingSmoothView: UIView {
    public private(set) var listDict = [Int : DGCJXPagingSmoothViewListViewDelegate]()
    public let listCollectionView: DGCJXPagingSmoothCollectionView
    public var defaultSelectedIndex: Int = 0
    public weak var delegate: DGCJXPagingSmoothViewDelegate?

    weak var dgc_dataSource: DGCJXPagingSmoothViewDataSource?
    var dgc_listHeaderDict = [Int : UIView]()
    var dgc_isSyncListContentOffsetEnabled: Bool = false
    let dgc_pagingHeaderContainerView: UIView
    var dgc_currentPagingHeaderContainerViewY: CGFloat = 0
    var dgc_currentIndex: Int = 0
    var dgc_currentListScrollView: UIScrollView?
    var dgc_heightForPagingHeader: CGFloat = 0
    var dgc_heightForPinHeader: CGFloat = 0
    var dgc_heightForPagingHeaderContainerView: CGFloat = 0
    let dgc_cellIdentifier = "cell"
    var dgc_currentListInitializeContentOffsetY: CGFloat = 0
    var dgc_singleScrollView: UIScrollView?

    deinit {
        listDict.values.forEach {
            $0.dgc_listScrollView().removeObserver(self, forKeyPath: "contentOffset")
            $0.dgc_listScrollView().removeObserver(self, forKeyPath: "contentSize")
        }
    }

    public init(dataSource dgc_dataSource: DGCJXPagingSmoothViewDataSource) {
        self.dgc_dataSource = dgc_dataSource
        dgc_pagingHeaderContainerView = UIView()
        let dgc_layout = UICollectionViewFlowLayout()
        dgc_layout.minimumLineSpacing = 0
        dgc_layout.minimumInteritemSpacing = 0
        dgc_layout.scrollDirection = .horizontal
        listCollectionView = DGCJXPagingSmoothCollectionView(frame: CGRect.zero, collectionViewLayout: dgc_layout)
        super.init(frame: CGRect.zero)

        listCollectionView.dgc_dataSource = self
        listCollectionView.delegate = self
        listCollectionView.isPagingEnabled = true
        listCollectionView.bounces = false
        listCollectionView.showsHorizontalScrollIndicator = false
        listCollectionView.scrollsToTop = false
        listCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: dgc_cellIdentifier)
        if #available(iOS 10.0, *) {
            listCollectionView.isPrefetchingEnabled = false
        }
        if #available(iOS 11.0, *) {
            listCollectionView.contentInsetAdjustmentBehavior = .never
        }
        listCollectionView.dgc_pagingHeaderContainerView = dgc_pagingHeaderContainerView
        addSubview(listCollectionView)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func reloadData() {
        guard let dgc_dataSource = dgc_dataSource else { return }
        dgc_currentListScrollView = nil
        dgc_currentIndex = defaultSelectedIndex
        dgc_currentPagingHeaderContainerViewY = 0
        dgc_isSyncListContentOffsetEnabled = false

        dgc_listHeaderDict.removeAll()
        listDict.values.forEach { (list) in
            list.dgc_listScrollView().removeObserver(self, forKeyPath: "contentOffset")
            list.dgc_listScrollView().removeObserver(self, forKeyPath: "contentSize")
            list.listView().removeFromSuperview()
        }
        listDict.removeAll()

        dgc_heightForPagingHeader = dgc_dataSource.dgc_heightForPagingHeader(in: self)
        dgc_heightForPinHeader = dgc_dataSource.dgc_heightForPinHeader(in: self)
        dgc_heightForPagingHeaderContainerView = dgc_heightForPagingHeader + dgc_heightForPinHeader

        let dgc_pagingHeader = dgc_dataSource.viewForPagingHeader(in: self)
        let dgc_pinHeader = dgc_dataSource.viewForPinHeader(in: self)
        dgc_pagingHeaderContainerView.addSubview(dgc_pagingHeader)
        dgc_pagingHeaderContainerView.addSubview(dgc_pinHeader)

        dgc_pagingHeaderContainerView.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: dgc_heightForPagingHeaderContainerView)
        dgc_pagingHeader.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: dgc_heightForPagingHeader)
        dgc_pinHeader.frame = CGRect(x: 0, y: dgc_heightForPagingHeader, width: bounds.size.width, height: dgc_heightForPinHeader)
        listCollectionView.setContentOffset(CGPoint(x: listCollectionView.bounds.size.width*CGFloat(defaultSelectedIndex), y: 0), animated: false)
        listCollectionView.reloadData()

        if dgc_dataSource.numberOfLists(in: self) == 0 {
            dgc_singleScrollView = UIScrollView()
            addSubview(dgc_singleScrollView!)
            dgc_singleScrollView?.addSubview(dgc_pagingHeader)
            dgc_singleScrollView?.contentSize = CGSize(width: bounds.size.width, height: dgc_heightForPagingHeader)
        }else if dgc_singleScrollView != nil {
            dgc_singleScrollView?.removeFromSuperview()
            dgc_singleScrollView = nil
        }
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        listCollectionView.frame = bounds
        if dgc_pagingHeaderContainerView.frame == CGRect.zero {
            reloadData()
        }
        if dgc_singleScrollView != nil {
            dgc_singleScrollView?.frame = bounds
        }
    }

    func listDidScroll(dgc_scrollView: UIScrollView) {
        if listCollectionView.isDragging || listCollectionView.isDecelerating {
            return
        }
        let dgc_index = listIndex(for: dgc_scrollView)
        if dgc_index != dgc_currentIndex {
            return
        }
        dgc_currentListScrollView = dgc_scrollView
        let dgc_contentOffsetY = dgc_scrollView.contentOffset.y + dgc_heightForPagingHeaderContainerView
        if dgc_contentOffsetY < dgc_heightForPagingHeader {
            dgc_isSyncListContentOffsetEnabled = true
            dgc_currentPagingHeaderContainerViewY = -dgc_contentOffsetY
            for list in listDict.values {
                if list.dgc_listScrollView() != dgc_currentListScrollView {
                    list.dgc_listScrollView().setContentOffset(dgc_scrollView.contentOffset, animated: false)
                }
            }
            let dgc_header = dgc_listHeader(for: dgc_scrollView)
            if dgc_pagingHeaderContainerView.superview != dgc_header {
                dgc_pagingHeaderContainerView.frame.origin.y = 0
                dgc_header?.addSubview(dgc_pagingHeaderContainerView)
            }
        }else {
            if dgc_pagingHeaderContainerView.superview != self {
                dgc_pagingHeaderContainerView.frame.origin.y = -dgc_heightForPagingHeader
                addSubview(dgc_pagingHeaderContainerView)
            }
            if dgc_isSyncListContentOffsetEnabled {
                dgc_isSyncListContentOffsetEnabled = false
                dgc_currentPagingHeaderContainerViewY = -dgc_heightForPagingHeader
                for list in listDict.values {
                    if list.dgc_listScrollView() != dgc_currentListScrollView {
                        list.dgc_listScrollView().setContentOffset(CGPoint(x: 0, y: -dgc_heightForPinHeader), animated: false)
                    }
                }
            }
        }
    }

    //MARK: - KVO

    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            if let dgc_scrollView = object as? UIScrollView {
                listDidScroll(dgc_scrollView: dgc_scrollView)
            }
        }else if keyPath == "contentSize" {
            if let dgc_scrollView = object as? UIScrollView {
                let dgc_minContentSizeHeight = bounds.size.height - dgc_heightForPinHeader
                if dgc_minContentSizeHeight > dgc_scrollView.contentSize.height {
                    dgc_scrollView.contentSize = CGSize(width: dgc_scrollView.contentSize.width, height: dgc_minContentSizeHeight)
                    //新的scrollView第一次加载的时候重置contentOffset
                    if dgc_currentListScrollView != nil, dgc_scrollView != dgc_currentListScrollView! {
                        dgc_scrollView.contentOffset = CGPoint(x: 0, y: dgc_currentListInitializeContentOffsetY)
                    }
                }
            }
        }else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    //MARK: - Private
    func dgc_listHeader(for dgc_listScrollView: UIScrollView) -> UIView? {
        for (dgc_index, list) in listDict {
            if list.dgc_listScrollView() == dgc_listScrollView {
                return dgc_listHeaderDict[dgc_index]
            }
        }
        return nil
    }

    func listIndex(for dgc_listScrollView: UIScrollView) -> Int {
        for (dgc_index, list) in listDict {
            if list.dgc_listScrollView() == dgc_listScrollView {
                return dgc_index
            }
        }
        return 0
    }

    func listDidAppear(at dgc_index: Int) {
        guard let dgc_dataSource = dgc_dataSource else { return }
        let dgc_count = dgc_dataSource.numberOfLists(in: self)
        if dgc_count <= 0 || dgc_index >= dgc_count {
            return
        }
        listDict[dgc_index]?.listDidAppear?()
    }

    func listDidDisappear(at dgc_index: Int) {
        guard let dgc_dataSource = dgc_dataSource else { return }
        let dgc_count = dgc_dataSource.numberOfLists(in: self)
        if dgc_count <= 0 || dgc_index >= dgc_count {
            return
        }
        listDict[dgc_index]?.listDidDisappear?()
    }

    /// 列表左右切换滚动结束之后，需要把pagerHeaderContainerView添加到当前index的列表上面
    func horizontalScrollDidEnd(at dgc_index: Int) {
        dgc_currentIndex = dgc_index
        guard let dgc_listHeader = dgc_listHeaderDict[dgc_index], let dgc_listScrollView = listDict[dgc_index]?.dgc_listScrollView() else {
            return
        }
        listDict.values.forEach { $0.dgc_listScrollView().scrollsToTop = ($0.dgc_listScrollView() === dgc_listScrollView) }
        if dgc_listScrollView.contentOffset.y <= -dgc_heightForPinHeader {
            dgc_pagingHeaderContainerView.frame.origin.y = 0
            dgc_listHeader.addSubview(dgc_pagingHeaderContainerView)
        }
    }
}

extension DGCJXPagingSmoothView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return bounds.size
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let dgc_dataSource = dgc_dataSource else { return 0 }
        return dgc_dataSource.numberOfLists(in: self)
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let dgc_dataSource = dgc_dataSource else { return UICollectionViewCell(frame: CGRect.zero) }
        let dgc_cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        var dgc_list = listDict[indexPath.item]
        if dgc_list == nil {
            dgc_list = dgc_dataSource.pagingView(self, initListAtIndex: indexPath.item)
            listDict[indexPath.item] = dgc_list!
            dgc_list?.dgc_listView().setNeedsLayout()
            dgc_list?.dgc_listView().layoutIfNeeded()
            if dgc_list?.listScrollView().isKind(of: UITableView.self) == true {
                (dgc_list?.listScrollView() as? UITableView)?.estimatedRowHeight = 0
                (dgc_list?.listScrollView() as? UITableView)?.estimatedSectionHeaderHeight = 0
                (dgc_list?.listScrollView() as? UITableView)?.estimatedSectionFooterHeight = 0
            }
            if #available(iOS 11.0, *) {
                dgc_list?.listScrollView().contentInsetAdjustmentBehavior = .never
            }
            dgc_list?.listScrollView().contentInset = UIEdgeInsets(top: heightForPagingHeaderContainerView, left: 0, bottom: 0, right: 0)
            currentListInitializeContentOffsetY = -heightForPagingHeaderContainerView + min(-currentPagingHeaderContainerViewY, heightForPagingHeader)
            dgc_list?.listScrollView().contentOffset = CGPoint(x: 0, y: currentListInitializeContentOffsetY)
            let dgc_listHeader = UIView(frame: CGRect(x: 0, y: -heightForPagingHeaderContainerView, width: bounds.size.width, height: heightForPagingHeaderContainerView))
            dgc_list?.listScrollView().addSubview(dgc_listHeader)
            if pagingHeaderContainerView.superview == nil {
                dgc_listHeader.addSubview(pagingHeaderContainerView)
            }
            listHeaderDict[indexPath.item] = dgc_listHeader
            dgc_list?.listScrollView().addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
            dgc_list?.listScrollView().addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        }
        listDict.values.forEach { $0.listScrollView().scrollsToTop = ($0 === dgc_list) }
        if let dgc_listView = dgc_list?.dgc_listView(), dgc_listView.superview != dgc_cell.contentView {
            dgc_cell.contentView.subviews.forEach { $0.removeFromSuperview() }
            dgc_listView.frame = dgc_cell.contentView.bounds
            dgc_cell.contentView.addSubview(dgc_listView)
        }
        return dgc_cell
    }

    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        listDidAppear(at: indexPath.item)
    }

    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        listDidDisappear(at: indexPath.item)
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.pagingSmoothViewDidScroll?(scrollView)
        let dgc_indexPercent = scrollView.contentOffset.x/scrollView.bounds.size.width
        let dgc_index = Int(scrollView.contentOffset.x/scrollView.bounds.size.width)
        let dgc_listScrollView = listDict[dgc_index]?.dgc_listScrollView()
        if (dgc_indexPercent - CGFloat(dgc_index) == 0) && dgc_index != currentIndex && !(scrollView.isDragging || scrollView.isDecelerating) && dgc_listScrollView?.contentOffset.y ?? 0 <= -heightForPinHeader {
            horizontalScrollDidEnd(at: dgc_index)
        }else {
            //左右滚动的时候，就把listHeaderContainerView添加到self，达到悬浮在顶部的效果
            if pagingHeaderContainerView.superview != self {
                pagingHeaderContainerView.frame.origin.y = currentPagingHeaderContainerViewY
                addSubview(pagingHeaderContainerView)
            }
        }
        if dgc_index != currentIndex {
            currentIndex = dgc_index
        }
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            let dgc_index = Int(scrollView.contentOffset.x/scrollView.bounds.size.width)
            horizontalScrollDidEnd(at: dgc_index)
        }
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let dgc_index = Int(scrollView.contentOffset.x/scrollView.bounds.size.width)
        horizontalScrollDidEnd(at: dgc_index)
    }
}

public class DGCJXPagingSmoothCollectionView: UICollectionView, UIGestureRecognizerDelegate {
    var pagingHeaderContainerView: UIView?
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let dgc_point = touch.location(in: pagingHeaderContainerView)
        if pagingHeaderContainerView?.bounds.contains(dgc_point) == true {
            return false
        }
        return true
    }
}
