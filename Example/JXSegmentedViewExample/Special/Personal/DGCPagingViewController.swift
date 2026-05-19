//
//  DGCPagingViewController.swift
//  DGCJXPagingView
//
//  Created by jiaxin on 2018/8/10.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

import UIKit
import DGCJXSegmentedView

extension DGCJXPagingListContainerView: DGCJXSegmentedViewListContainer {}

class DGCPagingViewController: UIViewController {
    var pagingView: DGCJXPagingView!
    var userHeaderView: DGCPagingViewTableHeaderView!
    var userHeaderContainerView: UIView!
    var segmentedViewDataSource: DGCJXSegmentedTitleDataSource!
    var segmentedView: DGCJXSegmentedView!
    let titles = ["能力", "爱好", "队友"]
    var JXTableHeaderViewHeight: Int = 200
    var JXheightForHeaderInSection: Int = 50

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "个人中心"
        self.navigationController?.navigationBar.isTranslucent = false

        userHeaderContainerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: CGFloat(JXTableHeaderViewHeight)))
        userHeaderView = DGCPagingViewTableHeaderView(frame: userHeaderContainerView.bounds)
        userHeaderContainerView.addSubview(userHeaderView)

        //segmentedViewDataSource一定要通过属性强持有！！！！！！！！！
        segmentedViewDataSource = DGCJXSegmentedTitleDataSource()
        segmentedViewDataSource.titles = titles
        segmentedViewDataSource.titleSelectedColor = UIColor(red: 105/255, green: 144/255, blue: 239/255, alpha: 1)
        segmentedViewDataSource.titleNormalColor = UIColor.black
        segmentedViewDataSource.isTitleColorGradientEnabled = true
        segmentedViewDataSource.isTitleZoomEnabled = true

        segmentedView = DGCJXSegmentedView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: CGFloat(JXheightForHeaderInSection)))
        segmentedView.backgroundColor = UIColor.white
        segmentedView.dataSource = segmentedViewDataSource
        segmentedView.isContentScrollViewClickTransitionAnimationEnabled = false

        let dgc_lineView = DGCJXSegmentedIndicatorLineView()
        dgc_lineView.indicatorColor = UIColor(red: 105/255, green: 144/255, blue: 239/255, alpha: 1)
        dgc_lineView.indicatorWidth = 30
        segmentedView.indicators = [dgc_lineView]

        let dgc_lineWidth = 1/UIScreen.main.scale
        let dgc_lineLayer = CALayer()
        dgc_lineLayer.backgroundColor = UIColor.lightGray.cgColor
        dgc_lineLayer.frame = CGRect(x: 0, y: segmentedView.bounds.height - dgc_lineWidth, width: segmentedView.bounds.width, height: dgc_lineWidth)
        segmentedView.layer.addSublayer(dgc_lineLayer)

        pagingView = DGCJXPagingView(delegate: self)

        self.view.addSubview(pagingView)
        
        segmentedView.listContainer = pagingView.listContainerView
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        pagingView.frame = self.view.bounds
    }
}

extension DGCPagingViewController: DGCJXPagingViewDelegate {

    func tableHeaderViewHeight(in pagingView: DGCJXPagingView) -> Int {
        return JXTableHeaderViewHeight
    }

    func tableHeaderView(in pagingView: DGCJXPagingView) -> UIView {
        return userHeaderContainerView
    }

    func heightForPinSectionHeader(in pagingView: DGCJXPagingView) -> Int {
        return JXheightForHeaderInSection
    }

    func viewForPinSectionHeader(in pagingView: DGCJXPagingView) -> UIView {
        return segmentedView
    }

    func numberOfLists(in pagingView: DGCJXPagingView) -> Int {
        return titles.count
    }

    func pagingView(_ pagingView: DGCJXPagingView, initListAtIndex index: Int) -> DGCJXPagingViewListViewDelegate {
        let dgc_list = DGCPagingListBaseView()
        if index == 0 {
            dgc_list.dataSource = ["橡胶火箭", "橡胶火箭炮", "橡胶机关枪", "橡胶子弹", "橡胶攻城炮", "橡胶象枪", "橡胶象枪乱打", "橡胶灰熊铳", "橡胶雷神象枪", "橡胶猿王枪", "橡胶犀·榴弹炮", "橡胶大蛇炮", "橡胶火箭", "橡胶火箭炮", "橡胶机关枪", "橡胶子弹", "橡胶攻城炮", "橡胶象枪", "橡胶象枪乱打", "橡胶灰熊铳", "橡胶雷神象枪", "橡胶猿王枪", "橡胶犀·榴弹炮", "橡胶大蛇炮"]
        }else if index == 1 {
            dgc_list.dataSource = ["吃烤肉", "吃鸡腿肉", "吃牛肉", "各种肉"]
        }else {
            dgc_list.dataSource = ["【剑士】罗罗诺亚·索隆", "【航海士】娜美", "【狙击手】乌索普", "【厨师】香吉士", "【船医】托尼托尼·乔巴", "【船匠】 弗兰奇", "【音乐家】布鲁克", "【考古学家】妮可·罗宾"]
        }
        dgc_list.beginFirstRefresh()
        return dgc_list
    }

    func mainTableViewDidScroll(_ scrollView: UIScrollView) {
        userHeaderView?.scrollViewDidScroll(contentOffsetY: scrollView.contentOffset.y)
    }
}

