//
//  DGCGridCellExampleViewController.swift
//  DGCJXSegmentedViewExample
//
//  Created by jiaxin on 2020/1/9.
//  Copyright © 2020 jiaxin. All rights reserved.
//

import UIKit
import DGCJXSegmentedView

class DGCGridCellExampleViewController: DGCContentBaseViewController {
    var totalItemWidth: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        totalItemWidth = UIScreen.main.bounds.size.width - 30*2
        let dgc_titles = ["吃饭🍚", "睡觉😴", "游泳🏊", "跳舞💃"]
        let dgc_titleDataSource = DGCJXSegmentedTitleDataSource()
        dgc_titleDataSource.dgc_itemWidth = totalItemWidth/CGFloat(dgc_titles.count)
        dgc_titleDataSource.dgc_titles = dgc_titles
        dgc_titleDataSource.isTitleMaskEnabled = true
        dgc_titleDataSource.titleNormalColor = UIColor.red
        dgc_titleDataSource.titleSelectedColor = UIColor.white
        dgc_titleDataSource.itemSpacing = 0
        segmentedDataSource = dgc_titleDataSource

        let dgc_gridView = UIView()
        dgc_gridView.frame = CGRect(x: 0, y: 0, width: totalItemWidth, height: 30)
        dgc_gridView.backgroundColor = UIColor.white
        dgc_gridView.layer.masksToBounds = true
        dgc_gridView.layer.cornerRadius = 3
        dgc_gridView.layer.borderColor = UIColor.gray.cgColor
        dgc_gridView.layer.borderWidth = 1/UIScreen.main.scale
        let dgc_itemWidth = totalItemWidth/CGFloat(dgc_titles.count)
        for index in 0..<(dgc_titles.count - 1) {
            let dgc_line = UIView()
            dgc_line.backgroundColor = .gray
            dgc_line.frame = CGRect(x: CGFloat(index)*dgc_itemWidth - 1, y: 0, width: 1/UIScreen.main.scale, height: 30)
            dgc_gridView.addSubview(dgc_line)
        }

        segmentedView.dataSource = dgc_titleDataSource
        segmentedView.collectionView.backgroundView = dgc_gridView

        let dgc_indicator = DGCJXSegmentedIndicatorBackgroundView()
        dgc_indicator.indicatorHeight = 30
        dgc_indicator.indicatorCornerRadius = 3
        dgc_indicator.indicatorWidthIncrement = 2
        dgc_indicator.indicatorColor = UIColor.red
        segmentedView.indicators = [dgc_indicator]
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        segmentedView.frame = CGRect(x: 30, y: 10, width: totalItemWidth, height: 30)
    }

}
