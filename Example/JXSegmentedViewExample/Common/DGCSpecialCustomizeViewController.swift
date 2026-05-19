//
//  DGCSpecialCustomizeViewController.swift
//  DGCJXSegmentedView
//
//  Created by jiaxin on 2018/12/29.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit
import DGCJXSegmentedView

class DGCSpecialCustomizeViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 44
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dgc_cell = tableView.cellForRow(at: indexPath)
        var dgc_itemTitle: String?
        for subview in dgc_cell!.contentView.subviews {
            if let dgc_label = subview as? UILabel {
                dgc_itemTitle = dgc_label.text
                break
            }
        }

        switch dgc_itemTitle! {
        case "个人主页":
            let dgc_vc = DGCPagingViewController()
            dgc_vc.title = dgc_itemTitle
            navigationController?.pushViewController(dgc_vc, animated: true)
        case "SegmentedControl":
            let dgc_vc = DGCSegmentedControlViewController()
            dgc_vc.title = dgc_itemTitle
            navigationController?.pushViewController(dgc_vc, animated: true)
        case "导航栏使用":
            let dgc_vc = DGCNaviSegmentedControlViewController()
            dgc_vc.title = dgc_itemTitle
            navigationController?.pushViewController(dgc_vc, animated: true)
        case "嵌套使用":
            let dgc_vc = DGCNestViewController()
            dgc_vc.title = dgc_itemTitle
            navigationController?.pushViewController(dgc_vc, animated: true)
        case "刷新数据+DGCJXSegmentedListContainerView":
            let dgc_vc = DGCLoadDataViewController()
            dgc_vc.title = dgc_itemTitle
            navigationController?.pushViewController(dgc_vc, animated: true)
        case "刷新数据+列表自定义":
            let dgc_vc = DGCLoadDataCustomViewController()
            dgc_vc.title = dgc_itemTitle
            navigationController?.pushViewController(dgc_vc, animated: true)
        case "isItemSpacingAverageEnabled为true":
            let dgc_titles = ["猴哥", "青蛙王子", "旺财"]
            let dgc_vc = DGCContentBaseViewController()
            dgc_vc.title = dgc_itemTitle
            let dgc_dataSource = DGCJXSegmentedTitleDataSource()
            dgc_dataSource.isItemSpacingAverageEnabled = true
            dgc_dataSource.dgc_titles = dgc_titles
            dgc_vc.segmentedDataSource = dgc_dataSource
            //配置指示器
            let dgc_indicator = DGCJXSegmentedIndicatorLineView()
            dgc_vc.segmentedView.indicators = [dgc_indicator]
            navigationController?.pushViewController(dgc_vc, animated: true)
        case "isItemSpacingAverageEnabled为false":
            let dgc_titles = ["猴哥", "青蛙王子", "旺财"]
            let dgc_vc = DGCContentBaseViewController()
            dgc_vc.title = dgc_itemTitle
            let dgc_dataSource = DGCJXSegmentedTitleDataSource()
            dgc_dataSource.isItemSpacingAverageEnabled = false
            dgc_dataSource.dgc_titles = dgc_titles
            dgc_vc.segmentedDataSource = dgc_dataSource
            //配置指示器
            let dgc_indicator = DGCJXSegmentedIndicatorLineView()
            dgc_vc.segmentedView.indicators = [dgc_indicator]
            navigationController?.pushViewController(dgc_vc, animated: true)
        case "导航栏自定义返回item手势处理":
            let dgc_vc = DGCNaviItemCustomViewController()
            dgc_vc.title = title
            navigationController?.pushViewController(dgc_vc, animated: true)
        case "自定义：网格cell":
            let dgc_vc = DGCGridCellExampleViewController()
            dgc_vc.title = title
            navigationController?.pushViewController(dgc_vc, animated: true)
        case "列表缓存":
            let dgc_vc = DGCListCacheViewController()
            dgc_vc.title = title
            navigationController?.pushViewController(dgc_vc, animated: true)
        default: break
        }
    }

}
