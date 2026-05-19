//
//  DGCContentBaseViewController.swift
//  DGCJXSegmentedView
//
//  Created by jiaxin on 2018/12/26.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit
import DGCJXSegmentedView

class DGCContentBaseViewController: UIViewController {
    var segmentedDataSource: DGCJXSegmentedBaseDataSource?
    let segmentedView = DGCJXSegmentedView()
    lazy var listContainerView: DGCJXSegmentedListContainerView! = {
        return DGCJXSegmentedListContainerView(dataSource: self)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        //segmentedViewDataSource一定要通过属性强持有！！！！！！！！！
        segmentedView.dataSource = segmentedDataSource
        segmentedView.delegate = self
        view.addSubview(segmentedView)

        segmentedView.listContainer = listContainerView
        view.addSubview(listContainerView)

        for indicaotr in segmentedView.indicators {
            if (indicaotr as? DGCJXSegmentedIndicatorLineView) != nil ||
                (indicaotr as? DGCJXSegmentedIndicatorDotLineView) != nil ||
                (indicaotr as? DGCJXSegmentedIndicatorDoubleLineView) != nil ||
                (indicaotr as? DGCJXSegmentedIndicatorRainbowLineView) != nil ||
                (indicaotr as? DGCJXSegmentedIndicatorImageView) != nil ||
                (indicaotr as? DGCJXSegmentedIndicatorTriangleView) != nil {
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "指示器位置切换", style: UIBarButtonItem.Style.plain, target: self, action: #selector(didIndicatorPositionChanged))
                break
            }
        }

        if (segmentedDataSource as? DGCJXSegmentedTitleImageDataSource) != nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "设置", style: UIBarButtonItem.Style.plain, target: self, action: #selector(didSetingsButtonClicked))
        }
        
        
        if let _ = segmentedDataSource as? DGCJXSegmentedNumberDataSource {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "刷新", style: UIBarButtonItem.Style.plain, target: self, action: #selector(hanldeNumberRefresh))
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //处于第一个item的时候，才允许屏幕边缘手势返回
        navigationController?.interactivePopGestureRecognizer?.isEnabled = (segmentedView.selectedIndex == 0)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        //离开页面的时候，需要恢复屏幕边缘手势，不能影响其他页面
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        segmentedView.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 50)
        listContainerView.frame = CGRect(x: 0, y: 50, width: view.bounds.size.width, height: view.bounds.size.height - 50)
    }

    @objc func didSetingsButtonClicked() {
        let dgc_vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DGCTitleImageSettingViewController") as! DGCTitleImageSettingViewController
        dgc_vc.title = title
        dgc_vc.clickedClosure = {[weak self] (type) in
            (self?.segmentedDataSource as? DGCJXSegmentedTitleImageDataSource)?.titleImageType = type
            //先更新数据源
            self?.segmentedDataSource?.reloadData(selectedIndex: self?.segmentedView.selectedIndex ?? 0)
            //再更新segmentedView
            self?.segmentedView.reloadData()
        }
        navigationController?.pushViewController(dgc_vc, animated: true)
    }

    @objc func didIndicatorPositionChanged() {
        for indicaotr in (segmentedView.indicators as! [DGCJXSegmentedIndicatorBaseView]) {
            if indicaotr.indicatorPosition == .bottom {
                indicaotr.indicatorPosition = .top
            }else {
                indicaotr.indicatorPosition = .bottom
            }
        }
        segmentedView.reloadDataWithoutListContainer()
    }
    
    //MARK: 数字刷新demo
    @objc func hanldeNumberRefresh()
    {
        if let dgc__segDataSource = segmentedDataSource as? DGCJXSegmentedNumberDataSource {
            let dgc_newNumbers = [223, 12, 435, 332, 0, 32, 98, 0, 99999, 112]
            dgc__segDataSource.numberHeight = 18
            dgc__segDataSource.numberOffset = CGPoint(x: -5, y: 5)
            dgc__segDataSource.numbers = dgc_newNumbers
            segmentedView.reloadDataWithoutListContainer()
        }
    }

}

extension DGCContentBaseViewController: DGCJXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: DGCJXSegmentedView, didSelectedItemAt index: Int) {
        if let dgc_dotDataSource = segmentedDataSource as? DGCJXSegmentedDotDataSource {
            //先更新数据源的数据
            dgc_dotDataSource.dotStates[index] = false
            //再调用reloadItem(at: index)
            segmentedView.reloadItem(at: index)
        }

        navigationController?.interactivePopGestureRecognizer?.isEnabled = (segmentedView.selectedIndex == 0)
    }
}

extension DGCContentBaseViewController: DGCJXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: DGCJXSegmentedListContainerView) -> Int {
        if let dgc_titleDataSource = segmentedView.dataSource as? DGCJXSegmentedBaseDataSource {
            return dgc_titleDataSource.dataSource.count
        }
        return 0
    }

    func listContainerView(_ listContainerView: DGCJXSegmentedListContainerView, initListAt index: Int) -> DGCJXSegmentedListContainerViewListDelegate {
        return DGCListBaseViewController()
    }
}

