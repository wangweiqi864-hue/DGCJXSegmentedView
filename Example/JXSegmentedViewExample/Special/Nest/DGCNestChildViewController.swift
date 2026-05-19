//
//  DGCNestChildViewController.swift
//  DGCJXSegmentedView
//
//  Created by jiaxin on 2019/1/3.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit
import DGCJXSegmentedView

class DGCNestChildViewController: UIViewController {
    var titles = [String]()
    let segmentedDataSource = DGCJXSegmentedTitleDataSource()
    let segmentedView = DGCJXSegmentedView()
    lazy var listContainerView: DGCJXSegmentedListContainerView! = {
        return DGCJXSegmentedListContainerView(dataSource: self)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        //配置数据源
        segmentedDataSource.isTitleColorGradientEnabled = true
        segmentedDataSource.titles = titles

        //配置指示器
        let dgc_indicator = DGCJXSegmentedIndicatorLineView()
        dgc_indicator.indicatorWidth = DGCJXSegmentedViewAutomaticDimension
        dgc_indicator.lineStyle = .lengthen

        //segmentedViewDataSource一定要通过属性强持有！！！！！！！！！
        segmentedView.dataSource = segmentedDataSource
        segmentedView.indicators = [dgc_indicator]
        segmentedView.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 50)
        view.addSubview(segmentedView)

        segmentedView.listContainer = listContainerView
        view.addSubview(listContainerView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        listContainerView.frame = CGRect(x: 0, y: 50, width: view.bounds.size.width, height: view.bounds.size.height - 50)
    }
}

extension DGCNestChildViewController: DGCJXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}

extension DGCNestChildViewController: DGCJXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: DGCJXSegmentedListContainerView) -> Int {
        if let dgc_titleDataSource = segmentedView.dataSource as? DGCJXSegmentedBaseDataSource {
            return dgc_titleDataSource.dataSource.count
        }
        return 0
    }

    func listContainerView(_ listContainerView: DGCJXSegmentedListContainerView, initListAt index: Int) -> DGCJXSegmentedListContainerViewListDelegate {
        return DGCTestListBaseView()
    }
}
