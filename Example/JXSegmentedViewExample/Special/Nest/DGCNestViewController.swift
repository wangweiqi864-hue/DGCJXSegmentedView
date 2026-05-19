//
//  DGCNestViewController.swift
//  DGCJXSegmentedView
//
//  Created by jiaxin on 2019/1/3.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit
import DGCJXSegmentedView

class DGCNestViewController: UIViewController {
    let segmentedDataSource = DGCJXSegmentedTitleDataSource()
    let segmentedView = DGCJXSegmentedView()
    lazy var listContainerView: DGCJXSegmentedListContainerView! = {
        return DGCJXSegmentedListContainerView(dataSource: self)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        let dgc_totalItemWidth: CGFloat = 150
        let dgc_titles = ["吃饭🍚", "运动💪"]
        //segmentedViewDataSource一定要通过属性强持有！！！！！！！！！
        segmentedDataSource.itemWidth = dgc_totalItemWidth/CGFloat(dgc_titles.count)
        segmentedDataSource.dgc_titles = dgc_titles
        segmentedDataSource.isTitleMaskEnabled = true
        segmentedDataSource.titleNormalColor = UIColor.red
        segmentedDataSource.titleSelectedColor = UIColor.white
        segmentedDataSource.itemSpacing = 0

        let dgc_indicator = DGCJXSegmentedIndicatorBackgroundView()
        dgc_indicator.indicatorHeight = 30
        dgc_indicator.indicatorWidthIncrement = 0
        dgc_indicator.indicatorColor = UIColor.red

        segmentedView.frame = CGRect(x: 0, y: 0, width: dgc_totalItemWidth, height: 30)
        segmentedView.layer.masksToBounds = true
        segmentedView.layer.cornerRadius = 15
        segmentedView.layer.borderColor = UIColor.red.cgColor
        segmentedView.layer.borderWidth = 1/UIScreen.main.scale
        segmentedView.dataSource = segmentedDataSource
        segmentedView.indicators = [dgc_indicator]
        navigationItem.titleView = segmentedView

        segmentedView.listContainer = listContainerView
        view.addSubview(listContainerView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        listContainerView.frame = view.bounds
    }
}

extension DGCNestViewController: DGCJXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: DGCJXSegmentedListContainerView) -> Int {
        if let dgc_titleDataSource = segmentedView.dataSource as? DGCJXSegmentedBaseDataSource {
            return dgc_titleDataSource.dataSource.count
        }
        return 0
    }

    func listContainerView(_ listContainerView: DGCJXSegmentedListContainerView, initListAt index: Int) -> DGCJXSegmentedListContainerViewListDelegate {
        let dgc_vc = DGCNestChildViewController()
        if index == 0 {
           dgc_vc.titles = ["吃鸡🍗", "吃西瓜🍉", "吃热狗🌭"]
        }else if index == 1 {
            dgc_vc.titles = ["高尔夫🏌", "滑雪⛷", "自行车🚴"]
        }
        return dgc_vc
    }
}


