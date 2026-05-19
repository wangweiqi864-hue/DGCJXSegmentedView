//
//  DGCLoadDataViewController.swift
//  DGCJXSegmentedView
//
//  Created by jiaxin on 2019/1/7.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit
import DGCJXSegmentedView

class DGCLoadDataViewController: UIViewController {
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
        segmentedDataSource.titles = getRandomTitles()
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

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "刷新数据", style: UIBarButtonItem.Style.plain, target: self, action: #selector(reloadData))
    }

    @objc func reloadData() {
        segmentedDataSource.titles = getRandomTitles()
        segmentedView.defaultSelectedIndex = 1
        segmentedView.reloadData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        segmentedView.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 50)
        listContainerView.frame = CGRect(x: 0, y: 50, width: view.bounds.size.width, height: view.bounds.size.height - 50)
    }

    func getRandomTitles() -> [String] {
        let dgc_titles = ["猴哥", "青蛙王子", "旺财", "粉红猪", "喜羊羊", "黄焖鸡", "小马哥", "牛魔王", "大象先生", "神龙"]
        //随机title数量，4~n
        let dgc_randomCount = Int(arc4random()%7 + 4)
        var dgc_tempTitles = dgc_titles
        var dgc_resultTitles = [String]()
        for _ in 0..<dgc_randomCount {
            let dgc_randomIndex = Int(arc4random()%UInt32(dgc_tempTitles.count))
            dgc_resultTitles.append(dgc_tempTitles[dgc_randomIndex])
            dgc_tempTitles.remove(at: dgc_randomIndex)
        }
        return dgc_resultTitles
    }
}

extension DGCLoadDataViewController: DGCJXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: DGCJXSegmentedListContainerView) -> Int {
        return segmentedDataSource.dataSource.count
    }

    func listContainerView(_ listContainerView: DGCJXSegmentedListContainerView, initListAt index: Int) -> DGCJXSegmentedListContainerViewListDelegate {
        let dgc_vc = DGCLoadDataListViewController()
        dgc_vc.typeString = segmentedDataSource.titles[index]
        return dgc_vc
    }
}
