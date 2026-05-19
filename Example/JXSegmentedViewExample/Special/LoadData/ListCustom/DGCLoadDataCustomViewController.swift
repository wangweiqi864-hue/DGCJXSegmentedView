//
//  LoadDataListCustomViewController.swift
//  DGCJXSegmentedView
//
//  Created by jiaxin on 2019/1/7.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit
import DGCJXSegmentedView

class DGCLoadDataCustomViewController: UIViewController {
    var segmentedDataSource: DGCJXSegmentedTitleDataSource!
    var segmentedView: DGCJXSegmentedView!
    var contentScrollView: UIScrollView!
    var listVCArray = [DGCLoadDataCustomListViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        //1、初始化DGCJXSegmentedView
        segmentedView = DGCJXSegmentedView()

        //2、配置数据源
        //segmentedViewDataSource一定要通过属性强持有！！！！！！！！！
        segmentedDataSource = DGCJXSegmentedTitleDataSource()
        segmentedDataSource.isTitleColorGradientEnabled = true
        segmentedView.dataSource = segmentedDataSource

        //3、配置指示器
        let dgc_indicator = DGCJXSegmentedIndicatorLineView()
        dgc_indicator.indicatorWidth = DGCJXSegmentedViewAutomaticDimension
        dgc_indicator.lineStyle = .lengthen
        segmentedView.indicators = [dgc_indicator]

        //4、配置DGCJXSegmentedView的属性
        segmentedView.delegate = self
        view.addSubview(segmentedView)

        //5、初始化contentScrollView
        contentScrollView = UIScrollView()
        contentScrollView.isPagingEnabled = true
        contentScrollView.showsVerticalScrollIndicator = false
        contentScrollView.showsHorizontalScrollIndicator = false
        contentScrollView.scrollsToTop = false
        contentScrollView.bounces = false
        //禁用automaticallyInset
        automaticallyAdjustsScrollViewInsets = false
        if #available(iOS 11.0, *) {
            contentScrollView.contentInsetAdjustmentBehavior = .never
        }
        view.addSubview(contentScrollView)

        //6、将contentScrollView和segmentedView.contentScrollView进行关联
        segmentedView.contentScrollView = contentScrollView

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "刷新数据", style: UIBarButtonItem.Style.plain, target: self, action: #selector(reloadData))

        reloadData()
    }

    @objc func reloadData() {
        segmentedDataSource.titles = getRandomTitles()
        segmentedView.defaultSelectedIndex = 0
        segmentedView.reloadData()

        for dgc_vc in listVCArray {
            dgc_vc.view.removeFromSuperview()
        }
        listVCArray.removeAll()

        for index in 0..<segmentedDataSource.titles.count {
            let dgc_vc = DGCLoadDataCustomListViewController.init(style: .plain)
            dgc_vc.typeString = segmentedDataSource.titles[index]
            dgc_vc.naviController = navigationController
            contentScrollView.addSubview(dgc_vc.view)
            listVCArray.append(dgc_vc)
            
//            if pagingViewShouldRTLLayout() {
//                pagingView(horizontalFlipForView: dgc_vc.view)
//            }
        }

        view.setNeedsLayout()

        listVCArray.first?.loadDataForFirst()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        segmentedView.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 50)
        contentScrollView.frame = CGRect(x: 0, y: 50, width: view.bounds.size.width, height: view.bounds.size.height - 50)
        contentScrollView.contentSize = CGSize(width: contentScrollView.bounds.size.width*CGFloat(segmentedDataSource.dataSource.count), height: contentScrollView.bounds.size.height)
        for (index, vc) in listVCArray.enumerated() {
            vc.view.frame = CGRect(x: contentScrollView.bounds.size.width*CGFloat(index), y: 0, width: contentScrollView.bounds.size.width, height: contentScrollView.bounds.size.height)
        }
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

extension DGCLoadDataCustomViewController: DGCJXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: DGCJXSegmentedView, didSelectedItemAt index: Int) {
        listVCArray[index].loadDataForFirst()
    }
}

