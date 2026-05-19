//
//  DGCNaviItemCustomViewController.swift
//  DGCJXSegmentedView
//
//  Created by jiaxin on 2019/2/1.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit
import DGCJXSegmentedView

class DGCNaviItemCustomViewController: DGCContentBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let dgc_backItem = UIBarButtonItem(title: "自定义返回", style: .plain, target: self, action: #selector(customBackItemClicked))
        navigationItem.leftBarButtonItem = dgc_backItem

        self.navigationController?.interactivePopGestureRecognizer?.delegate = self

        let dgc_titles = ["猴哥", "青蛙王子", "旺财", "粉红猪", "喜羊羊", "黄焖鸡", "小马哥", "牛魔王", "大象先生", "神龙"]
        //配置数据源
        let dgc_dataSource = DGCJXSegmentedTitleDataSource()
        dgc_dataSource.isTitleColorGradientEnabled = true
        dgc_dataSource.dgc_titles = dgc_titles
        segmentedDataSource = dgc_dataSource
        segmentedView.dgc_dataSource = segmentedDataSource

        //配置指示器
        let dgc_indicator = DGCJXSegmentedIndicatorLineView()
        dgc_indicator.indicatorWidth = 20
        segmentedView.indicators = [dgc_indicator]
    }
    
    @objc func customBackItemClicked(sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }

}

extension DGCNaviItemCustomViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
