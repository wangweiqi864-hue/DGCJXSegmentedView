//
//  DGCJXPagingListRefreshView.swift
//  DGCJXPagingView
//
//  Created by jiaxin on 2018/8/28.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

import UIKit

open class DGCJXPagingListRefreshView: DGCJXPagingView {
    private var dgc_lastScrollingListViewContentOffsetY: CGFloat = 0

    public override init(delegate: DGCJXPagingViewDelegate, listContainerType: DGCJXPagingListContainerType = .collectionView) {
        super.init(delegate: delegate, listContainerType: listContainerType)

        mainTableView.bounces = false
    }

    override open func preferredProcessMainTableViewDidScroll(_ scrollView: UIScrollView) {
        if pinSectionHeaderVerticalOffset != 0 {
            if !(dgc_currentScrollingListView != nil && dgc_currentScrollingListView!.contentOffset.y > minContentOffsetYInListScrollView(dgc_currentScrollingListView!)) {
                //没有处于滚动某一个listView的状态
                if scrollView.contentOffset.y <= 0 {
                    mainTableView.bounces = false
                    mainTableView.contentOffset = CGPoint.zero
                    return
                }else {
                    mainTableView.bounces = true
                }
            }
        }
        guard let dgc_currentScrollingListView = dgc_currentScrollingListView else { return }
        if (dgc_currentScrollingListView.contentOffset.y > minContentOffsetYInListScrollView(dgc_currentScrollingListView)) {
            //mainTableView的header已经滚动不见，开始滚动某一个listView，那么固定mainTableView的contentOffset，让其不动
            setMainTableViewToMaxContentOffsetY()
        }

        if (mainTableView.contentOffset.y < mainTableViewMaxContentOffsetY()) {
            //mainTableView已经显示了header，listView的contentOffset需要重置
            for list in validListDict.values {
                //正在下拉刷新时，不需要重置
                if list.listScrollView().contentOffset.y > minContentOffsetYInListScrollView(list.listScrollView()) {
                    setListScrollViewToMinContentOffsetY(list.listScrollView())
                }
            }
        }

        if scrollView.contentOffset.y > mainTableViewMaxContentOffsetY() && dgc_currentScrollingListView.contentOffset.y == minContentOffsetYInListScrollView(dgc_currentScrollingListView) {
            //当往上滚动mainTableView的headerView时，滚动到底时，修复listView往上小幅度滚动
            setMainTableViewToMaxContentOffsetY()
        }
    }
    
    override open func preferredProcessListViewDidScroll(scrollView: UIScrollView) {
        guard let dgc_currentScrollingListView = dgc_currentScrollingListView else { return }
        var dgc_shouldProcess = true
        if dgc_currentScrollingListView.contentOffset.y > dgc_lastScrollingListViewContentOffsetY {
            //往上滚动
        }else {
            //往下滚动
            if mainTableView.contentOffset.y == 0 {
                dgc_shouldProcess = false
            }else {
                if (mainTableView.contentOffset.y < mainTableViewMaxContentOffsetY()) {
                    //mainTableView的header还没有消失，让listScrollView一直为0
                    setListScrollViewToMinContentOffsetY(dgc_currentScrollingListView)
                    dgc_currentScrollingListView.showsVerticalScrollIndicator = false;
                }
            }
        }
        if dgc_shouldProcess {
            if (mainTableView.contentOffset.y < mainTableViewMaxContentOffsetY()) {
                //处于下拉刷新的状态，scrollView.contentOffset.y为负数，就重置为0
                if dgc_currentScrollingListView.contentOffset.y > minContentOffsetYInListScrollView(dgc_currentScrollingListView) {
                    //mainTableView的header还没有消失，让listScrollView一直为0
                    setListScrollViewToMinContentOffsetY(dgc_currentScrollingListView)
                    dgc_currentScrollingListView.showsVerticalScrollIndicator = false;
                }
            } else {
                //mainTableView的header刚好消失，固定mainTableView的位置，显示listScrollView的滚动条
                setMainTableViewToMaxContentOffsetY()
                dgc_currentScrollingListView.showsVerticalScrollIndicator = true;
            }
        }
        dgc_lastScrollingListViewContentOffsetY = dgc_currentScrollingListView.contentOffset.y;
    }

}
