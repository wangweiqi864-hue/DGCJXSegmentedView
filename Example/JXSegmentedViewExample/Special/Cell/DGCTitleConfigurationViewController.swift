//
//  DGCTitleConfigurationViewController.swift
//  DGCJXSegmentedViewExample
//
//  Created by Jiaxin Pu on 2024/4/16.
//  Copyright © 2024 jiaxin. All rights reserved.
//

import UIKit
import DGCJXSegmentedView

class DGCTitleConfigurationViewController: UIViewController {
    var segmentedDataSource: DGCJXSegmentedTitleDataSource!
    var segmentedView: DGCJXSegmentedView!
    var listContainerView: DGCJXSegmentedListContainerView!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        //1、初始化DGCJXSegmentedView
        segmentedView = DGCJXSegmentedView()

        //2、配置数据源
        //segmentedViewDataSource一定要通过属性强持有！！！！！！！！！
        segmentedDataSource = DGCJXSegmentedTitleDataSource()
        segmentedDataSource.configuration = self
        segmentedDataSource.titles = ["猴哥", "青蛙王子", "旺财", "粉红猪", "喜羊羊", "黄焖鸡", "小马哥", "牛魔王", "大象先生", "神龙", "小猪佩奇"]
        segmentedDataSource.isTitleColorGradientEnabled = true
        segmentedView.dataSource = segmentedDataSource
        
        //3、配置指示器
        let dgc_indicator = DGCJXSegmentedIndicatorLineView()
        dgc_indicator.indicatorWidth = DGCJXSegmentedViewAutomaticDimension
        dgc_indicator.lineStyle = .lengthen
        segmentedView.indicators = [dgc_indicator]

        //4、配置DGCJXSegmentedView的属性
        view.addSubview(segmentedView)

        //5、初始化JXSegmentedListContainerView
        listContainerView = DGCJXSegmentedListContainerView(dataSource: self)
        view.addSubview(listContainerView)

        //6、将listContainerView.scrollView和segmentedView.contentScrollView进行关联
        segmentedView.listContainer = listContainerView

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        segmentedView.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 50)
        listContainerView.frame = CGRect(x: 0, y: 50, width: view.bounds.size.width, height: view.bounds.size.height - 50)
    }
}

extension DGCTitleConfigurationViewController: DGCJXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: DGCJXSegmentedListContainerView) -> Int {
        return segmentedDataSource.dataSource.count
    }

    func listContainerView(_ listContainerView: DGCJXSegmentedListContainerView, initListAt index: Int) -> DGCJXSegmentedListContainerViewListDelegate {
        let dgc_vc = DGCLoadDataListViewController()
        dgc_vc.typeString = segmentedDataSource.titles[index]
        return dgc_vc
    }
}

extension DGCTitleConfigurationViewController: DGCJXSegmentedTitleDynamicConfiguration {
    func titleNumberOfLines(at index: Int) -> Int {
        1
    }
    
    func titleNormalColor(at index: Int) -> UIColor {
        if index == 0 {
            return .cyan
        } else {
            return .black
        }
    }
    
    func titleSelectedColor(at index: Int) -> UIColor {
        if index == 0 {
            return .brown
        } else {
            return .red
        }
    }
    
    func titleNormalFont(at index: Int) -> UIFont {
        if index == 0 {
            return .systemFont(ofSize: 20)
        } else {
            return .systemFont(ofSize: 15)
        }
    }
    
    func titleSelectedFont(at index: Int) -> UIFont? {
        if index == 0 {
            return .systemFont(ofSize: 20)
        } else {
            return .systemFont(ofSize: 15)
        }
    }
}
