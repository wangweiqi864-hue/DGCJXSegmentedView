//
//  DGCTitleImageSettingViewController.swift
//  DGCJXSegmentedView
//
//  Created by jiaxin on 2018/12/29.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit
import DGCJXSegmentedView

class DGCTitleImageSettingViewController: UITableViewController {
    var clickedClosure: ((DGCJXSegmentedTitleImageType) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dgc_types: [DGCJXSegmentedTitleImageType] = [.topImage, .leftImage, .bottomImage, .rightImage, .onlyImage, .onlyTitle]
        clickedClosure?(dgc_types[indexPath.row])
        navigationController?.popViewController(animated: true)
    }
}
