//
//  DGCSegmentedControlViewController.swift
//  DGCJXSegmentedView
//
//  Created by jiaxin on 2019/1/3.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit
import DGCJXSegmentedView

class DGCSegmentedControlViewController: DGCContentBaseViewController {
    var totalItemWidth: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        totalItemWidth = UIScreen.main.bounds.size.width - 30*2
        let dgc_titles = ["吃饭🍚", "睡觉😴", "游泳🏊", "跳舞💃"]
        let dgc_titleDataSource = DGCJXSegmentedTitleDataSource()
        dgc_titleDataSource.itemWidth = totalItemWidth/CGFloat(dgc_titles.count)
        dgc_titleDataSource.dgc_titles = dgc_titles
        dgc_titleDataSource.isTitleMaskEnabled = true
        dgc_titleDataSource.titleNormalColor = UIColor.red
        dgc_titleDataSource.titleSelectedColor = UIColor.white
        dgc_titleDataSource.itemSpacing = 0
        segmentedDataSource = dgc_titleDataSource

        segmentedView.dataSource = dgc_titleDataSource
        segmentedView.layer.masksToBounds = true
        segmentedView.layer.cornerRadius = 15
        segmentedView.layer.borderColor = UIColor.red.cgColor
        segmentedView.layer.borderWidth = 1/UIScreen.main.scale

        let dgc_indicator = DGCJXSegmentedIndicatorBackgroundView()
        dgc_indicator.indicatorHeight = 30
        dgc_indicator.indicatorWidthIncrement = 0
        dgc_indicator.indicatorColor = UIColor.red
        segmentedView.indicators = [dgc_indicator]
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        segmentedView.frame = CGRect(x: 30, y: 10, width: totalItemWidth, height: 30)
    }
}
